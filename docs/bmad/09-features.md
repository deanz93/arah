# Arah — Complete Feature Catalogue

> Master reference for all platform features across all repos.
> Priority tiers: **MVP** (launch blocker) · **v1** (first stable release) · **v2** (post-launch) · **v3** (scale/monetise)
> Each feature lists the repos that own implementation.

---

## 1. Core Navigation

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| NAV-001 | Real-time GPS position | Blue dot with heading arrow, smooth interpolation between GPS pings | MVP | mobile |
| NAV-002 | Turn-by-turn directions | Step-by-step manoeuvre instructions with icons | MVP | mobile, api |
| NAV-003 | Voice guidance — BM | Bahasa Malaysia TTS prompts at 200m, 100m, 50m, at turn | MVP | mobile |
| NAV-004 | Voice guidance — EN | English TTS as user-selectable alternative | MVP | mobile |
| NAV-005 | Route calculation | Up to 3 route alternatives returned from Valhalla | MVP | mobile, api, routing |
| NAV-006 | ETA display | Estimated arrival time + remaining distance | MVP | mobile |
| NAV-007 | Auto-rerouting | Detects deviation > 50m, silently recalculates | MVP | mobile, api, routing |
| NAV-008 | Route profiles | Fastest / Toll-free / Shortest selectable per trip | MVP | mobile, api, routing |
| NAV-009 | Toll cost estimation | Per-route toll cost in RM using Malaysian toll database | MVP | mobile, api |
| NAV-010 | Lane guidance | Correct-lane indicator banner at complex junctions | v1 | mobile |
| NAV-011 | Junction view | Visual rendering of complex interchanges (SMART, Spaghetti junction) | v1 | mobile |
| NAV-012 | Speed limit display | Current road speed limit shown in HUD | v1 | mobile, routing |
| NAV-013 | Speed warning alert | Visual + audio alert when exceeding speed limit by configurable margin | v1 | mobile |
| NAV-014 | Night / day auto-mode | Map colour scheme switches automatically at sunset/sunrise or by ambient light | v1 | mobile |
| NAV-015 | Waypoints / multi-stop | Add up to 5 intermediate stops on a single trip | v1 | mobile, api, routing |
| NAV-016 | Route preview | Browse full route on map before starting navigation | MVP | mobile |
| NAV-017 | Commute mode | Learn regular routes, predict congestion for next departure | v2 | mobile, api |
| NAV-018 | Best time to leave | Suggest optimal departure time based on historical traffic | v2 | mobile, api |
| NAV-019 | Android Auto | Mirror navigation UI to in-car display | v2 | mobile |
| NAV-020 | CarPlay | Apple CarPlay navigation integration | v2 | mobile |
| NAV-021 | Motorcycle routing | Separate routing profile for motorcycles (lane-splitting paths) | v2 | mobile, routing |
| NAV-022 | Lorry / heavy vehicle | Height/weight-restricted routing profile | v3 | mobile, routing |
| NAV-023 | ETA share | Send live ETA to contact via WhatsApp/SMS deep link | v1 | mobile |
| NAV-024 | Keep screen on | Prevent device sleep during active navigation session | MVP | mobile |
| NAV-025 | Re-centre button | One-tap to re-centre map on user position | MVP | mobile |
| NAV-026 | North-up / heading-up | Toggle map orientation between fixed north and travel direction | v1 | mobile |
| NAV-027 | Distance unit toggle | Switch between km and miles | v1 | mobile |

---

