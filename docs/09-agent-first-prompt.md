# 09 — Agent First Prompt (Report-Aligned)

```text
You are the implementation agent for Travel Explorer AI.
Repository: Globe_Guide-Tour-Guide-Application

READ FIRST:
- AGENTS.md
- docs/00-product-context.md
- docs/00-execution-source-of-truth.md
- docs/01-current-state-audit.md
- docs/02-target-architecture.md
- docs/03-domain-model.md
- docs/04-mvp-execution-plan.md
- docs/05-backlog.md
- docs/06-agent-working-rules.md
- docs/07-acceptance-tests.md
- docs/08-decisions.md

The repository audit already identified this project as a prototype/active-development Flutter application with P0 launch blockers. Treat those findings as hypotheses to verify locally, not as permission to skip verification.

PHASE 0 ONLY. Do not build new product features yet.

1. Run and record:
   flutter --version
   flutter pub get
   flutter analyze
   flutter test

2. Inspect:
   lib/, assets/, android/, ios/, web/, pubspec.yaml, Supabase setup, storage, auth, maps, bookings/payments, chatbot, routing, localization, tests.

3. Create docs/current-state.md with evidence. For each major feature classify KEEP / ADAPT / REFACTOR / REPLACE / REMOVE.

4. Fix ONLY P0 blockers required for a trustworthy baseline:
   - externalize/secure Supabase + Maps + Gemini configuration;
   - do not expose Gemini credentials in Flutter client production code;
   - create versioned Supabase migrations/RLS/Storage policies;
   - remove fake endpoints/example.com content;
   - repair missing assets;
   - fix placeholder routing and startup blockers;
   - consolidate duplicate guide booking controllers;
   - improve error handling only where required for the baseline.

5. Do NOT:
   - migrate Supabase to Firebase;
   - rewrite the entire app;
   - add advanced AI;
   - add a real payment gateway unless needed only to establish a documented interface;
   - expand beyond Jordan;
   - implement monetization features.

6. Every change must be small and verifiable. Preserve working behavior.

7. At the end report:
   - exact commands and outputs/status;
   - files changed;
   - current architecture;
   - security/config findings;
   - backend tables/storage objects discovered;
   - remaining P0/P1 blockers;
   - whether Phase 0 exit criteria are satisfied.

STOP after Phase 0. Do not continue automatically into feature development.
```
