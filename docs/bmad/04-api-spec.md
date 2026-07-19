# Arah — API Specification

## Base URLs

| Service | URL |
|---------|-----|
| API Gateway | `https://api.arah.my/v1` |
| Routing | `https://routing.arah.my` |
| Geocoding | `https://geocode.arah.my` |
| Realtime (WS) | `wss://realtime.arah.my` |
| Tile Server | `https://tiles.arah.my` |

## Authentication

All `/api/v1/` endpoints require a Firebase ID token:
```
Authorization: Bearer <firebase-id-token>
```

The API Gateway verifies the token with Firebase Admin SDK. On success, `req.uid` is the Firebase UID.

---

## Routing Service

### GET /route

Calculate a route between two points using Valhalla.

**Request**
```
GET /route?from_lat=3.1390&from_lng=101.6869&to_lat=3.0738&to_lng=101.5183&profile=auto&alternatives=3
```

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `from_lat` | float | ✅ | Origin latitude |
| `from_lng` | float | ✅ | Origin longitude |
| `to_lat` | float | ✅ | Destination latitude |
| `to_lng` | float | ✅ | Destination longitude |
| `profile` | string | ✅ | `auto` (car), `motorcycle` (v2) |
| `alternatives` | int | No | Number of route alternatives (default 1, max 3) |
| `avoid_tolls` | bool | No | Prefer toll-free roads |
| `avoid_highways` | bool | No | Prefer non-highway roads |

**Response `200`**
```json
{
  "routes": [
    {
      "id": "route_0",
      "distance_meters": 18450,
      "duration_seconds": 1320,
      "toll_cost_myr": 4.50,
      "has_tolls": true,
      "summary": "Via LDP",
      "polyline": "encoded_polyline_string",
      "legs": [
        {
          "manoeuvres": [
            {
              "type": "turn_right",
              "instruction": "Belok kanan ke Jalan Ampang",
              "instruction_en": "Turn right onto Jalan Ampang",
              "distance_meters": 450,
              "bearing_before": 90,
              "bearing_after": 180
            }
          ]
        }
      ]
    }
  ]
}
```

---

## Geocoding Service

### GET /search

Search for a place or address.

**Request**
```
GET /search?q=KLCC&limit=5&countrycodes=my
```

**Response `200`**
```json
{
  "results": [
    {
      "place_id": "node/123456",
      "display_name": "Kuala Lumpur City Centre (KLCC), Jalan Ampang, KL",
      "lat": 3.1578,
      "lng": 101.7118,
      "type": "landmark",
      "category": "tourism"
    }
  ]
}
```

### GET /reverse

Reverse geocode a coordinate to an address.

**Request**
```
GET /reverse?lat=3.1390&lng=101.6869
```

**Response `200`**
```json
{
  "display_name": "Jalan Raja Chulan, Bukit Bintang, Kuala Lumpur",
  "road": "Jalan Raja Chulan",
  "suburb": "Bukit Bintang",
  "city": "Kuala Lumpur",
  "postcode": "50200",
  "country_code": "my"
}
```

---

## Reports API

### GET /api/v1/reports

Fetch community reports within a bounding box.

**Request**
```
GET /api/v1/reports?sw_lat=3.0&sw_lng=101.5&ne_lat=3.3&ne_lng=101.8
```

**Response `200`**
```json
{
  "reports": [
    {
      "id": "rpt_abc123",
      "type": "police",
      "lat": 3.1420,
      "lng": 101.6880,
      "upvotes": 12,
      "downvotes": 1,
      "created_at": "2026-07-19T08:30:00Z",
      "expires_at": "2026-07-19T10:30:00Z"
    }
  ]
}
```

### POST /api/v1/reports

Submit a new community report. Requires auth.

**Request Body**
```json
{
  "type": "police",
  "lat": 3.1420,
  "lng": 101.6880
}
```

| Field | Type | Required | Values |
|-------|------|----------|--------|
| `type` | string | ✅ | `police`, `accident`, `flood`, `pothole`, `roadblock`, `hazard` |
| `lat` | float | ✅ | Latitude |
| `lng` | float | ✅ | Longitude |

**Response `201`**
```json
{
  "id": "rpt_abc123",
  "type": "police",
  "expires_at": "2026-07-19T10:30:00Z"
}
```

### POST /api/v1/reports/:id/vote

Vote on an existing report (confirm or clear it).

**Request Body**
```json
{ "vote": "up" }
```

| `vote` | Effect |
|--------|--------|
| `"up"` | Confirm report is still valid (+1 upvote) |
| `"down"` | Mark report as cleared (+1 downvote) |

**Response `200`**
```json
{
  "id": "rpt_abc123",
  "upvotes": 13,
  "downvotes": 1
}
```

---

## User Profile API

### GET /api/v1/profile

Get the current user's profile.

**Response `200`**
```json
{
  "uid": "firebase_uid",
  "display_name": "Ahmad",
  "preferred_language": "ms",
  "route_preferences": {
    "avoid_tolls": false,
    "avoid_highways": false
  },
  "saved_places": [
    { "id": "sp_001", "label": "Rumah", "lat": 3.1234, "lng": 101.6543 },
    { "id": "sp_002", "label": "Kerja", "lat": 3.1567, "lng": 101.7123 }
  ],
  "report_count": 47,
  "joined_at": "2026-01-15T10:00:00Z"
}
```

### PATCH /api/v1/profile

Update user preferences.

**Request Body**
```json
{
  "preferred_language": "ms",
  "route_preferences": {
    "avoid_tolls": true
  }
}
```

---

## WebSocket Events (Realtime Service)

### Connection

```javascript
const socket = io('wss://realtime.arah.my', {
  auth: { token: firebaseIdToken }
})
```

### Subscribe to Report Feed

```javascript
// Client → Server
socket.emit('subscribe_bbox', {
  sw: { lat: 3.0, lng: 101.5 },
  ne: { lat: 3.3, lng: 101.8 }
})

// Server → Client (when new report in bbox)
socket.on('report:new', (report) => {
  // { id, type, lat, lng, created_at }
})

// Server → Client (when report voted off / expired)
socket.on('report:removed', ({ id }) => {
  // remove from map
})
```

---

## Error Responses

All endpoints return consistent errors:

```json
{
  "error": {
    "code": "REPORT_RATE_LIMITED",
    "message": "Too many reports submitted. Please wait before submitting another.",
    "status": 429
  }
}
```

| Code | Status | Meaning |
|------|--------|---------|
| `UNAUTHORIZED` | 401 | Missing or invalid Firebase token |
| `FORBIDDEN` | 403 | Token valid but resource access denied |
| `NOT_FOUND` | 404 | Resource does not exist |
| `VALIDATION_ERROR` | 422 | Request body fails validation |
| `REPORT_RATE_LIMITED` | 429 | Too many reports (5/min) |
| `INTERNAL_ERROR` | 500 | Server error |

---

*Version 1.0 — 2026-07-19*
