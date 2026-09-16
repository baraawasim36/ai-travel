# 03 — Domain Model

## Core entities

### users
Authentication-linked application profile.

Suggested fields:
- id
- display_name
- email
- phone (optional)
- locale
- preferred_city_id (optional)
- preference_tags (array/table, depending on chosen schema)
- avatar_url
- role (`traveler`, `guide`, `business`, `admin`)
- status
- created_at
- updated_at

### destinations
Country/city/place hierarchy.

Suggested fields:
- id
- country_code
- city_id / parent_id
- name_ar
- name_en
- description_ar
- description_en
- latitude
- longitude
- cover_image_url
- status

### experiences
The product's primary discovery object.

Suggested fields:
- id
- business_id (nullable for editorial/free places)
- destination_id
- title_ar
- title_en
- description_ar
- description_en
- category_ids / relation table
- tags
- experience_type
- duration_minutes (optional)
- price_from (optional)
- currency
- capacity (optional)
- booking_mode (`manual`, `instant_later`, `external_later`)
- status
- verification_status
- featured_until (optional)
- latitude
- longitude
- created_at
- updated_at

### businesses
Partner/provider account.

Suggested fields:
- id
- legal_name
- display_name
- description
- contact fields
- city_id
- status
- verification_status
- commission_rate_override (nullable)
- created_at
- updated_at

### guides
Guide profile linked to a user/business where appropriate.

Suggested fields:
- id
- user_id
- business_id (optional)
- bio_ar
- bio_en
- specialties
- languages
- price_from
- verification_status
- rating_avg
- rating_count
- availability_mode

### categories
Configurable taxonomy.

Seed the eight launch categories:
Adrenaline, Relaxation, Nature, Valleys, Water, Nightlife, Food, Instagram spots.

### favorites
- user_id
- experience_id or destination_id
- created_at

Use a unique constraint to prevent duplicates.

### bookings
Booking requests are stateful records.

Suggested fields:
- id
- user_id
- experience_id / guide_id
- requested_start
- requested_end
- party_size
- contact_name
- contact_phone
- notes
- quoted_amount (optional)
- currency
- commission_amount (derived/snapshotted when needed)
- status: `requested`, `confirmed`, `rejected`, `cancelled`, `completed`
- payment_status: `not_required`, `pending`, `paid`, `failed`, `refunded`
- created_at
- updated_at

The MVP uses **manual confirmation**. Do not pretend a booking is paid merely because it is confirmed.

### reviews
- id
- user_id
- experience_id / guide_id
- booking_id (preferred for verified post-booking review)
- rating 1..5
- title
- body
- status
- created_at

### media
Abstract media metadata from actual storage paths.

### trips
Use for saved/planned journeys; do not overload bookings.

Suggested fields:
- id
- user_id
- title
- start_date
- end_date
- city_ids
- status
- created_at

### trip_items
- trip_id
- experience_id/destination_id
- scheduled_at
- notes
- sort_order

### chat_sessions / chat_messages
Create the table structure only when the assistant phase needs persistence. AI data is not authoritative business state.

## Relationship overview
```text
user ──< favorite >── experience
user ──< booking >── experience ──> business
user ──< review >── experience
user ──< trip >──< trip_item >── experience/destination
business ──< guide
experience ──< category_link >── category
experience ──> destination
```

## Jordan seed strategy
Do not hard-code Jordan attractions into widgets. Seed/import them into the database/content layer. The first seed should cover a small, curated launch set across several Jordan locations and all eight experience categories where possible.

The initial data quality goal is correctness and completeness of fields, not maximum place count.

## Data rules
- Use stable UUIDs/IDs.
- Use ISO timestamps.
- Store coordinates as numeric latitude/longitude.
- Store Arabic and English separately when content is editorially distinct.
- Avoid a single free-text field containing both languages.
- Never delete booking history just because an experience is unpublished; use status/soft-delete semantics.
- Snapshot financial/commission values on transactions where later configuration changes must not rewrite history.