## 2. Map & Visualisation

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| MAP-001 | Vector tile rendering | MapLibre GL + PMTiles, Malaysia OSM data | MVP | mobile, web, tile-server |
| MAP-002 | Satellite / hybrid view | Toggle between street map and satellite imagery | v1 | mobile, tile-server |
| MAP-003 | 3D buildings view | Extruded building footprints at zoom > 15 | v1 | mobile, tile-server |
| MAP-004 | Traffic layer | Live congestion colour overlay (green/orange/red) | v1 | mobile, api |
| MAP-005 | Report icons on map | Hazard icons rendered as MapLibre symbol layers | MVP | mobile |
| MAP-006 | Report clustering | Nearby reports merge into count bubble at low zoom | v1 | mobile |
| MAP-007 | Zoom controls | + / – buttons + pinch-to-zoom | MVP | mobile |
| MAP-008 | Compass widget | Tappable compass that resets bearing to north | v1 | mobile |
| MAP-009 | Map scale bar | Distance scale rendered in corner | v1 | mobile |
| MAP-010 | POI icons | Petrol stations, hospitals, police, R&R, mosques on map | v1 | mobile, tile-server |
| MAP-011 | Offline map tiles | Downloadable region packs stored on device | v1 | mobile, tile-server |
| MAP-012 | Offline map update | Delta sync for map tile updates | v2 | mobile, tile-server |
| MAP-013 | Custom map style | Arah-branded style with BM place names | v1 | tile-server |
| MAP-014 | Bilingual place names | Toggle between BM and EN for place labels | v1 | mobile, tile-server |
| MAP-015 | Jawi place names | Optional Jawi script for place labels | v2 | mobile, tile-server |
| MAP-016 | High-contrast mode | Accessibility map theme with stronger colour contrast | v2 | mobile |
| MAP-017 | Route polyline | Active route rendered as coloured line on map | MVP | mobile |
| MAP-018 | Inactive route dim | Unchosen alternatives shown dimmed | MVP | mobile |
| MAP-019 | User location accuracy circle | Semi-transparent ring around GPS dot showing accuracy radius | v1 | mobile |

---

## 3. Community Reports

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| RPT-001 | Police trap report | Speed trap or stationary police checkpoint | MVP | mobile, api, functions |
| RPT-002 | Accident report | Vehicle collision with severity selector | MVP | mobile, api, functions |
| RPT-003 | Flood report | Road flooded / impassable (critical Malaysia feature) | MVP | mobile, api, functions |
| RPT-004 | Pothole report | Road surface hazard | MVP | mobile, api, functions |
| RPT-005 | Roadblock report | Police barikad or protest closure | MVP | mobile, api, functions |
| RPT-006 | Hazard report | Generic road hazard (debris, animals, fallen tree) | MVP | mobile, api, functions |
| RPT-007 | Construction report | Ongoing road works reducing lanes | v1 | mobile, api, functions |
| RPT-008 | Broken traffic light report | Non-functioning traffic signal | v1 | mobile, api, functions |
| RPT-009 | Wrong-way driver report | Vehicle driving against traffic (emergency alert) | v1 | mobile, api, functions |
| RPT-010 | Event closure report | Temporary road closure for event (stadium, parade) | v1 | mobile, api, functions |
| RPT-011 | Report confirm (upvote) | Thumbs-up to confirm a report is still valid | MVP | mobile, api, functions |
| RPT-012 | Report dismiss (downvote) | Thumbs-down to mark report as cleared | MVP | mobile, api, functions |
| RPT-013 | Auto-remove on votes | Remove report when downvotes − upvotes ≥ 3 | MVP | functions |
| RPT-014 | Report TTL expiry | Auto-expire reports after type-specific TTL | MVP | functions |
| RPT-015 | Report on-route alert | Push audio + visual alert when report is ahead on active route | MVP | mobile |
| RPT-016 | Report map icon | Distinctive icon per report type on map | MVP | mobile |
| RPT-017 | Report photo | Attach photo to report for visual evidence | v2 | mobile, api |
| RPT-018 | Report comment | Add text comment to an existing report | v2 | mobile, api |
| RPT-019 | Report spam flag | Flag suspicious/fake report for admin review | v1 | mobile, api |
| RPT-020 | Flood evacuation routing | When flood reported, auto-suggest nearest evacuation route | v1 | mobile, api, routing |
| RPT-021 | Report history (personal) | View all reports the user has submitted | v1 | mobile, web |
| RPT-022 | Real-time report broadcast | WebSocket push new/removed reports to all nearby clients | MVP | api |
| RPT-023 | HMAC anonymisation | User identity stored as HMAC hash, never raw UID | MVP | api |
| RPT-024 | Rate limiting per user | Max 5 reports per user per minute | MVP | api |

---

