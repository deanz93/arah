# Arah — Product Requirements Document (PRD)

| Field | Value |
|-------|-------|
| Product | Arah — Malaysian Navigation Platform |
| Version | 2.0 |
| Status | In Development |
| Feature catalogue | See [09-features.md](./09-features.md) for full 230-feature reference |
| Last Updated | 2026-07-19 |

---

## 1. User Stories

Stories reference Feature IDs from `09-features.md`. Each story maps to implementation work in a specific service repo.

---

### Epic 1: Core Navigation

| ID | As a… | I want to… | So that… | Priority | Feature |
|----|-------|-----------|---------|----------|---------|
| US-001 | Driver | See my current location as a blue dot with heading arrow on the map | I always know exactly where I am and which direction I am facing | Must | NAV-001 |
| US-002 | Driver | Have the map smoothly follow my movement during navigation | I don't have to manually pan the map while driving | Must | NAV-001 |
| US-003 | Driver | Search for a destination by landmark name (KLCC, Pavilion, KLIA) | I can navigate to popular places without knowing the full address | Must | SCH-001 |
| US-004 | Driver | Search for a destination by full Malaysian address | I can navigate to any specific address in the country | Must | SCH-002 |
| US-005 | Driver | Choose from up to 3 route alternatives | I can pick the route that best suits my situation | Must | NAV-005 |
| US-006 | Driver | See each route's distance, ETA, and estimated toll cost before I start | I can make an informed decision about which route to take | Must | NAV-005, NAV-009 |
| US-007 | Driver | Start turn-by-turn navigation with a single tap | I don't waste time in menus before driving | Must | NAV-002 |
| US-008 | Driver | Hear voice guidance in Bahasa Malaysia | I can keep my eyes on the road while following directions | Must | NAV-003 |
| US-009 | Driver | Hear voice guidance in English | I can choose my preferred language for instructions | Must | NAV-004 |
| US-010 | Driver | Receive voice prompts at 200m, 100m and 50m before each turn | I have enough warning to safely change lanes before the turn | Must | NAV-002 |
| US-011 | Driver | See the current manoeuvre icon and street name in a persistent banner | I always know what to do next at a glance | Must | NAV-002 |
| US-012 | Driver | See my ETA and remaining distance continuously updated | I can communicate my arrival time to others | Must | NAV-006 |
| US-013 | Driver | Have the app automatically reroute me when I miss a turn | I don't have to manually search again after going off route | Must | NAV-007 |
| US-014 | Driver | Set my route preference to avoid tolls | I can plan journeys without incurring toll charges | Must | NAV-008 |
| US-015 | Driver | Set my route preference to avoid highways | I can take slower, smaller roads if I prefer | Must | NAV-008 |
| US-016 | Driver | See a preview of the full route on the map before starting | I can mentally plan the journey before I begin driving | Must | NAV-016 |
| US-017 | Driver | Keep the screen on during navigation without manually disabling sleep | I don't have to unlock my phone repeatedly while driving | Must | NAV-024 |
| US-018 | Driver | Tap a button to instantly re-centre the map on my position | I can quickly regain context if I have manually panned the map | Must | NAV-025 |
| US-019 | Driver | See lane guidance at complex junctions (Jambatan Spaghetti, SMART Tunnel) | I get into the correct lane well before the junction | Should | NAV-010 |
| US-020 | Driver | See the current road speed limit displayed in the navigation HUD | I stay aware of speed limits and avoid fines | Should | NAV-012 |
| US-021 | Driver | Receive an alert when I exceed the speed limit | I can slow down proactively before approaching a camera | Should | NAV-013 |
| US-022 | Driver | Add up to 5 waypoints / intermediate stops to a single trip | I can plan a delivery or errand run without restarting navigation | Should | NAV-015 |
| US-023 | Driver | Share my ETA with a contact via WhatsApp | My family knows when to expect me without me needing to call | Should | NAV-023 |
| US-024 | Driver | Navigate using motorcycle routing | Routes avoid highways and suggest motorcycle-accessible lanes | Could | NAV-021 |

---

### Epic 2: Map & Visualisation

