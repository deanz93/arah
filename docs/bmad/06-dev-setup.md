# Arah — Developer Setup Guide

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Node.js | 20 LTS | https://nodejs.org |
| npm | 10.x | Bundled with Node |
| React Native CLI | latest | `npm i -g react-native-cli` |
| Android Studio | latest | https://developer.android.com/studio |
| Xcode | 15+ | Mac App Store (macOS only) |
| Java JDK | 17 | https://adoptium.net |
| Docker | latest | https://docker.com |
| Git | latest | https://git-scm.com |

---

## 1. Clone & Install

```bash
git clone https://github.com/deanz93/arah.git
cd arah

# Mobile app
cd apps/mobile
npm install

# Web app
cd ../../apps/web
npm install
```

---

## 2. Firebase Setup

### 2.1 Create Firebase Project

1. Go to https://console.firebase.google.com
2. Create a new project named `arah-app`
3. Enable these services:
   - **Authentication** → Sign-in methods: Google, Phone
   - **Firestore Database** → Production mode
   - **Analytics** → Enable
   - **Crashlytics** → Enable

### 2.2 Mobile App — Download config files

1. In Firebase Console → Project Settings → Your apps
2. Add Android app: package name `com.arah.app`
3. Download `google-services.json` → place at `apps/mobile/android/app/google-services.json`
4. Add iOS app: bundle ID `com.arah.app`
5. Download `GoogleService-Info.plist` → place at `apps/mobile/ios/GoogleService-Info.plist`

### 2.3 Web App — Firebase config

1. In Firebase Console → Project Settings → Your apps → Web app
2. Copy the config object
3. Create `apps/web/.env.local`:

```env
NEXT_PUBLIC_FIREBASE_API_KEY=...
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=arah-app.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=arah-app
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=arah-app.appspot.com
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=...
NEXT_PUBLIC_FIREBASE_APP_ID=...

# Firebase Admin (server-side, keep secret)
FIREBASE_PROJECT_ID=arah-app
FIREBASE_CLIENT_EMAIL=...
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----"
```

> Get the Admin SDK credentials from Firebase Console → Project Settings → Service accounts → Generate new private key.

---

## 3. Backend Services (Docker)

### 3.1 Valhalla (Routing Engine)

```bash
cd services/routing

# Download Malaysia OSM data (~300MB)
wget https://download.geofabrik.de/asia/malaysia-singapore-brunei-latest.osm.pbf

# Build Valhalla tiles (~10min first time)
docker-compose up valhalla-build

# Start routing server
docker-compose up valhalla
# Runs at http://localhost:8002
```

### 3.2 Nominatim (Geocoding)

```bash
cd services/geocoding

# This downloads ~2GB and imports OSM data (~30min)
docker-compose up nominatim
# Runs at http://localhost:7070
```

### 3.3 API Gateway

```bash
cd services/api-gateway
cp .env.example .env
# Fill in Firebase Admin SDK values in .env
npm install
npm run dev
# Runs at http://localhost:3001
```

---

## 4. Mobile App

### 4.1 Environment Variables

```bash
cd apps/mobile
cp .env.example .env
# Edit .env with local service URLs:
# ARAH_API_URL=http://10.0.2.2:3001  (Android emulator)
# VALHALLA_URL=http://10.0.2.2:8002
# NOMINATIM_URL=http://10.0.2.2:7070
```

> Note: `10.0.2.2` is the Android emulator's alias for your host machine's `localhost`. For iOS simulator, use `127.0.0.1`.

### 4.2 Android

```bash
cd apps/mobile

# Start Metro bundler
npx react-native start

# In another terminal:
npx react-native run-android
```

### 4.3 iOS (macOS only)

```bash
cd apps/mobile/ios
pod install

cd ..
npx react-native run-ios
```

---

## 5. Web App

```bash
cd apps/web
npm run dev
# Opens at http://localhost:3000
```

Pages:
- `/` — Public landing page
- `/admin` — Admin dashboard (requires Firebase Auth with admin claim)
- `/admin/reports` — Live report moderation
- `/admin/users` — User management

---

## 6. Development Commands

### Mobile

```bash
cd apps/mobile
npm run android        # Run on Android
npm run ios            # Run on iOS (macOS only)
npm run lint           # ESLint
npm run typecheck      # TypeScript check (no emit)
npm test               # Jest unit tests
npm run test:watch     # Jest in watch mode
```

### Web

```bash
cd apps/web
npm run dev            # Development server
npm run build          # Production build
npm run lint           # ESLint
npm run typecheck      # TypeScript check
npm test               # Jest tests
```

---

## 7. Git Workflow

```
main          ← production-ready, protected
  └── develop ← integration branch for features
       ├── feature/S-011-map-screen
       ├── feature/S-013-search-screen
       └── fix/S-012-gps-accuracy
```

### Branch naming
- `feature/S-XXX-short-description`
- `fix/S-XXX-short-description`
- `chore/description`
- `docs/description`

### Commit format (Conventional Commits)
```
feat(map): add user GPS position blue dot
fix(routing): handle valhalla timeout gracefully
chore(deps): upgrade maplibre to 10.1.0
docs(bmad): update epic 2 story statuses
```

### PR checklist
- [ ] Story ID referenced in PR title (e.g. `S-013`)
- [ ] `npm run lint` passes
- [ ] `npm run typecheck` passes
- [ ] `npm test` passes
- [ ] Tested on Android emulator (API 33)
- [ ] Updated story status in `docs/bmad/05-epics-stories.md`

---

## 8. Useful Test Coordinates (Malaysia)

| Location | Latitude | Longitude |
|----------|----------|-----------|
| KLCC | 3.1578 | 101.7118 |
| Putrajaya | 2.9264 | 101.6964 |
| Penang Bridge (Mainland) | 5.3730 | 100.3991 |
| JB CIQ | 1.4637 | 103.7640 |
| KLIA | 2.7456 | 101.7099 |
| Pavilion KL | 3.1488 | 101.7131 |

---

*Version 1.0 — 2026-07-19*
