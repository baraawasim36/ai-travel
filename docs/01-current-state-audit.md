# 01 — Current State Audit Contract

## Repository baseline
The chosen starting repository is:
`Mahad-Ghauri/Globe_Guide-Tour-Guide-Application`

The public README describes a Flutter travel app with onboarding, authentication, home/trending destinations, city/country selection, calendar, chatbot, guide marketplace, bookings, albums, maps, QR verification, reviews, profile management, payments, and support.

The repository's own project documentation describes Flutter + Provider on the client and Supabase/PostgreSQL/Realtime/Storage/Edge Functions on the backend, and lists the application as supporting Gemini, Google Maps/Places, local payment methods, QR, reviews, and albums.

However, the actual `pubspec.yaml` currently exposes the real dependency baseline and includes `supabase_flutter`, `sqflite`, Google Maps/Places packages, geolocation, media packages, QR packages, Provider, and other UI utilities. It does not currently declare Firebase packages. This document therefore treats **Supabase as the actual baseline backend** and requires the agent to verify the runtime code before assuming any feature exists.

## Mandatory audit before feature work
Create `docs/current-state.md` in the target repository after the first local inspection.

Record:
1. Flutter/Dart versions.
2. Entry point(s).
3. Current folder structure under `lib/`.
4. State-management providers/controllers.
5. Models/entities.
6. Supabase initialization and tables referenced by code.
7. Any local SQLite usage and why it exists.
8. Authentication flow.
9. Map/Places flow and API-key locations.
10. Booking flow and persistence.
11. Chatbot flow and model/provider used.
12. Asset/content sources.
13. Navigation and route definitions.
14. localization support, if any.
15. tests and their current pass/fail state.
16. known crashes, TODOs, dead code, and duplicate implementations.

## Audit commands
Run from repo root:

```powershell
flutter --version
flutter pub get
flutter analyze
flutter test
Get-ChildItem -Recurse lib | Select-Object FullName
Select-String -Path .\lib\**\*.dart -Pattern 'Supabase|SQLite|sqflite|Firebase|GoogleMap|google_places|Gemini|GenerativeModel|booking|guide|review|calendar|Provider'
```

If PowerShell globbing is insufficient, use a small Dart/Python/shell inventory script instead.

## Audit classification
For every existing feature classify it as:
- `KEEP`: already useful and structurally safe;
- `ADAPT`: useful but needs domain/Jordan/product changes;
- `REFACTOR`: technically useful but too coupled or brittle;
- `REPLACE`: feature exists conceptually but implementation is unsuitable;
- `REMOVE`: irrelevant to Travel Explorer MVP.

Do not classify from README text alone. Classification requires code evidence.

## Initial repository-specific observations to verify locally
- The repo is Flutter-based.
- The published README claims guide hiring and booking.
- The published documentation claims Supabase as backend.
- The package manifest includes Supabase rather than Firebase.
- The package manifest includes `sqflite`; the agent must determine whether it is production-critical or legacy/local-only.
- The asset list contains Pakistan-specific names such as Hunza, Fairy Meadows, Babusar Top, Lahore, Kashmir, Peshawar, etc.; these must not remain as the primary Jordan product content.

## First deliverable after audit
`docs/current-state.md` plus a commit containing **only** audit/health improvements if any are required to make the app buildable. Do not mix a large feature with the baseline cleanup.
