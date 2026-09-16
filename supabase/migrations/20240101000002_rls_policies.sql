-- 20240101000002_rls_policies.sql
-- Row Level Security policies for Travel Explorer AI

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE countries ENABLE ROW LEVEL SECURITY;
ALTER TABLE cities ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE destinations ENABLE ROW LEVEL SECURITY;
ALTER TABLE businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE experiences ENABLE ROW LEVEL SECURITY;
ALTER TABLE experience_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE guides ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE calendar_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE selected_country ENABLE ROW LEVEL SECURITY;

-- ============================================
-- PROFILES
-- ============================================
-- Users can view their own profile
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Admins can view all profiles
CREATE POLICY "Admins can view all profiles" ON profiles
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Admins can update all profiles
CREATE POLICY "Admins can update all profiles" ON profiles
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ============================================
-- COUNTRIES (Public read, admin write)
-- ============================================
CREATE POLICY "Countries are viewable by everyone" ON countries
  FOR SELECT USING (is_active = TRUE);

CREATE POLICY "Admins can manage countries" ON countries
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ============================================
-- CITIES (Public read, admin write)
-- ============================================
CREATE POLICY "Cities are viewable by everyone" ON cities
  FOR SELECT USING (is_active = TRUE);

CREATE POLICY "Admins can manage cities" ON cities
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ============================================
-- CATEGORIES (Public read, admin write)
-- ============================================
CREATE POLICY "Categories are viewable by everyone" ON categories
  FOR SELECT USING (is_active = TRUE);

CREATE POLICY "Admins can manage categories" ON categories
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ============================================
-- DESTINATIONS (Public read active, admin write)
-- ============================================
CREATE POLICY "Active destinations are viewable by everyone" ON destinations
  FOR SELECT USING (status = 'active');

CREATE POLICY "Admins can manage destinations" ON destinations
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Business owners can view their own destinations
CREATE POLICY "Business owners can view own destinations" ON destinations
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM experiences
      WHERE experiences.destination_id = destinations.id
      AND experiences.business_id IN (
        SELECT id FROM businesses WHERE businesses.id = experiences.business_id
      )
    )
  );

-- ============================================
-- BUSINESSES
-- ============================================
-- Public can view active businesses
CREATE POLICY "Active businesses are viewable by everyone" ON businesses
  FOR SELECT USING (status = 'active');

-- Business owners can view their own business
CREATE POLICY "Business owners can view own business" ON businesses
  FOR SELECT USING (
    id IN (
      SELECT business_id FROM profiles WHERE id = auth.uid()
    )
  );

-- Business owners can update their own business
CREATE POLICY "Business owners can update own business" ON businesses
  FOR UPDATE USING (
    id IN (
      SELECT business_id FROM profiles WHERE id = auth.uid()
    )
  );

-- Admins can manage all businesses
CREATE POLICY "Admins can manage businesses" ON businesses
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ============================================
-- EXPERIENCES
-- ============================================
-- Public can view active experiences
CREATE POLICY "Active experiences are viewable by everyone" ON experiences
  FOR SELECT USING (status = 'active');

-- Business owners can manage their own experiences
CREATE POLICY "Business owners can manage own experiences" ON experiences
  FOR ALL USING (
    business_id IN (
      SELECT id FROM businesses
      WHERE id IN (
        SELECT business_id FROM profiles WHERE id = auth.uid()
      )
    )
  );

-- Admins can manage all experiences
CREATE POLICY "Admins can manage experiences" ON experiences
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ============================================
-- EXPERIENCE_CATEGORIES
-- ============================================
CREATE POLICY "Experience categories are viewable by everyone" ON experience_categories
  FOR SELECT USING (TRUE);

CREATE POLICY "Admins can manage experience categories" ON experience_categories
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Business owners can manage categories for their experiences
CREATE POLICY "Business owners can manage categories for own experiences" ON experience_categories
  FOR ALL USING (
    experience_id IN (
      SELECT id FROM experiences
      WHERE business_id IN (
        SELECT id FROM businesses
        WHERE id IN (
          SELECT business_id FROM profiles WHERE id = auth.uid()
        )
      )
    )
  );

-- ============================================
-- GUIDES
-- ============================================
-- Public can view verified guides
CREATE POLICY "Verified guides are viewable by everyone" ON guides
  FOR SELECT USING (verification_status = 'verified');

