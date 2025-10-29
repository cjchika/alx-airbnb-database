# ⚡ Query Performance Optimization — Airbnb Clone Backend

## 🎯 Objective
Optimize SQL queries that retrieve **bookings along with user, property, and payment details** by identifying inefficiencies and refactoring for better performance.

---

## 🧱 1️⃣ Initial Query (Unoptimized)
```sql
SELECT
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.first_name,
    u.last_name,
    u.email,
    p.name AS property_name,
    p.price_per_night,
    pay.amount AS payment_amount,
    pay.payment_date
FROM Bookings b
JOIN Users u ON b.user_id = u.user_id
JOIN Properties p ON b.property_id = p.property_id
LEFT JOIN Payments pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;
