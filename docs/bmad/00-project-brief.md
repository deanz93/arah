# Arah — Project Brief

## Vision

**Arah** (meaning "Direction" in Malay) is a community-powered navigation app built for Malaysia, by Malaysians. It delivers real-time crowd-sourced traffic intelligence, hyperlocal hazard alerts, and Malaysia-specific features that global apps do not provide.

## Problem Statement

- Over 90% of Malaysian drivers use Waze or Google Maps — both foreign-owned platforms with no local accountability and no data sovereignty.
- Ownership concerns have raised national discussions about foreign app dependency.
- No navigation app natively addresses Malaysia-specific needs: flash floods, toll cost transparency, emergency road cuts, and a Bahasa Malaysia-first UX.

## Goals

| # | Goal | Success Metric |
|---|------|----------------|
| 1 | Working navigation MVP for Malaysian roads | Turn-by-turn routing functions end-to-end |
| 2 | Community reporting at Waze feature parity | Police, accidents, floods, potholes, roadblocks |
| 3 | Malaysia-specific differentiators | Toll cost display, flood alerts, BM voice guidance |
| 4 | 50k MAU in Year 1 | Analytics dashboard |
| 5 | Data sovereignty | All data stored in Malaysian-region datacenters |

## Non-Goals (MVP / v1)

- Public transit (LRT/bus/MRT) directions → v2
- Motorcycle-specific routing → v2
- Ride-hailing integration → v3
- Cross-border navigation (Singapore, Thailand) → v2
- Map editing UI → v2 (direct OSM contribution)

## Target Users

| Persona | Profile |
|---------|---------|
| **Daily Commuter** | KL/PJ/JB office worker, drives to work, needs fastest route |
| **Intercity Traveler** | KL–Penang, KL–JB highway trips, needs toll costs upfront |
| **Delivery Driver** | GrabFood/Lalamove drivers, time-sensitive multi-stop routing |
| **Community Reporter** | Active user who flags hazards and validates others' reports |

## MVP Feature Checklist

- [ ] Real-time user GPS position on map
- [ ] Address and POI search
- [ ] Turn-by-turn voice navigation (Bahasa Malaysia + English)
- [ ] Route alternatives: fastest / toll-free / shortest
- [ ] Estimated toll cost per route
- [ ] Community reports: police, accident, flood, pothole, roadblock
- [ ] Report upvote / confirm / clear voting
- [ ] Offline map tiles for Peninsular Malaysia

## Competitive Positioning

| Feature | Arah | Waze | Google Maps |
|---------|------|------|-------------|
| Malaysia data sovereignty | ✅ | ❌ | ❌ |
| Bahasa Malaysia-first UI | ✅ | Partial | Partial |
| Flash flood alerts | ✅ | ❌ | ❌ |
| Toll cost estimation | ✅ | Basic | ❌ |
| Open-source map data (OSM) | ✅ | ❌ | ❌ |
| Community hazard reports | ✅ | ✅ | Partial |
| Offline maps | ✅ | Limited | ✅ |

## Tech Philosophy

- **Open-source first** — OpenStreetMap, Valhalla, MapLibre GL
- **Privacy by design** — No data selling; anonymised GPS pings
- **Malaysian cloud** — AWS ap-southeast-1 (Singapore) initially → MY datacenter when viable
- **Mobile-first** — Android priority (90%+ of Malaysian smartphone market)

## Stakeholders

| Role | Responsibility |
|------|----------------|
| Product Owner | Feature prioritization, user research |
| Tech Lead | Architecture, code review, ADRs |
| Mobile Dev | React Native iOS + Android app |
| Backend Dev | Routing, real-time, geocoding microservices |
| DevOps | CI/CD, infrastructure, monitoring |
| Community Manager | OSM data quality, report moderation |

---

*Version 1.0 — 2026-07-19*