## 4. Malaysia-Specific Features

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| MY-001 | Toll cost database | Cost per toll plaza for TNG/SmartTag, per vehicle type | MVP | api |
| MY-002 | PLUS Highway tolls | Full PLUS north-south cost matrix | MVP | api |
| MY-003 | LDP / SPRINT / KESAS tolls | Klang Valley expressway toll costs | MVP | api |
| MY-004 | Penang Bridge toll | Single + return costs | v1 | api |
| MY-005 | Flash flood alert zone | Geofenced known flood-prone areas with severity levels | MVP | mobile, api, functions |
| MY-006 | Flood evacuation route | Auto-route to nearest high ground / evac shelter | v1 | mobile, api, routing |
| MY-007 | Prayer time display | Solat waktu overlay with current prayer period indicator | v1 | mobile |
| MY-008 | Masjid / Surau locator | Find nearest mosque along route or by location | v1 | mobile, api |
| MY-009 | Petrol price display | Current RON95 / RON97 / diesel prices at nearby stations | v2 | mobile, api |
| MY-010 | R&R locator | PLUS Highway R&R stops along route with facilities info | v1 | mobile, api |
| MY-011 | Zon Selamat alert | School zone speed warning with active hours (7–8am, 1–2pm) | v1 | mobile |
| MY-012 | Balik Kampung prediction | Elevated congestion predictions during major festive periods | v2 | mobile, api |
| MY-013 | Public holiday calendar | Malaysian public holiday-aware traffic predictions | v2 | api |
| MY-014 | Emergency hotlines | Quick-dial 999, PLUS 1800-88-0000, Bomba 994, from map | v1 | mobile |
| MY-015 | PDRM checkpoint alerts | Community-reported police checkpoint locations (real-time) | MVP | mobile, api |
| MY-016 | Postcode search | Search Malaysian postcodes (01000–98859) | MVP | mobile, api, geocoding |
| MY-017 | Malaysian address format | Correct display: No, Jalan, Taman, Bandar, Negeri | MVP | mobile, geocoding |
| MY-018 | East Malaysia coverage | Full Sabah & Sarawak map + routing data | v1 | routing, geocoding, tile-server |
| MY-019 | Border crossing info | Johor–Singapore checkpoint wait time (community-reported) | v2 | mobile, api |
| MY-020 | Jalan / Lebuhraya naming | Correct Malaysian road type abbreviations (Jln, Lbh, Prn) | v1 | mobile, tile-server |

---

## 5. Search & Discovery

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| SCH-001 | Landmark search | "KLCC", "Pavilion", "KLIA" keyword search | MVP | mobile, api, geocoding |
| SCH-002 | Address search | Full Malaysian address lookup via Nominatim | MVP | mobile, api, geocoding |
| SCH-003 | POI category search | Search by category: petrol, hospital, police, food | v1 | mobile, api |
| SCH-004 | Search debounce | 300ms debounce before firing geocode request | MVP | mobile |
| SCH-005 | Search along route | Find petrol station / restroom within 5km of active route | v1 | mobile, api |
| SCH-006 | Recent searches | Last 20 searches stored locally | MVP | mobile |
| SCH-007 | Saved places — Home | One-tap home navigation | MVP | mobile, api |
| SCH-008 | Saved places — Work | One-tap work navigation | MVP | mobile, api |
| SCH-009 | Saved places — Custom | User-defined favourite locations | v1 | mobile, api |
| SCH-010 | Reverse geocode | "Where am I?" address from current GPS position | MVP | mobile, api, geocoding |
| SCH-011 | Nearby POI discovery | Browse categories of nearby places on map | v1 | mobile, api |
| SCH-012 | Place details | Name, address, phone, hours, photo for POI | v2 | mobile, api |
| SCH-013 | QR location share | Generate QR code for a location to share with others | v2 | mobile |
| SCH-014 | Deep link to location | arah://navigate?lat=3.139&lng=101.686 URL scheme | v1 | mobile |
| SCH-015 | Share via WhatsApp | Share "I'm navigating to X" pre-filled WhatsApp message | v1 | mobile |

---

