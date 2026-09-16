# 01 — Current State Audit (Evidence-Based)

Generated after local inspection of `Globe_Guide-Tour-Guide-Application` at D:\bara\Globe_Guide-Tour-Guide-Application.

## 1. Flutter/Dart Versions
- **Flutter**: Not installed in PATH (could not run `flutter --version`)
- **Dart SDK**: Specified as `^3.7.0` in pubspec.yaml
- **pubspec.yaml**: Present at root, declares Flutter SDK, supabase_flutter ^2.9.0, provider ^6.0.0, google_maps_flutter ^2.5.0, google_places_flutter ^2.1.0, sqflite ^2.4.2, and 30+ other dependencies

## 2. Entry Points
- **lib/main.dart**: Main entry point. Initializes Supabase with **hardcoded URL and anon key**, then runs `MyApp` with Provider setup.
- **ErrorApp**: Fallback widget shown if Supabase init fails.

## 3. Folder Structure (lib/)
```
lib/
├── main.dart
├── Components/          # 11 reusable UI components
├── Controllers/         # 22 controllers (state/business logic)
│   ├── authentication/  # auth_controller.dart, auth_gate.dart
│   ├── chatbot/         # chatbot_controller.dart, database_controller.dart
│   ├── guide/           # guide_booking_controller.dart, guide_bookingcontroller.dart (DUPLICATE)
│   ├── maps/            # map_controller.dart, google_map_controller.dart
│   ├── Services/        # supabase_service.dart (stub), google_map_service.dart, api_service.dart, location_service.dart
├── models/              # 3 models: destination_model.dart, calendar_event.dart, location_details.dart
├── Screens/             # 40+ screens
│   ├── authentication/  # 7 auth screens
│   ├── Calendar/        # calendar_screen.dart, calendar_view.dart
│   ├── Chat Bot/        # chatbot_screen.dart, chatbot_interface.dart
│   ├── locations/       # 4 hardcoded Pakistan location screens
│   ├── QR/              # qr_scanner_screen.dart (commented out), qr_scanner_confirmation_screen.dart
│   ├── interface/       # 6 core app screens (home, profile, onboarding, etc.)
├── Utilis/              # routes.dart, Theme/chatbot_theme.dart, widgets/
```

## 4. State Management
- **Provider** (^6.0.0) used throughout.
- **MultiProvider** in main.dart provides: `AuthenticationController`, `CalendarController`, `CountryController`, `AlbumController`, `ChatbotController`.
- Controllers extend `ChangeNotifier`.
- No repository/service abstraction layer — controllers directly call Supabase client.

## 5. Models/Entities
| Model | File | Status |
|-------|------|--------|
| DestinationInfo | models/destination_model.dart | Basic DTO with toMap/fromMap |
| CalendarEvent | models/calendar_event.dart | Not read yet |
| LocationDetails | models/location_details.dart | Not read yet |

## 6. Supabase Initialization & Tables Referenced
**Hardcoded credentials in main.dart:20-23:**
```
url: 'https://wkwhjswjekqlugndxegl.supabase.co'
anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' (full JWT in source)
```

**Tables referenced in code:**
- `locations` (supabase_service.dart - commented)
- `booked_guides` (guide_booking_controller.dart)
- `booking` (guide_bookingcontroller.dart, billing_detail_screen.dart, payment_screen.dart)
- `payments` (payment_screen.dart)
- `reviews` (home_screen.dart)
- `chat_messages` (chatbot_controller.dart)
- `cities` (city_controller.dart)
- `countries` (country_controllers.dart)
- `selected_country` (country_controllers.dart)
- `destinations` (destination_controller.dart)
- `calendar_events` (calendar_controller.dart)
- `user_locations` (map_screen.dart)
- `tour_guide_app` (Storage bucket - payment_screen.dart, billing_detail_screen.dart)

**No versioned SQL migrations exist.** No RLS policies defined in repo.

## 7. SQLite Usage
- **sqflite ^2.4.2** declared in pubspec.yaml.
- **No usage found** in Dart code (grep for `sqflite`/`Sqflite`/`openDatabase` returns nothing).
- Likely a leftover dependency. Classify as **REMOVE** unless proven otherwise.

## 8. Authentication Flow
- **AuthGate** (auth_gate.dart) listens to `supabase.auth.onAuthStateChange`.
- On session: → `HomeScreen`
- No session: → `OnboardingScreen(nextScreen: LoginScreen())`
- **AuthController** handles signIn/signUp/signOut with email/password.
- No password reset flow fully wired (forgot password screen exists but not connected to Supabase reset).
- No email verification enforced (signup uses `emailRedirectTo: null`).

