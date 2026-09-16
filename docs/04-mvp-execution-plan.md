# 04 — MVP Execution Plan (Report-Aligned)

## Phase 0 — P0 Baseline, Security, and Buildability
Goal: make the inherited repository trustworthy before adding Travel Explorer features.

### P0-A Configuration and secrets
- Externalize Supabase URL/key and all map/model credentials.
- Rotate/revoke repository-exposed credentials.
- Restrict platform API keys.
- Do not put Gemini credentials in Flutter client code; use a server-side/Edge Function boundary for production AI.

### P0-B Backend contract
- Create versioned Supabase SQL migrations.
- Define profiles/users, guides/businesses, destinations, experiences, bookings, payments/manual-verification records, reviews, albums/media, calendar events, cities/countries, and chat tables only as justified by code/product.
- Define PK/FK, constraints, indexes, RLS, Storage buckets, and Storage policies.

### P0-C Build blockers and broken content
- Run `flutter --version`, `flutter pub get`, `flutter analyze`, `flutter test`.
- Repair or remove missing asset references.
- Remove `example.com` images/endpoints.
- Fix placeholder route arguments and placeholder tab screens.
- Make startup/AuthGate robust with valid configuration and clear errors.

### P0-D Code integrity
- Consolidate `guide_booking_controller.dart` and `guide_bookingcontroller.dart` into one implementation.
- Identify and remove dead/duplicate navigation paths.
- Add a structured error layer and stop silently converting backend failures into empty success states.

**Phase 0 exit criteria:**
- Build/analyzer/test status documented.
- No plaintext production secrets in tracked source.
- Versioned backend schema exists.
- Home/auth/startup do not depend on placeholder assets or fake endpoints.
- `docs/current-state.md` is committed and accurate.

## Phase 1 — Jordan Product Shell
- Rename visible product identity to Travel Explorer AI.
- Arabic/English + RTL/LTR.
- Preserve working Globe Guide patterns where useful.
- Replace Pakistan-specific launch content with Jordan data placeholders/seed data.

## Phase 2 — Discovery Core
- Destination + experience + category + city domain.
- Repository-backed home/search/filter/sort.
- Detail page.
- Map and navigation handoff.
- Favorites.
- Loading/empty/error/offline states.

## Phase 3 — Booking MVP
- Booking request.
- Availability/date validation.
- Manual confirmation workflow.
- User booking history.
- Operator confirm/reject/cancel/complete states.
- Idempotency/duplicate submission protection.
- Audit trail.

## Phase 4 — Trust and retention
- Verified reviews based on completed bookings where possible.
- Trip planner.
- Calendar.
- Guide/business profiles.

## Phase 5 — AI foundation
- `TravelAssistantService` interface.
- Deterministic recommendation engine as test double.
- Privacy/retention rules.
- Live model via server-side boundary only after data layer is stable.

## Phase 6 — Monetization and scale
- Gateway integrations.
- Commission settlement.
- Featured listings/subscriptions.
- Partner APIs.
- Regional configuration.
