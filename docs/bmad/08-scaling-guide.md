# Arah — Scaling Guide

## Overview

This document defines how to scale the Arah platform from MVP (0–10k users) to production (1M+ users). It covers infrastructure upgrades, Kubernetes deployment, caching strategy, database scaling, and cost estimates at each phase.

All Kubernetes manifests are in `infra/k8s/`.

---

## Scaling Phases

### Phase 1 — MVP (0–10k users)
**Infrastructure:** Single-server Docker Compose (`infra/docker-compose.yml`)
**Bottleneck:** None at this scale
**Action:** Ship the product, validate product-market fit
**Monthly cost:** ~RM 500 (1× EC2 m5.large or equivalent)

---

### Phase 2 — Early Growth (10k–100k users)
**Infrastructure:** AWS ECS Fargate + Redis + Cloudflare CDN
**Bottleneck:** API Gateway single instance, Nominatim cold queries
**Actions:**
- Deploy API Gateway to ECS Fargate (2+ tasks, ALB in front)
- Add Redis ElastiCache for API response caching
- Put Cloudflare in front of tile server (CDN caches tiles globally)
- Enable Firestore offline persistence on mobile to reduce reads
- Add Sentry for error tracking

**Monthly cost:** ~RM 2,000

---

### Phase 3 — Scale (100k–1M users)
**Infrastructure:** Kubernetes (EKS) with Horizontal Pod Autoscaler
**Bottleneck:** Valhalla memory (4GB/instance), Nominatim under search load
**Actions:**
- Migrate all services to Kubernetes (`infra/k8s/`)
- Valhalla: 3+ replicas, Redis cache for popular routes
- Nominatim: 2+ replicas (read), 1 write replica
- API Gateway: HPA 2–10 pods based on CPU/RPS
- Prometheus + Grafana monitoring
- FCM push notifications for report alerts

**Monthly cost:** ~RM 8,000–15,000

---

### Phase 4 — National Scale (1M+ users)
**Infrastructure:** Multi-AZ EKS + Aurora PostgreSQL + Kafka
**Bottleneck:** Firestore cost at extreme read volume, report fan-out latency
**Actions:**
- Migrate Firestore reports → Aurora PostgreSQL + PostGIS (cheaper at scale)
- Replace Socket.io realtime → Kafka + WebSocket gateway
- Malaysia-region datacenter (AIMS, TM One) for data sovereignty
- Valhalla: 6+ replicas, dedicated node pool
- Nominatim: Aurora PostgreSQL with PostGIS extension
- CDN: Cloudflare R2 for tile storage (pay-per-use, cheaper than S3)
- Multi-AZ for all stateful services

**Monthly cost:** ~RM 30,000–60,000

---

## Kubernetes Architecture (Phase 3+)

```
                         Internet
                             │
                    ┌────────▼────────┐
                    │   Cloudflare    │  WAF, DDoS, CDN
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │    AWS ALB      │  SSL termination
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  K8s Ingress    │  nginx-ingress-controller
                    │  (arah.my)      │
                    └────┬──────┬─────┘
                         │      │
            ┌────────────┘      └────────────┐
            ▼                                ▼
   ┌─────────────────┐            ┌─────────────────┐
   │  api-gateway    │            │  tile-server    │
   │  (2–10 pods)    │            │  (2–4 pods)     │
   │  HPA: CPU 70%   │            │  Cloudflare CDN │
   └────────┬────────┘            └─────────────────┘
            │
    ┌───────┼───────────────┐
    ▼       ▼               ▼
┌───────┐ ┌──────────┐ ┌──────────────┐
│ Redis │ │ Valhalla │ │  Nominatim   │
│Cluster│ │(3 pods)  │ │  (2 pods)    │
│       │ │ 4GB RAM  │ │  read slaves │
│       │ │ per pod  │ │              │
└───────┘ └──────────┘ └──────────────┘
    │
    └──── Firebase Firestore (managed)
```

---

## Redis Caching Strategy

