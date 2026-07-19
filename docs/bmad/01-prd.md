# Arah — Product Requirements Document (PRD)

| Field | Value |
|-------|-------|
| Product | Arah — Malaysian Navigation App |
| Version | 1.0 (MVP) |
| Status | In Development |
| Last Updated | 2026-07-19 |

---

## 1. User Stories

### Epic 1: Core Navigation

| ID | As a… | I want to… | So that… | Priority |
|----|-------|-----------|---------|----------|
| US-001 | Driver | See my current location on a map | I know where I am | Must |
| US-002 | Driver | Search for a destination by name or address | I can navigate there | Must |
| US-003 | Driver | Get turn-by-turn directions to my destination | I don't get lost | Must |
| US-004 | Driver | Hear voice instructions in Bahasa Malaysia | I can drive without looking at the screen | Must |
| US-005 | Driver | See my ETA and distance remaining | I can plan my arrival time | Must |
| US-006 | Driver | Choose between fastest / toll-free / shortest routes | I can pick based on my preference | Must |
| US-007 | Driver | See estimated toll costs for each route | I know how much Touch 'n Go to prepare | Must |
| US-008 | Driver | Reroute automatically if I miss a turn | I get back on track without manual interaction | Must |
| US-009 | Driver | Navigate without internet (offline mode) | I can use the app in poor coverage areas | Should |
| US-010 | Driver | Switch voice language between BM and English | I prefer one language over the other | Should |

### Epic 2: Community Reports

| ID | As a… | I want to… | So that… | Priority |
|----|-------|-----------|---------|----------|
| US-011 | Driver | Report a speed trap / police | Other drivers are warned | Must |
| US-012 | Driver | Report an accident | Others avoid congestion | Must |
| US-013 | Driver | Report a flood / road flooded | Others take alternative routes | Must |
| US-014 | Driver | Report a pothole | The community knows to avoid it | Should |
| US-015 | Driver | Report a roadblock / barikad polis | Drivers are informed ahead | Must |
| US-016 | Driver | Confirm or clear an existing report | Reports stay accurate and up to date | Must |
| US-017 | Driver | See reports on the map as icons | I know what's ahead on my route | Must |
| US-018 | Driver | Get an alert when a report is on my route | I'm warned proactively without looking | Must |

### Epic 3: Map & Search

| ID | As a… | I want to… | So that… | Priority |
|----|-------|-----------|---------|----------|
| US-019 | Driver | Search by place name (e.g. "KLCC", "Pavilion KL") | I find popular landmarks fast | Must |
| US-020 | Driver | Search by address | I can navigate to any address | Must |
| US-021 | Driver | See recent searches | I can quickly return to common destinations | Should |
| US-022 | Driver | Save favourite places (Home, Work) | I navigate there in one tap | Should |
| US-023 | Driver | View the map in 2D and 3D tilt mode | I see road context more clearly | Could |

### Epic 4: Onboarding & Settings

| ID | As a… | I want to… | So that… | Priority |
|----|-------|-----------|---------|----------|
| US-024 | New user | Sign up with phone number or Google | I have a persistent account | Must |
| US-025 | User | Set my preferred language (BM/EN) | The app speaks my language | Must |
| US-026 | User | Set my route preferences (avoid tolls, avoid highways) | Routes match my driving style | Should |
| US-027 | User | Enable/disable sound for voice guidance | I can use it silently if needed | Must |
| US-028 | User | See my contribution stats (reports submitted) | I feel rewarded for contributing | Could |

---

## 2. Functional Requirements

### 2.1 Map Display
- Render vector map tiles from a self-hosted tile server (MapLibre GL + PMTiles)
- Show user's real-time GPS location with heading indicator (blue dot + arrow)
- Smooth map following during navigation
- Cluster nearby reports into a single icon at low zoom levels
- Support zoom levels 5–18

### 2.2 Search & Geocoding
- Autocomplete search with debouncing (300ms)
- Search result categories: Address, Place, POI
- Reverse geocoding for "Where am I?"
- Prioritise Malaysian results (bounding box: 1.0°N–7.5°N, 99.5°E–119.5°E)

### 2.3 Routing
- Call self-hosted Valhalla routing engine
- Return up to 3 route alternatives with: distance, ETA, toll cost, avoid-highway flag
- Render route polyline on map with active/inactive state distinction
- Recalculate route when user deviates >50m from path
- Support routing profiles: auto (car), motorcycle (v2)

### 2.4 Turn-by-Turn Navigation
- Display current manoeuvre icon + street name in a banner
- Display next manoeuvre at 200m, 100m, 50m with voice prompt
- Show distance to next turn, ETA, total remaining distance
- Night mode: auto-switch based on device time/ambient light

### 2.5 Voice Guidance
- TTS in Bahasa Malaysia and English
- Prompt triggers: approaching turn, at turn, rerouting, destination arrived
- Volume control independent of device volume

### 2.6 Community Reports
- Report types: `police`, `accident`, `flood`, `pothole`, `roadblock`, `hazard`
- Each report stores: type, coordinates, user ID (hashed), timestamp, upvotes, downvotes, TTL
- Report TTL by type: police (2h), flood (6h), accident (1h), pothole (7d), roadblock (24h)
- Report icon appears on map immediately after submission
- Reports sorted by proximity to user's route for alerts

### 2.7 Offline Mode
- Download Peninsular Malaysia or Borneo region as a map pack
- Routing works offline using bundled Valhalla graph
- Reports not available offline (requires connectivity)

---

## 3. Non-Functional Requirements

| Category | Requirement |
|----------|-------------|
| Performance | Map render < 2s on mid-range Android (Snapdragon 665) |
| Performance | Route calculation < 3s for intra-city trips |
| Reliability | 99.5% uptime for routing and tile API |
| Security | All API calls over HTTPS / TLS 1.3 |
| Privacy | GPS data anonymised before sending; no PII in logs |
| Accessibility | BM + EN; font size respects system settings |
| Battery | Background GPS tracking < 5% battery/hour |
| Data usage | Map tiles cached aggressively; < 10MB/hour during navigation |

---

## 4. Out of Scope (v1)

- In-app messaging between users
- Speed camera database (legal review needed)
- EV charging station integration
- Public transport (LRT/MRT/bus) routing
- Business listings / sponsored pins

---

*Version 1.0 — 2026-07-19*
