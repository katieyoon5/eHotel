-- =========================
-- drop tables
-- =========================
DROP TABLE IF EXISTS Payment CASCADE;
DROP TABLE IF EXISTS RoomAmenities CASCADE;
DROP TABLE IF EXISTS RoomIssues CASCADE;
DROP TABLE IF EXISTS RentingArchive CASCADE;
DROP TABLE IF EXISTS BookingArchive CASCADE;
DROP TABLE IF EXISTS Renting CASCADE;
DROP TABLE IF EXISTS Booking CASCADE;
DROP TABLE IF EXISTS Room CASCADE;
DROP TABLE IF EXISTS Employee CASCADE;
DROP TABLE IF EXISTS Customer CASCADE;
DROP TABLE IF EXISTS HotelPhone CASCADE;
DROP TABLE IF EXISTS Hotel CASCADE;
DROP TABLE IF EXISTS HotelChainEmail CASCADE;
DROP TABLE IF EXISTS HotelChainPhone CASCADE;
DROP TABLE IF EXISTS Hotel_Chain CASCADE;
-- =========================
-- hotel chain
-- =========================
CREATE TABLE Hotel_Chain (
                             Chain_ID SERIAL PRIMARY KEY,
                             Office_Address TEXT UNIQUE,
                             Num_Hotels INT CHECK (Num_Hotels > 0)
);
CREATE TABLE HotelChainPhone (
                                 Chain_ID INT,
                                 Phone TEXT,
                                 PRIMARY KEY (Chain_ID, Phone),
                                 FOREIGN KEY (Chain_ID) REFERENCES Hotel_Chain(Chain_ID)
);
CREATE TABLE HotelChainEmail (
                                 Chain_ID INT,
                                 Email TEXT,
                                 PRIMARY KEY (Chain_ID, Email),
                                 FOREIGN KEY (Chain_ID) REFERENCES Hotel_Chain(Chain_ID)
);
-- =========================
-- hotel
-- =========================
CREATE TABLE Hotel (
                       Hotel_ID SERIAL PRIMARY KEY,
                       Rating FLOAT CHECK (Rating BETWEEN 1 AND 5),
                       Address TEXT UNIQUE,
                       Chain_ID INT,
                       Manager_SSN INT,
                       FOREIGN KEY (Chain_ID) REFERENCES Hotel_Chain(Chain_ID)
);
CREATE TABLE HotelPhone (
                            Hotel_ID INT,
                            Phone TEXT,
                            PRIMARY KEY (Hotel_ID, Phone),
                            FOREIGN KEY (Hotel_ID) REFERENCES Hotel(Hotel_ID)
);
-- =========================
-- customer
-- =========================
CREATE TABLE Customer (
                          Cust_ID SERIAL PRIMARY KEY,
                          FirstName TEXT,
                          MiddleName TEXT,
                          LastName TEXT,
                          Address TEXT,
                          RegistrationDate DATE DEFAULT CURRENT_DATE,
                          Username TEXT UNIQUE,
                          Password TEXT
);
-- =========================
-- employee
-- =========================
CREATE TABLE Employee (
                          SSN SERIAL PRIMARY KEY,
                          FirstName TEXT,
                          MiddleName TEXT,
                          LastName TEXT,
                          Address TEXT,
                          Role TEXT NOT NULL,
                          Hotel_ID INT,
                          Username TEXT UNIQUE,
                          Password TEXT,
                          FOREIGN KEY (Hotel_ID) REFERENCES Hotel(Hotel_ID)
);
-- =========================
-- room
-- =========================
CREATE TABLE Room (
    Hotel_ID INT,
    Chain_ID INT,
    Available BOOLEAN DEFAULT TRUE,
    RoomNumber INT,
    Price INT CHECK (Price > 0),
    Capacity INT CHECK (Capacity > 0),
    View TEXT CHECK (View IN ('sea', 'mountain')),
    Extendable BOOLEAN,
    PRIMARY KEY (Hotel_ID, RoomNumber),
    FOREIGN KEY (Hotel_ID) REFERENCES Hotel(Hotel_ID),
    FOREIGN KEY (Chain_ID) REFERENCES Hotel_Chain(Chain_ID)
);
-- =========================
-- multivalued attributes
-- =========================
CREATE TABLE RoomAmenities (
                               Hotel_ID INT,
                               RoomNumber INT,
                               Amenity TEXT,
                               PRIMARY KEY (Hotel_ID, RoomNumber, Amenity),
                               FOREIGN KEY (Hotel_ID, RoomNumber)
                                   REFERENCES Room(Hotel_ID, RoomNumber)
);
CREATE TABLE RoomIssues (
                            Hotel_ID INT,
                            RoomNumber INT,
                            Issue TEXT,
                            PRIMARY KEY (Hotel_ID, RoomNumber, Issue),
                            FOREIGN KEY (Hotel_ID, RoomNumber)
                                REFERENCES Room(Hotel_ID, RoomNumber)
);
-- =========================
-- booking
-- =========================
CREATE TABLE Booking (
                         Book_ID SERIAL PRIMARY KEY,
                         StartDate DATE,
                         EndDate DATE,
                         Hotel_ID INT,
                         RoomNumber INT,
                         Cust_ID INT,
                         FOREIGN KEY (Cust_ID) REFERENCES Customer(Cust_ID),
                         FOREIGN KEY (Hotel_ID, RoomNumber)
                             REFERENCES Room(Hotel_ID, RoomNumber)
);
-- =========================
-- renting
-- =========================
CREATE TABLE Renting (
                         Rent_ID SERIAL PRIMARY KEY,
                         Start_Date DATE,
                         End_Date DATE,
                         Hotel_ID INT,
                         RoomNumber INT,
                         Cust_ID INT,
                         SSN INT,
                         FOREIGN KEY (Cust_ID) REFERENCES Customer(Cust_ID),
                         FOREIGN KEY (SSN) REFERENCES Employee(SSN),
                         FOREIGN KEY (Hotel_ID, RoomNumber)
                             REFERENCES Room(Hotel_ID, RoomNumber)
);
-- =========================
-- payment
-- =========================
CREATE TABLE Payment (
                         Payment_ID SERIAL PRIMARY KEY,
                         Rent_ID INT,
                         Amount DECIMAL(10,2) CHECK (Amount > 0),
                         Payment_Date DATE,
                         FOREIGN KEY (Rent_ID) REFERENCES Renting(Rent_ID)
);
-- =========================
-- archive tables
-- =========================
CREATE TABLE BookingArchive AS TABLE Booking WITH NO DATA;
CREATE TABLE RentingArchive AS TABLE Renting WITH NO DATA;
-- =========================
-- add manager fk
-- =========================
ALTER TABLE Hotel
    ADD CONSTRAINT fk_manager
        FOREIGN KEY (Manager_SSN)
            REFERENCES Employee(SSN);
