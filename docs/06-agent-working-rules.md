# 06 — Agent Working Rules

## Before coding
Read the relevant feature docs. Inspect existing code first. Search for an equivalent implementation before creating a new class/file.

## When modifying existing code
- Keep diffs narrow.
- Do not rename hundreds of files solely for aesthetics.
- Extract duplicated business logic into services/repositories.
- Preserve behavior unless the backlog item explicitly changes it.

## Data access
UI widgets must not contain direct Supabase table queries. Queries belong in repositories/data sources.

## Business logic
Booking transitions, verification state, commission calculations, and permissions are business rules, not UI conditions.

## UI
Every network-backed screen needs at least:
- loading;
- success;
- empty;
- error;
- retry where meaningful.

## Maps
Map provider APIs are behind an abstraction. The product must work with missing location permission. Do not block discovery merely because GPS is off.

## Localization
No new hard-coded user-visible text. Add translation keys.

## Images/media
Do not ship a new large asset for every place. Prefer remote/object-storage URLs for scalable content, with caching and placeholders.

## Testing standard
For each new domain object:
- model serialization/deserialization;
- repository success path;
- repository failure path;
- authorization/permission case where relevant;
- provider/state transition;
- one user-flow/widget test for critical features.

## Git discipline
Recommended commit granularity:
- `chore: establish baseline`
- `refactor: isolate discovery data layer`
- `feat: jordan discovery`
- `feat: booking request flow`
- `feat: trip planning`
- `test: cover booking state transitions`

Do not make a "big bang" commit containing unrelated refactors and features.

## Stop conditions
Pause implementation of a task and document it when:
- current code and schema conflict in a way that may delete data;
- auth/RLS would be bypassed;
- a new third-party service is required but not configured;
- payment or financial behavior is being introduced before its business rules are defined;
- a migration would make rollback unsafe.
