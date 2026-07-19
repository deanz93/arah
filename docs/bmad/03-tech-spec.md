# Arah — Technical Specification

## Mobile App Stack

### Core Dependencies (`apps/mobile/package.json`)

| Package | Version | Purpose |
|---------|---------|---------|
| `react` | 18.x | UI framework |
| `react-native` | 0.74.x | Mobile runtime |
| `typescript` | 5.x | Language |
| `@maplibre/maplibre-react-native` | 10.x | Map rendering (open-source) |
| `@react-navigation/native` | 6.x | Navigation container |
| `@react-navigation/native-stack` | 6.x | Stack navigator |
| `@react-navigation/bottom-tabs` | 6.x | Tab bar navigator |
| `react-native-safe-area-context` | 4.x | Safe area insets |
| `react-native-screens` | 3.x | Native screen optimization |
| `zustand` | 4.x | State management |
| `@tanstack/react-query` | 5.x | Server state, caching |
| `axios` | 1.x | HTTP client |
| `socket.io-client` | 4.x | WebSocket (reports) |
| `react-native-geolocation-service` | 5.x | GPS location |
| `react-native-tts` | 4.x | Text-to-speech (BM + EN) |
| `react-native-permissions` | 4.x | Runtime permission requests |
| `@react-native-async-storage/async-storage` | 1.x | Local persistence |
| `react-native-vector-icons` | 10.x | Icon set |
| `react-native-mmkv` | 2.x | Fast key-value storage |
| `react-native-reanimated` | 3.x | Animations |
| `react-native-gesture-handler` | 2.x | Touch gestures |
| `@react-native-community/netinfo` | 11.x | Network status |
| `date-fns` | 3.x | Date formatting |

### Dev Dependencies

| Package | Purpose |
|---------|---------|
| `@typescript-eslint/parser` + `plugin` | TypeScript linting |
| `eslint-plugin-react-native` | RN-specific lint rules |
| `prettier` | Code formatting |
| `jest` | Unit testing |
| `@testing-library/react-native` | Component testing |
| `detox` | E2E testing (setup in v2) |
| `babel-plugin-module-resolver` | `@/` path alias |

---

## Project Structure

```
apps/mobile/
├── android/                    # Android native project
├── ios/                        # iOS native project
├── src/
│   ├── types/
│   │   └── index.ts            # All shared TypeScript types
│   ├── constants/
│   │   └── index.ts            # API URLs, map config, report types
│   ├── navigation/
│   │   ├── index.tsx           # Root navigator
│   │   └── types.ts            # Navigator param lists
│   ├── store/
│   │   ├── mapStore.ts         # Camera, zoom, selected features
│   │   ├── routingStore.ts     # Active route, manoeuvres, nav state
│   │   ├── reportStore.ts      # Active reports on map
│   │   └── userStore.ts        # Auth, preferences, saved places
│   ├── services/
│   │   ├── api.ts              # Axios instance + interceptors
│   │   ├── locationService.ts  # GPS subscription management
│   │   ├── routingService.ts   # Valhalla API calls
│   │   ├── geocodingService.ts # Nominatim API calls
│   │   ├── reportService.ts    # Report CRUD API calls
│   │   └── socketService.ts    # Socket.io connection + events
│   ├── hooks/
│   │   ├── useLocation.ts      # Current GPS position hook
│   │   ├── useRouting.ts       # Route request + recalculation
│   │   ├── useReports.ts       # Report submission + feed
│   │   └── useNavigation.ts    # Turn-by-turn state machine
│   ├── screens/
│   │   ├── MapScreen.tsx       # Main map (home screen)
│   │   ├── SearchScreen.tsx    # Destination search
│   │   ├── RoutePreviewScreen.tsx # Route options before starting
│   │   ├── NavigationScreen.tsx  # Active navigation overlay
│   │   ├── ReportScreen.tsx    # Submit a community report
│   │   ├── SettingsScreen.tsx  # User preferences
│   │   └── OnboardingScreen.tsx  # First-run setup
│   ├── components/
│   │   ├── Map/
│   │   │   ├── ArahMapView.tsx   # MapLibre wrapper
│   │   │   ├── UserMarker.tsx    # GPS position dot
│   │   │   ├── ReportMarker.tsx  # Community report icon
│   │   │   └── RouteLayer.tsx    # Active route polyline
│   │   ├── Search/
│   │   │   ├── SearchBar.tsx
│   │   │   └── SearchResultItem.tsx
│   │   ├── Report/
│   │   │   ├── ReportFab.tsx     # Floating action button
│   │   │   └── ReportTypeSheet.tsx # Bottom sheet with report types
│   │   ├── Navigation/
│   │   │   ├── ManoeuvreBar.tsx  # Top banner: next turn info
│   │   │   └── NavBottomBar.tsx  # ETA, distance, cancel
│   │   └── common/
│   │       ├── Button.tsx
│   │       ├── BottomSheet.tsx
│   │       └── LoadingOverlay.tsx
│   └── utils/
│       ├── geoUtils.ts         # Distance calc, bearing, bounding box
│       └── formatters.ts       # Distance/time/toll formatting (BM/EN)
├── .env.example
├── babel.config.js
├── tsconfig.json
├── .eslintrc.js
└── package.json
```