-- =========================
-- DATA POPULATION
-- =========================
INSERT INTO Hotel_Chain (office_address, num_hotels) VALUES
                                                         ('Address1', 8),
                                                         ('Address2', 8),
                                                         ('Address3', 8),
                                                         ('Address4', 8),
                                                         ('Address5', 8);
INSERT INTO Hotel (rating, address, chain_id) VALUES
                                                  -- Chain 1 (8 hotels, includes same area)
                                                  (4.5, 'Toronto Downtown', 1),
                                                  (3.0, 'Toronto Downtown East', 1),
                                                  (2.0, '123 thunder bay', 1),
                                                  (1.5, '234 jane street', 1),
                                                  (5.0, '111 maple st', 1),
                                                  (4.0, '222 king st', 1),
                                                  (3.5, '333 queen st', 1),
                                                  (2.5, '444 bay st', 1),
                                                  -- Chain 2
                                                  (2.0, '23 ottawa town', 2),
                                                  (5.0, '23 mackenzie street', 2),
                                                  (4.5, '101 sparks', 2),
                                                  (3.5, '202 elgin', 2),
                                                  (2.5, '303 rideau', 2),
                                                  (4.0, '404 bank', 2),
                                                  (3.0, '505 somerset', 2),
                                                  (1.0, '606 bronson', 2),
                                                  -- Chain 3
                                                  (4.5, '468 maddie street', 3),
                                                  (4.5, '979 cony island', 3),
                                                  (3.5, '1010 lakeview', 3),
                                                  (2.5, '1111 sunset', 3),
                                                  (5.0, '1212 sunrise', 3),
                                                  (4.0, '1313 hilltop', 3),
                                                  (3.0, '1414 valley', 3),
                                                  (2.0, '1515 ridge', 3),
                                                  -- Chain 4
                                                  (4.5, '567 icecream town', 4),
                                                  (4.0, '1616 north rd', 4),
                                                  (3.5, '1717 south rd', 4),
                                                  (2.5, '1818 east rd', 4),
                                                  (1.5, '1919 west rd', 4),
                                                  (5.0, '2020 central', 4),
                                                  (4.0, '2121 lake', 4),
                                                  (3.0, '2222 river', 4),
                                                  -- Chain 5
                                                  (4.5, '232 hogwarts', 5),
                                                  (4.5, '978 vampire town', 5),
                                                  (4.5, '4543 ottawa center', 5),
                                                  (3.5, '232 wizard lane', 5),
                                                  (2.5, '343 magic ave', 5),
                                                  (1.5, '454 spell rd', 5),
                                                  (5.0, '565 potion st', 5),
                                                  (4.0, '676 dragon way', 5);
