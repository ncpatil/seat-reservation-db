-- ===============================
--  Seat Reservation Database System
--  Author: Ninganagoud C Patil
--  Tech Stack: MySQL, MySQL Workbench
-- ===============================

-- Database creation
CREATE DATABASE IF NOT EXISTS SeatReservationDB;
USE SeatReservationDB;

-- Tables creation

-- ROUTE TABLE
CREATE TABLE Route (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    source_station VARCHAR(100) NOT NULL,
    destination_station VARCHAR(100) NOT NULL,
    distance_km INT NOT NULL
);

-- TRAIN TABLE
CREATE TABLE Train (
    train_id INT AUTO_INCREMENT PRIMARY KEY,
    train_name VARCHAR(100) NOT NULL,
    total_seats INT NOT NULL,
    route_id INT,
    FOREIGN KEY (route_id) REFERENCES Route(route_id)
);

-- PASSENGER TABLE
CREATE TABLE Passenger (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    age INT,
    contact_number VARCHAR(15),
    email VARCHAR(100)
);

-- TICKET TABLE
CREATE TABLE Ticket (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT,
    train_id INT,
    seat_number VARCHAR(10),
    booking_date DATE,
    journey_date DATE,
    status ENUM('Booked', 'Cancelled') DEFAULT 'Booked',
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (train_id) REFERENCES Train(train_id)
);

-- PAYMENT TABLE
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_mode ENUM('UPI', 'Card', 'NetBanking', 'Cash'),
    FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id)
);

-- Insertion of Data
-- ROUTES
INSERT INTO Route (source_station, destination_station, distance_km)
VALUES 
('Bangalore', 'Chennai', 350),
('Bangalore', 'Hyderabad', 570),
('Bangalore', 'Mumbai', 980);

-- TRAINS
INSERT INTO Train (train_name, total_seats, route_id)
VALUES 
('Kaveri Express', 100, 1),
('Charminar Express', 120, 2),
('Udyan Express', 150, 3);

-- PASSENGERS
INSERT INTO Passenger (full_name, gender, age, contact_number, email)
VALUES 
('Ramesh Kumar', 'Male', 32, '9876543210', 'ramesh@example.com'),
('Sita Devi', 'Female', 28, '9988776655', 'sita@example.com'),
('Arjun Patel', 'Male', 45, '9123456789', 'arjun@example.com');

-- TICKETS
INSERT INTO Ticket (passenger_id, train_id, seat_number, booking_date, journey_date, status)
VALUES 
(1, 1, 'A1', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 2 DAY), 'Booked'),
(2, 2, 'B2', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 3 DAY), 'Booked'),
(3, 3, 'C3', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 4 DAY), 'Cancelled');

-- PAYMENTS
INSERT INTO Payment (ticket_id, amount, payment_date, payment_mode)
VALUES 
(1, 450.00, CURDATE(), 'UPI'),
(2, 600.00, CURDATE(), 'Card'),
(3, 700.00, CURDATE(), 'NetBanking');

-- =========================================
-- Core Queries
-- =========================================

-- Check Seat Availability for a Train
SELECT 
    t.train_id, 
    t.train_name,
    (t.total_seats - COUNT(ticket_id)) AS available_seats
FROM Train t
LEFT JOIN Ticket tk 
    ON t.train_id = tk.train_id 
    AND tk.status = 'Booked'
WHERE t.train_id = 1
GROUP BY t.train_id, t.train_name, t.total_seats;

-- To Book a Seat
INSERT INTO Ticket (passenger_id, train_id, seat_number, booking_date, journey_date, status)
VALUES (1, 2, 'A10', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'Booked');

-- To Cancel a Ticket
UPDATE Ticket
SET status = 'Cancelled'
WHERE ticket_id = 1;

-- Daily Passenger Count Report
SELECT 
    journey_date, 
    COUNT(ticket_id) AS total_passengers
FROM Ticket
WHERE status = 'Booked'
GROUP BY journey_date
ORDER BY journey_date;

-- Route-wise Revenue Report
SELECT 
    r.route_id, 
    r.source_station, 
    r.destination_station,
    SUM(p.amount) AS total_revenue
FROM Route r
JOIN Train t ON r.route_id = t.route_id
JOIN Ticket tk ON t.train_id = tk.train_id
JOIN Payment p ON tk.ticket_id = p.ticket_id
WHERE tk.status = 'Booked'
GROUP BY r.route_id, r.source_station, r.destination_station;

-- Cancelled Tickets Report
SELECT 
    tk.ticket_id, 
    p.full_name, 
    t.train_name, 
    tk.journey_date, 
    tk.status
FROM Ticket tk
JOIN Passenger p ON tk.passenger_id = p.passenger_id
JOIN Train t ON tk.train_id = t.train_id
WHERE tk.status = 'Cancelled';

-- Top Routes by Bookings
SELECT 
    r.source_station, 
    r.destination_station, 
    COUNT(tk.ticket_id) AS total_bookings
FROM Route r
JOIN Train t ON r.route_id = t.route_id
JOIN Ticket tk ON t.train_id = tk.train_id
WHERE tk.status = 'Booked'
GROUP BY r.route_id
ORDER BY total_bookings DESC;

-- Seat Utilization per Train
SELECT 
    t.train_name,
    (COUNT(tk.ticket_id) / t.total_seats * 100) AS utilization_percent
FROM Train t
LEFT JOIN Ticket tk 
    ON t.train_id = tk.train_id 
    AND tk.status = 'Booked'
GROUP BY t.train_id, t.train_name, t.total_seats;