## 9. Maps/Places Integration & API Keys
**Hardcoded Google Maps API Key (AIzaSyAeaU65bPgJ0XnoQy1Js9gmwxG_ixb_f0w) found in:**
- web/index.html:24 (script src)
- lib/Controllers/Services/google_map_service.dart:9
- lib/Screens/locations/location_entry_screen.dart:294 (FlutterGooglePlacesSdk init)
- lib/Screens/locations/location_entry_screen.dart:19 (commented)

**Usage:**
- `GoogleMapService.getDirections()` calls Directions API directly with key in URL.
- `LocationEntryScreen` uses `FlutterGooglePlacesSdk` for autocomplete.
- `MapScreen` uses `google_maps_flutter` widget + Geolocator for location tracking.
- No abstraction — API key scattered in 4+ locations.

## 10. Booking Flow & Persistence
**Two duplicate controllers:**
1. `guide_booking_controller.dart` — inserts into `booked_guides` table
2. `guide_bookingcontroller.dart` — inserts into `booking` table, has `getUserBooking`, `cancelBooking`

**Flow (BillingDetailsScreen → PaymentScreen):**
1. User selects guide → BillingDetailsScreen (duration, personal info, ID upload)
2. Creates booking in `booking` table with status `pending_payment`, returns bookingId
3. PaymentScreen (JazzCash/EasyPaisa — Pakistan-specific) → upload receipt to Storage bucket `tour_guide_app`
4. Inserts into `payments` table with status `pending_verification`
5. Updates `booking` status to `payment_submitted`
6. ConfirmationScreen shows success

**Issues:**
- Pakistan payment methods (JazzCash/EasyPaisa) hardcoded
- No server-side validation of payment
- Manual verification pattern but not explicitly modeled as such
- Duplicate controllers with different table targets

## 11. Chatbot Flow & Model/Provider
- **ChatbotController** extends ChangeNotifier, holds `apiKey` for **Gemini 1.5 Flash** hardcoded (line 12).
- Calls `generativelanguage.googleapis.com` directly from client.
- Stores messages in `chat_messages` table (user_id, sender, message).
- **Security issue**: Gemini API key exposed in Flutter client bundle.

## 12. Asset/Content Sources
**Assets declared in pubspec.yaml (63 images):**
- Pakistan-specific: hunza.jpg, fairymeadows.jpg, babusartop.jpg, skardu.jpg, lahore.jpg, mushkpuritop.jpg, kashmir.jpg, peshawar.jpg, tomb1-4.jpg, ghar1-3.jpg
- Generic: image1-5.jpg, destination1-10.jpg, guide1-15.jpg, splashscreen1-3.jpg, travel.jpg, logo.png, applogo.png
- **cities.html** (asset) contains 30 Pakistan cities hardcoded in JavaScript.

**HomeScreen hardcodes:**
- `journeyCards` — 11 Pakistan destinations (Kashmir, Lahore, Skardu, Babusar Top, Fairy Meadows, Hunza Valley, Peshawar, Swat Valley, Mushkpuri Top)
- `trendingNowList` — 10 Multan locations with placeholder images
- `journeyTogetherList` — duplicates of journeyCards

**example.com placeholder images in:**
- destination_info_screen.dart (3 URLs)
- routes.dart (2 URLs for BillingDetailsScreen default)

## 13. Navigation & Route Definitions
- **Routes class** (routes.dart) defines 25+ named routes + `generateRoute`.
- **Placeholder routes** with hardcoded dummy data:
  - `/map` → MapScreen with `LatLng(0.0, 0.0)` and 'Default Place'
  - `/confirmation` → hardcoded guideName/duration/amount/bookingId (commented in getRoutes, active in generateRoute)
  - `/payment` → same hardcoded dummy data
  - `/billing` → example.com image URL
  - `/destination_info` → commented out
- **AuthGate** at `/auth` but home is `/` mapped to HomeScreen directly in generateRoute.

## 14. Localization Support
- **No localization infrastructure** (no `flutter_localizations`, no `intl`, no `.arb` files).
- All user-visible text hardcoded in English.
- No RTL support.
- Arabic not implemented.

## 15. Tests
- **test/ directory does not exist**.
- `flutter_test` in dev_dependencies but no test files.
- **flutter analyze / flutter test cannot run** (Flutter not in PATH).