| ID | As a… | I want to… | So that… | Priority | Feature |
|----|-------|-----------|---------|----------|---------|
| US-025 | Driver | See the map rendered with Malaysian road names and place labels | The map reflects how I know my local area | Must | MAP-001 |
| US-026 | Driver | Toggle map labels between Bahasa Malaysia and English | I can read the map in my preferred language | Should | MAP-014 |
| US-027 | Driver | See a traffic congestion colour overlay on the map | I can spot jams before I enter them | Should | MAP-004 |
| US-028 | Driver | View the map in satellite / hybrid mode | I can get a real-world visual reference for unfamiliar areas | Could | MAP-002 |
| US-029 | Driver | See 3D building silhouettes in city areas at high zoom | I can more easily identify landmarks while navigating | Could | MAP-003 |
| US-030 | Driver | Download a map region for offline use | I can navigate in areas with poor mobile data coverage | Should | MAP-011, OFF-001 |
| US-031 | Driver | See petrol stations, hospitals, mosques, and R&R stops as icons on the map | I can spot essential facilities without searching | Should | MAP-010 |
| US-032 | Driver | Pinch-to-zoom and rotate the map with standard gestures | The map responds naturally like any other mapping app | Must | MAP-007 |
| US-033 | Driver | See report icons clustered at low zoom levels | The map is not cluttered with individual report icons when zoomed out | Should | MAP-006 |
| US-034 | Driver | Have the map automatically switch to night mode after sunset | I can read the map comfortably when driving at night | Should | NAV-014 |
| US-035 | Driver | Toggle between north-up and heading-up map orientations | I can choose whether the map rotates with my direction of travel | Should | NAV-026 |

---

### Epic 3: Community Reports

| ID | As a… | I want to… | So that… | Priority | Feature |
|----|-------|-----------|---------|----------|---------|
| US-036 | Driver | Report a police speed trap with one tap | Other drivers are warned before they reach the checkpoint | Must | RPT-001 |
| US-037 | Driver | Report a vehicle accident | Others can avoid the area and emergency services are alerted via community | Must | RPT-002 |
| US-038 | Driver | Report a flooded road | Other drivers avoid driving into floodwater, which can be dangerous | Must | RPT-003 |
| US-039 | Driver | Report a pothole | Other drivers slow down in that area to protect their tyres | Must | RPT-004 |
| US-040 | Driver | Report a police roadblock (barikad) | Drivers who need to avoid the area can reroute | Must | RPT-005 |
| US-041 | Driver | Report a general road hazard (debris, fallen tree) | Others are warned of an unexpected obstacle | Must | RPT-006 |
| US-042 | Driver | Report active road construction | Drivers expect lane reductions ahead | Should | RPT-007 |
| US-043 | Driver | Report a broken traffic light | Drivers approach the junction with extra caution | Should | RPT-008 |
| US-044 | Driver | Report a wrong-way driver | An emergency push notification is broadcast to nearby users immediately | Should | RPT-009 |
| US-045 | Driver | Confirm an existing report is still accurate (thumbs up) | The report gains confidence and stays visible longer | Must | RPT-011 |
| US-046 | Driver | Dismiss an existing report as cleared (thumbs down) | Stale reports are automatically removed after enough dismissals | Must | RPT-012 |
| US-047 | Driver | See all active reports displayed as icons on the map | I know what hazards exist in the areas I'm driving through | Must | MAP-005 |
| US-048 | Driver | Receive an in-navigation alert when I approach a report on my route | I am proactively warned about hazards without looking at the map | Must | RPT-015 |
| US-049 | Driver | Flag a report as fake or spam | Malicious or mistaken reports are removed from the map | Should | RPT-019 |
| US-050 | Driver | See a real-time flood evacuation suggestion when a flood is reported on my route | I can immediately take a safe alternative when flooding occurs | Must | RPT-020 |
| US-051 | Driver | Attach a photo to my report | Other drivers can visually verify the hazard | Could | RPT-017 |
| US-052 | Driver | View all my past reports and their current status | I can track my contribution to the community | Should | RPT-021 |

---

### Epic 4: Malaysia-Specific Features

