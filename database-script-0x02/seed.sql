-- ==========================================================
-- DATABASE: Property Rental System (Airbnb Clone)
-- TASK 4: Seed the Database with Sample Data
-- AUTHOR: Chijioke Chika
-- DATE: 2025-10-23
-- ==========================================================

-- =======================================
-- ROLES (Predefined in Task 3, skip if already exists)
-- =======================================
INSERT INTO Roles (role_name)
VALUES
    ('guest'),
    ('host'),
    ('admin')
ON CONFLICT (role_name) DO NOTHING;

-- =======================================
-- BOOKING STATUSES
-- =======================================
INSERT INTO Booking_Statuses (status_name)
VALUES
    ('pending'),
    ('confirmed'),
    ('canceled')
ON CONFLICT (status_name) DO NOTHING;

-- =======================================
-- PAYMENT METHODS
-- =======================================
INSERT INTO Payment_Methods (method_name)
VALUES
    ('credit_card'),
    ('paypal'),
    ('stripe')
ON CONFLICT (method_name) DO NOTHING;

-- =======================================
-- USERS
-- =======================================
INSERT INTO Users (role_id, first_name, last_name, email, password_hash, phone_number)
VALUES
    ((SELECT role_id FROM Roles WHERE role_name = 'host'), 'John', 'Doe', 'john.doe@example.com', 'hashed_pw_123', '+2348012345678'),
    ((SELECT role_id FROM Roles WHERE role_name = 'guest'), 'Jane', 'Smith', 'jane.smith@example.com', 'hashed_pw_456', '+2348098765432'),
    ((SELECT role_id FROM Roles WHERE role_name = 'admin'), 'Admin', 'User', 'admin@rentalapp.com', 'hashed_pw_admin', '+2348000000000');

-- =======================================
-- ADDRESSES
-- =======================================
INSERT INTO Addresses (street, city, state, country, postal_code)
VALUES
    ('12 Banana Island Road', 'Lagos', 'Lagos State', 'Nigeria', '101233'),
    ('45 King’s Cross', 'London', 'England', 'United Kingdom', 'WC1X 9AH'),
    ('88 Sunset Boulevard', 'Los Angeles', 'California', 'United States', '90046');

-- =======================================
-- PROPERTIES
-- =======================================
INSERT INTO Properties (host_id, address_id, name, description, price_per_night)
VALUES
    ((SELECT user_id FROM Users WHERE email = 'john.doe@example.com'),
     (SELECT address_id FROM Addresses WHERE city = 'Lagos'),
     'Luxury Apartment with Ocean View',
     'A modern apartment with ocean views and private pool.',
     250.00),

    ((SELECT user_id FROM Users WHERE email = 'john.doe@example.com'),
     (SELECT address_id FROM Addresses WHERE city = 'London'),
     'Charming Studio in Central London',
     'Perfect for tourists and business travelers. 5 mins from King’s Cross.',
     180.00);

-- =======================================
-- PROPERTY IMAGES
-- =======================================
INSERT INTO Property_Images (property_id, image_url)
VALUES
    ((SELECT property_id FROM Properties WHERE name = 'Luxury Apartment with Ocean View'), 'https://example.com/images/property1_1.jpg'),
    ((SELECT property_id FROM Properties WHERE name = 'Luxury Apartment with Ocean View'), 'https://example.com/images/property1_2.jpg'),
    ((SELECT property_id FROM Properties WHERE name = 'Charming Studio in Central London'), 'https://example.com/images/property2_1.jpg');

-- =======================================
-- AMENITIES
-- =======================================
INSERT INTO Amenities (name)
VALUES
    ('Wi-Fi'),
    ('Air Conditioning'),
    ('Swimming Pool'),
    ('Parking'),
    ('Kitchen')
ON CONFLICT (name) DO NOTHING;

