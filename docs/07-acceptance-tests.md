# 07 — Acceptance Tests

## Critical journey 1: discovery
1. Launch with a clean install.
2. Choose Arabic.
3. Home loads Jordan discovery data.
4. Select a category.
5. Select a city.
6. Open an experience.
7. Open its map location.
8. Save it.
9. Close and reopen; favorite remains.

Pass condition: no crash, correct RTL, data persists, error/empty states behave correctly.

## Critical journey 2: booking
1. Sign in.
2. Open a bookable experience.
3. Submit a request with date/time and party size.
4. Booking appears as `requested`.
5. Authorized operator changes it to `confirmed` or `rejected`.
6. Traveler sees the new state.
7. Traveler can cancel only when allowed by the state rules.

Pass condition: no client-side-only authorization decisions.

## Critical journey 3: offline/error
1. Start app with network available.
2. Load a discovery list.
3. Disable network.
4. Navigate/retry.

Pass condition: app presents a controlled state rather than crashing or showing misleading booking confirmation.

## Critical journey 4: localization
Repeat discovery and booking in English and Arabic.

Pass condition:
- English LTR;
- Arabic RTL;
- no untranslated critical labels;
- dates/numbers formatted appropriately.

## Release gate
Do not mark MVP ready when any of the following is true:
- analyzer errors remain;
- critical journey crashes;
- booking can be created without authorization;
- secrets are committed;
- primary launch content is still Pakistan-specific;
- critical UI lacks error/empty states;
- production build cannot be generated.