## 6. User Account & Profile

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| USR-001 | Google Sign-In | OAuth 2.0 via Firebase Auth | MVP | mobile, web, api |
| USR-002 | Phone OTP login | Malaysian +60 number OTP via Firebase Auth | MVP | mobile |
| USR-003 | Anonymous mode | Navigate without account, limited features | v1 | mobile |
| USR-004 | User profile page | Display name, avatar, report count, join date | v1 | mobile, api |
| USR-005 | Language preference | BM / EN stored per user, synced across devices | MVP | mobile, api |
| USR-006 | Route preferences | Avoid tolls / avoid highways / prefer expressways | MVP | mobile, api |
| USR-007 | Vehicle type | Car / Motorcycle / Van / Lorry affects routing | v1 | mobile, api, routing |
| USR-008 | Notification preferences | Toggle: report alerts, flood alerts, speed warnings | v1 | mobile |
| USR-009 | Report stats | Total reports submitted, accepted, dismissed | v1 | mobile, api |
| USR-010 | Achievement badges | Reward active contributors (5 reports, 50 reports etc.) | v2 | mobile, api, functions |
| USR-011 | Leaderboard | Top reporters in city / state / national | v2 | mobile, api |
| USR-012 | Trip history | Last 30 days of completed navigations | v2 | mobile, api |
| USR-013 | Data export | Export personal data as JSON (PDPA compliance) | v2 | mobile, api |
| USR-014 | Account deletion | Full account + data removal within 30 days | v1 | mobile, api, functions |
| USR-015 | Multi-device sync | Saved places, preferences sync across Android + iOS | v1 | mobile, api |
| USR-016 | Voice guidance volume | Per-user TTS volume setting | MVP | mobile |
| USR-017 | Avatar upload | Profile picture from camera or gallery | v2 | mobile, api |

---

## 7. Real-Time & Live Features

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| RT-001 | WebSocket connection | Persistent WS connection for live report updates | MVP | mobile, api |
| RT-002 | Report push — new | Broadcast new report to clients within 10km radius | MVP | api, mobile |
| RT-003 | Report push — removed | Broadcast when report is voted off or expired | MVP | api, mobile |
| RT-004 | Live traffic data | Aggregate anonymous speed data from app users | v2 | mobile, api |
| RT-005 | Incident push | High-priority incident (wrong-way driver, flood) to route-affected users | v1 | api, mobile, functions |
| RT-006 | FCM push notifications | Foreground + background push via Firebase Cloud Messaging | v1 | mobile, functions |
| RT-007 | Flood broadcast | Emergency mass notification to users in flood-affected zone | v1 | functions, mobile |
| RT-008 | Connection recovery | Auto-reconnect WS on app foreground with missed event replay | v1 | mobile, api |
| RT-009 | Presence heartbeat | Client pings server every 30s to maintain live session | v1 | mobile, api |

---

## 8. Offline Capabilities

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| OFF-001 | Offline map download | Download region by state or peninsula/Borneo | v1 | mobile, tile-server |
| OFF-002 | Offline routing | On-device Valhalla graph for downloaded regions | v2 | mobile, routing |
| OFF-003 | Offline POI | Bundled POI database for offline search | v2 | mobile |
| OFF-004 | Offline ETA | Distance + ETA calculation without server | v2 | mobile |
| OFF-005 | Download progress | Region download with progress bar, pause/resume | v1 | mobile |
| OFF-006 | Storage management | Show downloaded regions, delete to free space | v1 | mobile |
| OFF-007 | Delta tile update | Download only changed tiles on map update, not full re-download | v2 | mobile, tile-server |

---

## 9. Safety & Emergency

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| SAF-001 | SOS button | Tap to call 999 / Bomba 994 / PLUS emergency | v1 | mobile |
| SAF-002 | Emergency POI | Nearest hospital, police station, fire station on demand | v1 | mobile, api |
| SAF-003 | Accident detection | Sudden severe deceleration triggers crash alert dialog | v2 | mobile |
| SAF-004 | Emergency contact alert | Auto-SMS configured emergency contact with GPS on crash detection | v2 | mobile |
| SAF-005 | Breakdown alert | Stopped + low speed + hazard lights → prompt to report breakdown | v2 | mobile |
| SAF-006 | School zone alert | Audio alert + reduced speed limit when entering Zon Selamat | v1 | mobile |
| SAF-007 | Fatigue warning | Prompt rest stop after 2+ hour continuous navigation | v2 | mobile |

---

