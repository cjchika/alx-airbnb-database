-- ==========================================================
-- DATABASE: Property Rental System (Airbnb Clone)
-- DESCRIPTION: Normalized schema (3NF)
-- AUTHOR: Chijioke Chika
-- DATE: 2025-10-22
-- ==========================================================

-- Drop tables if they exist (for re-runs)
DROP TABLE IF EXISTS Payments, Bookings, Property_Rates, Property_Amenities, Amenities,
Property_Images, Properties, Addresses, Reviews, Messages, Conversation_Participants,
Conversations, Users, Roles, Booking_Statuses, Payment_Methods CASCADE;

-- ==========================================================
-- LOOKUP TABLES
-- ==========================================================

CREATE TABLE Roles (
    role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Booking_Statuses (
    status_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    status_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Payment_Methods (
    method_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    method_name VARCHAR(50) UNIQUE NOT NULL
);

-- ==========================================================
-- USERS
-- ==========================================================

CREATE TABLE Users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID REFERENCES Roles(role_id) ON DELETE SET NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_users_email ON Users(email);

-- ==========================================================
-- ADDRESSES
-- ==========================================================

CREATE TABLE Addresses (
    address_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20)
);

-- ==========================================================
-- PROPERTIES
-- ==========================================================

CREATE TABLE Properties (
    property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
    address_id UUID REFERENCES Addresses(address_id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_properties_host_id ON Properties(host_id);

-- ==========================================================
-- PROPERTY IMAGES
-- ==========================================================

CREATE TABLE Property_Images (
    image_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID REFERENCES Properties(property_id) ON DELETE CASCADE,
    image_url VARCHAR(255) NOT NULL
);
CREATE INDEX idx_property_images_property_id ON Property_Images(property_id);

-- ==========================================================
-- AMENITIES
-- ==========================================================

CREATE TABLE Amenities (
    amenity_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Property_Amenities (
    property_id UUID REFERENCES Properties(property_id) ON DELETE CASCADE,
    amenity_id UUID REFERENCES Amenities(amenity_id) ON DELETE CASCADE,
    PRIMARY KEY (property_id, amenity_id)
);

-- ==========================================================
-- PROPERTY RATES (for seasonal pricing)
-- ==========================================================

CREATE TABLE Property_Rates (
    rate_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID REFERENCES Properties(property_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    nightly_rate DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_date_range CHECK (end_date > start_date)
);

-- ==========================================================
-- BOOKINGS
-- ==========================================================

CREATE TABLE Bookings (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID REFERENCES Properties(property_id) ON DELETE CASCADE,
    user_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
    status_id UUID REFERENCES Booking_Statuses(status_id) ON DELETE SET NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_bookings_user_id ON Bookings(user_id);
CREATE INDEX idx_bookings_property_id ON Bookings(property_id);

-- ==========================================================
-- PAYMENTS
-- ==========================================================

CREATE TABLE Payments (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    method_id UUID REFERENCES Payment_Methods(method_id) ON DELETE SET NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_payments_booking_id ON Payments(booking_id);

-- ==========================================================
-- REVIEWS
-- ==========================================================

CREATE TABLE Reviews (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID REFERENCES Properties(property_id) ON DELETE CASCADE,
    user_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_reviews_property_id ON Reviews(property_id);
CREATE INDEX idx_reviews_user_id ON Reviews(user_id);

-- ==========================================================
-- CONVERSATIONS (for messaging)
-- ==========================================================

CREATE TABLE Conversations (
    conversation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Conversation_Participants (
    conversation_id UUID REFERENCES Conversations(conversation_id) ON DELETE CASCADE,
    user_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
    PRIMARY KEY (conversation_id, user_id)
);

-- ==========================================================
-- MESSAGES
-- ==========================================================

CREATE TABLE Messages (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID REFERENCES Conversations(conversation_id) ON DELETE CASCADE,
    sender_id UUID REFERENCES Users(user_id) ON DELETE CASCADE,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_messages_conversation_id ON Messages(conversation_id);

-- ==========================================================
-- INITIAL LOOKUP DATA
-- ==========================================================

INSERT INTO Roles (role_name) VALUES ('guest'), ('host'), ('admin');
INSERT INTO Booking_Statuses (status_name) VALUES ('pending'), ('confirmed'), ('canceled');
INSERT INTO Payment_Methods (method_name) VALUES ('credit_card'), ('paypal'), ('stripe');

-- ==========================================================
-- END OF SCHEMA
-- ==========================================================
