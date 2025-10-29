# 🧩 Table Partitioning Optimization – Booking Table

## 📘 Overview
This task focuses on **optimizing query performance** for large datasets by implementing **table partitioning** in PostgreSQL.
The `Booking` table was redesigned to use **RANGE partitioning** based on the `start_date` column.

Partitioning allows PostgreSQL to store and query data more efficiently by splitting a large table into smaller, manageable sections (partitions), improving query speed and maintenance operations.

---

## 🎯 Objective
- Optimize query performance on large booking datasets.
- Enable efficient filtering for date-range queries.
- Improve scalability and maintenance for growing data volumes.

---

## ⚙️ Implementation Steps

### **1️⃣ Create the Partitioned Table**
The original `Booking` table was dropped and recreated as a **partitioned table** using:
```sql
CREATE TABLE Booking (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    payment_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (property_id) REFERENCES Property(property_id)
) PARTITION BY RANGE (start_date);