INSERT INTO Employee (FirstName, MiddleName, LastName, Address, Role, Hotel_ID) VALUES
                                                                                    ('Alice', NULL, 'Joe', '4129 Sunnybrook Ln', 'manager', 1),
                                                                                    ('Kiara', NULL, 'Maynard', '1142 Severn St', 'manager', 2),
                                                                                    ('Megan', NULL, 'Gross', '323 Riverdale Dr.', 'manager', 3),
                                                                                    ('Belen', NULL, 'Springer', '4541 Gordon Way', 'manager', 4),
                                                                                    ('Luisa', NULL, 'Nickerson', '1026 Shinnecock Dr', 'manager', 5),
                                                                                    ('Dillan', NULL, 'Weathers', '2044W Flag Way', 'manager', 6),
                                                                                    ('Lucina', NULL, 'Zhou', '1569 Harrisburg Dr', 'manager', 7),
                                                                                    ('Peter', NULL, 'Kim', '1569 Harrison Dr', 'manager', 8),
                                                                                    ('Kimmy', NULL, 'Lee', '1523 Harrisonburg Dr', 'manager', 9),
                                                                                    ('Tamara', NULL, 'Kane', '567 W Cross Rd', 'manager', 10);
-- =========================
-- SET MANAGERS
-- =========================
-- SSNs are auto-generated in insert order: Alice=1, Kiara=2, Megan=3, etc.
UPDATE Hotel SET Manager_SSN = 1 WHERE Hotel_ID = 1;
UPDATE Hotel SET Manager_SSN = 2 WHERE Hotel_ID = 2;
UPDATE Hotel SET Manager_SSN = 3 WHERE Hotel_ID = 3;
UPDATE Hotel SET Manager_SSN = 4 WHERE Hotel_ID = 4;
UPDATE Hotel SET Manager_SSN = 5 WHERE Hotel_ID = 5;
UPDATE Hotel SET Manager_SSN = 6 WHERE Hotel_ID = 6;
UPDATE Hotel SET Manager_SSN = 7 WHERE Hotel_ID = 7;
UPDATE Hotel SET Manager_SSN = 8 WHERE Hotel_ID = 8;
UPDATE Hotel SET Manager_SSN = 9 WHERE Hotel_ID = 9;
UPDATE Hotel SET Manager_SSN = 10 WHERE Hotel_ID = 10;
INSERT INTO Customer (FirstName, MiddleName, LastName, Address, RegistrationDate) VALUES
                                                                                      ('Hermione', NULL, 'Granger', '54 lakehouse', '2026-05-02'),
                                                                                      ('Harry', NULL, 'Potter', '77 disney land', '2026-12-05'),
                                                                                      ('Ron', NULL, 'Weasley', '45 jane doe', '2026-11-04');
INSERT INTO Room (Hotel_ID, Chain_ID, Available, RoomNumber, Price, Capacity, View, Extendable) VALUES
           -- Hotel 1 (5 rooms, different capacities)
           (1, 1, TRUE, 101, 112, 2, 'sea', TRUE),
           (1, 1,FALSE, 102, 120, 3, 'sea', FALSE),
           (1,1, FALSE, 103, 130, 4, 'sea', TRUE),
           (1, 1, FALSE,104, 140, 5, 'sea', FALSE),
           (1,1, TRUE, 105, 150, 6, 'sea', TRUE),
           -- Hotel 2
           (2, 1, TRUE,201, 100, 2, 'mountain', TRUE),
           (2, 1, TRUE,202, 110, 3, 'mountain', FALSE),
           (2, 1, TRUE,203, 120, 4, 'mountain', TRUE),
           (2, 1, TRUE,204, 130, 5, 'mountain', FALSE),
           (2, 1, TRUE,205, 140, 6, 'mountain', TRUE);
