# Arah — Firebase Architecture

Firebase is the starter backend for Auth, real-time reports, user profiles, and analytics. This document describes how Firebase integrates across the mobile app and web portal.

## Firebase Services Used

| Service | Purpose |
|---------|---------|
| **Firebase Auth** | User sign-in (Google, Phone OTP) |
| **Firestore** | User profiles, saved places, community reports |
| **Firebase Analytics** | App usage events, funnel analysis |
| **Firebase Crashlytics** | Crash reporting (mobile) |
| **Firebase Cloud Messaging (FCM)** | Push notifications (v2) |
| **Firebase Admin SDK** | Server-side auth verification, admin operations |

---

## Firestore Data Model

### Collection: `users/{uid}`

```
users/
  {firebase_uid}/
    display_name: "Ahmad Zulkifli"
    preferred_language: "ms"          # "ms" | "en"
    route_preferences:
      avoid_tolls: false
      avoid_highways: false
    report_count: 47
    created_at: Timestamp
    last_seen_at: Timestamp
    saved_places: [                   # subcollection or embedded array
      { id, label, lat, lng }
    ]
```

### Collection: `reports/{reportId}`

```
reports/
  {auto_id}/
    type: "police"                    # police | accident | flood | pothole | roadblock | hazard
    lat: 3.1420
    lng: 101.6880
    user_hash: "sha256_of_uid"        # anonymised
    upvotes: 12
    downvotes: 1
    created_at: Timestamp
    expires_at: Timestamp             # auto-set based on type TTL
    active: true                      # false when expired or voted off
```

### TTL by Report Type

| Type | TTL |
|------|-----|
| `police` | 2 hours |
| `accident` | 1 hour |
| `flood` | 6 hours |
| `roadblock` | 24 hours |
| `pothole` | 7 days |
| `hazard` | 4 hours |

---

## Firestore Rules

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users can only read/write their own profile
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }

    // Reports: anyone authenticated can read active reports
    // Any authenticated user can create a report
    // Only the report owner (by user_hash) or admin can update/delete
    match /reports/{reportId} {
      allow read: if request.auth != null && resource.data.active == true;
      allow create: if request.auth != null
        && request.resource.data.type in ['police','accident','flood','pothole','roadblock','hazard']
        && request.resource.data.lat is number
        && request.resource.data.lng is number;
      allow update: if request.auth != null
        && (request.resource.data.keys().hasOnly(['upvotes','downvotes','active']));
      allow delete: if request.auth.token.admin == true;
    }
  }
}
```

---

## Mobile App Integration

### Firebase packages (`apps/mobile`)

```json
"@react-native-firebase/app": "^20.x",
"@react-native-firebase/auth": "^20.x",
"@react-native-firebase/firestore": "^20.x",
"@react-native-firebase/analytics": "^20.x",
"@react-native-firebase/crashlytics": "^20.x"
```

### Analytics Events to Track

| Event | When |
|-------|------|
| `app_open` | App foreground |
| `navigation_started` | User taps "Go" |
| `navigation_completed` | User arrives at destination |
| `navigation_cancelled` | User cancels mid-route |
| `report_submitted` | User submits a report |
| `report_type` | Which type (police, flood, etc.) |
| `search_query` | User searches for a destination |
| `route_alternative_selected` | User picks non-default route |
| `offline_map_downloaded` | User downloads a region |

---

## Web Admin Integration

### Admin Role

Set the `admin` custom claim via Firebase Admin SDK to restrict admin access:

```typescript
// In a one-time admin setup script or Cloud Function
await admin.auth().setCustomUserClaims(uid, { admin: true })
```

### Firestore queries for admin dashboard

```typescript
// Active reports count (last 24h)
const activeReports = await db.collection('reports')
  .where('active', '==', true)
  .where('created_at', '>=', yesterday)
  .count()
  .get()

// Reports by type (for pie chart)
const byType = await db.collection('reports')
  .where('active', '==', true)
  .select('type')
  .get()
```

---

## Migration Path (Post-MVP)

When Arah scales beyond Firebase free tier, these components migrate first:

| Firebase Service | Replacement | Reason |
|-----------------|-------------|--------|
| Firestore (reports) | PostgreSQL + PostGIS | Geospatial queries, cost at scale |
| Firebase Auth | Self-hosted (Supabase Auth / Keycloak) | Data sovereignty |
| Firebase Analytics | PostHog (self-hosted) | Data ownership |

Firebase Auth tokens remain compatible during the transition period — the API Gateway can verify both Firebase tokens and new auth tokens simultaneously.

---

*Version 1.0 — 2026-07-19*
