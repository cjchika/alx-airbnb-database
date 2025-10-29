# 🧠 SQL Joins Practice — Airbnb Clone Backend

This document demonstrates the use of **SQL joins** in the context of the Airbnb Clone database.
We explore how different join types retrieve related data between key entities like `Users`, `Properties`, `Bookings`, and `Reviews`.

---

## 🟢 1️⃣ INNER JOIN — Users and Bookings

### **Query**
```sql
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
    ON b.user_id = u.user_id;

SELECT
    p.property_id,
    p.title AS property_title,
    p.location,
    r.review_id,
    r.rating,
    r.comment
FROM properties p
LEFT JOIN reviews r
    ON p.property_id = r.property_id;

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
    ON u.user_id = b.user_id;