## 10. Admin Web Portal

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| ADM-001 | Dashboard — KPIs | DAU, MAU, active navigations, routes/min, reports/hour | MVP | web |
| ADM-002 | Dashboard — charts | 7/30-day trends for users, reports, routes | v1 | web |
| ADM-003 | Report moderation queue | List of flagged / pending review reports | MVP | web |
| ADM-004 | Delete report | Admin removes invalid report, logs reason | MVP | web, api, functions |
| ADM-005 | Report heatmap | Map view of report density by type and time | v1 | web |
| ADM-006 | User management table | Search users, view profile, report history, ban status | v1 | web, api |
| ADM-007 | Ban user | Prevent user from submitting reports (soft ban) | v1 | web, api, functions |
| ADM-008 | Admin role promotion | Assign admin role to trusted users | v1 | web, api, functions |
| ADM-009 | Push notification broadcast | Send announcement to all users or filtered segment | v1 | web, functions |
| ADM-010 | Flood zone management | Define and update known flood-prone geofences | v1 | web, api |
| ADM-011 | Analytics — retention | Day-1 / Day-7 / Day-30 retention cohorts | v1 | web |
| ADM-012 | Analytics — feature usage | Report type breakdown, navigation session stats | v1 | web |
| ADM-013 | Analytics — geography | Route density heatmap, popular corridors | v2 | web |
| ADM-014 | API usage monitoring | Request count, error rate, p99 latency per endpoint | v1 | web |
| ADM-015 | Feature flag management | Toggle features per user segment without deploy | v2 | web, api |
| ADM-016 | A/B test management | Define experiments, view results | v3 | web, api |
| ADM-017 | Content management | Edit POI names, correct OSM data notes | v2 | web |
| ADM-018 | Revenue dashboard | Subscription count, ARPU, churn (when monetised) | v3 | web |
| ADM-019 | Audit log | Record all admin actions with timestamp + actor | v1 | web, api |
| ADM-020 | Export reports CSV | Download filtered report data for analysis | v1 | web |

---

## 11. Public Transport Integration (v2)

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| PT-001 | LRT/MRT directions | Klang Valley rail journey planner | v2 | mobile, api |
| PT-002 | Rapid KL bus routes | Bus journey planning with stop search | v2 | mobile, api |
| PT-003 | Transit real-time arrival | Live platform arrival times | v2 | mobile, api |
| PT-004 | Integrated journey planning | Walk + transit + last-mile drive in one plan | v2 | mobile, api |
| PT-005 | Park & Ride suggestion | Nearest P&R to transit station along route | v2 | mobile, api |
| PT-006 | Bus Express / ETS / KTM | Intercity rail journey options | v3 | mobile, api |
| PT-007 | Touch 'n Go transit fare | Estimated fare for rail + bus legs | v2 | mobile, api |

---

## 12. Accessibility & Localisation

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| ACC-001 | Bahasa Malaysia UI | All UI strings in BM as primary language | MVP | mobile, web |
| ACC-002 | English UI | Full EN translation as alternative | MVP | mobile, web |
| ACC-003 | Mandarin Chinese UI | Simplified Chinese for Chinese-Malaysian users | v2 | mobile, web |
| ACC-004 | Tamil UI | Tamil language for Indian-Malaysian users | v2 | mobile, web |
| ACC-005 | Large text support | Respect system font size (Dynamic Type / sp units) | v1 | mobile |
| ACC-006 | Screen reader support | TalkBack (Android) + VoiceOver (iOS) compatible | v2 | mobile |
| ACC-007 | High contrast mode | Accessibility theme for low-vision users | v2 | mobile |
| ACC-008 | Dyslexia font option | OpenDyslexic font toggle | v2 | mobile |
| ACC-009 | Jawi script | Optional Jawi rendering for place names | v2 | mobile, tile-server |
| ACC-010 | RTL layout | Jawi/Arabic UI requires RTL layout support | v3 | mobile |

---

## 13. Privacy & Security

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| SEC-001 | TLS 1.3 everywhere | All API endpoints HTTPS-only | MVP | api, infra |
| SEC-002 | Firebase JWT verification | All authenticated endpoints verify Bearer token | MVP | api |
| SEC-003 | GPS anonymisation | No raw GPS stored; only aggregated or hashed | MVP | api |
| SEC-004 | Report HMAC | Reporter identity stored as HMAC-SHA256(uid + secret) | MVP | api |
| SEC-005 | Rate limiting | 60 req/min global, 5 reports/min per user | MVP | api |
| SEC-006 | Input validation | All inputs validated with Zod schemas | MVP | api |
| SEC-007 | Coordinate bounds check | Reject coordinates outside Malaysia bounding box | MVP | api |
| SEC-008 | WAF on CloudFront | Block SQLi, XSS, malicious bots at CDN edge | v1 | infra |
| SEC-009 | DDoS protection | AWS Shield Standard + Cloudflare for tile CDN | v1 | infra |
| SEC-010 | Secret rotation | Firebase service account key rotation schedule | v1 | infra |
| SEC-011 | PDPA compliance | Malaysian Personal Data Protection Act data handling | v1 | api, functions |
| SEC-012 | Data minimisation | Collect only what is necessary for the feature | v1 | api |
| SEC-013 | Anonymous navigation | Navigate without account; no location stored | v1 | mobile |
| SEC-014 | Session cookie security | Web admin HttpOnly, Secure, SameSite=Strict cookies | MVP | web |

