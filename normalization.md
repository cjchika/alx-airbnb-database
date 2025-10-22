# Database Normalization – Property Rental System (Airbnb Clone)

## Objective
To apply normalization principles to the Property Rental database schema, ensuring it reaches **Third Normal Form (3NF)** — eliminating redundancy, maintaining data integrity, and optimizing relational efficiency.

---

## 1. Initial Schema Overview

The original schema consisted of the following entities:

- **User**
- **Property**
- **Booking**
- **Payment**
- **Review**
- **Message**

Each table captured distinct business concepts but contained areas that could cause **redundancy** or **update anomalies**, such as:
- `location` stored as a single text field in `Property`
- Enums (`role`, `payment_method`, `status`) limiting flexibility and potential extensibility
- Missing intermediate entities for messaging (no `Conversation`)
- Multi-valued attributes like amenities and property images not properly normalized

---

## 2. Normalization Process

Normalization was applied in **three stages** — 1NF, 2NF, and 3NF.

---

### **1NF — First Normal Form**
**Rule:** Eliminate repeating groups and ensure atomicity.

| Issue | Violation | Resolution |
|-------|------------|-------------|
| `location` stored as a single text value | Not atomic (may contain city, state, country) | Decomposed into a new `Address` table |
| `amenities` or `images` (if added) | Multi-valued attributes | Separated into `Property_Amenities` and `Property_Images` tables |
| `role`, `status`, `payment_method` as enums | Hard to extend | Replaced with lookup tables: `Roles`, `Booking_Statuses`, and `Payment_Methods` |

✅ **Result:** All fields now contain single atomic values.

---

### **2NF — Second Normal Form**
**Rule:** Remove partial dependencies (non-key attributes depending only on part of a composite key).

All tables use **single-column UUID primary keys**, so no composite keys exist.
→ Therefore, 2NF is **automatically satisfied**.

However, derived attributes such as `total_price` in `Booking` were reviewed:
- It depends on `price_per_night` and `nights`.
- Kept for audit/logging purposes (not computed dynamically every time).

✅ **Result:** All non-key attributes depend on the full primary key.

---

### **3NF — Third Normal Form**
**Rule:** Remove transitive dependencies — non-key attributes should not depend on other non-key attributes.

| Issue | Violation | Resolution |
|-------|------------|-------------|
| `role` meaning embedded in `User` | Transitive dependency | Moved to `Roles` lookup table |
| `payment_method` meaning stored in `Payment` | Transitive dependency | Moved to `Payment_Methods` lookup table |
| `status` meaning stored in `Booking` | Transitive dependency | Moved to `Booking_Statuses` lookup table |
| `Message` missing context grouping | Implicit dependency between sender/recipient | Introduced `Conversation` and `Conversation_Participants` tables |
| Changing property price over time | Time-dependent redundancy | Added `Property_Rates` table for date-based pricing |
| Repeating address data across properties | Data redundancy | Introduced `Addresses` table and referenced it from `Properties` |

✅ **Result:** All attributes depend **only** on their primary keys, and all transitive dependencies are removed.

---

## 3. Final Normalized Tables (Summary)

| Entity | Purpose | Normalized Additions |
|--------|----------|----------------------|
| **Users** | Stores guest, host, or admin info | Linked to `Roles` |
| **Roles** | Lookup for user roles | New table |
| **Properties** | Stores property metadata | References `Addresses`, `Users` |
| **Addresses** | Stores structured location data | New table |
| **Property_Images** | Stores multiple images per property | New table |
| **Amenities** / **Property_Amenities** | Defines and links amenities | New tables |
| **Property_Rates** | Manages historical/seasonal pricing | New table |
| **Bookings** | Links guests and properties | References `Booking_Statuses` |
| **Payments** | Tracks transactions | References `Payment_Methods` |
| **Reviews** | Stores user reviews | Optionally linked to `Bookings` |
| **Messages** | Stores chat messages | Linked to `Conversations` |
| **Conversations** / **Conversation_Participants** | Group and manage chat participants | New tables |

---

## 4. Benefits of Achieving 3NF

| Benefit | Description |
|----------|-------------|
| ✅ **Reduced Redundancy** | No duplication of role, location, or payment type data. |
| ✅ **Improved Integrity** | Referential integrity enforced with foreign keys. |
| ✅ **Simplified Maintenance** | Future updates (e.g., adding a new payment method) require changes only in lookup tables. |
| ✅ **Extensible Messaging** | Conversations support group or threaded chats without data duplication. |
| ✅ **Better Query Performance** | Proper indexing and foreign key relations optimize lookups. |

---

## 5. Conclusion

The Property Rental (Airbnb-like) database has been successfully normalized to **Third Normal Form (3NF)**.

All potential redundancies and transitive dependencies were resolved by introducing lookup and relational tables.
The design now ensures:
- High data integrity
- Scalability for future features (seasonal pricing, chat, payment gateways)
- Efficient querying and maintenance

---

### ✅ Next Step
**Task 3:** Implement SQL DDL scripts based on this normalized schema, defining:
- Primary and foreign keys
- Unique constraints
- Indexes
- Timestamps and triggers

---

**Author:** Chijioke Chika
**Project:** Property Rental System (Airbnb Clone)
**Date:** 2025-10-22
