# 🚆 Seat Reservation Database System

## 📘 Project Overview

The **Seat Reservation Database System** is a MySQL-based project designed to manage train schedules, passengers, and reservations.  
It demonstrates database design principles, SQL query writing, and reporting for bookings, cancellations, and revenue tracking.

---

## 🧱 Tech Stack

| Component    | Description     |
| ------------ | --------------- |
| **Database** | MySQL           |
| **Tool**     | MySQL Workbench |
| **Language** | SQL             |

---

## 🎯 Objectives

- Manage train and route information efficiently
- Track passenger and booking details
- Handle seat availability, bookings, and cancellations dynamically
- Generate reports for business insights

---

## 🗂️ Database Schema Design

The database is normalized and includes the following tables:

| Table Name     | Description                                                           |
| -------------- | --------------------------------------------------------------------- |
| **Trains**     | Stores train details such as train number, name, and capacity         |
| **Routes**     | Contains route information including start, destination, and distance |
| **Passengers** | Stores passenger personal details                                     |
| **Tickets**    | Holds booking details, linking passengers and trains                  |
| **Payments**   | Manages ticket payments and cancellation details                      |

---

## 🔗 Entity-Relationship (ER) Diagram

![ER Diagram](Seat_Reservation_ER_Diagram.png)

---

## 💾 Key Features

✅ Normalized relational schema design  
✅ SQL queries for seat availability, booking, and cancellation  
✅ Reporting queries for:

- Daily passenger count
- Route-wise revenue  
  ✅ Proper foreign key relationships and constraints

---

## ⚙️ How to Run the Project

1. Open **MySQL Workbench**
2. Create a new schema (example: `seat_reservation_db`)
3. Copy and run all SQL commands from `seat_reservation.sql`
4. View the tables using:

   ```sql
   SHOW TABLES;
   ```

5. To verify inserted data:

SELECT _ FROM passengers;
SELECT _ FROM trains;

6. Explore analytical queries in the SQL file to view seat availability and revenue reports.

---

Example Reports -
Daily Passenger Count

SELECT travel_date, COUNT(ticket_id) AS total_passengers
FROM tickets
GROUP BY travel_date;

---

Route-wise Revenue

SELECT r.route_name, SUM(p.amount) AS total_revenue
FROM payments p
JOIN tickets t ON p.ticket_id = t.ticket_id
JOIN routes r ON t.route_id = r.route_id
GROUP BY r.route_name;

---

Author
Ninganagoud. C. Patil
Full Stack Developer
Bengaluru, India

GitHub Repository
You can view the complete project here:
https://github.com/ncpatil/seat-reservation-db