---

## 14. Monetisation (v2/v3)

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| MON-001 | Free tier | Core navigation + reports free forever | MVP | — |
| MON-002 | Premium subscription | Ad-free, offline maps, advanced analytics, priority routing | v2 | mobile, api, web |
| MON-003 | Business listings | Sponsored pins for petrol stations, restaurants, hotels | v3 | mobile, api, web |
| MON-004 | Fleet management subscription | Multi-vehicle tracking dashboard for businesses | v3 | web, api |
| MON-005 | Government data API | Sell anonymised traffic data to JKR / SPAD | v3 | api |
| MON-006 | White-label SDK | Arah routing + map SDK for third-party apps | v3 | api, tile-server |

---

## 15. DevOps & Platform

| ID | Feature | Description | Priority | Repos |
|----|---------|-------------|----------|-------|
| DEV-001 | CI/CD pipeline | Lint + test + Docker build + deploy on every PR | MVP | infra |
| DEV-002 | Staging environment | Mirror of production for pre-release testing | MVP | infra |
| DEV-003 | Blue/green deploy | Zero-downtime production deployments | v1 | infra |
| DEV-004 | HPA autoscaling | CPU-based horizontal pod autoscaling | MVP | infra |
| DEV-005 | Prometheus metrics | App + infra metrics scraped and stored | v1 | infra, api |
| DEV-006 | Grafana dashboards | API latency, Valhalla latency, Redis memory, K8s pods | v1 | infra |
| DEV-007 | AlertManager | Slack alerts for high error rate, p99 breach, pod crash | v1 | infra |
| DEV-008 | Sentry integration | Mobile + web + API error tracking with stack traces | v1 | mobile, web, api |
| DEV-009 | Crashlytics | Mobile crash reporting via Firebase | v1 | mobile |
| DEV-010 | Log aggregation | Centralised logs (CloudWatch or ELK) | v1 | infra, api |
| DEV-011 | Uptime monitoring | External health check (e.g. BetterUptime) for api.arah.my | v1 | infra |
| DEV-012 | Cost alerts | AWS Budget alerts at 80% of monthly budget | v1 | infra |
| DEV-013 | Terraform drift detection | Scheduled plan to detect manual infra changes | v2 | infra |
| DEV-014 | Monthly OSM refresh | Rebuild routing tiles + PMTiles from updated OSM data | v1 | routing, tile-server |
| DEV-015 | Database backup | Firestore daily export to GCS; Redis snapshot to S3 | v1 | infra, functions |

---

## Summary by Priority

| Tier | Count | Description |
|------|-------|-------------|
| **MVP** | 71 features | Required for first public release |
| **v1** | 89 features | First stable release within 3 months of MVP |
| **v2** | 52 features | Growth phase features |
| **v3** | 18 features | Monetisation and enterprise |
| **Total** | **230 features** | Across 15 modules |

---

## Cross-Repo Feature Coverage

| Repo | Feature IDs owned |
|------|-------------------|
| arah-mobile | NAV, MAP, RPT (submit/display), MY, SCH, USR, RT (client), OFF, SAF, ACC |
| arah-web | ADM, partial USR, partial RPT (moderation) |
| arah-api | RPT (CRUD), SCH (geocode proxy), USR (profile), RT (WS), SEC, MON-002 |
| arah-functions | RPT-013/014, USR-010, ADM-004/007/009, RT-006/007, DEV-015 |
| arah-routing | NAV-005/007/008/021/022, OFF-002, RPT-020, MY-006 |
| arah-tile-server | MAP-001–003/010–012, OFF-001/007, MY-013/015 |
| arah-geocoding | SCH-001/002/010, MY-016/017, NAV (address resolution) |
| arah-infra | DEV (all), SEC-008/009/010, MY-012 (data pipeline) |

---

*Version 1.0 — 2026-07-19 | Ref: https://github.com/deanz93/arah*
