# Arah — Epics & Stories

## Sprint Status Legend

| Symbol | Meaning |
|--------|---------|
| ⬜ | Not started |
| 🔵 | In progress |
| ✅ | Done |
| ❌ | Blocked |
| 🔶 | Deferred to next sprint |

---

## Epic 0: Project Foundation
**Goal:** Scaffold, CI/CD, and Firebase setup so the team can build on a solid base.

| ID | Story | Priority | Status | Owner |
|----|-------|----------|--------|-------|
| S-001 | Initialise React Native project with TypeScript | Must | ✅ | |
| S-002 | Configure ESLint + Prettier + Husky pre-commit hook | Must | ✅ | |
| S-003 | Set up Firebase project (Auth, Analytics, Crashlytics) | Must | ✅ | |
| S-004 | Integrate `@react-native-firebase/app` in mobile app | Must | ✅ | |
| S-005 | Configure environment variables (.env + react-native-config) | Must | ✅ | |
| S-006 | Set up GitHub Actions CI (lint + test on PR) | Should | ✅ | |
| S-007 | Initialise Next.js web app (admin + web portal) | Must | ✅ | |
| S-008 | Configure Firebase Admin SDK in Next.js API routes | Must | ✅ | |
| S-009 | Set up Valhalla routing engine (Docker, Malaysia graph) | Must | ✅ | |
| S-010 | Set up Nominatim geocoding (Docker, Malaysia OSM data) | Must | ✅ | |

---

## Epic 1: Core Map & Navigation
**Goal:** A driver can open the app, see their position, search for a destination, and get turn-by-turn navigation.

| ID | Story | Ref | Priority | Status | Owner |
|----|-------|-----|----------|--------|-------|
| S-011 | Render MapLibre map with OSM tiles on app open | US-001 | Must | ✅ | |
| S-012 | Show user GPS position (blue dot + heading) | US-001 | Must | ✅ | |
| S-013 | Implement search screen with Nominatim autocomplete | US-002 | Must | ✅ | |
| S-014 | Display search results list; tap to set as destination | US-002 | Must | ✅ | |
| S-015 | Call Valhalla routing API; render route polyline on map | US-003 | Must | ✅ | |
| S-016 | Show route preview: distance, ETA, toll cost, alternatives | US-005,006,007 | Must | ✅ | |
| S-017 | Start navigation mode: manoeuvre banner + bottom bar | US-003,005 | Must | ✅ | |
| S-018 | BM voice guidance via react-native-tts | US-004 | Must | ✅ | |
| S-019 | Auto-reroute when user deviates >50m from route | US-008 | Must | ⬜ | |
| S-020 | "Arrived at destination" announcement + nav end | US-003 | Must | ⬜ | |
| S-021 | Night mode: auto-switch map style at sunset | — | Should | ⬜ | |
| S-022 | Language toggle: BM / EN for voice + UI | US-010 | Should | ⬜ | |

---

## Epic 2: Community Reports
**Goal:** Drivers can submit and see real-time hazard reports on the map.

| ID | Story | Ref | Priority | Status | Owner |
|----|-------|-----|----------|--------|-------|
| S-023 | Report FAB button on map screen | US-011 | Must | ⬜ | |
| S-024 | Report type selection bottom sheet | US-011–015 | Must | ⬜ | |
| S-025 | Submit report to Firestore (police, accident, flood, roadblock) | US-011–015 | Must | ⬜ | |
| S-026 | Load and display report markers from Firestore real-time listener | US-017 | Must | ⬜ | |
| S-027 | Upvote / downvote report; remove if net downvotes > 3 | US-016 | Must | ⬜ | |
| S-028 | Alert driver when a report is ahead on their active route | US-018 | Must | ⬜ | |
| S-029 | Auto-expire reports based on type TTL | — | Must | ⬜ | |
| S-030 | Pothole and hazard report types | US-014 | Should | ⬜ | |

---

## Epic 3: Authentication & User Profile (Firebase)
**Goal:** Users have accounts, preferences persist across devices.

| ID | Story | Ref | Priority | Status | Owner |
|----|-------|-----|----------|--------|-------|
| S-031 | Onboarding screen: sign in with Google via Firebase Auth | US-024 | Must | ⬜ | |
| S-032 | Phone number OTP sign-in via Firebase Auth | US-024 | Must | ⬜ | |
| S-033 | Create Firestore user profile on first login | — | Must | ⬜ | |
| S-034 | Save preferred language (BM/EN) to Firestore profile | US-025 | Must | ⬜ | |
| S-035 | Save route preferences (avoid tolls, avoid highways) | US-026 | Should | ⬜ | |
| S-036 | Save / delete favourite places (Home, Work, custom) | US-022 | Should | ⬜ | |
| S-037 | Show user report count in settings screen | US-028 | Could | ⬜ | |

---

## Epic 4: Web Portal (Next.js + Firebase)
**Goal:** Web system for admin management, analytics, and user support.

| ID | Story | Priority | Status | Owner |
|----|-------|----------|--------|-------|
| S-038 | Public landing page for Arah (arah.my) | Must | ⬜ | |
| S-039 | Admin login via Firebase Auth (email/password, admin role claim) | Must | ⬜ | |
| S-040 | Admin dashboard: DAU / MAU / report count charts | Must | ⬜ | |
| S-041 | Live reports map view (admin sees all active reports) | Must | ⬜ | |
| S-042 | Moderate reports: delete / flag inappropriate | Must | ⬜ | |
| S-043 | User list: search by UID, ban/unban user | Should | ⬜ | |
| S-044 | Analytics page: top routes, hotspot heatmap | Should | ⬜ | |
| S-045 | Export report data as CSV | Could | ⬜ | |

---

## Epic 5: Offline & Performance
**Goal:** App is usable in low-connectivity Malaysian rural areas.

| ID | Story | Ref | Priority | Status | Owner |
|----|-------|-----|----------|--------|-------|
| S-046 | Download Peninsular Malaysia map pack for offline use | US-009 | Should | ⬜ | |
| S-047 | Offline routing using bundled Valhalla graph | US-009 | Should | ⬜ | |
| S-048 | Show "offline mode" banner when network is unavailable | — | Should | ⬜ | |
| S-049 | Queue report submissions when offline; sync on reconnect | — | Could | ⬜ | |

---

## Backlog (Future Sprints)

| ID | Story | Epic |
|----|-------|------|
| S-050 | Motorcycle routing profile | Navigation |
| S-051 | LRT/MRT/bus routing (public transit) | Navigation |
| S-052 | Speed limit display on navigation banner | Navigation |
| S-053 | Cross-border routing (Singapore, Thailand) | Navigation |
| S-054 | In-app OSM contribution (report missing road) | Map |
| S-055 | Push notifications for route alerts (FCM) | Reports |
| S-056 | Carpooling / trip sharing feature | Social |

---

## Current Sprint: Sprint 1

**Focus:** Epic 2 (Community Reports) + Epic 3 (Auth) + Epic 4 (Web Portal)

**Sprint Goal:** A user can sign in with Google, submit a hazard report, see it appear on the map in real-time, and an admin can view and moderate it on the web portal.

---

*Version 1.0 — 2026-07-19*
