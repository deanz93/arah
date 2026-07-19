# Arah — AI Agent Context (CLAUDE.md)

This file is loaded automatically by Claude Code. Any AI agent or developer picking up this project should read this file first.

## What is Arah?

Arah is a Malaysian community-powered navigation app — a sovereign alternative to Waze and Google Maps. Built with open-source tools (OpenStreetMap, Valhalla, MapLibre), deployed on Malaysian-region infrastructure, with Bahasa Malaysia-first UX.

**App Name:** Arah (meaning "Direction" in Malay)
**Tagline:** Tunjuk Arah, Bersama (Show Direction, Together)
**Platform:** React Native (Android-priority, iOS secondary)

## Repository Layout

```
arah/
├── CLAUDE.md                  ← You are here
├── docs/
│   ├── bmad/                  ← BMAD methodology documents (read these first)
│   │   ├── 00-project-brief.md
│   │   ├── 01-prd.md
│   │   ├── 02-architecture.md
│   │   ├── 03-tech-spec.md
│   │   ├── 04-api-spec.md
│   │   ├── 05-epics-stories.md
│   │   └── 06-dev-setup.md
│   └── adr/                   ← Architecture Decision Records
├── apps/
│   └── mobile/                ← React Native app (TypeScript)
│       └── src/
│           ├── components/    ← Reusable UI components
│           ├── screens/       ← Full-page screen components
│           ├── navigation/    ← React Navigation configuration
│           ├── store/         ← Zustand state stores
│           ├── services/      ← API, location, socket services
│           ├── hooks/         ← Custom React hooks
│           ├── types/         ← TypeScript type definitions
│           ├── utils/         ← Helper functions
│           └── constants/     ← App-wide constants
└── services/                  ← Backend microservices (Node.js / Go stubs)
    ├── api-gateway/
    ├── routing/
    ├── realtime/
    └── geocoding/
```

## Current Sprint Focus

See `docs/bmad/05-epics-stories.md` for the active sprint and backlog.

**Currently building:** Epic 1 — Core Map & Navigation (MVP)

## Key Technical Decisions

| Decision | Choice | Why |
|----------|--------|-----|
| Mobile framework | React Native (TypeScript) | Single codebase, large ecosystem |
| Map renderer | MapLibre GL (react-native-maps alternative) | Open-source, no API key cost |
| Map data | OpenStreetMap via PMTiles | Free, community-maintained, Malaysia coverage |
| Routing engine | Valhalla (self-hosted) | Open-source, supports turn-by-turn, Malaysian roads |
| Geocoding | Nominatim (self-hosted) | Free, OSM-based |
| State management | Zustand | Lightweight, minimal boilerplate |
| Data fetching | TanStack Query (React Query) | Caching, background refetch, loading states |
| Real-time | Socket.io | Community report broadcasting |
| Voice TTS | react-native-tts | BM and EN language support |

## Environment Variables

Copy `apps/mobile/.env.example` to `apps/mobile/.env`. Required:

```
ARAH_API_URL=https://api.arah.my
ARAH_TILE_URL=https://tiles.arah.my
ARAH_SOCKET_URL=wss://realtime.arah.my
VALHALLA_URL=https://routing.arah.my
NOMINATIM_URL=https://geocode.arah.my
```

## Development Commands

```bash
# Mobile app
cd apps/mobile
npm install
npm run android     # Run on Android emulator
npm run ios         # Run on iOS simulator (macOS only)
npm run lint        # ESLint
npm run typecheck   # TypeScript check
npm test            # Jest unit tests
```

## Conventions

- **Language:** TypeScript strict mode throughout
- **Naming:** Components in PascalCase, functions/vars in camelCase, constants in SCREAMING_SNAKE_CASE
- **Files:** One component per file, named same as the component
- **Imports:** Absolute paths using `@/` alias (e.g. `@/components/Map/MapView`)
- **Commits:** Conventional Commits format (`feat:`, `fix:`, `docs:`, `chore:`)
- **Branch naming:** `feature/US-XXX-short-description`, `fix/US-XXX-description`

## AI Agent Instructions

When continuing work on this project:

1. Read `docs/bmad/05-epics-stories.md` to find the next unstarted story.
2. Read `docs/bmad/02-architecture.md` before touching services.
3. Read `docs/bmad/03-tech-spec.md` before adding new dependencies.
4. Always update story status in `05-epics-stories.md` when completing work.
5. Follow the coding conventions above.
6. Write TypeScript — no `any` types unless unavoidable (comment why).
7. No comments unless the WHY is non-obvious.
8. Test with real Malaysian coordinates: KL (3.1390° N, 101.6869° E).

## Contact / Ownership

- GitHub: https://github.com/deanz93/arah
- Email: developer@plisca.com.my