---

## TypeScript Conventions

```typescript
// Use explicit return types on all exported functions
export function formatDistance(meters: number, lang: Language): string { ... }

// Prefer interface over type for object shapes
interface Report {
  id: string
  type: ReportType
  coordinates: Coordinates
  createdAt: Date
  upvotes: number
  downvotes: number
}

// Enum for fixed sets
enum ReportType {
  Police = 'police',
  Accident = 'accident',
  Flood = 'flood',
  Pothole = 'pothole',
  Roadblock = 'roadblock',
  Hazard = 'hazard',
}

// No `any`. If unavoidable, add a comment explaining why.
```

---

## State Management Pattern

Each Zustand store follows this pattern:

```typescript
interface MapState {
  // State
  cameraCenter: Coordinates
  zoomLevel: number
  isFollowingUser: boolean
  // Actions
  setCameraCenter: (coords: Coordinates) => void
  setFollowingUser: (following: boolean) => void
}

export const useMapStore = create<MapState>((set) => ({
  cameraCenter: { latitude: 3.139, longitude: 101.6869 }, // KL default
  zoomLevel: 13,
  isFollowingUser: true,
  setCameraCenter: (coords) => set({ cameraCenter: coords }),
  setFollowingUser: (following) => set({ isFollowingUser: following }),
}))
```

---

## API Communication

All API calls go through the Axios instance in `services/api.ts`:

```typescript
const api = axios.create({
  baseURL: Config.ARAH_API_URL,
  timeout: 10000,
})

// JWT refresh interceptor on 401
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      await refreshToken()
      return api.request(error.config)
    }
    return Promise.reject(error)
  },
)
```

---

## Map Configuration

```typescript
// constants/index.ts
export const MAP_CONFIG = {
  TILE_URL: 'https://tiles.arah.my/{z}/{x}/{y}.pbf',
  STYLE_URL: 'https://tiles.arah.my/style.json',
  DEFAULT_CENTER: { latitude: 3.139, longitude: 101.6869 }, // Kuala Lumpur
  DEFAULT_ZOOM: 13,
  MIN_ZOOM: 5,
  MAX_ZOOM: 18,
  MALAYSIA_BOUNDS: {
    sw: { latitude: 1.0, longitude: 99.5 },
    ne: { latitude: 7.5, longitude: 119.5 },
  },
}
```

---

## Environment Variables

```env
# apps/mobile/.env.example
ARAH_API_URL=https://api.arah.my
ARAH_TILE_URL=https://tiles.arah.my
ARAH_SOCKET_URL=wss://realtime.arah.my
VALHALLA_URL=https://routing.arah.my
NOMINATIM_URL=https://geocode.arah.my
```

Use `react-native-config` to access env vars in code as `Config.ARAH_API_URL`.

---

## Coding Rules

1. No `console.log` in production code — use a logger utility
2. All strings user-visible: use i18n keys (BM default, EN fallback)
3. No inline styles — use `StyleSheet.create()`
4. No `useEffect` for derived state — compute in render or store selector
5. All screens wrapped in `<SafeAreaView>`
6. Error boundaries on screens, not on leaf components
7. Coordinates always as `{ latitude: number, longitude: number }` — never `[lng, lat]` (GeoJSON order) in app code

---

*Version 1.0 — 2026-07-19*
