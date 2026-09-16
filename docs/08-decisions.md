# 08 — Initial Architecture Decisions

| Decision | Choice | Reason |
|---|---|---|
| Starting codebase | Globe_Guide Flutter repo | Closest available product-shaped Flutter baseline |
| Launch geography | Jordan | Product plan starts in Jordan |
| MVP backend | Supabase | Current selected repository already uses `supabase_flutter`; avoids unnecessary backend rewrite |
| State management | Preserve Provider initially | Current repo documents Provider; migrate only when there is a concrete maintenance reason |
| Discovery object | Experience | Product differentiator is experience/mood-based discovery, not just static destinations |
| Booking mode | Manual confirmation | Matches MVP scope and avoids premature payment complexity |
| AI | Isolated service boundary, live AI deferred | Keeps AI from becoming business-state logic |
| Payments | Deferred | Requires business, legal, settlement, refund, and gateway rules not necessary for MVP discovery/booking request |
| Languages | Arabic + English | Jordan launch and regional expansion require bilingual foundation |
| Data source | Database/content layer | Avoid hard-coded places in widgets; supports admin, moderation, and scale |

## Change policy
Future decisions must be appended below with date, decision, alternatives considered, and consequences.
