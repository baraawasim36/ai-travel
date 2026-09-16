# 05 — Implementation Backlog

Use this as the agent's executable task list. Complete top-to-bottom unless a task is blocked.

## EPIC A — Baseline
- [ ] A01 Build baseline with current Flutter toolchain.
- [ ] A02 Run analyzer/tests and record failures.
- [ ] A03 Inventory `lib/` architecture.
- [ ] A04 Inventory Supabase tables/queries.
- [ ] A05 Inventory SQLite usage.
- [ ] A06 Inventory route/navigation system.
- [ ] A07 Inventory maps/Places integration.
- [ ] A08 Inventory chatbot integration.
- [ ] A09 Inventory secrets/configuration.
- [ ] A10 Create `docs/current-state.md`.

## EPIC B — Foundation
- [ ] B01 Create app-wide configuration layer.
- [ ] B02 Create error/result conventions.
- [ ] B03 Create repository interfaces for core domain.
- [ ] B04 Establish localization resources (AR/EN).
- [ ] B05 Establish RTL/LTR test coverage.
- [ ] B06 Create reusable loading/empty/error components.
- [ ] B07 Add app logging/debug diagnostics suitable for development.

## EPIC C — Discovery
- [ ] C01 Destination entity/model.
- [ ] C02 Experience entity/model.
- [ ] C03 Category entity/model.
- [ ] C04 Business entity/model.
- [ ] C05 Discovery repository.
- [ ] C06 Home sections backed by real queries.
- [ ] C07 Search.
- [ ] C08 Category filters.
- [ ] C09 City filters.
- [ ] C10 Experience detail.
- [ ] C11 Favorites.
- [ ] C12 Map detail and directions.
- [ ] C13 Nearby discovery with permission handling.

## EPIC D — Booking
- [ ] D01 Booking data model.
- [ ] D02 Booking state machine.
- [ ] D03 Booking creation form.
- [ ] D04 Server-side authorization rules.
- [ ] D05 Operator confirmation/rejection flow.
- [ ] D06 Cancellation flow.
- [ ] D07 User booking history.
- [ ] D08 Booking audit entries.

## EPIC E — Trust
- [ ] E01 Review data model.
- [ ] E02 Verified-review rule.
- [ ] E03 Rating aggregate.
- [ ] E04 Report/moderation hook.
- [ ] E05 Guide verification status model.

## EPIC F — Trip planning
- [ ] F01 Trip model.
- [ ] F02 Trip item model.
- [ ] F03 Add/remove/reorder experience.
- [ ] F04 Date/time scheduling.
- [ ] F05 Calendar integration.

## EPIC G — AI foundation
- [ ] G01 Assistant service interface.
- [ ] G02 Structured recommendation request DTO.
- [ ] G03 Structured recommendation response DTO.
- [ ] G04 Rule-based fake recommendation engine.
- [ ] G05 Chat persistence only after privacy/security review.
- [ ] G06 Live model adapter.

## EPIC H — Production readiness
- [ ] H01 Remove dead Pakistan demo data.
- [ ] H02 Verify secrets/config separation.
- [ ] H03 Crash/error telemetry.
- [ ] H04 Performance pass on image/map-heavy screens.
- [ ] H05 Accessibility pass.
- [ ] H06 Offline/network failure pass.
- [ ] H07 Release build verification.
- [ ] H08 End-to-end smoke tests for critical journeys.
