# 🏡 Property Rental System (Airbnb Clone)

## 📘 Task 4 – Seed the Database with Sample Data

### 🎯 Objective
The goal of this task is to **populate the normalized Property Rental System database** with realistic, meaningful sample data to simulate real-world scenarios for testing, validation, and demonstration.

---

## 🧩 Overview

The seeding script inserts data into:
- Lookup tables (`Roles`, `Booking_Statuses`, `Payment_Methods`)
- Core entities (`Users`, `Properties`, `Addresses`)
- Relationships (`Property_Amenities`, `Bookings`, `Payments`)
- Supporting entities (`Reviews`, `Conversations`, `Messages`)

This ensures the database is **ready for testing**, **query demonstrations**, and **frontend integration**.

---

## 🧱 Entities and Sample Records

| Entity | Example Record |
|---------|----------------|
| **Roles** | guest, host, admin |
| **Users** | John Doe (Host), Jane Smith (Guest) |
| **Addresses** | 12 Banana Island Road, Lagos |
| **Properties** | “Luxury Apartment with Ocean View”, “Charming Studio in Central London” |
| **Amenities** | Wi-Fi, Pool, Kitchen, Parking |
| **Bookings** | Jane Smith booked Lagos Apartment (confirmed) |
| **Payments** | ₦1,250.00 via credit card |
| **Reviews** | “Amazing stay! The view and amenities were top-notch.” |
| **Messages** | Jane ↔ John conversation about booking availability |

---

## ⚙️ How to Run the Seed Script

1. Ensure that the database schema from **Task 3** is already created.
2. Run the SQL file in your preferred SQL client or via CLI:

```bash
psql -U <username> -d property_rental -f seed.sql
