-- ==============================================
-- Airbnb Clone — SQL Subqueries Practice
-- ==============================================
-- Assumes existing tables:
-- users(user_id, first_name, last_name, email, role)
-- properties(property_id, title, location, host_id)
-- bookings(booking_id, user_id, property_id, start_date, end_date, status)
-- reviews(review_id, property_id, user_id, rating, comment)
-- ==============================================


-- 🟢 1️⃣ NON-CORRELATED SUBQUERY
-- Find all properties where the average rating is greater than 4.0

SELECT
    p.property_id,
    p.title,
    p.location
FROM properties p
WHERE p.property_id IN (
    SELECT
        r.property_id
    FROM reviews r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);

-- ✅ Explanation:
-- This subquery is non-correlated because it runs independently of the outer query.
-- It calculates the average rating per property, then filters those greater than 4.0.
-- The outer query retrieves the property details for those IDs.
-- ----------------------------------------------


-- 🔵 2️⃣ CORRELATED SUBQUERY
-- Find users who have made more than 3 bookings

SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM users u
WHERE (
    SELECT COUNT(*)
    FROM bookings b
    WHERE b.user_id = u.user_id
) > 3;

-- ✅ Explanation:
-- This is a correlated subquery — it references the outer query (u.user_id).
-- For each user, it counts how many bookings they’ve made.
-- The outer query then returns only those users with more than 3 bookings.
-- ----------------------------------------------

-- Optional: To verify, you can order results
-- by number of bookings per user:
SELECT
    u.user_id,
    u.first_name,
    (
        SELECT COUNT(*)
        FROM bookings b
        WHERE b.user_id = u.user_id
    ) AS total_bookings
FROM users u
ORDER BY total_bookings DESC;