| ID | As a… | I want to… | So that… | Priority | Feature |
|----|-------|-----------|---------|----------|---------|
| US-053 | Driver | See the estimated toll cost in Ringgit Malaysia for each route | I know how much Touch 'n Go credit to prepare before I start | Must | MY-001, MY-002, MY-003 |
| US-054 | Driver | Get a flash flood alert when I am approaching a known flood-prone area | I can reroute before I reach dangerous floodwater | Must | MY-005 |
| US-055 | Driver | Get a suggested evacuation route when flooding is reported near me | I don't have to figure out an alternative route by myself in a panic | Must | MY-006 |
| US-056 | Driver | See the current Islamic prayer time displayed as a non-intrusive indicator | I can plan whether to stop for prayer along my route | Should | MY-007 |
| US-057 | Driver | Find the nearest surau or masjid along my current route | I can stop for solat without going far out of the way | Should | MY-008 |
| US-058 | Driver | Find PLUS Highway R&R stops along my intercity route | I can plan rest, meals, and toilet breaks during long journeys | Should | MY-010 |
| US-059 | Driver | Receive a Zon Selamat (school zone) alert when driving near a school during school hours | I automatically slow down and am more careful near children | Should | MY-011 |
| US-060 | Driver | See Balik Kampung congestion predictions during Hari Raya, CNY, and Deepavali | I can plan my holiday journey departure time to avoid the worst traffic | Could | MY-012 |
| US-061 | Driver | Access emergency hotline numbers (999, Bomba 994, PLUS 1800-88-0000) from the map | I can call for help immediately without searching for numbers | Should | MY-014 |
| US-062 | Driver | Search using Malaysian postcodes (e.g. 50450 for Kuala Lumpur City Centre) | I can navigate to a location I only have a postcode for | Must | MY-016 |
| US-063 | Driver | See addresses displayed in correct Malaysian format | Addresses look familiar and match what I see on letters and signboards | Must | MY-017 |
| US-064 | Driver | Navigate in Sabah and Sarawak with full map and routing coverage | East Malaysian users have the same experience as Peninsular Malaysia users | Should | MY-018 |
| US-065 | Driver | See the current RON95, RON97, and diesel prices at nearby petrol stations | I can choose the cheapest or most convenient station for refuelling | Could | MY-009 |

---

### Epic 5: Search & Saved Places

