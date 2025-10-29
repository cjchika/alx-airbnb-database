-- ==============================================
-- Airbnb Clone — SQL Aggregation & Window Functions
-- ==============================================
-- Author: Chijioke Chika
-- Date: 2025-10-22
-- ==============================================
-- Tables referenced:
-- Users(user_id, first_name, last_name)
-- Bookings(booking_id, user_id, property_id)
-- Properties(property_id, name)
-- ==============================================


-- 🟢 1️⃣ Aggregation Query
-- Find the total number of bookings made by each user
-- ==============================================

SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings
FROM Users u
LEFT JOIN Bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_bookings DESC;

-- ✅ Explanation:
-- - Uses COUNT() and GROUP BY to aggregate total bookings per user.
-- - LEFT JOIN ensures all users appear even if they have no bookings.
-- - ORDER BY sorts users by number of bookings in descending order.
-- ----------------------------------------------


-- 🔵 2️⃣ Window Function Query
-- Rank properties based on total number of bookings
-- ==============================================

SELECT
    p.property_id,
    p.name AS property_name,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM Properties p
LEFT JOIN Bookings b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name
ORDER BY booking_rank;

-- ✅ Explanation:
-- - COUNT() + GROUP BY aggregates bookings per property.
-- - RANK() OVER (ORDER BY COUNT DESC) assigns ranking:
--     - 1 = most booked property
--     - Properties with equal bookings share the same rank.
-- - Use ROW_NUMBER() instead of RANK() if you want unique sequential numbering.
-- ----------------------------------------------


-- 🟣 Optional Variant
-- Using ROW_NUMBER() instead of RANK() for strict ordering

SELECT
    p.property_id,
    p.name AS property_name,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_position
FROM Properties p
LEFT JOIN Bookings b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name
ORDER BY booking_position;
