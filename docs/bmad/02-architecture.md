# Arah — System Architecture

## Overview

Arah is a mobile-first application with a microservices backend. All components are self-hosted or on open infrastructure. No proprietary mapping APIs are used.

```
┌─────────────────────────────────────────────────────────────┐
│                      Mobile App (RN)                        │
│  MapLibre GL  │  React Navigation  │  Zustand  │  RN TTS   │
└──────────┬─────────────┬──────────────┬──────────────┬──────┘
           │ HTTPS       │ WebSocket    │ HTTPS        │ HTTPS
           ▼             ▼             ▼              ▼
    ┌──────────┐  ┌────────────┐ ┌──────────┐  ┌──────────┐
    │  Tile    │  │  Realtime  │ │  API     │  │ Routing  │
    │  Server  │  │  Service   │ │ Gateway  │  │ (Valhalla│
    │ (PMTiles)│  │ (Socket.io)│ │ (Node.js)│  │  Go srv) │
    └──────────┘  └────────────┘ └────┬─────┘  └──────────┘
                                      │
                    ┌─────────────────┼─────────────────┐
                    ▼                 ▼                  ▼
             ┌──────────┐    ┌──────────────┐   ┌──────────────┐
             │ Geocoding│    │  PostgreSQL  │   │   Redis      │
             │(Nominatim│    │  + PostGIS   │   │  (sessions,  │
             │  Go srv) │    │  (reports,   │   │   report TTL)│
             └──────────┘    │   users)     │   └──────────────┘
                             └──────────────┘
```

## Services

### 1. Mobile App (`apps/mobile`)
- **Framework:** React Native (TypeScript)
- **Map renderer:** `@maplibre/maplibre-react-native`
- **Tile source:** PMTiles from self-hosted tile server
- **Navigation:** React Navigation v6 (Stack + Bottom Tabs)
- **State:** Zustand stores (map, user, routing, reports)
- **Data fetching:** TanStack Query v5
- **Real-time:** Socket.io client
- **Location:** `react-native-geolocation-service`
- **Voice:** `react-native-tts`

### 2. Tile Server
- Serves PMTiles (vector tiles for Malaysia region)
- Source: OpenStreetMap data via `planetiler` processing
- Hosted as static files on CDN (Cloudflare or AWS CloudFront)
- Update cycle: weekly OSM diff sync
- **Tech:** nginx + pmtiles-server or Go tile server

### 3. API Gateway (`services/api-gateway`)
- Single entry point for all mobile API calls
- Handles auth (JWT), rate limiting, request routing
- Routes to geocoding, reports, user profile services
- **Tech:** Node.js + Fastify

### 4. Routing Service (`services/routing`)
- Self-hosted Valhalla routing engine
- Supports: auto (car) profile with Malaysian toll roads
- Custom costing for Malaysian highway network
- **Tech:** Valhalla (C++) wrapped with a thin Go HTTP proxy

### 5. Realtime Service (`services/realtime`)
- WebSocket server for live report broadcasting
- Broadcasts new reports to clients within bounding box
- Redis pub/sub as the message bus between instances
- **Tech:** Node.js + Socket.io + Redis

### 6. Geocoding Service (`services/geocoding`)
- Self-hosted Nominatim instance for Malaysia
- OSM data (Malaysia + Singapore bounding box)
- Full-text search + reverse geocoding
- **Tech:** Nominatim (PostgreSQL + PostGIS)

### 7. Database
- **PostgreSQL 16 + PostGIS** for:
  - User accounts (hashed, minimal PII)
  - Community reports (with geospatial index)
  - Saved places (home, work, favourites)
- **Redis** for:
  - Session tokens (JWT refresh)
  - Report TTL expiry (auto-expire via Redis TTL)
  - Rate limiting counters

---

## Data Flow

### Navigation Request
```
User taps "Go" →
  App calls GET /routing/route?from=3.1390,101.6869&to=3.0738,101.5183&profile=auto
  → Valhalla returns JSON with manoeuvres, polyline, toll_cost
  App decodes polyline → renders on MapLibre
  App parses manoeuvres → starts TTS guidance loop
```

### Community Report Submission
```
User taps "Report Police" →
  App POSTs to /api/reports { type: "police", lat, lng, user_hash }
  API Gateway validates, writes to PostgreSQL
  API Gateway publishes to Redis "reports" channel
  Realtime Service receives → broadcasts to all clients with matching bounding box
  Other clients receive WS event → add report marker to map
```

### Search Flow
```
User types "KLCC" →
  App calls GET /geocode/search?q=KLCC&countrycodes=my&limit=5
  → Nominatim returns candidates
  User selects → App sets destination
  App calls routing service → renders route
```

---

## Infrastructure

| Component | Hosting (MVP) | Hosting (Scale) |
|-----------|---------------|-----------------|
| Tile server | Cloudflare R2 + CDN | Same (scales automatically) |
| API Gateway | AWS ap-southeast-1 ECS | ECS + ALB + auto-scaling |
| Routing (Valhalla) | AWS EC2 m5.large | EC2 m5.xlarge (RAM-heavy) |
| Realtime | AWS ECS Fargate | ECS + Redis cluster |
| Geocoding | AWS EC2 m5.large | EC2 + read replica |
| PostgreSQL | AWS RDS (single-AZ) | RDS Multi-AZ |
| Redis | AWS ElastiCache | ElastiCache cluster |

---

## Security

- All mobile↔backend traffic over HTTPS / TLS 1.3
- JWT access tokens (15min expiry) + refresh tokens (30d, Redis-backed)
- User GPS coordinates anonymised: stripped to 3 decimal places before storage
- No PII stored other than hashed phone/email for auth
- Report user ID stored as HMAC-SHA256 of user ID (prevents spam, preserves privacy)
- Rate limiting: 60 API req/min per user, 5 reports/min

---

## Scalability Considerations

- Valhalla is memory-intensive (~4GB for Malaysia graph) — dedicate a fixed-size instance
- Tile server scales horizontally (stateless, CDN-cached)
- Realtime service scales with Redis pub/sub (multiple instances)
- PostgreSQL reports table partitioned by `created_at` (monthly partitions)
- PostGIS GIST index on report coordinates for fast bounding-box queries

---

*Version 1.0 — 2026-07-19*
