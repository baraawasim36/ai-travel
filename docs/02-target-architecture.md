# 02 — Target Architecture

## Architecture decision
Use the existing Flutter application as the client foundation and keep **Supabase** as the MVP backend. The original business material mentions Firebase, but the selected codebase currently uses Supabase; migrating backend technology is not an MVP objective.

## Logical layers
```text
Flutter UI
  -> Presentation / Feature State
  -> Domain Services / Use Cases
  -> Repositories
  -> Supabase / External APIs

External services:
  Maps & Places
  Geolocation
  Object Storage
  AI provider (deferred/isolated)
```

## Recommended folder direction
Do not reorganize the entire project in one pass. Migrate feature-by-feature toward:

```text
lib/
  app/
    app.dart
    router/
    theme/
    localization/
  core/
    constants/
    errors/
    result/
    utils/
    widgets/
    services/
  features/
    auth/
      data/
      domain/
      presentation/
    discovery/
      data/
      domain/
      presentation/
    places/
    experiences/
    bookings/
    favorites/
    reviews/
    map/
    profile/
    trips/
    assistant/          # shell only until AI phase
  shared/
    models/
    widgets/
```

The exact directory names can adapt to the current repo if that reduces churn. The architectural rule matters more than the folder spelling.

## Dependency direction
```text
presentation -> domain -> data
presentation -X-> concrete Supabase classes
presentation -X-> raw HTTP calls
presentation -X-> direct SQL/queries
```

Repositories/interfaces own persistence concerns. Services own external integrations. UI consumes state models and actions rather than knowing table names.

## Backend boundaries
### Supabase
Owns:
- Auth;
- PostgreSQL data;
- row-level security;
- storage metadata and file access;
- realtime where justified;
- server-side privileged actions via Edge Functions when required.

### Google Maps/Places
Use only through a provider/service abstraction. Do not scatter API-key strings or HTTP calls throughout widgets.

### AI
AI is a separate service boundary. It may read approved, normalized experience/place data through a controlled interface. AI must not write bookings, payments, or authorization decisions directly.

## Offline/resilience
The MVP should tolerate temporary network failure. Local caching can be introduced where the existing app already uses `sqflite`, but the agent must document the source of truth and invalidation rules. Avoid a second full database unless there is a demonstrated requirement.

## Localization
All user-visible text must use localization resources.
- Arabic: RTL.
- English: LTR.
- Never infer direction from string content.
- Dates/currency/number formatting must use locale-aware utilities.

## Security principles
- Public client keys only where intended by the provider.
- Never ship service-role/private keys.
- Enforce authorization server-side with Supabase RLS/policies.
- Validate booking state transitions server-side.
- Sanitize and validate user-entered review/content fields.
- Keep audit fields (`created_at`, `updated_at`, and actor identifiers) on mutable records where practical.
