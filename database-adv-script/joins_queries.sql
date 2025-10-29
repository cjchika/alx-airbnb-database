-- ==============================================
-- Airbnb Clone — SQL Joins Practice (With ORDER BY)
-- ==============================================
-- Assumes database tables:
-- users, properties, bookings, reviews
-- ==============================================

-- 🟢 1️⃣ INNER JOIN
-- Retrieve all bookings along with user details (only users who have made bookings)
SELECT
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM bookings b
INNER JOIN users u
    ON b.user_id = u.user_id
ORDER BY
    b.start_date DESC,          -- Show latest bookings first
    u.last_name ASC;            -- Secondary order by user name for readability

-- ✅ Explanation:
-- INNER JOIN returns only records where both bookings.user_id and users.user_id match.
-- Users without bookings are excluded.
-- ORDER BY ensures results are displayed with the most recent bookings first.

-- ----------------------------------------------

-- 🟠 2️⃣ LEFT JOIN
-- Retrieve all properties and their reviews (include properties with no reviews)
SELECT
    p.property_id,
    p.title AS property_title,
    p.location,
    r.review_id,
    r.rating,
    r.comment
FROM properties p
LEFT JOIN reviews r
    ON p.property_id = r.property_id
ORDER BY
    p.location ASC,             -- Organize by property location
    r.rating DESC NULLS LAST;   -- Highest-rated reviews first; unrated at bottom

-- ✅ Explanation:
-- LEFT JOIN returns all properties, whether or not a review exists.
-- If a property has no review, review columns will show NULL.
-- ORDER BY improves data readability by grouping by location and sorting by rating.

-- ----------------------------------------------

-- 🔵 3️⃣ FULL OUTER JOIN
-- Retrieve all users and bookings — include users with no bookings and bookings without users
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.status
FROM users u
FULL OUTER JOIN bookings b
    ON u.user_id = b.user_id
ORDER BY
    u.last_name ASC NULLS LAST,  -- Sort users alphabetically
    b.start_date DESC NULLS LAST; -- Recent bookings shown first

-- ✅ Explanation:
-- FULL OUTER JOIN returns all records from both tables.
-- Unmatched users (no bookings) and unmatched bookings (invalid user_id) are included.
-- ORDER BY helps ensure consistent output, with unlinked records (NULLs) at the bottom.
-- ⚠️ Note: Some databases (like MySQL) don’t support FULL OUTER JOIN.
-- In that case, simulate with UNION of LEFT and RIGHT JOIN.