-- Guide users can view their own guide profile
CREATE POLICY "Guides can view own profile" ON guides
  FOR SELECT USING (user_id = auth.uid());

-- Guide users can update their own guide profile
CREATE POLICY "Guides can update own profile" ON guides
  FOR UPDATE USING (user_id = auth.uid());

-- Business owners can manage guides for their business
CREATE POLICY "Business owners can manage guides for own business" ON guides
  FOR ALL USING (
    business_id IN (
      SELECT id FROM businesses
      WHERE id IN (
        SELECT business_id FROM profiles WHERE id = auth.uid()
      )
    )
  );

-- Admins can manage all guides
CREATE POLICY "Admins can manage guides" ON guides
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ============================================
-- FAVORITES
-- ============================================
-- Users can manage their own favorites
CREATE POLICY "Users can manage own favorites" ON favorites
  FOR ALL USING (user_id = auth.uid());

-- ============================================
-- BOOKINGS
-- ============================================
-- Users can view their own bookings
CREATE POLICY "Users can view own bookings" ON bookings
  FOR SELECT USING (user_id = auth.uid());

-- Users can create bookings
CREATE POLICY "Users can create bookings" ON bookings
  FOR INSERT WITH CHECK (user_id = auth.uid());

-- Users can cancel their own bookings (if status allows)
CREATE POLICY "Users can cancel own bookings" ON bookings
  FOR UPDATE USING (
    user_id = auth.uid()
    AND status IN ('requested', 'confirmed')
  )
  WITH CHECK (
    user_id = auth.uid()
    AND status IN ('requested', 'confirmed', 'cancelled')
  );

-- Experience/Guide owners can view bookings for their items
CREATE POLICY "Experience owners can view bookings" ON bookings
  FOR SELECT USING (
    experience_id IN (
      SELECT id FROM experiences
      WHERE business_id IN (
        SELECT id FROM businesses
        WHERE id IN (
          SELECT business_id FROM profiles WHERE id = auth.uid()
        )
      )
    )
  );

CREATE POLICY "Guide owners can view bookings" ON bookings
  FOR SELECT USING (
    guide_id IN (
      SELECT id FROM guides WHERE user_id = auth.uid()
    )
  );

-- Experience/Guide owners can update booking status (confirm/reject)
CREATE POLICY "Experience owners can update booking status" ON bookings
  FOR UPDATE USING (
    experience_id IN (
      SELECT id FROM experiences
      WHERE business_id IN (
        SELECT id FROM businesses
        WHERE id IN (
          SELECT business_id FROM profiles WHERE id = auth.uid()
        )
      )
    )
  )
  WITH CHECK (
    experience_id IN (
      SELECT id FROM experiences
      WHERE business_id IN (
        SELECT id FROM businesses
        WHERE id IN (
          SELECT business_id FROM profiles WHERE id = auth.uid()
        )
      )
    )
    AND status IN ('requested', 'confirmed', 'rejected', 'cancelled', 'completed')
  );

CREATE POLICY "Guide owners can update booking status" ON bookings
  FOR UPDATE USING (
    guide_id IN (
      SELECT id FROM guides WHERE user_id = auth.uid()
    )
  )
  WITH CHECK (
    guide_id IN (
      SELECT id FROM guides WHERE user_id = auth.uid()
    )
    AND status IN ('requested', 'confirmed', 'rejected', 'cancelled', 'completed')
  );

-- Admins can manage all bookings
CREATE POLICY "Admins can manage bookings" ON bookings
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ============================================
-- PAYMENTS
-- ============================================
-- Users can view their own payments
CREATE POLICY "Users can view own payments" ON payments
  FOR SELECT USING (user_id = auth.uid());

-- Users can create payments for their bookings
CREATE POLICY "Users can create payments" ON payments
  FOR INSERT WITH CHECK (
    user_id = auth.uid()
    AND booking_id IN (
      SELECT id FROM bookings WHERE user_id = auth.uid()
    )
  );

-- Experience/Guide owners can view payments for their bookings
CREATE POLICY "Experience owners can view payments" ON payments
  FOR SELECT USING (
    booking_id IN (
      SELECT id FROM bookings
      WHERE experience_id IN (
        SELECT id FROM experiences
        WHERE business_id IN (
          SELECT id FROM businesses
          WHERE id IN (
            SELECT business_id FROM profiles WHERE id = auth.uid()
          )
        )
      )
    )
  );

