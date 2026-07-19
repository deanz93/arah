# Arah — Malaysian Navigation Platform

> **Arah** (Direction in Malay) — A sovereign, community-powered navigation platform for Malaysia.

Tagline: *Tunjuk Arah, Bersama* (Show Direction, Together)

---

## Platform Overview

Arah is a full navigation platform — not just an app. Each service lives in its own repo:

| Repo | Tech | Description |
|------|------|-------------|
| [arah-mobile](https://github.com/deanz93/arah-mobile) | React Native 0.74 + TypeScript | iOS + Android navigation app |
| [arah-web](https://github.com/deanz93/arah-web) | Next.js 14 + TypeScript | Public site, user login, admin panel |
| [arah-api](https://github.com/deanz93/arah-api) | Node.js + Fastify | Auth, reports, user profile API |
| [arah-routing](https://github.com/deanz93/arah-routing) | Valhalla (C++) | Self-hosted turn-by-turn routing engine |
| [arah-geocoding](https://github.com/deanz93/arah-geocoding) | Nominatim | Self-hosted OSM-based address search |
| [arah-tile-server](https://github.com/deanz93/arah-tile-server) | PMTiles + TileServer-GL | Self-hosted vector map tile server |
| [arah-functions](https://github.com/deanz93/arah-functions) | Firebase Cloud Functions | Report expiry, auto-remove, counters |
| [arah-infra](https://github.com/deanz93/arah-infra) | Terraform + Kubernetes + Helm | All infrastructure-as-code |

> This repo (`arah`) is the **main reference** — BMAD documentation, architecture decisions, API spec, and the monorepo scaffold live here.

All mapping data is sourced from **OpenStreetMap**. No proprietary APIs. All data stored in Malaysia-region infrastructure.

---

## Quick Start (Local Dev)

```bash
# Clone
git clone https://github.com/deanz93/arah.git && cd arah

# Start full backend stack
cd infra && docker-compose up

# Mobile app
cd apps/mobile && npm install && npx react-native run-android

# Web app
cd apps/web && npm install && npm run dev
```

> Full setup instructions: [docs/bmad/06-dev-setup.md](docs/bmad/06-dev-setup.md)

---

## Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   Mobile App    │    │    Web Portal   │
│  (React Native) │    │    (Next.js)    │
└────────┬────────┘    └────────┬────────┘
         │                      │
         └──────────┬───────────┘
                    │ HTTPS
              ┌─────▼──────┐
              │   nginx    │  ← reverse proxy
              └─────┬──────┘
       ┌────────────┼────────────┬──────────┐
       ▼            ▼            ▼          ▼
  ┌─────────┐ ┌──────────┐ ┌────────┐ ┌────────────┐
  │  API    │ │ Routing  │ │ Tiles  │ │ Geocoding  │
  │ Gateway │ │(Valhalla)│ │(PMTile)│ │(Nominatim) │
  └────┬────┘ └──────────┘ └────────┘ └────────────┘
       │
  ┌────┴──────────────┐
  │     Firebase      │
  │ Auth + Firestore  │
  │   + Analytics     │
  └───────────────────┘
```

---

## Documentation

| Document | Description |
|----------|-------------|
| [00-project-brief](docs/bmad/00-project-brief.md) | Vision, goals, competitive positioning |
| [01-prd](docs/bmad/01-prd.md) | Product requirements and user stories |
| [02-architecture](docs/bmad/02-architecture.md) | System architecture |
| [03-tech-spec](docs/bmad/03-tech-spec.md) | Technical specifications |
| [04-api-spec](docs/bmad/04-api-spec.md) | API contracts |
| [05-epics-stories](docs/bmad/05-epics-stories.md) | Agile epics and sprint stories |
| [06-dev-setup](docs/bmad/06-dev-setup.md) | Developer setup guide |
| [07-firebase-architecture](docs/bmad/07-firebase-architecture.md) | Firebase data model and integration |

---

## Scalability

Arah is designed to scale from MVP to 1M+ Malaysian users without a full rewrite.

| Phase | Users | Infrastructure |
|-------|-------|---------------|
| MVP | 0–10k | Docker Compose (`infra/docker-compose.yml`) |
| Growth | 10k–100k | ECS Fargate + Redis + Cloudflare CDN |
| Scale | 100k–1M | Kubernetes (`infra/k8s/`) + HPA + monitoring |
| National | 1M+ | Multi-AZ + Aurora PostgreSQL + Kafka |

Full details: [docs/bmad/08-scaling-guide.md](docs/bmad/08-scaling-guide.md)
K8s manifests: [infra/k8s/](infra/k8s/)

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Story IDs in `docs/bmad/05-epics-stories.md` track what to build next.

- Branch format: `feature/S-XXX-description`
- Commits: [Conventional Commits](https://www.conventionalcommits.org/)
- PR: reference the story ID, update story status in `05-epics-stories.md`

---

## License

MIT — Free to use, modify, and distribute. See [LICENSE](LICENSE).

*Built in Malaysia 🇲🇾*