--Add more rooms later, amentinites, issues
INSERT INTO Booking (StartDate, EndDate, Hotel_ID, RoomNumber, Cust_ID) VALUES
    ('2026-12-22', '2026-12-26', 1, 101, 1);
INSERT INTO Renting (Start_Date, End_Date, Hotel_ID, RoomNumber, Cust_ID, SSN) VALUES
    ('2026-12-22', '2026-12-26', 1, 101, 2, 1);
-- =========================
-- INDEXES
-- =========================
-- 1. speed up searching hotels by chain
CREATE INDEX idx_hotel_chain ON Hotel(Chain_ID);
-- 2. speed up finding rooms in a hotel
CREATE INDEX idx_room_hotel ON Room(Hotel_ID);
-- 3. speed up booking lookups by customer
CREATE INDEX idx_booking_customer ON Booking(Cust_ID);
-- =========================
-- VIEWS
-- =========================
-- 1. the first view is the number of available rooms per area (hotel address) .
CREATE VIEW RoomsPerArea AS
SELECT h.Address, COUNT(*) AS total_rooms
FROM Room r
         JOIN Hotel h ON r.Hotel_ID = h.Hotel_ID
WHERE NOT EXISTS (
    SELECT 1 FROM Booking b
    WHERE b.Hotel_ID = r.Hotel_ID
      AND b.RoomNumber = r.RoomNumber
)
GROUP BY h.Address;
-- 2. the second view is the aggregated capacity of all the rooms of a specific hotel.
CREATE VIEW HotelCapacity AS
SELECT Hotel_ID, SUM(Capacity) AS total_capacity
FROM Room
GROUP BY Hotel_ID;
SELECT * FROM RoomsPerArea;
SELECT * FROM HotelCapacity;
-- =========================
-- Achive booking on delete
-- =========================
CREATE OR REPLACE FUNCTION archive_booking()
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO BookingArchive
SELECT OLD.*;
RETURN OLD;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER booking_archive_trigger
    BEFORE DELETE ON Booking
    FOR EACH ROW
    EXECUTE FUNCTION archive_booking();
-- =========================
-- Archive renting on delete
-- =========================
CREATE OR REPLACE FUNCTION archive_renting()
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO RentingArchive
SELECT OLD.*;
RETURN OLD;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER renting_archive_trigger
    BEFORE DELETE ON Renting
    FOR EACH ROW
    EXECUTE FUNCTION archive_renting();
-- =========================
-- Prevent overllaping bookings
-- =========================
CREATE OR REPLACE FUNCTION prevent_overlap_booking()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (
      SELECT 1 FROM Booking
      WHERE Hotel_ID = NEW.Hotel_ID
      AND RoomNumber = NEW.RoomNumber
      AND NEW.StartDate < EndDate
      AND NEW.EndDate > StartDate
  ) THEN
      RAISE EXCEPTION 'Booking dates overlap!';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER booking_overlap_trigger
    BEFORE INSERT ON Booking
    FOR EACH ROW
    EXECUTE FUNCTION prevent_overlap_booking();
-- All available rooms
SELECT *
FROM Room r
WHERE NOT EXISTS (
    SELECT 1 FROM Booking b
    WHERE b.Hotel_ID = r.Hotel_ID
      AND b.RoomNumber = r.RoomNumber
);
-- Rooms with capacity > 2
SELECT * FROM Room
WHERE Capacity > 2;
-- All bookings with customer names
SELECT c.FirstName, c.LastName, b.*
FROM Booking b
         JOIN Customer c ON b.Cust_ID = c.Cust_ID;
-- Count rooms per hotel
SELECT Hotel_ID, COUNT(*) AS total_rooms
FROM Room
GROUP BY Hotel_ID;
-- Average room price per hotel
SELECT Hotel_ID, AVG(Price) AS avg_price
FROM Room
GROUP BY Hotel_ID;
