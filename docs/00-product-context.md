# 00 — Product Context

## Product
**Travel Explorer AI** is an experience-first travel discovery and booking platform. Jordan is the first market; expansion to Turkey, Egypt, GCC countries, Malaysia, and other markets is later.

## Product problem
The product addresses fragmented travel discovery, weak personalization, expensive/complex trip planning, and the lack of one place that combines discovery, recommendations, and booking.

## Core value proposition
The application helps a traveler answer:
- What can I do here?
- Which experience matches my mood/interests?
- Where is it?
- Can I save it to my trip?
- Can I request a booking?

## Experience taxonomy
Use these as the initial product-level categories:
- Adrenaline
- Relaxation
- Nature
- Valleys
- Water
- Nightlife
- Food
- Instagram spots

These are experience categories, not rigid database tables. The data model must support adding/reclassifying categories without schema rewrites.

## Initial business model
- booking commission: 5–20% (business policy, configurable per partner/experience);
- featured listings;
- business subscriptions;
- premium AI travel planning later.

Do not implement monetization as a hard-coded percentage in the MVP. Store commission configuration so it can change by partner/contract.

## MVP product boundary
### Included
- Jordan destination and experience discovery;
- city/category filters;
- map/location;
- user authentication/profile;
- favorites;
- manual booking request + status workflow;
- booking history;
- reviews/ratings where the current code can support them safely;
- admin/operator content management;
- Arabic/English and RTL/LTR;
- analytics-ready event model;
- robust loading/empty/error states.

### Deferred
- automated online payment settlement;
- advanced AI/RAG assistant;
- dynamic personalized recommendation engine;
- partner APIs;
- hotel/flight integrations;
- regional rollout;
- blockchain verification;
- social community features.

## Product principle
Build the core marketplace and experience data model first. AI should consume clean, permission-aware product data later instead of becoming the database/business logic itself.