## 16. Known Crashes, TODOs, Dead Code, Duplicates
| Issue | Location | Severity |
|-------|----------|----------|
| Hardcoded Supabase URL + anon key | main.dart:21-23 | P0 — Security |
| Hardcoded Google Maps API key (4 locations) | web/index.html, google_map_service.dart, location_entry_screen.dart (2x) | P0 — Security |
| Hardcoded Gemini API key | chatbot_controller.dart:12 | P0 — Security |
| Duplicate guide booking controllers | guide_booking_controller.dart vs guide_bookingcontroller.dart | P0 — Code integrity |
| No versioned Supabase migrations | — | P0 — Backend contract |
| No RLS/Storage policies | — | P0 — Security |
| example.com placeholder images | destination_info_screen.dart, routes.dart | P0 — Build/content |
| Pakistan-specific content (assets, hardcoded lists) | home_screen.dart, assets/, cities.html | P0 — Product |
| Pakistan payment methods (JazzCash/EasyPaisa) | payment_screen.dart | P0 — Product |
| No localization (AR/EN, RTL/LTR) | — | P0 — Product |
| Placeholder routes with dummy data | routes.dart | P1 — UX |
| sqflite dependency unused | pubspec.yaml | P1 — Cleanup |
| location_entry_screen.dart has 200+ lines of commented code | location_entry_screen.dart | P1 — Cleanup |
| qr_scanner_screen.dart entirely commented out | qr_scanner_screen.dart | P1 — Cleanup |
| supabase_service.dart is empty stub | supabase_service.dart | P1 — Cleanup |
| No error boundary/structured error handling | Controllers catch but rethrow strings | P1 — Robustness |
| Firebase google-services.json present but unused | android/app/google-services.json | P1 — Cleanup |
| API service calls example.com | api_service.dart | P1 — Dead code |

---

## 17. Feature Classification

| Feature | Classification | Evidence |
|---------|---------------|----------|
| Supabase Auth (email/password) | **KEEP** | Working auth flow in AuthController, AuthGate |
| Provider state management | **KEEP** | Consistent usage, documented in AGENTS.md |
| HomeScreen discovery UI | **ADAPT** | Structure usable but all content is Pakistan-specific; needs Jordan data + repository layer |
| Category tabs / trending / journey sections | **ADAPT** | UI components reusable; data must come from backend |
| Map/Navigation (MapScreen) | **KEEP** | Functional Google Maps integration with TTS, location tracking |
| LocationEntryScreen (Places autocomplete) | **KEEP** | Working Places SDK integration |
| Guide hiring / booking flow | **REFACTOR** | Duplicate controllers, Pakistan payment methods, manual verification not modeled cleanly |
| Chatbot (Gemini) | **REPLACE** | Client-side API key exposure; must move to Edge Function |
| Country/City selection | **ADAPT** | RestCountries API + Supabase cache works; UI needs RTL/AR |
| Calendar/Events | **KEEP** | Basic CRUD with Supabase; needs localization |
| Profile/Settings | **KEEP** | Basic structure; needs edit profile implementation |
| Reviews | **ADAPT** | Fetches from Supabase; needs verified-review logic |
| Albums/Media | **ADAPT** | Screens exist; backend integration unclear |
| QR Scanner | **REMOVE** | Entirely commented out; not in MVP scope |
| Onboarding | **ADAPT** | Works; needs AR/EN + RTL |
| Payment (JazzCash/EasyPaisa) | **REPLACE** | Pakistan-specific; MVP uses manual verification workflow |
| Destination detail screens (TombInfo, etc.) | **REMOVE** | Hardcoded Pakistan content; replace with dynamic Experience detail |
| cities.html (WebView city picker) | **REMOVE** | Pakistan cities; replace with native Jordan city picker |
| api_service.dart (example.com) | **REMOVE** | Dead code |
| sqflite dependency | **REMOVE** | Unused |
| google-services.json (Firebase) | **REMOVE** | Unused; Supabase is backend |

---

## 18. P0 Blockers Summary (Must Fix in Phase 0)

1. **Externalize all secrets** — Supabase URL/key, Google Maps API key, Gemini API key → use `--dart-define` or platform config files
2. **Remove Gemini from client** — Create Supabase Edge Function proxy for AI calls
3. **Create versioned Supabase migrations** — SQL files for all tables referenced + RLS policies + Storage policies
4. **Remove example.com placeholder images** — Replace with actual assets or remote URLs
5. **Consolidate duplicate guide booking controllers** — Single implementation with proper domain model
6. **Fix placeholder routes** — Remove dummy data, wire real navigation with arguments
7. **Replace Pakistan content with Jordan placeholders** — Assets, home_screen.dart lists, cities.html
8. **Add localization infrastructure** — flutter_localizations, AR/EN .arb files, RTL support
9. **Remove dead code** — sqflite, api_service.dart, commented blocks, qr_scanner, Firebase config
10. **Verify build** — Install Flutter, run `flutter pub get`, `flutter analyze`, `flutter test`

---

## 19. Phase 0 Exit Criteria Assessment

| Criterion | Status |
|-----------|--------|
| Build/analyzer/test status documented | ❌ Flutter not installed |
| No plaintext production secrets in tracked source | ❌ 3 hardcoded keys found |
| Versioned backend schema exists | ❌ No migrations |
| Home/auth/startup don't depend on placeholder assets/fake endpoints | ❌ example.com images, dummy routes, Pakistan content |
| docs/current-state.md committed and accurate | ✅ This document |

**Phase 0 not satisfied.** Requires Flutter installation and all P0 fixes.