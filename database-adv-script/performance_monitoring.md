# 📊 Continuous Database Performance Monitoring and Optimization

## 📘 Overview
This document outlines how we continuously **monitor, analyze, and refine database performance** for the Airbnb Clone backend system.

Using PostgreSQL’s powerful diagnostic tools such as `EXPLAIN ANALYZE`, we identified slow-performing queries, analyzed their execution plans, and implemented schema and index optimizations to reduce query times and improve scalability.

---

## 🎯 Objective
- Monitor database performance using query analysis tools.
- Identify and resolve bottlenecks.
- Apply schema and indexing improvements.
- Measure and report performance gains.

---

## 🧩 Tools and Commands Used

| Command | Purpose |
|----------|----------|
| `EXPLAIN` | Displays the execution plan for a query. |
| `EXPLAIN ANALYZE` | Executes the query and returns actual run times. |
| `SHOW ALL` | Displays current database performance parameters. |
| `pg_stat_statements` | Extension to track execution statistics of all SQL queries. |

---

## ⚙️ Step 1 – Identify Slow Queries

We started by analyzing high-usage queries from core features such as:
- Booking retrieval with joins
- Property search by filters
- User-booking summary reports

Example query:
```sql
EXPLAIN ANALYZE
SELECT
    b.booking_id,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    b.start_date,
    b.end_date,
    b.total_price
FROM Booking b
JOIN Users u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
ORDER BY b.start_date DESC;
