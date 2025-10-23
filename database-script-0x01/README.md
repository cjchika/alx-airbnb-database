# 🏠 Property Rental System (Airbnb Clone)

## 📘 Task 3 – Database Schema Definition (SQL)

### 📌 Objective
The objective of this task is to **translate the normalized Entity Relationship Diagram (ERD)** and **3rd Normal Form (3NF)** logical model into a **SQL database schema**.
This involves creating tables, defining relationships, and applying constraints to ensure **data integrity**, **referential consistency**, and **optimal query performance**.

---

## 🧩 Overview

This schema models a **Property Rental System**, similar to Airbnb, supporting:
- User roles (guest, host, admin)
- Property listings with images and amenities
- Bookings, payments, and seasonal pricing
- Reviews and messaging between users

The database follows **Third Normal Form (3NF)** to eliminate redundancy and maintain data consistency.

---

## 🧱 Database Structure

### 🗂️ Core Entities
| Entity | Description |
|---------|--------------|
| **Users** | Stores user details such as name, email, password hash, and role (guest, host, admin). |
| **Roles** | Defines user roles. |
| **Properties** | Represents property listings created by hosts. |
| **Addresses** | Stores address information for properties. |
| **Amenities** | Contains a list of possible amenities (e.g., Wi-Fi, Pool). |
| **Property_Amenities** | Junction table linking properties to amenities (Many-to-Many). |
| **Property_Rates** | Allows hosts to define custom nightly rates for specific date ranges. |
| **Bookings** | Stores user bookings for specific properties. |
| **Payments** | Records payment transactions linked to bookings. |
| **Reviews** | User-submitted reviews for properties. |
| **Conversations** | Represents chat threads between users. |
| **Messages** | Stores individual chat messages. |
| **Conversation_Participants** | Links users to conversations (Many-to-Many). |

---

## ⚙️ Database Setup

### 1. Drop Existing Tables
Ensures the script can be safely re-run during development:
```sql
DROP TABLE IF EXISTS Payments, Bookings, Property_Rates, Property_Amenities, Amenities,
Property_Images, Properties, Addresses, Reviews, Messages, Conversation_Participants,
Conversations, Users, Roles, Booking_Statuses, Payment_Methods CASCADE;
