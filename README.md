# Arah 🧭

> **Navigasi Malaysia, Tanpa Kompromi.**
> *Navigate Malaysia, Without Compromise.*

[![Landing Page](https://img.shields.io/badge/🌐%20Landing%20Page-deanz93.github.io%2Farah-00D8A0.svg)](https://deanz93.github.io/arah/)
[![License: MIT](https://img.shields.io/badge/License-MIT-00D8A0.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web-blue.svg)](#)
[![Data: Malaysia](https://img.shields.io/badge/data-Malaysia%20only-CC0001.svg)](#)

> 🌐 **Landing page:** https://deanz93.github.io/arah/

**Arah** (Direction in Malay) is a sovereign, community-powered navigation platform built for Malaysia — a real alternative to Waze and Google Maps, with features no foreign app offers.

- 🇲🇾 **Data stays in Malaysia** — AWS ap-southeast-1, PDPA 2010 compliant
- 🗣️ **Bahasa Malaysia-first** — Turn-by-turn TTS voice guidance in natural BM
- 🌊 **Flash flood alerts** — Evacuation routing when roads are inundated
- 💰 **Toll cost in Ringgit** — Exact cost per plaza before you start driving
- 🕌 **Islamic suite** — Waktu solat, doa + azan audio, Qibla compass, Musafir calculator, Halal filter
- ⚠️ **Zon Selamat alerts** — School zone audio warnings during school hours
- 📡 **Open source, no proprietary APIs** — OSM, Valhalla, MapLibre GL, Nominatim

---

## What Makes Arah Different?

| Feature | Arah | Waze | Google Maps |
|---------|:----:|:----:|:-----------:|
| Data stored in Malaysia | ✅ | ❌ | ❌ |
| Bahasa Malaysia-first UI + TTS | ✅ | Partial | Partial |
| Flash flood alert + evacuation routing | ✅ | ❌ | ❌ |
| Toll cost in RM (per plaza) | ✅ | Basic | ❌ |
| Zon Selamat school zone alerts | ✅ | ❌ | ❌ |
| Prayer time + Surau/Masjid locator | ✅ | ❌ | ❌ |
| Johor–Singapore checkpoint wait times | ✅ | ❌ | ❌ |
| Balik Kampung traffic prediction | ✅ | ❌ | ❌ |
| PDPA 2010 compliant | ✅ | ❌ (US law) | ❌ (US law) |
| No user data sold to advertisers | ✅ | ❌ | ❌ |
| Open source — fully auditable | ✅ | ❌ | ❌ |
| 100% OpenStreetMap (no API cost) | ✅ | ❌ | ❌ |

---

## Feature Highlights

### 🗺️ Navigation & Routing
- Turn-by-turn manoeuvres with BM/EN voice guidance
- 3 route alternatives: **fastest**, **toll-free**, **shortest**
- Real-time rerouting on deviation > 50m
- Lane guidance at complex junctions
- Speed limit display + overspeed audio alert
- Up to 5 waypoints with drag-to-reorder
- ETA share to WhatsApp

### 📢 Community Reports (Real-Time)
- **10 report types:** Police speed trap, accident, flood, pothole, roadblock, hazard, construction, broken light, wrong-way driver, event closure
- Instant broadcast via WebSocket — all nearby drivers notified in < 1s
- Upvote / downvote / confirm / dismiss reports
- Auto-remove reports on net-3 downvotes (Cloud Function)
- Photo attachment for reports
- Approach alert: audio + visual when route crosses a report

### 🇲🇾 Malaysia-Specific Features (Unique to Arah)
- **Flash flood alerts** with evacuation route re-calculation
- **Zon Selamat** — school zone alerts during school hours (7–8am, 1–2pm)
- **Waktu solat** — prayer times overlay for your location
- **Masjid/Surau locator** along route
- **Balik Kampung** traffic prediction (Hari Raya, CNY, Deepavali)
- **PLUS R&R** locator for intercity highway trips
- **Petrol price** live display at nearby stations
- **Johor–Singapore** checkpoint community wait time
- **Jawi script** toggle for place name labels
- **Malaysian postcode** search (01000–98859, all states)

### 🕌 Islamic Features (Ciri Islam)

- **Waktu Solat** — Prayer times banner on map screen; auto-detects your JAKIM zone from GPS; powered by `api.waktusolat.app/v2` (Malaysia) and `api.aladhan.com` (worldwide)
- **Doa Naik Kenderaan** — Arabic, rumi, and Malay translation displayed + **audio recitation** plays automatically when navigation starts (Az-Zukhruf 43:13–14)
- **Azan** — Full azan **audio** plays at every prayer time; navigation voice is lowered during azan and resumes automatically after
- **Musafir Calculator** — Detects if your journey ≥ 88.7 km (Shafi'i school); shows "🧳 Musafir — anda layak qasar & jamak" badge on route preview
- **Nearest Masjid/Surau** — Find the 3 closest places of worship with one tap; add as navigation waypoint mid-journey
- **Qibla Compass** — Live Qibla direction using device magnetometer; shows bearing in degrees and distance to Mecca
- **Prayer Approaching Alert** — "Asar dalam 15 minit — Surau Al-Hidayah 800m on route, singgah?" alert during navigation; configurable 0–60 min lead time
- **Halal POI Filter** — Toggle "Halal Sahaja" in food search to show only halal-tagged restaurants
- **Jumaat Reminder** — Push notification N minutes before Friday Zohor with route to nearest masjid
- **Hijri Date** — Displayed alongside Gregorian date on the prayer times banner

### 🔌 Offline & Performance
- Download map tiles for offline: **Peninsular**, **Sabah**, or **Sarawak**
- Delta tile updates — only download what changed
- Cold launch target: < 3 seconds
- Route render target: < 500ms
- Aggressive tile caching — navigate without mobile data

### 🔐 Privacy & Security
- Anonymous mode — navigate without an account
- HMAC-SHA256 one-way hash for GPS reports — no raw UID in database
- Full PDPA 2010 data export on request
- Account deletion with 30-day data wipe
- No advertising SDK. No third-party analytics.

---

## Platform Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   Mobile App    │    │    Web Portal   │
│  (React Native) │    │    (Next.js)    │
└────────┬────────┘    └────────┬────────┘
         └──────────┬───────────┘
                    │ HTTPS / WSS
              ┌─────▼──────┐
              │  nginx ALB │  ← TLS, rate limiting
              └─────┬──────┘
       ┌────────────┼────────────┬──────────┐
       ▼            ▼            ▼          ▼
  ┌─────────┐ ┌──────────┐ ┌────────┐ ┌────────────┐
  │  API    │ │ Routing  │ │ Tiles  │ │ Geocoding  │
  │Gateway  │ │(Valhalla)│ │PMTiles │ │(Nominatim) │
  │Fastify  │ └──────────┘ │+CDN    │ └────────────┘
  └────┬────┘              └────────┘
       │ Firebase Admin
  ┌────┴──────────────────────────────┐
  │            Firebase               │
  │  Auth · Firestore · Functions     │
  │  Analytics · Crashlytics · FCM   │
  └───────────────────────────────────┘

Infrastructure: AWS EKS ap-southeast-1 · ElastiCache Redis 7.1
                CloudFront CDN · Terraform IaC · GitHub Actions CI/CD
```

---

## The 9 Service Repos

| Repo | Stack | What it does | Site |
|------|-------|--------------|------|
| [arah-mobile](https://github.com/deanz93/arah-mobile) | React Native 0.74 + TypeScript | iOS + Android navigation app | [↗](https://deanz93.github.io/arah/arah-mobile/) |
| [arah-web](https://github.com/deanz93/arah-web) | Next.js 14 App Router | Admin portal + public web | [↗](https://deanz93.github.io/arah/arah-web/) |
| [arah-api](https://github.com/deanz93/arah-api) | Fastify + Node.js + Socket.io | REST API + WebSocket gateway | [↗](https://deanz93.github.io/arah/arah-api/) |
| [arah-functions](https://github.com/deanz93/arah-functions) | Firebase Cloud Functions v2 | Report lifecycle, FCM, analytics | [↗](https://deanz93.github.io/arah/arah-functions/) |
| [arah-routing](https://github.com/deanz93/arah-routing) | Valhalla (C++) | Self-hosted turn-by-turn engine | [↗](https://deanz93.github.io/arah/arah-routing/) |
| [arah-geocoding](https://github.com/deanz93/arah-geocoding) | Nominatim 4.4 | Malaysian address search | [↗](https://deanz93.github.io/arah/arah-geocoding/) |
| [arah-tile-server](https://github.com/deanz93/arah-tile-server) | PMTiles + TileServer-GL-Light | Self-hosted vector map tiles | [↗](https://deanz93.github.io/arah/arah-tile-server/) |
| [arah-infra](https://github.com/deanz93/arah-infra) | Terraform + Kubernetes + Helm | All infrastructure as code | [↗](https://deanz93.github.io/arah/arah-infra/) |
| [arah-basemap](https://github.com/deanz93/arah-basemap) | Planetiler + PMTiles + MapLibre GL | 2D/3D basemap pipeline | [↗](https://deanz93.github.io/arah/arah-basemap/) |

> This repo (`arah`) is the **reference monorepo** — BMAD documentation, architecture decisions, API spec, and scaffold live here.

---

## Scalability Path

| Phase | Users | Infrastructure |
|-------|-------|----------------|
| **MVP** | 0 – 10k | Docker Compose (`infra/docker-compose.yml`) |
| **Growth** | 10k – 100k | ECS Fargate + Redis + CloudFront |
| **Scale** | 100k – 1M | EKS + HPA + kube-prometheus-stack |
| **National** | 1M+ | Multi-AZ + Aurora + Kafka event streaming |

Full scaling design: [docs/bmad/08-scaling-guide.md](docs/bmad/08-scaling-guide.md)

---

## Documentation

| Doc | Description |
|-----|-------------|
| [00-project-brief](docs/bmad/00-project-brief.md) | Vision, goals, competitive positioning |
| [01-prd](docs/bmad/01-prd.md) | 116 user stories across 10 epics |
| [02-architecture](docs/bmad/02-architecture.md) | System design & ADRs |
| [03-tech-spec](docs/bmad/03-tech-spec.md) | Technical specifications |
| [04-api-spec](docs/bmad/04-api-spec.md) | REST + WebSocket API contracts |
| [05-epics-stories](docs/bmad/05-epics-stories.md) | Sprint-ready story backlog |
| [06-dev-setup](docs/bmad/06-dev-setup.md) | Developer environment guide |
| [07-firebase-architecture](docs/bmad/07-firebase-architecture.md) | Firebase data model |
| [08-scaling-guide](docs/bmad/08-scaling-guide.md) | Scale from 0 to 1M+ users |
| [09-features](docs/bmad/09-features.md) | Complete feature catalogue (230 features) |

---

## Contributing

We welcome contributions from Malaysian developers, designers, OSM mappers, and anyone who believes Malaysia deserves better navigation.

```bash
# Pick a story from any service repo's docs/bmad/04-stories.md
# Branch format:
git checkout -b feature/MOB-014-lane-guidance

# Commit with Conventional Commits:
git commit -m "feat(mobile): add lane guidance banner at complex junctions"

# Open a PR referencing the story ID
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.

**Where to contribute by interest:**
- 📱 Mobile dev → [arah-mobile](https://github.com/deanz93/arah-mobile)
- 🌐 Frontend / admin UI → [arah-web](https://github.com/deanz93/arah-web)
- ⚙️ Backend API → [arah-api](https://github.com/deanz93/arah-api)
- 🔔 Cloud functions & notifications → [arah-functions](https://github.com/deanz93/arah-functions)
- 🛣️ Routing engine → [arah-routing](https://github.com/deanz93/arah-routing)
- 🗺️ Address search & OSM data → [arah-geocoding](https://github.com/deanz93/arah-geocoding)
- 🧱 Vector map tiles (2D/3D) → [arah-basemap](https://github.com/deanz93/arah-basemap)
- 🖥️ Tile server & delivery → [arah-tile-server](https://github.com/deanz93/arah-tile-server)
- ☁️ DevOps / infrastructure → [arah-infra](https://github.com/deanz93/arah-infra)

---

## Join the Team

Arah is built by a small core team and growing. We're looking for people who care about Malaysia, open-source, and building things that last.

**To express interest, email:**

> 📧 **deanz9307@gmail.com**
>
> Subject: `[Arah] <Role> — <Your name>`
> Attach or link your GitHub profile, portfolio, or relevant work.

All roles are currently **volunteer / open-source contributor** basis. Serious contributors will be considered for paid engagements as the project grows.

---

## Open Roles

| # | Role | Skills | Repo |
|---|------|--------|------|
| 1 | **Mobile Developer** | React Native 0.74, TypeScript, MapLibre GL Native | [arah-mobile](https://github.com/deanz93/arah-mobile) |
| 2 | **Backend Developer** | Node.js, Fastify v4, Socket.io, Firebase Admin | [arah-api](https://github.com/deanz93/arah-api) |
| 3 | **Frontend Developer** | Next.js 14 App Router, TypeScript, Tailwind CSS | [arah-web](https://github.com/deanz93/arah-web) |
| 4 | **Firebase / Cloud Functions Engineer** | Firebase v2 Functions, Firestore, FCM, TypeScript | [arah-functions](https://github.com/deanz93/arah-functions) |
| 5 | **DevOps / Infrastructure Engineer** | Terraform, AWS EKS, Kubernetes, Helm, GitHub Actions | [arah-infra](https://github.com/deanz93/arah-infra) |
| 6 | **GIS / Map Data Specialist** | OpenStreetMap, Nominatim, Valhalla, Planetiler, PMTiles | [arah-geocoding](https://github.com/deanz93/arah-geocoding) · [arah-basemap](https://github.com/deanz93/arah-basemap) |
| 7 | **Routing Engineer** | C++, Valhalla costing models, OSM road data | [arah-routing](https://github.com/deanz93/arah-routing) |
| 8 | **UI/UX Designer** | Figma, mobile navigation UX, Bahasa Malaysia-first design | All repos |
| 9 | **QA / Test Engineer** | Detox (mobile E2E), Playwright (web), API testing | All repos |
| 10 | **Community Manager** | OSM mapping, social media, Malaysian developer community | — |

### What We Value

- You care about Malaysia having sovereign, open infrastructure
- You write clean code and review others' PRs honestly
- You're comfortable working async in a distributed team
- You contribute with intent — quality over quantity

---

## License

MIT — Free to use, modify, and distribute. See [LICENSE](LICENSE).

---

*Dibina di Malaysia 🇲🇾 — Built in Malaysia*
*Tunjuk Arah, Bersama — Show Direction, Together*
