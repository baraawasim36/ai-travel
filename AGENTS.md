# Travel Explorer AI — Agent Execution Contract

## Source-of-truth rule
The latest evidence-based repository audit is the baseline. Do not contradict verified code/command findings with assumptions from README or older plans.

## Mission
Transform the existing `Globe_Guide-Tour-Guide-Application` Flutter app into **Travel Explorer AI**, starting with Jordan, without throwing away working code unnecessarily.

The agent must implement the product in small, verifiable increments. Existing code is a starting point, not the product specification.

## Non-negotiable execution rules
1. Read `docs/00-product-context.md`, `docs/01-current-state-audit.md`, `docs/02-target-architecture.md`, and `docs/04-mvp-execution-plan.md` before changing application code.
2. Run the baseline commands first:
   - `flutter pub get`
   - `flutter analyze`
   - `flutter test`
   - inspect `lib/`, `assets/`, `android/`, `ios/`, `web/` and all backend/configuration files.
3. Record what is actually implemented. Do not trust README claims as proof that a feature works.
4. Preserve working functionality when refactoring. Prefer migration over rewrite.
5. Do not add a second backend because a document mentions it. The current repository uses Supabase; keep Supabase as the MVP backend unless an explicit architecture change is approved.
6. Do not implement advanced payments, full AI/RAG, partner APIs, regional expansion, blockchain, or social-network features before the baseline and booking core are stable.
7. Treat manual booking/payment verification as a first-class MVP workflow; do not describe receipt upload as a live payment gateway.
8. Jordan is the launch market. Replace Pakistan-specific demo/content progressively with Jordan data and content.
9. Arabic + RTL are first-class requirements. English must remain supported.
10. Every feature must have: data model -> repository/service -> state -> UI -> validation -> tests.
11. Never hard-code secrets, service-role keys, or production API keys into source control.
12. Every completed task must end with a verification pass: analyze, tests, and manual smoke check where relevant.
13. Do not silently change product decisions. If implementation pressure conflicts with a decision in these docs, log the conflict in `docs/decisions/` and choose the least-destructive path.

## MVP definition of done
The MVP is complete only when a new user can:
- choose Arabic or English;
- discover Jordan destinations and experiences;
- browse by experience category and city;
- open a place/experience detail page;
- view it on a map and navigate to it;
- save/favorite it;
- request a booking with manual confirmation;
- view booking history/status;
- manage profile and preferences;
- use the core app without crashing when network data is unavailable.

The admin/operator side must be able to manage the core content and booking status through a practical operational workflow. It does not have to be a polished separate mobile app in the first milestone.

## Implementation order
Follow the order in `docs/04-mvp-execution-plan.md` unless a blocking defect requires deviation.

## Definition of evidence
A feature is not "done" because a screen exists. Evidence should include:
- real data path;
- loading/empty/error states;
- authorization behavior;
- successful and failed test cases;
- no analyzer errors;
- short note in the task log.