CREATE POLICY "Guide owners can view payments" ON payments
  FOR SELECT USING (
    booking_id IN (
      SELECT id FROM bookings
      WHERE guide_id IN (
        SELECT id FROM guides WHERE user_id = auth.uid()
      )
    )
  );

-- Experience/Guide owners can verify/reject payments
CREATE POLICY "Experience owners can verify payments" ON payments
  FOR UPDATE USING (
    booking_id IN (
      SELECT id FROM bookings
      WHERE experience_id IN (
        SELECT id FROM experiences
        WHERE business_id IN (
          SELECT id FROM businesses
          WHERE id IN (
            SELECT business_id FROM profiles WHERE id = auth.uid()
          )
        )
      )
    )
  )
  WITH CHECK (
    booking_id IN (
      SELECT id FROM bookings
      WHERE experience_id IN (
        SELECT id FROM experiences
        WHERE business_id IN (
          SELECT id FROM businesses
          WHERE id IN (
            SELECT business_id FROM profiles WHERE id = auth.uid()
          )
        )
      )
    )
    AND status IN ('pending_verification', 'verified', 'rejected', 'refunded')
  );

CREATE POLICY "Guide owners can verify payments" ON payments
  FOR UPDATE USING (
    booking_id IN (
      SELECT id FROM bookings
      WHERE guide_id IN (
        SELECT id FROM guides WHERE user_id = auth.uid()
      )
    )
  )
  WITH CHECK (
    booking_id IN (
      SELECT id FROM bookings
      WHERE guide_id IN (
        SELECT id FROM guides WHERE user_id = auth.uid()
      )
    )
    AND status IN ('pending_verification', 'verified', 'rejected', 'refunded')
  );

-- Admins can manage all payments
CREATE POLICY "Admins can manage payments" ON payments
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ============================================
-- REVIEWS
-- ============================================
-- Public can view published reviews
CREATE POLICY "Published reviews are viewable by everyone" ON reviews
  FOR SELECT USING (status = 'published');

-- Users can view their own reviews
CREATE POLICY "Users can view own reviews" ON reviews
  FOR SELECT USING (user_id = auth.uid());

-- Users can create reviews for completed bookings
CREATE POLICY "Users can create reviews for completed bookings" ON reviews
  FOR INSERT WITH CHECK (
    user_id = auth.uid()
    AND booking_id IN (
      SELECT id FROM bookings
      WHERE user_id = auth.uid()
      AND status = 'completed'
    )
  );

-- Users can update their own pending reviews
CREATE POLICY "Users can update own pending reviews" ON reviews
  FOR UPDATE USING (
    user_id = auth.uid()
    AND status = 'pending'
  )
  WITH CHECK (
    user_id = auth.uid()
    AND status IN ('pending', 'published')
  );

-- Experience/Guide owners can view reviews for their items
CREATE POLICY "Experience owners can view reviews" ON reviews
  FOR SELECT USING (
    experience_id IN (
      SELECT id FROM experiences
      WHERE business_id IN (
        SELECT id FROM businesses
        WHERE id IN (
          SELECT business_id FROM profiles WHERE id = auth.uid()
        )
      )
    )
  );

CREATE POLICY "Guide owners can view reviews" ON reviews
  FOR SELECT USING (
    guide_id IN (
      SELECT id FROM guides WHERE user_id = auth.uid()
    )
  );

-- Admins can manage all reviews
CREATE POLICY "Admins can manage reviews" ON reviews
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ============================================
-- CALENDAR_EVENTS
-- ============================================
CREATE POLICY "Users can manage own calendar events" ON calendar_events
  FOR ALL USING (user_id = auth.uid());

-- ============================================
-- CHAT_MESSAGES
-- ============================================
CREATE POLICY "Users can manage own chat messages" ON chat_messages
  FOR ALL USING (user_id = auth.uid());

-- ============================================
-- USER_LOCATIONS
-- ============================================
CREATE POLICY "Users can manage own locations" ON user_locations
  FOR ALL USING (user_id = auth.uid());

-- ============================================
-- SELECTED_COUNTRY
-- ============================================
CREATE POLICY "Users can manage own selected country" ON selected_country
  FOR ALL USING (user_id = auth.uid());