| Data | TTL | Cache Key Pattern |
|------|-----|-------------------|
| Route (from→to, same profile) | 5 min | `route:{from_lat4}:{from_lng4}:{to_lat4}:{to_lng4}:{profile}` |
| Search results | 1 hour | `geocode:{query_normalized}` |
| Active reports (bbox) | 30 sec | `reports:{sw_lat2}:{sw_lng2}:{ne_lat2}:{ne_lng2}` |
| User profile | 5 min | `profile:{uid}` |
| Reverse geocode | 24 hours | `revgeo:{lat4}:{lng4}` |

Coordinate precision: 4 decimal places for routes (~11m accuracy), 2 for report bbox (~1km cells).

---

## Valhalla Scaling Notes

- Each Valhalla instance loads the full Malaysia graph (~4GB RAM)
- Route calculation: ~50–200ms per request
- One instance handles ~500 concurrent requests safely
- At 1M MAU with 20% using navigation simultaneously = 200k concurrent → need ~400 pods
- **Reality check:** Simultaneous navigation sessions at peak = ~5–10% of MAU = 50k–100k
- 3 pods (12GB RAM total) handles ~1,500 concurrent routes — sufficient for 500k MAU
- Cache popular routes in Redis to reduce Valhalla load by ~60%

**Recommended node pool for Valhalla:** `r6i.xlarge` (32GB RAM, 4 vCPU) — run 4 Valhalla pods per node

---

## Firestore → PostgreSQL Migration Trigger

Migrate when **monthly Firestore reads exceed 5 billion** (approximately 500k DAU × 10k reads/day).

Migration path:
1. Run PostgreSQL + PostGIS alongside Firestore (dual-write)
2. Backfill historical data
3. Switch reads to PostgreSQL
4. Remove Firestore writes
5. Keep Firebase Auth (no reason to migrate auth)

---

## Monitoring Stack

### Metrics: Prometheus + Grafana
Key dashboards:
- API Gateway: RPS, p50/p95/p99 latency, error rate
- Valhalla: routing latency, queue depth, cache hit rate
- Redis: memory usage, hit/miss ratio, eviction rate
- Firestore: read/write counts, cost projection

### Alerts (PagerDuty / Telegram bot)
| Alert | Threshold | Severity |
|-------|-----------|----------|
| API error rate | >1% for 5min | Critical |
| Valhalla p99 latency | >5s | Warning |
| Redis memory | >80% | Warning |
| Pod crash loop | 3 restarts | Critical |
| Tile server 5xx | >0.1% | Warning |

### Error tracking: Sentry
- Mobile: `@sentry/react-native`
- API Gateway: `@sentry/node`
- Web: `@sentry/nextjs`

---

## Cost Breakdown (Phase 3 — 500k MAU)

| Service | Instance | Cost/month (RM) |
|---------|----------|----------------|
| EKS cluster | 1 cluster | ~RM 300 |
| API Gateway nodes | 2× m5.large | ~RM 700 |
| Valhalla nodes | 2× r6i.xlarge | ~RM 2,400 |
| Nominatim nodes | 1× m5.xlarge | ~RM 700 |
| Redis ElastiCache | cache.r6g.large | ~RM 600 |
| Tile Server | 2× t3.medium | ~RM 300 |
| Cloudflare CDN | Pro plan | ~RM 100 |
| Firebase (Blaze) | ~50B reads/mo | ~RM 2,000 |
| Data transfer | ~5TB/month | ~RM 800 |
| **Total** | | **~RM 7,900/month** |

---

## Security at Scale

| Layer | Control |
|-------|---------|
| Cloudflare WAF | Block SQL injection, XSS, bots |
| AWS Security Groups | Deny all inter-service traffic except defined ports |
| K8s NetworkPolicy | Pods only communicate through defined service routes |
| Secrets | AWS Secrets Manager (not env vars in K8s manifests) |
| mTLS | Service mesh (Linkerd) for pod-to-pod encryption |
| Rate limiting | Redis-backed: 60 req/min per user, 5 reports/min |
| DDoS | Cloudflare Magic Transit or AWS Shield Standard |

---

*Version 1.0 — 2026-07-19*
