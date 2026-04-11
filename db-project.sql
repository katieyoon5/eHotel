-- =========================
-- drop tables
-- =========================
DROP TABLE IF EXISTS HotelEmail CASCADE;
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
CREATE TABLE HotelEmail (
                            Hotel_ID INT,
                            Email TEXT,
                            PRIMARY KEY (Hotel_ID, Email),
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
INSERT INTO Employee (FirstName, MiddleName, LastName, Address, Role, Hotel_ID, Username, Password) VALUES
                                                                                    ('Alice', NULL, 'Joe', '4129 Sunnybrook Ln', 'manager', 1, 'user1', '123'),
                                                                                    ('Kiara', NULL, 'Maynard', '1142 Severn St', 'manager', 2, 'user2', '123'),
                                                                                    ('Megan', NULL, 'Gross', '323 Riverdale Dr.', 'manager', 3, 'user3', '234'),
                                                                                    ('Belen', NULL, 'Springer', '4541 Gordon Way', 'manager', 4, 'user4', '123'),
                                                                                    ('Luisa', NULL, 'Nickerson', '1026 Shinnecock Dr', 'manager', 5, 'user5', '123'),
                                                                                    ('Dillan', NULL, 'Weathers', '2044W Flag Way', 'manager', 6, 'user6', '234'),
                                                                                    ('Lucina', NULL, 'Zhou', '1569 Harrisburg Dr', 'manager', 7, 'user7', '234'),
                                                                                    ('Peter', NULL, 'Kim', '1569 Harrison Dr', 'manager', 8, 'user8', '234'),
                                                                                    ('Kimmy', NULL, 'Lee', '1523 Harrisonburg Dr', 'manager', 9, 'user9', '123'),
                                                                                    ('Tamara', NULL, 'Kane', '567 W Cross Rd', 'manager', 10, 'user10', '123');
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
INSERT INTO Customer (FirstName, MiddleName, LastName, Address, RegistrationDate, Username, Password) VALUES
                                                                                      ('Hermione', NULL, 'Granger', '54 lakehouse', '2026-05-02', 'cust1', '123'),
                                                                                      ('Harry', NULL, 'Potter', '77 disney land', '2026-12-05', 'cust2', '123'),
                                                                                      ('Ron', NULL, 'Weasley', '45 jane doe', '2026-11-04', 'cust3', '123');
INSERT INTO Room (Hotel_ID, Chain_ID, RoomNumber, Price, Capacity, View, Extendable) VALUES
                                                                                         -- Hotel 1 (5 rooms, different capacities)
                                                                                         (1, 1, 101, 112, 2, 'sea', TRUE),
                                                                                         (1, 1, 102, 120, 3, 'sea', FALSE),
                                                                                         (1,1,  103, 130, 4, 'sea', TRUE),
                                                                                         (1, 1,104, 140, 5, 'sea', FALSE),
                                                                                         (1,1, 105, 150, 6, 'sea', TRUE),
                                                                                         -- Hotel 2
                                                                                         (2, 1,201, 100, 2, 'mountain', TRUE),
                                                                                         (2, 1,202, 110, 3, 'mountain', FALSE),
                                                                                         (2, 1,203, 120, 4, 'mountain', TRUE),
                                                                                         (2, 1,204, 130, 5, 'mountain', FALSE),
                                                                                         (2, 1,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 3
                                                                                         (3, 1,201, 100, 2, 'mountain', TRUE),
                                                                                         (3, 1,202, 110, 3, 'sea', FALSE),
                                                                                         (3, 1,203, 120, 4, 'mountain', TRUE),
                                                                                         (3, 1,204, 130, 5, 'mountain', FALSE),
                                                                                         (3, 1,205, 140, 6, 'sea', TRUE),

                                                                                         -- Hotel 4
                                                                                         (4, 1,201, 100, 2, 'mountain', TRUE),
                                                                                         (4, 1,202, 110, 3, 'sea', FALSE),
                                                                                         (4, 1,203, 120, 4, 'mountain', TRUE),
                                                                                         (4, 1,204, 130, 5, 'mountain', FALSE),
                                                                                         (4, 1,205, 140, 6, 'sea', TRUE),

                                                                                         -- Hotel 5
                                                                                         (5, 1,201, 50, 2, 'mountain', TRUE),
                                                                                         (5, 1,202, 30, 3, 'mountain', FALSE),
                                                                                         (5, 1,203, 101, 4, 'sea', TRUE),
                                                                                         (5, 1,204, 101, 5, 'mountain', FALSE),
                                                                                         (5, 1,205, 140, 6, 'mountain', TRUE),

                                                                                         -- Hotel 6
                                                                                         (6, 1,201, 200, 2, 'mountain', TRUE),
                                                                                         (6, 1,202, 110, 3, 'mountain', FALSE),
                                                                                         (6, 1,203, 120, 4, 'mountain', TRUE),
                                                                                         (6, 1,204, 130, 5, 'sea', FALSE),
                                                                                         (6, 1,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 7
                                                                                         (7, 1,201, 100, 2, 'sea', TRUE),
                                                                                         (7, 1,202, 99, 3, 'mountain', FALSE),
                                                                                         (7, 1,203, 120, 4, 'mountain', TRUE),
                                                                                         (7, 1,204, 130, 5, 'mountain', FALSE),
                                                                                         (7, 1,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 8
                                                                                         (8, 1,201, 100, 2, 'mountain', TRUE),
                                                                                         (8, 1,202, 110, 3, 'mountain', FALSE),
                                                                                         (8, 1,203, 120, 4, 'mountain', TRUE),
                                                                                         (8, 1,204, 130, 5, 'mountain', FALSE),
                                                                                         (8, 1,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 9
                                                                                         (9, 2,201, 100, 2, 'mountain', TRUE),
                                                                                         (9, 2,202, 110, 3, 'mountain', FALSE),
                                                                                         (9, 2,203, 120, 4, 'mountain', TRUE),
                                                                                         (9, 2,204, 130, 5, 'mountain', FALSE),
                                                                                         (9, 2,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (10, 2,201, 99, 2, 'mountain', TRUE),
                                                                                         (10, 2,202, 110, 3, 'mountain', FALSE),
                                                                                         (10, 2,203, 120, 4, 'mountain', TRUE),
                                                                                         (10, 2,204, 400, 5, 'mountain', FALSE),
                                                                                         (10, 2,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (11, 2,201, 100, 2, 'mountain', TRUE),
                                                                                         (11, 2,202, 500, 3, 'mountain', FALSE),
                                                                                         (11, 2,203, 120, 4, 'mountain', TRUE),
                                                                                         (11, 2,204, 130, 5, 'mountain', FALSE),
                                                                                         (11, 2,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (12, 2,201, 100, 2, 'mountain', TRUE),
                                                                                         (12, 2,202, 110, 3, 'mountain', FALSE),
                                                                                         (12, 2,203, 120, 4, 'mountain', TRUE),
                                                                                         (12, 2,204, 130, 5, 'mountain', FALSE),
                                                                                         (12, 2,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (13, 2,201, 100, 2, 'mountain', TRUE),
                                                                                         (13, 2,202, 110, 3, 'mountain', FALSE),
                                                                                         (13, 2,203, 120, 4, 'mountain', TRUE),
                                                                                         (13, 2,204, 130, 5, 'mountain', FALSE),
                                                                                         (13, 2,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (14, 2,201, 600, 2, 'mountain', TRUE),
                                                                                         (14, 2,202, 110, 3, 'mountain', FALSE),
                                                                                         (14, 2,203, 120, 4, 'mountain', TRUE),
                                                                                         (14, 2,204, 130, 5, 'mountain', FALSE),
                                                                                         (14, 2,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (15, 2,201, 870, 2, 'mountain', TRUE),
                                                                                         (15, 2,202, 110, 3, 'mountain', FALSE),
                                                                                         (15, 2,203, 120, 4, 'mountain', TRUE),
                                                                                         (15, 2,204, 130, 5, 'mountain', FALSE),
                                                                                         (15, 2,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (16, 2,201, 900, 2, 'mountain', TRUE),
                                                                                         (16, 2,202, 110, 3, 'mountain', FALSE),
                                                                                         (16, 2,203, 120, 4, 'mountain', TRUE),
                                                                                         (16, 2,204, 130, 5, 'mountain', FALSE),
                                                                                         (16, 2,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (17, 3,201, 100, 2, 'mountain', TRUE),
                                                                                         (17, 3,202, 110, 3, 'mountain', FALSE),
                                                                                         (17, 3,203, 120, 4, 'mountain', TRUE),
                                                                                         (17, 3,204, 130, 5, 'mountain', FALSE),
                                                                                         (17, 3,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (18, 3,201, 585, 2, 'mountain', TRUE),
                                                                                         (18, 3,202, 110, 3, 'mountain', FALSE),
                                                                                         (18, 3,203, 120, 4, 'mountain', TRUE),
                                                                                         (18, 3,204, 130, 5, 'mountain', FALSE),
                                                                                         (18, 3,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (19, 3,201, 88, 2, 'mountain', TRUE),
                                                                                         (19, 3,202, 110, 3, 'mountain', FALSE),
                                                                                         (19, 3,203, 120, 4, 'mountain', TRUE),
                                                                                         (19, 3,204, 130, 5, 'mountain', FALSE),
                                                                                         (19, 3,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (20, 3,201, 750, 2, 'mountain', TRUE),
                                                                                         (20, 3,202, 110, 3, 'mountain', FALSE),
                                                                                         (20, 3,203, 120, 4, 'mountain', TRUE),
                                                                                         (20, 3,204, 130, 5, 'mountain', FALSE),
                                                                                         (20, 3,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (21, 3,201, 100, 2, 'mountain', TRUE),
                                                                                         (21, 3,202, 110, 3, 'mountain', FALSE),
                                                                                         (21, 3,203, 120, 4, 'mountain', TRUE),
                                                                                         (21, 3,204, 130, 5, 'mountain', FALSE),
                                                                                         (21, 3,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (22, 3,201, 100, 2, 'mountain', TRUE),
                                                                                         (22, 3,202, 110, 3, 'mountain', FALSE),
                                                                                         (22, 3,203, 120, 4, 'mountain', TRUE),
                                                                                         (22, 3,204, 130, 5, 'mountain', FALSE),
                                                                                         (22, 3,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (23, 3,201, 100, 2, 'mountain', TRUE),
                                                                                         (23, 3,202, 110, 3, 'mountain', FALSE),
                                                                                         (23, 3,203, 120, 4, 'mountain', TRUE),
                                                                                         (23, 3,204, 130, 5, 'mountain', FALSE),
                                                                                         (23, 3,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (24, 3,201, 100, 2, 'mountain', TRUE),
                                                                                         (24, 3,202, 110, 3, 'mountain', FALSE),
                                                                                         (24, 3,203, 120, 4, 'mountain', TRUE),
                                                                                         (24, 3,204, 130, 5, 'mountain', FALSE),
                                                                                         (24, 3,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (25, 4,201, 100, 2, 'mountain', TRUE),
                                                                                         (25, 4,202, 110, 3, 'mountain', FALSE),
                                                                                         (25, 4,203, 120, 4, 'mountain', TRUE),
                                                                                         (25, 4,204, 130, 5, 'mountain', FALSE),
                                                                                         (25, 4,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (26, 4,201, 100, 2, 'mountain', TRUE),
                                                                                         (26, 4,202, 110, 3, 'mountain', FALSE),
                                                                                         (26, 4,203, 120, 4, 'mountain', TRUE),
                                                                                         (26, 4,204, 130, 5, 'mountain', FALSE),
                                                                                         (26, 4,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (27, 4,201, 100, 2, 'mountain', TRUE),
                                                                                         (27, 4,202, 110, 3, 'mountain', FALSE),
                                                                                         (27, 4,203, 120, 4, 'mountain', TRUE),
                                                                                         (27, 4,204, 130, 5, 'mountain', FALSE),
                                                                                         (27, 4,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (28, 4,201, 100, 2, 'mountain', TRUE),
                                                                                         (28, 4,202, 110, 3, 'mountain', FALSE),
                                                                                         (28, 4,203, 120, 4, 'mountain', TRUE),
                                                                                         (28, 4,204, 130, 5, 'mountain', FALSE),
                                                                                         (28, 4,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (29, 4,201, 100, 2, 'mountain', TRUE),
                                                                                         (29, 4,202, 110, 3, 'mountain', FALSE),
                                                                                         (29, 4,203, 120, 4, 'mountain', TRUE),
                                                                                         (29, 4,204, 130, 5, 'mountain', FALSE),
                                                                                         (29, 4,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (30, 4,201, 100, 2, 'mountain', TRUE),
                                                                                         (30, 4,202, 110, 3, 'mountain', FALSE),
                                                                                         (30, 4,203, 120, 4, 'mountain', TRUE),
                                                                                         (30, 4,204, 130, 5, 'mountain', FALSE),
                                                                                         (30, 4,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (31, 4,201, 100, 2, 'mountain', TRUE),
                                                                                         (31, 4,202, 110, 3, 'mountain', FALSE),
                                                                                         (31, 4,203, 120, 4, 'mountain', TRUE),
                                                                                         (31, 4,204, 130, 5, 'mountain', FALSE),
                                                                                         (31, 4,205, 140, 6, 'mountain', TRUE),

                                                                                         -- Hotel 2
                                                                                         (32, 4,201, 100, 2, 'mountain', TRUE),
                                                                                         (32, 4,202, 110, 3, 'mountain', FALSE),
                                                                                         (32, 4,203, 120, 4, 'mountain', TRUE),
                                                                                         (32, 4,204, 130, 5, 'mountain', FALSE),
                                                                                         (32, 4,205, 140, 6, 'mountain', TRUE),
                                                                                         -- Hotel 2
                                                                                         (33, 5,201, 100, 2, 'mountain', TRUE),
                                                                                         (33, 5,202, 110, 3, 'mountain', FALSE),
                                                                                         (33, 5,203, 120, 4, 'mountain', TRUE),
                                                                                         (33, 5,204, 130, 5, 'mountain', FALSE),
                                                                                         (33, 5,205, 140, 6, 'mountain', TRUE),

                                                                                         -- Hotel 2
                                                                                         (34, 5,201, 100, 2, 'mountain', TRUE),
                                                                                         (34, 5,202, 110, 3, 'mountain', FALSE),
                                                                                         (34, 5,203, 120, 4, 'mountain', TRUE),
                                                                                         (34, 5,204, 130, 5, 'mountain', FALSE),
                                                                                         (34, 5,205, 140, 6, 'mountain', TRUE),

                                                                                         -- Hotel 2
                                                                                         (35, 5,201, 100, 2, 'mountain', TRUE),
                                                                                         (35, 5,202, 110, 3, 'mountain', FALSE),
                                                                                         (35, 5,203, 120, 4, 'mountain', TRUE),
                                                                                         (35, 5,204, 130, 5, 'mountain', FALSE),
                                                                                         (35, 5,205, 140, 6, 'mountain', TRUE),

                                                                                         -- Hotel 2
                                                                                         (36, 5,201, 100, 2, 'mountain', TRUE),
                                                                                         (36, 5,202, 110, 3, 'mountain', FALSE),
                                                                                         (36, 5,203, 120, 4, 'mountain', TRUE),
                                                                                         (36, 5,204, 130, 5, 'mountain', FALSE),
                                                                                         (36, 5,205, 140, 6, 'mountain', TRUE),

                                                                                         -- Hotel 2
                                                                                         (37, 5,201, 100, 2, 'mountain', TRUE),
                                                                                         (37, 5,202, 110, 3, 'mountain', FALSE),
                                                                                         (37, 5,203, 120, 4, 'mountain', TRUE),
                                                                                         (37, 5,204, 130, 5, 'mountain', FALSE),
                                                                                         (37, 5,205, 140, 6, 'mountain', TRUE),

                                                                                         -- Hotel 2
                                                                                         (38, 5,201, 100, 2, 'mountain', TRUE),
                                                                                         (38, 5,202, 110, 3, 'mountain', FALSE),
                                                                                         (38, 5,203, 120, 4, 'mountain', TRUE),
                                                                                         (38, 5,204, 130, 5, 'mountain', FALSE),
                                                                                         (38, 5,205, 140, 6, 'mountain', TRUE),

                                                                                         -- Hotel 2
                                                                                         (39, 5,201, 100, 2, 'mountain', TRUE),
                                                                                         (39, 5,202, 110, 3, 'mountain', FALSE),
                                                                                         (39, 5,203, 120, 4, 'mountain', TRUE),
                                                                                         (39, 5,204, 130, 5, 'mountain', FALSE),
                                                                                         (39, 5,205, 140, 6, 'mountain', TRUE),

                                                                                         -- Hotel 2
                                                                                         (40, 5,201, 100, 2, 'mountain', TRUE),
                                                                                         (40, 5,202, 110, 3, 'mountain', FALSE),
                                                                                         (40, 5,203, 120, 4, 'mountain', TRUE),
                                                                                         (40, 5,204, 130, 5, 'mountain', FALSE),
                                                                                         (40, 5,205, 140, 6, 'mountain', TRUE);




INSERT INTO RoomAmenities(Hotel_ID, RoomNumber, Amenity) VALUES
                                                             (1, 101, 'pool'),
                                                             (1, 101, 'coffee'),
                                                             (1, 102, 'sauna'),
                                                             (1, 102, 'breakfast'),
                                                             (1, 103, 'parking'),
                                                             (1, 103, 'pool'),
                                                             (1, 103, 'coffee'),
                                                             (1, 103, 'sauna'),
                                                             (1, 104, 'breakfast'),
                                                             (1, 104, 'parking'),
                                                             (1, 105, 'pool'),
                                                             (1, 105, 'coffee'),
                                                             (2, 201, 'sauna'),
                                                             (2, 201, 'breakfast'),
                                                             (2, 201, 'parking');
INSERT INTO RoomIssues(Hotel_ID, RoomNumber, Issue) VALUES
                                                        (1, 101, 'Slow Wifi'),
                                                        (1, 101, 'Noisy Neighbours'),
                                                        (1, 102, 'Bad Breakfast'),
                                                        (1, 102, 'Slow Wifi'),
                                                        (1, 103, 'Bad Breakfast'),
                                                        (1, 103, 'Noisy Neighbours'),
                                                        (1, 103, 'Slow Wifi'),
                                                        (1, 103, 'Lack of Supply'),
                                                        (1, 104, 'Bad Breakfast'),
                                                        (1, 104, 'Slow Wifi'),
                                                        (1, 105, 'Lack of Supply'),
                                                        (1, 105, 'Slow Wifi'),
                                                        (2, 201, 'Noisy Neighbours'),
                                                        (2, 201, 'Lack of Supply'),

                                                        (2, 201, 'Bad Breakfast'),

                                                        (4, 201, 'Slow Wifi'),
                                                        (4, 201, 'Noisy Neighbours'),
                                                        (4, 201, 'Lack of Supply'),
                                                        (5, 205, 'Slow Wifi'),
                                                        (5, 201, 'Noisy Neighbours'),
                                                        (5, 201, 'Lack of Supply');

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
-- =========================
-- PREVENT DUPLICATE MANAGERS PER HOTEL
-- =========================
CREATE OR REPLACE FUNCTION prevent_duplicate_manager()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Role = 'manager' THEN
        IF EXISTS (
            SELECT 1 FROM Employee
            WHERE Hotel_ID = NEW.Hotel_ID
            AND Role = 'manager'
            AND SSN != NEW.SSN
        ) THEN
            RAISE EXCEPTION 'Hotel % already has a manager!', NEW.Hotel_ID;
END IF;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER manager_per_hotel_trigger
    BEFORE INSERT OR UPDATE ON Employee
                         FOR EACH ROW
                         EXECUTE FUNCTION prevent_duplicate_manager();
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

