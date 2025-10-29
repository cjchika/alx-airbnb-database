# 🧩 Airbnb Clone — Index Optimization Script

**Author:** Chijioke Chika
**Date:** 2025-10-22

---

## 🎯 Objective
Continuously monitor and refine database performance by analyzing query execution plans and making schema adjustments.

This script identifies high-usage columns and creates indexes to optimize performance for frequent queries in an **Airbnb Clone** database.

---

## 🧠 Overview

Indexes are added to improve performance on:
- User lookups and authentication
- Property filtering and sorting
- Booking retrievals and joins

Each table’s indexing strategy targets **high-frequency query patterns** found during profiling with `EXPLAIN ANALYZE` or `SHOW PROFILE`.

---

## 🧱 SQL Script

```sql
-- ==============================================
-- Airbnb Clone — Index Optimization Script
-- ==============================================
-- Author: Chijioke Chika
-- Date: 2025-10-22
-- ==============================================
-- Goal: Identify high-usage columns and create indexes
-- to improve performance for frequent queries.
-- ==============================================

-- ==============================================
-- 1️⃣ USERS TABLE INDEXES
-- ==============================================
-- Common query patterns:
-- - Searching users by email during login
-- - Joining Users with Bookings via user_id
-- - Sorting users by created_at for admin analytics

CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_users_created_at ON Users(created_at);

-- ==============================================
-- 2️⃣ PROPERTIES TABLE INDEXES
-- ==============================================
-- Common query patterns:
-- - Searching/filtering properties by location or price range
-- - Joining Properties with Bookings via property_id
-- - Sorting by created_at (latest listings)

CREATE INDEX idx_properties_location ON Properties(address_id);
CREATE INDEX idx_properties_price_per_night ON Properties(price_per_night);
CREATE INDEX idx_properties_created_at ON Properties(created_at);

-- ==============================================
-- 3️⃣ BOOKINGS TABLE INDEXES
-- ==============================================
-- Common query patterns:
-- - Fetching bookings by user_id (user history)
-- - Joining with Properties via property_id
-- - Filtering by booking status or date range

CREATE INDEX idx_bookings_user_id ON Bookings(user_id);
CREATE INDEX idx_bookings_property_id ON Bookings(property_id);
CREATE INDEX idx_bookings_status_id ON Bookings(status_id);
CREATE INDEX idx_bookings_start_end_date ON Bookings(start_date, end_date);

-- ==============================================
-- 4️⃣ TESTING INDEX EFFECTIVENESS
-- ==============================================
-- Use EXPLAIN ANALYZE to compare query plans before and after indexing.

-- Before indexes:
EXPLAIN ANALYZE
SELECT b.booking_id, u.first_name, p.name AS property_name
FROM Bookings b
JOIN Users u ON b.user_id = u.user_id
JOIN Properties p ON b.property_id = p.property_id
WHERE u.email = 'john@example.com'
ORDER BY b.created_at DESC;

-- After indexes:
EXPLAIN ANALYZE
SELECT b.booking_id, u.first_name, p.name AS property_name
FROM Bookings b
JOIN Users u ON b.user_id = u.user_id
JOIN Properties p ON b.property_id = p.property_id
WHERE u.email = 'john@example.com'
ORDER BY b.created_at DESC;