| ID | As a… | I want to… | So that… | Priority | Feature |
|----|-------|-----------|---------|----------|---------|
| US-066 | Driver | See search suggestions appear as I type with a 300ms debounce | The search feels fast and responsive without hammering the server | Must | SCH-004 |
| US-067 | Driver | See my 20 most recent search destinations | I can quickly navigate to places I've been to recently without retyping | Must | SCH-006 |
| US-068 | Driver | Save my home address and navigate there in one tap | My most common destination requires zero typing | Must | SCH-007 |
| US-069 | Driver | Save my work address and navigate there in one tap | My second most common destination requires zero typing | Must | SCH-008 |
| US-070 | Driver | Save unlimited custom favourite places with a name I choose | I can quickly navigate to any regular destination (gym, parents' home) | Should | SCH-009 |
| US-071 | Driver | Find petrol stations, restaurants, and hospitals near my current location | I can discover what's around me without pre-planning | Should | SCH-011 |
| US-072 | Driver | Search for a petrol station or rest stop along my active route | I can add a stop without cancelling and restarting navigation | Should | SCH-005 |
| US-073 | Driver | Share a location with another person by sending an Arah deep link | My contact can open the location directly in the app | Should | SCH-014 |
| US-074 | Driver | Share my destination via WhatsApp with a pre-written message | I can easily coordinate meeting points with friends or family | Should | SCH-015 |
| US-075 | Driver | Ask "Where am I?" and get my current address in plain language | I can communicate my location to others even in an unfamiliar area | Must | SCH-010 |

---

### Epic 6: Authentication & User Account

| ID | As a… | I want to… | So that… | Priority | Feature |
|----|-------|-----------|---------|----------|---------|
| US-076 | New user | Sign in with my Google account in one tap | I don't have to create yet another username and password | Must | USR-001 |
| US-077 | New user | Sign in with my Malaysian phone number and a 6-digit OTP | I can use the app even if I don't have a Google account | Must | USR-002 |
| US-078 | User | Remain signed in across app restarts | I don't have to log in every time I open the app | Must | USR-001 |
| US-079 | User | See my profile with my display name, avatar, and report contribution count | I feel a sense of identity and belonging in the community | Should | USR-004 |
| US-080 | User | Set my preferred language (BM or English) in settings | The app communicates with me in my preferred language | Must | USR-005 |
| US-081 | User | Set default route preferences (avoid tolls, avoid highways) | Every route calculation automatically respects my preferences | Must | USR-006 |
| US-082 | User | Set my vehicle type (car, motorcycle, van) | Routes are calculated appropriately for my vehicle | Should | USR-007 |
| US-083 | User | Control which push notifications I receive | I only get alerts that are relevant to me | Should | USR-008 |
| US-084 | User | See how many reports I have submitted and how many were accepted | I am motivated to keep contributing accurate reports | Should | USR-009 |
| US-085 | User | Earn achievement badges for contributing to the community | I feel recognised for my effort in keeping the map accurate | Could | USR-010 |
| US-086 | User | Delete my account and all associated data | I can leave the platform and have my data fully removed | Should | USR-014 |
| US-087 | User | Export my personal data as a JSON file | I can exercise my rights under the Personal Data Protection Act 2010 | Should | USR-013 |

---

### Epic 7: Real-Time & Notifications

| ID | As a… | I want to… | So that… | Priority | Feature |
|----|-------|-----------|---------|----------|---------|
| US-088 | Driver | Receive new hazard reports on my map in real-time | I see reports appear without having to refresh the app | Must | RT-001, RT-002 |
| US-089 | Driver | See reports automatically disappear from the map when they are cleared | The map always shows only current hazards | Must | RT-003 |
| US-090 | Driver | Receive a push notification about a major incident (flood, wrong-way driver) even when the app is in the background | I am warned of critical safety events even when not actively navigating | Should | RT-006 |
| US-091 | Driver | Have the app automatically reconnect to live updates after losing network | My experience is not permanently broken by a momentary loss of signal | Should | RT-008 |
| US-092 | Driver | Receive an emergency broadcast when widespread flooding is detected near my location | I have time to change routes before roads become impassable | Must | RT-007 |

---

### Epic 8: Admin & Moderation (Web Portal)

| ID | As an… | I want to… | So that… | Priority | Feature |
|----|-------|-----------|---------|----------|---------|
| US-093 | Admin | See a live dashboard with DAU, MAU, active navigations, and reports per hour | I can monitor platform health at a glance | Must | ADM-001 |
| US-094 | Admin | See 7-day and 30-day trend charts for key metrics | I can identify growth trends and anomalies | Should | ADM-002 |
| US-095 | Admin | View all active reports on a map | I have a geographic overview of community activity | Should | ADM-005 |
| US-096 | Admin | Review the queue of reports that have been flagged as spam | I can manually review borderline cases and remove fakes | Must | ADM-003 |
| US-097 | Admin | Delete any report with a logged reason | I can remove harmful or inaccurate content from the platform | Must | ADM-004 |
| US-098 | Admin | Search for and view any user profile, including their report history | I can investigate reports of abusive users | Should | ADM-006 |
| US-099 | Admin | Temporarily or permanently ban a user from submitting reports | I can prevent bad actors from polluting the community data | Should | ADM-007 |
| US-100 | Admin | Promote a trusted user to an admin or moderator role | I can grow the moderation team from the community | Should | ADM-008 |
| US-101 | Admin | Send a push notification to all users or a filtered segment | I can broadcast important announcements (major outage, festive safety reminder) | Should | ADM-009 |
| US-102 | Admin | Create and edit known flood-prone geofenced zones | The app has accurate flood risk data for proactive alerts | Must | ADM-010 |
| US-103 | Admin | View feature usage analytics (which report types, route profiles, search terms) | I can make data-driven product decisions | Should | ADM-012 |
| US-104 | Admin | See a full audit log of all admin actions | I can review who changed what and when for accountability | Should | ADM-019 |
| US-105 | Admin | Export filtered report data to CSV | I can perform offline analysis or share data with stakeholders | Should | ADM-020 |

---

### Epic 9: Safety & Emergency

| ID | As a… | I want to… | So that… | Priority | Feature |
|----|-------|-----------|---------|----------|---------|
| US-106 | Driver | Access a one-tap SOS button that dials 999, Bomba, or PLUS emergency | I can get help immediately in a dangerous situation | Should | SAF-001 |
| US-107 | Driver | Find the nearest hospital, police station, or fire station instantly | In an emergency I know exactly where to go | Should | SAF-002 |
| US-108 | Driver | Receive a prompt to rest after 2 hours of continuous navigation | I am reminded to take breaks on long journeys to prevent fatigue | Could | SAF-007 |
| US-109 | Driver | Have the app detect a potential crash via sudden deceleration and prompt an emergency contact alert | My emergency contact is automatically notified if I am unable to respond | Could | SAF-003, SAF-004 |

---

### Epic 10: Offline & Performance

| ID | As a… | I want to… | So that… | Priority | Feature |
|----|-------|-----------|---------|----------|---------|
| US-110 | Driver | Download Peninsular Malaysia or Borneo as a map pack | I can navigate in areas with limited or no mobile data coverage | Should | OFF-001 |
| US-111 | Driver | See a download progress indicator and estimated size before downloading | I can decide whether I have enough storage and data | Should | OFF-005 |
| US-112 | Driver | Delete downloaded map regions to free up storage | I can manage my phone storage efficiently | Should | OFF-006 |
| US-113 | Driver | See the map load in under 2 seconds on a mid-range Android device | The app feels fast and professional, not laggy | Must | — |
| US-114 | Driver | Have routes calculated in under 3 seconds for intra-city journeys | I don't wait too long before I can start navigating | Must | — |
| US-115 | Driver | Use less than 10MB of mobile data per hour of navigation | My data plan is not significantly drained by using the app | Should | — |
| US-116 | Driver | Have background GPS tracking consume less than 5% battery per hour | I can navigate for a full work day without running out of charge | Must | — |

---

## 2. Functional Requirements

### 2.1 Map Display
- Render vector tiles from self-hosted TileServer-GL + PMTiles via MapLibre GL
- Blue dot with heading indicator, smooth interpolation at ≥ 30fps
- Traffic layer as coloured polyline segments (green < 30km/h, orange 30–60km/h, red > 60km/h)
- Report icons as MapLibre symbol layers with distinct SVG per type
- Cluster reports at zoom < 12 with count badge
- Auto-switch night/day theme based on civil twilight time
- Support zoom levels 4–18; map tiles available at z4–z18 for Malaysia

### 2.2 Search & Geocoding
- Nominatim search with `countrycodes=my`, `limit=5`, `format=json`
- 300ms debounce; minimum 3 characters before firing request
- Results classified: Address, Landmark, POI, Postcode
- Reverse geocode on long-press or "Where am I?" tap
- Cached results: geocode 1 hour in Redis, 24h in mobile async storage

### 2.3 Routing
- Valhalla `/route` with `costing: auto`, `costing_options.auto.toll_booth_penalty`
- 3 alternatives per request, ranked by duration
- Polyline decoded and rendered on MapLibre as LineLayer
- Deviation threshold: 50 metres triggers silent reroute
- Toll cost calculated from toll-plaza database keyed on route waypoints
- Route cache in Redis: 5 minutes TTL, key = `route:{from_lat}:{from_lng}:{to_lat}:{to_lng}:{profile}`

### 2.4 Community Reports
- Types: `police`, `accident`, `flood`, `pothole`, `roadblock`, `hazard`, `construction`, `broken_light`, `wrong_way`, `event_closure`
- Firestore collection: `reports/{id}` with fields: `type`, `coordinates`, `user_hash`, `active`, `created_at`, `expires_at`, `upvotes`, `downvotes`
- Malaysia coordinate validation: lat 1.0–7.5, lng 99.5–119.5
- TTL by type: `police` 2h, `accident` 1h, `flood` 6h, `pothole` 168h, `roadblock` 24h, `hazard` 4h, `construction` 72h, `broken_light` 48h, `wrong_way` 30min, `event_closure` 24h
- Auto-remove: `downvotes - upvotes ≥ 3` triggers Cloud Function deletion

### 2.5 Real-Time
- Socket.io namespace `/reports`; client joins room by geohash prefix
- Events: `report:new` (payload: report object), `report:removed` (payload: `{id}`)
- Heartbeat: client pings every 30 seconds; server disconnects after 90s silence
- Reconnect: exponential backoff 1s → 2s → 4s → 8s → 30s cap

### 2.6 Authentication
- Firebase Auth: Google provider + Phone (SMS OTP, region MY)
- All API requests must include `Authorization: Bearer <firebase_id_token>`
- Token verified server-side via `firebase-admin` `verifyIdToken()`
- Token auto-refreshed on mobile before expiry (Firebase SDK handles)
- Admin role: custom claim `{ admin: true }` set via admin SDK

### 2.7 Admin Portal
- Protected behind Firebase session cookie (`__session`) with HttpOnly + Secure + SameSite=Strict
- Only users with `admin: true` custom claim can access `/admin/*`
- All mutating admin actions (delete report, ban user) write to Firestore `audit_log/{id}`

---

## 3. Non-Functional Requirements

| Category | Requirement | How Measured |
|----------|-------------|-------------|
| Performance | Map render < 2s on Snapdragon 665 (mid-range Android) | Appium benchmark |
| Performance | Route calculation < 3s for intra-city trips (p95) | k6 load test |
| Performance | Geocode search response < 500ms (p95) | API test |
| Performance | Admin dashboard load < 2s | Lighthouse |
| Reliability | API uptime ≥ 99.5% | Uptime monitor |
| Reliability | Valhalla uptime ≥ 99.5% | Prometheus alert |
| Scalability | Handle 50k concurrent WebSocket connections | Load test at scale |
| Scalability | Route 500 req/s at p99 < 2s | k6 load test |
| Security | All endpoints HTTPS / TLS 1.3 | SSL Labs A+ grade |
| Security | Zero PII in logs or error messages | Log audit |
| Privacy | GPS data never stored raw on server | Code audit |
| Privacy | PDPA 2010 compliant data handling | Legal review |
| Battery | Background GPS < 5% battery/hour | Device profiler |
| Data | < 10MB/hour during active navigation | Proxy monitoring |
| Crash | Mobile crash-free rate ≥ 99.5% | Firebase Crashlytics |
| Accessibility | WCAG AA compliance for web admin | Axe scan |

---

## 4. Out of Scope

### v1 (deferred to v2)
- Public transit (LRT/MRT/bus/ETS) routing — see PT-001 to PT-007
- Speed camera fixed database (legal review with PDRM required)
- In-app messaging between users
- User-generated map corrections (OSM editing UI)
- Motorcycle routing profile

### v2 (deferred to v3)
- EV charging station network integration
- Business listing / sponsored pins
- Fleet management dashboard
- White-label SDK

### Never (explicit non-goals)
- Tracking users' locations for advertising purposes
- Selling individual user data to third parties
- Providing turn-by-turn navigation outside Malaysia (except MY-019 border crossing info)

---

## 5. Epics Summary

| Epic | Stories | MVP Stories | Feature Module |
|------|---------|-------------|----------------|
| 1 — Core Navigation | US-001 to US-024 | 18 | NAV |
| 2 — Map & Visualisation | US-025 to US-035 | 4 | MAP |
| 3 — Community Reports | US-036 to US-052 | 10 | RPT |
| 4 — Malaysia-Specific | US-053 to US-065 | 6 | MY |
| 5 — Search & Saved Places | US-066 to US-075 | 4 | SCH |
| 6 — Auth & User Account | US-076 to US-087 | 5 | USR |
| 7 — Real-Time & Notifications | US-088 to US-092 | 3 | RT |
| 8 — Admin & Moderation | US-093 to US-105 | 3 | ADM |
| 9 — Safety & Emergency | US-106 to US-109 | 0 | SAF |
| 10 — Offline & Performance | US-110 to US-116 | 3 | OFF |
| **Total** | **116 stories** | **56 MVP** | |

---

*Version 2.0 — 2026-07-19 | Feature catalogue: [09-features.md](./09-features.md)*
