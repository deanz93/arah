# Contributing to Arah

Thank you for contributing to Arah — Malaysia's navigation platform!

## Before You Start

1. Read `CLAUDE.md` for the AI agent context and project conventions.
2. Read `docs/bmad/05-epics-stories.md` to find an unstarted story to work on.
3. Read `docs/bmad/06-dev-setup.md` to set up your dev environment.

## Picking a Story

All work is tracked in `docs/bmad/05-epics-stories.md`. Look for stories with status `⬜` (Not started). Claim a story by:

1. Opening a PR that changes the story status to `🔵 In progress` with your name in the Owner column.
2. Creating a branch: `feature/S-XXX-short-description`

## Branch & Commit Rules

```
Branch: feature/S-013-search-autocomplete
        fix/S-012-gps-heading-wrong
        chore/upgrade-maplibre

Commit: feat(search): add autocomplete debouncing
        fix(map): correct GPS heading calculation
        chore(deps): upgrade maplibre-react-native to 10.1
```

Format: [Conventional Commits](https://www.conventionalcommits.org/)

## PR Checklist

Before submitting a pull request:

- [ ] Story ID referenced in PR title (`S-XXX`)
- [ ] Story status updated to `✅ Done` in `docs/bmad/05-epics-stories.md`
- [ ] `npm run lint` passes in the affected package
- [ ] `npm run typecheck` passes
- [ ] `npm test` passes
- [ ] Tested on Android emulator (API 33+)
- [ ] No `console.log` in production code
- [ ] No hardcoded coordinates (use `MAP_CONFIG.DEFAULT_CENTER` or constants)
- [ ] No `any` types without explanation comment

## Scope Rules

- **Mobile changes**: edit files under `apps/mobile/`
- **Web changes**: edit files under `apps/web/`
- **API changes**: edit files under `services/api-gateway/`
- **Infra changes**: edit files under `infra/`
- **Documentation**: update relevant files under `docs/bmad/`

## Code Style

- TypeScript strict mode — no `any` unless justified
- No inline styles in RN — use `StyleSheet.create()`
- No comments explaining WHAT code does — only WHY if non-obvious
- BM strings in UI components, use i18n keys (not hardcoded English)

## AI Agent Contributions

If you are an AI agent contributing to this project:

1. Read `CLAUDE.md` first.
2. Find the next unstarted story in `docs/bmad/05-epics-stories.md`.
3. Implement the story according to `docs/bmad/03-tech-spec.md`.
4. Update the story status to `✅ Done`.
5. Follow all PR checklist items above.

---

*Built with ❤️ in Malaysia 🇲🇾*