-- =======================================
-- PROPERTY AMENITIES
-- =======================================
INSERT INTO Property_Amenities (property_id, amenity_id)
VALUES
    ((SELECT property_id FROM Properties WHERE name = 'Luxury Apartment with Ocean View'),
     (SELECT amenity_id FROM Amenities WHERE name = 'Wi-Fi')),
    ((SELECT property_id FROM Properties WHERE name = 'Luxury Apartment with Ocean View'),
     (SELECT amenity_id FROM Amenities WHERE name = 'Swimming Pool')),
    ((SELECT property_id FROM Properties WHERE name = 'Charming Studio in Central London'),
     (SELECT amenity_id FROM Amenities WHERE name = 'Kitchen')),
    ((SELECT property_id FROM Properties WHERE name = 'Charming Studio in Central London'),
     (SELECT amenity_id FROM Amenities WHERE name = 'Air Conditioning'));

-- =======================================
-- PROPERTY RATES (Seasonal Pricing)
-- =======================================
INSERT INTO Property_Rates (property_id, start_date, end_date, nightly_rate)
VALUES
    ((SELECT property_id FROM Properties WHERE name = 'Luxury Apartment with Ocean View'),
     '2025-12-01', '2025-12-31', 300.00),
    ((SELECT property_id FROM Properties WHERE name = 'Charming Studio in Central London'),
     '2025-11-01', '2025-11-30', 200.00);

-- =======================================
-- BOOKINGS
-- =======================================
INSERT INTO Bookings (property_id, user_id, status_id, start_date, end_date, total_price)
VALUES
    ((SELECT property_id FROM Properties WHERE name = 'Luxury Apartment with Ocean View'),
     (SELECT user_id FROM Users WHERE email = 'jane.smith@example.com'),
     (SELECT status_id FROM Booking_Statuses WHERE status_name = 'confirmed'),
     '2025-12-05', '2025-12-10', 1250.00),

    ((SELECT property_id FROM Properties WHERE name = 'Charming Studio in Central London'),
     (SELECT user_id FROM Users WHERE email = 'jane.smith@example.com'),
     (SELECT status_id FROM Booking_Statuses WHERE status_name = 'pending'),
     '2025-11-15', '2025-11-20', 900.00);

-- =======================================
-- PAYMENTS
-- =======================================
INSERT INTO Payments (booking_id, method_id, amount)
VALUES
    ((SELECT booking_id FROM Bookings WHERE total_price = 1250.00),
     (SELECT method_id FROM Payment_Methods WHERE method_name = 'credit_card'),
     1250.00);

-- =======================================
-- REVIEWS
-- =======================================
INSERT INTO Reviews (property_id, user_id, rating, comment)
VALUES
    ((SELECT property_id FROM Properties WHERE name = 'Luxury Apartment with Ocean View'),
     (SELECT user_id FROM Users WHERE email = 'jane.smith@example.com'),
     5,
     'Amazing stay! The view and amenities were top-notch.');

-- =======================================
-- CONVERSATIONS & MESSAGES
-- =======================================
INSERT INTO Conversations DEFAULT VALUES;

INSERT INTO Conversation_Participants (conversation_id, user_id)
VALUES
    ((SELECT conversation_id FROM Conversations LIMIT 1),
     (SELECT user_id FROM Users WHERE email = 'john.doe@example.com')),
    ((SELECT conversation_id FROM Conversations LIMIT 1),
     (SELECT user_id FROM Users WHERE email = 'jane.smith@example.com'));

INSERT INTO Messages (conversation_id, sender_id, message_body)
VALUES
    ((SELECT conversation_id FROM Conversations LIMIT 1),
     (SELECT user_id FROM Users WHERE email = 'jane.smith@example.com'),
     'Hi John, is the apartment available in December?'),

    ((SELECT conversation_id FROM Conversations LIMIT 1),
     (SELECT user_id FROM Users WHERE email = 'john.doe@example.com'),
     'Hi Jane, yes it’s available! Would you like to book now?');
