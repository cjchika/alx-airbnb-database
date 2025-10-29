-- =======================================================
-- FILE: partitioning.sql
-- OBJECTIVE: Implement table partitioning on the Booking table
-- =======================================================

-- 1️⃣ STEP 1: Drop the old Booking table if it exists (for clean setup)
DROP TABLE IF EXISTS Booking CASCADE;

-- 2️⃣ STEP 2: Create a new partitioned Booking table by RANGE (based on start_date)
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

-- 3️⃣ STEP 3: Create partitions by year (for scalability)
CREATE TABLE booking_2023 PARTITION OF Booking
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE booking_2024 PARTITION OF Booking
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE booking_2025 PARTITION OF Booking
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Optional: Future-proof with default partition
CREATE TABLE booking_future PARTITION OF Booking
    DEFAULT;

-- 4️⃣ STEP 4: Insert sample data
INSERT INTO Booking (user_id, property_id, start_date, end_date, total_amount, status)
VALUES
(1, 3, '2023-03-10', '2023-03-15', 450.00, 'Completed'),
(2, 1, '2023-07-22', '2023-07-24', 250.00, 'Completed'),
(3, 2, '2024-02-01', '2024-02-03', 350.00, 'Cancelled'),
(4, 1, '2024-05-12', '2024-05-15', 550.00, 'Completed'),
(1, 3, '2025-03-20', '2025-03-25', 480.00, 'Pending');

-- 5️⃣ STEP 5: Verify partition distribution
SELECT tableoid::regclass AS partition_name, *
FROM Booking
ORDER BY booking_id;

-- 6️⃣ STEP 6: Compare performance (non-partitioned vs partitioned)
-- Non-partitioned query (simulated):
-- SELECT * FROM Booking WHERE start_date BETWEEN '2023-01-01' AND '2023-12-31';

-- Partitioned query using EXPLAIN ANALYZE:
EXPLAIN ANALYZE
SELECT * FROM Booking WHERE start_date BETWEEN '2023-01-01' AND '2023-12-31';

-- Expected Output (sample):
-- QUERY PLAN
-- -----------------------------------------------------------------
-- Append  (cost=0.00..120.00 rows=500 width=64)
--   ->  Seq Scan on booking_2023  (cost=0.00..40.00 rows=200 width=64)
-- Planning Time: 0.09 ms
-- Execution Time: 0.35 ms
