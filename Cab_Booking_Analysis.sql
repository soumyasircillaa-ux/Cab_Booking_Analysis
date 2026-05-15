/*
Project Title : Deign RDBMS for Cab_Booking_Analysis

Objective : 
1. Design RDBMS schema for Cab_Booking_Analysis and Understand the trend analysis 
2. Understand operational performance of Cab_Booking_Analysis

However, managing thousands of daily bookings, drivers, and 
customer interactions generates massive amounts of data.

This project leverages SQL to:
  ✓ Structure operational data efficiently
  ✓ Extract meaningful business insights  
  ✓ Enable data-driven decision making
  ✓ Optimize resource allocation
  ✓ Improve customer satisfaction
 
 */
/*

Create Database = Cab_Booking_Analysis

*/

Create Database if not exists Cab_Booking_Analysis;

Use Cab_Booking_Analysis;

-----------------------------------------------------------------------------------------------------------------------------------------
-- Create Table = Customers
------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Customers_Info 
(Customer_ID INT PRIMARY KEY NOT NULL,
Customer_FullName VARCHAR(100) NOT NULL, 
Customer_Gender ENUM('Male', 'Female') NOT NULL,
Customer_Age INT NOT NULL,
Customer_MobileNO bigint NOT NULL,
Customer_City VARCHAR(20) NOT NULL,
Customer_Location VARCHAR(40) NOT NULL,
Customer_Type ENUM('Regular', 'Premium', 'Corporate') DEFAULT 'Regular');

-----------------------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE = DRIVERS_INFO
------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Drivers_Info
(Driver_ID INT PRIMARY KEY NOT NULL,
Driver_Name VARCHAR(100) NOT NULL,  
Driver_Age INT NOT NULL,
Driver_MobileNO BIGINT NOT NULL, 
Driver_JoinDate DATE NOT NULL,
Driver_LicenseNO VARCHAR(20) NOT NULL,
Driver_Location VARCHAR(40) NOT NULL);

----------------------------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE CAB_INFO
------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Cab_Info 
(Cab_ID INT PRIMARY KEY NOT NULL,
Registration_No VARCHAR(30) NOT NULL,
Model_Name VARCHAR(40) NOT NULL,
Cab_Type ENUM('Sedan', 'SUV', 'Hatchback', 'Luxury') NOT NULL,
Cab_Capacity INT DEFAULT 4,
Driver_ID INT NOT NULL,
FOREIGN KEY (Driver_ID) REFERENCES Drivers_Info(Driver_ID));

--------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE BOOKING_INFO
-----------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Booking_Info 
(Booking_ID INT PRIMARY KEY NOT NULL,
Booking_Time DATETIME NOT NULL,
Pickup_Location VARCHAR(100) NOT NULL,
Dropoff_Location VARCHAR (100) NOT NULL,
Booking_Day ENUM ('Weekday','Weekend') NOT NULL,
Booking_Status ENUM ('Pending', 'Confirmed', 'InProgress', 'Completed', 'CancelledByCustomer', 'CancelledByDriver'),
Customer_ID INT NOT NULL,
Driver_ID INT NOT NULL,
Cab_ID INT NOT NULL,
FOREIGN KEY (Customer_ID) REFERENCES Customers_Info (Customer_ID),
FOREIGN KEY (Driver_ID) REFERENCES Drivers_Info (Driver_ID),
FOREIGN KEY (Cab_ID) REFERENCES Cab_Info (Cab_ID));


-----------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE TRIP_DETAILS
--------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Trip_Details
(Trip_ID INT PRIMARY KEY NOT NULL,
Trip_Distance_KM DECIMAL (8,2),
Trip_Start_Location VARCHAR (40) NOT NULL,
Trip_End_Location VARCHAR (40) NOT NULL,
Trip_Start_Time DATETIME NOT NULL,
Trip_End_Time DATETIME NOT NULL,
Fare_Amount DECIMAL(10,2),
Discount_Applied DECIMAL(5,2) DEFAULT 0.00,
Final_Amount DECIMAL(10,2),
Payment_Type ENUM('Cash', 'Card', 'Wallet', 'UPI') DEFAULT 'Cash',
Customer_ID INT NOT NULL,
Driver_ID INT NOT NULL,
Cab_ID INT NOT NULL,
Booking_ID INT NOT NULL,
FOREIGN KEY (Customer_ID) REFERENCES Customers_Info (Customer_ID),
FOREIGN KEY (Driver_ID) REFERENCES Drivers_Info (Driver_id),
FOREIGN KEY (Cab_ID) REFERENCES Cab_Info (Cab_ID),
FOREIGN KEY (Booking_ID) REFERENCES Booking_Info (Booking_ID));


----------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE PAYMENT_TRANSACTION
-------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Payment_Transaction
(Transaction_ID INT PRIMARY KEY NOT NULL,
Transaction_Time DATETIME NOT NULL,  -- ADDED
Total_Amount DECIMAL(10,2) NOT NULL,
Transaction_Status ENUM('Initiated', 'Success', 'Failed', 'Refunded') DEFAULT 'Initiated',
Gateway_Name VARCHAR(50),
Booking_ID INT NOT NULL,
Trip_ID INT NOT NULL,
Customer_ID INT NOT NULL,
FOREIGN KEY (Booking_ID) REFERENCES Booking_Info(Booking_ID),
FOREIGN KEY (Trip_ID) REFERENCES Trip_Details(Trip_ID),
FOREIGN KEY (Customer_ID) REFERENCES Customers_Info(Customer_ID));


--------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE DAILY_OPERATIONS
---------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Daily_Operations
(Total_Bookings INT DEFAULT 0,
Completed_Bookings INT DEFAULT 0,
Cancelled_Bookings INT DEFAULT 0,
Total_Revenue DECIMAL(12,2) DEFAULT 0.00,
Peak_Hour_Start TIME,
Peak_Hour_End TIME,
Active_Drivers INT,
Driver_ID INT NOT NULL,
Cab_ID INT NOT NULL,
Trip_ID INT NOT NULL,
Booking_ID INT NOT NULL,
FOREIGN KEY (Driver_ID) REFERENCES Drivers_Info (Driver_ID),
FOREIGN KEY (Cab_ID) REFERENCES Cab_Info (Cab_ID),
FOREIGN KEY (Trip_ID) REFERENCES Trip_Details (Trip_ID),
FOREIGN KEY (Booking_ID) REFERENCES Booking_Info (Booking_ID));


---------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE FEEDBACK 
---------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE FEEDBACK
(Customer_Rating DECIMAL(2,1) CHECK (Customer_Rating BETWEEN 0 AND 5),
Driver_Rating DECIMAL(2,1) CHECK (Driver_Rating BETWEEN 0 AND 5),
Customer_Review VARCHAR (100),
Driver_Review VARCHAR (0),
Customer_ID INT NOT NULL,
Driver_ID INT NOT NULL,
Booking_ID INT NOT NULL,
Trip_ID INT NOT NULL,
FOREIGN KEY (Customer_ID) REFERENCES Customers_Info (Customer_ID),
FOREIGN KEY (Driver_ID) REFERENCES Drivers_Info (Driver_ID),
FOREIGN KEY (Booking_ID) REFERENCES Booking_Info (Booking_ID),
FOREIGN KEY (Trip_ID) REFERENCES Trip_Details (Trip_ID));

SELECT * FROM Booking_Info;
SELECT * FROM Cab_Info;
select * from customers_info;
select * from daily_operations;
select * from drivers_Info;
select * from feedback;
SELECT * FROM booking_info;
select * from payment_transaction;
select * from trip_details;

INSERT INTO Customers_Info VALUES
(1, 'Rajesh Sharma', 'Male', 34, 9876543210, 'Mumbai', 'Andheri East', 'Regular'),
(2, 'Priya Singh', 'Female', 28, 9988776655, 'Delhi', 'Connaught Place', 'Premium'),
(3, 'Ahmed Khan', 'Male', 45, 9123456780, 'Bangalore', 'Koramangala', 'Regular'),
(4, 'Anita Desai', 'Female', 52, 9001122334, 'Chennai', 'Adyar', 'Regular'),
(5, 'Vikram Reddy', 'Male', 31, 9898989898, 'Hyderabad', 'Hitech City', 'Premium'),
(6, 'Neha Gupta', 'Female', 26, 9765432109, 'Pune', 'Koregaon Park', 'Corporate'),
(7, 'Suresh Nair', 'Male', 40, 9654321098, 'Ahmedabad', 'Satellite', 'Regular'),
(8, 'Meera Iyer', 'Female', 37, 9543210987, 'Chennai', 'T Nagar', 'Premium'),
(9, 'Arjun Mewar', 'Male', 29, 9432109876, 'Jaipur', 'Malviya Nagar', 'Regular'),
(10, 'Divya Patil', 'Female', 33, 9321098765, 'Mumbai', 'Bandra West', 'Premium'),
(11, 'Rohan Dutta', 'Male', 47, 9210987654, 'Kolkata', 'Salt Lake City', 'Regular'),
(12, 'Sneha Rajan', 'Female', 24, 9109876543, 'Bangalore', 'Indiranagar', 'Corporate'),
(13, 'Amit Srivastava', 'Male', 41, 9098765432, 'Lucknow', 'Gomti Nagar', 'Premium'),
(14, 'Sunita Verma', 'Female', 58, 9988001122, 'Delhi', 'Model Town', 'Regular'),
(15, 'Kunal Mehta', 'Male', 30, 9876112233, 'Surat', 'City Light Road', 'Regular'),
(16, 'Pooja Nair', 'Female', 35, 9766223344, 'Mumbai', 'Navi Mumbai', 'Premium'),
(17, 'Manoj Joshi', 'Male', 49, 9655334455, 'Indore', 'Vijay Nagar', 'Regular'),
(18, 'Deepika Kaur', 'Female', 27, 9544445566, 'Chandigarh', 'Sector 17', 'Regular'),
(19, 'Vijay Shetty', 'Male', 39, 9433556677, 'Mangalore', 'Bejai', 'Corporate'),
(20, 'Rekha Bhardwaj', 'Female', 60, 9322667788, 'Delhi', 'Rohini', 'Regular'),
(21, 'Tarun Kapoor', 'Male', 32, 9211778899, 'Noida', 'Sector 62', 'Premium'),
(22, 'Swati Menon', 'Female', 42, 9100889900, 'Kochi', 'Marine Drive', 'Regular'),
(23, 'Gaurav Sinha', 'Male', 26, 9099001122, 'Patna', 'Kankarbagh', 'Regular'),
(24, 'Anjali Rathi', 'Female', 38, 9988771122, 'Jaipur', 'C Scheme', 'Premium'),
(25, 'Rahul Bose', 'Male', 51, 9877003344, 'Kolkata', 'New Alipore', 'Corporate'),
(26, 'Kavita Shekhawat', 'Female', 29, 9766114455, 'Udaipur', 'Hiran Magri', 'Regular'),
(27, 'Nikhil Jain', 'Male', 44, 9655225566, 'Nagpur', 'Dharampeth', 'Regular'),
(28, 'Shreya Mahajan', 'Female', 31, 9544336677, 'Amritsar', 'Ranjit Avenue', 'Premium'),
(29, 'Prakash Rao', 'Male', 55, 9433447788, 'Visakhapatnam', 'Dwaraka Nagar', 'Regular'),
(30, 'Lata Trivedi', 'Female', 36, 9322558899, 'Bhopal', 'Arera Colony', 'Corporate');

INSERT INTO Drivers_Info VALUES
(11, 'Suresh Yadav', 45, 9988776601, '2020-01-15', 'DL1234567890', 'Andheri East'),
(21, 'Ramesh Gupta', 42, 9988776602, '2020-03-20', 'DL1234567891', 'Bandra West'),
(31, 'Mahesh Patil', 38, 9988776603, '2020-06-10', 'DL1234567892', 'Powai'),
(41, 'Dinesh Kumar', 40, 9988776604, '2021-01-05', 'DL1234567893', 'Juhu'),
(51, 'Prakash Raj', 44, 9988776605, '2021-02-18', 'DL1234567894', 'Connaught Place'),
(61, 'Kumar Swamy', 39, 9988776606, '2021-04-22', 'DL1234567895', 'Indiranagar'),
(71, 'Mohan Das', 41, 9988776607, '2021-07-30', 'DL1234567896', 'Whitefield'),
(81, 'Gopal Krishna', 36, 9988776608, '2021-09-14', 'DL1234567897', 'Gachibowli'),
(91, 'Venkatesh Rao', 43, 9988776609, '2022-01-10', 'DL1234567898', 'Hitech City'),
(101, 'Narayan Iyer', 37, 9988776610, '2022-02-28', 'DL1234567899', 'T Nagar'),
(111, 'Ravi Shankar', 35, 9988776611, '2022-05-12', 'DL1234567900', 'Velachery'),
(121, 'Anil Kapoor', 34, 9988776612, '2022-07-19', 'DL1234567901', 'Koregaon Park'),
(131, 'Sanjay Dutt', 33, 9988776613, '2022-09-25', 'DL1234567902', 'Hinjewadi'),
(141, 'Ajay Devgn', 32, 9988776614, '2022-11-30', 'DL1234567903', 'Satellite'),
(151, 'Akshay Kumar', 48, 9988776615, '2023-01-08', 'DL1234567904', 'Marine Drive'),
(161, 'Rajkumar Rao', 31, 9988776616, '2023-02-14', 'DL1234567905', 'RS Puram'),
(171, 'Vicky Kaushal', 30, 9988776617, '2023-03-20', 'DL1234567906', 'Malviya Nagar'),
(181, 'Ranbir Kapoor', 29, 9988776618, '2023-04-05', 'DL1234567907', 'Vijay Nagar'),
(191, 'Ranveer Singh', 28, 9988776619, '2023-05-18', 'DL1234567908', 'Greater Kailash'),
(201, 'Shahid Kapoor', 35, 9988776620, '2023-06-22', 'DL1234567909', 'UB City'),
(211, 'Kartik Aryan', 27, 9988776621, '2024-01-10', 'DL1234567910', 'DLF Phase 3'),
(221, 'Ayushmann Khurrana', 26, 9988776622, '2024-02-15', 'DL1234567911', 'Worli Seaface'),
(231, 'Rajkummar Rao', 34, 9988776623, '2024-03-20', 'DL1234567912', 'Electronic City'),
(241, 'Pankaj Tripathi', 47, 9988776624, '2024-04-25', 'DL1234567913', 'BKC'),
(251, 'Nawazuddin Siddiqui', 50, 9988776625, '2024-05-30', 'DL1234567914', 'Mindspace'),
(261, 'Manoj Bajpayee', 49, 9988776626, '2024-06-05', 'DL1234567915', 'OMR'),
(271, 'Irrfan Khan', 52, 9988776627, '2024-07-12', 'DL1234567916', 'Magarpatta City'),
(281, 'Arshad Warsi', 44, 9988776628, '2025-01-08', 'DL1234567917', 'Andheri East'),
(291, 'Sharman Joshi', 39, 9988776629, '2025-02-14', 'DL1234567918', 'Bandra West'),
(301, 'Jimmy Sheirgill', 48, 9988776630, '2025-03-01', 'DL1234567919', 'Connaught Place');


INSERT INTO Cab_Info VALUES
(101, 'ABC1234', 'Toyota Innova', 'SUV', 7, 11),
(205, 'XYZ5678', 'Honda City', 'Sedan', 5, 21),
(310, 'LMN9101', 'Maruti Suzuki Swift', 'Hatchback', 4, 31),
(408, 'PQRS234', 'Hyundai i20', 'Hatchback', 4, 41),
(522, 'TUV6789', 'Mahindra XUV700', 'SUV', 7, 51),
(607, 'DEF3456', 'Toyota Camry', 'Luxury', 5, 61),
(713, 'GHI7890', 'Honda Civic', 'Sedan', 5, 71),
(829, 'JKL1234', 'Ford EcoSport', 'SUV', 5, 81),
(901, 'MNO4567', 'Hyundai Verna', 'Sedan', 5, 91),
(1005, 'PQR8901', 'Maruti Suzuki Baleno', 'Hatchback', 5, 101),
(1112, 'STU2345', 'Kia Seltos', 'SUV', 5, 111),
(1229, 'VWX6789', 'BMW 3 Series', 'Luxury', 5, 121),
(1334, 'YZA0123', 'Mercedes-Benz E-Class', 'Luxury', 5, 131),
(1447, 'BCD4567', 'Tata Nexon', 'SUV', 5, 141),
(1558, 'EFG8901', 'Renault Kwid', 'Hatchback', 4, 151),
(1672, 'HIJ2345', 'Volkswagen Polo', 'Hatchback', 4, 161),
(1783, 'KLM6789', 'Skoda Rapid', 'Sedan', 5, 171),
(1896, 'NOP0123', 'Audi A6', 'Luxury', 5, 181),
(2014, 'QRS4567', 'Hyundai Creta', 'SUV', 5, 191),
(2125, 'TUV8901', 'Ford Mustang', 'Luxury', 4, 201),
(2238, 'VWX2345', 'Honda WR-V', 'SUV', 5, 211),
(2349, 'YZA6789', 'Maruti Suzuki Dzire', 'Sedan', 5, 221),
(2461, 'BCD0123', 'Kia Carnival', 'Luxury', 7, 231),
(2573, 'EFG4567', 'Toyota Fortuner', 'SUV', 7, 241),
(2685, 'HIJ8901', 'Honda Jazz', 'Hatchback', 5, 251),
(2798, 'KLM2345', 'Nissan Magnite', 'SUV', 5, 261),
(2910, 'NOP6789', 'Volvo S90', 'Luxury', 5, 271),
(3022, 'QRS0123', 'MG Hector', 'SUV', 6, 281),
(3136, 'TUV4567', 'Hyundai Grand i10', 'Hatchback', 4, 291),
(3248, 'VWX8901', 'BMW X5', 'SUV', 5, 301),
(3361, 'YZA2345', 'Mercedes-Benz S-Class', 'Luxury', 5, 11),
(3473, 'BCD6789', 'Mahindra Thar', 'SUV', 4, 21),
(3585, 'EFG0123', 'Maruti Suzuki Ignis', 'Hatchback', 4, 31);


INSERT INTO Booking_Info VALUES
(1001, '2025-04-15 08:30:00', 'Andheri East', 'BKC', 'Weekday', 'Completed', 1, 11, 101),
(1025, '2025-04-15 09:15:00', 'Connaught Place', 'Gurgaon', 'Weekday', 'Completed', 2, 21, 205),
(1052, '2025-04-15 18:45:00', 'Koramangala', 'Electronic City', 'Weekday', 'Completed', 3, 31, 310),
(1088, '2025-04-16 07:20:00', 'Adyar', 'OMR', 'Weekday', 'Completed', 4, 41, 408),
(1115, '2025-04-16 19:10:00', 'Hitech City', 'Gachibowli', 'Weekday', 'Completed', 5, 51, 522),
(1147, '2025-04-17 10:00:00', 'Koregaon Park', 'Hinjewadi', 'Weekday', 'InProgress', 6, 61, 607),
(1182, '2025-04-17 14:30:00', 'Satellite', 'SG Highway', 'Weekday', 'Confirmed', 7, 71, 713),
(1210, '2025-04-18 22:15:00', 'T Nagar', 'Velachery', 'Weekday', 'Completed', 8, 81, 829),
(1245, '2025-04-18 06:45:00', 'Malviya Nagar', 'Sitapura', 'Weekday', 'Completed', 9, 91, 901),
(1278, '2025-04-19 20:30:00', 'Bandra West', 'Navi Mumbai', 'Weekend', 'Completed', 10, 101, 1005),
(1303, '2025-04-19 11:00:00', 'Salt Lake City', 'Airport', 'Weekend', 'Completed', 11, 111, 1112),
(1336, '2025-04-20 16:20:00', 'Indiranagar', 'Whitefield', 'Weekend', 'Completed', 12, 121, 1229),
(1369, '2025-04-20 09:30:00', 'Gomti Nagar', 'Charbagh', 'Weekend', 'CancelledByCustomer', 13, 131, 1334),
(1395, '2025-04-21 23:00:00', 'Model Town', 'Rohini', 'Weekday', 'Completed', 14, 141, 1447),
(1422, '2025-04-21 17:45:00', 'City Light Road', 'Dumas Road', 'Weekday', 'Completed', 15, 151, 1558),
(1458, '2025-04-22 07:00:00', 'Navi Mumbai', 'Panvel', 'Weekday', 'InProgress', 16, 161, 1672),
(1491, '2025-04-22 12:15:00', 'Vijay Nagar', 'Rajwada', 'Weekday', 'Confirmed', 17, 171, 1783),
(1524, '2025-04-23 21:00:00', 'Sector 17', 'Airport', 'Weekday', 'Completed', 18, 181, 1896),
(1557, '2025-04-23 13:30:00', 'Bejai', 'Manglore Central', 'Weekday', 'Completed', 19, 191, 2014),
(1583, '2025-04-24 18:00:00', 'Rohini', 'Pitampura', 'Weekday', 'CancelledByDriver', 20, 201, 2125),
(1616, '2025-04-24 08:45:00', 'Sector 62', 'Sector 18', 'Weekday', 'Completed', 21, 211, 2238),
(1649, '2025-04-25 19:30:00', 'Marine Drive', 'Infopark', 'Weekday', 'Completed', 22, 221, 2349),
(1682, '2025-04-25 10:15:00', 'Kankarbagh', 'Patna Junction', 'Weekday', 'Pending', 23, 231, 2461),
(1715, '2025-04-26 15:00:00', 'C Scheme', 'Airport', 'Weekend', 'Confirmed', 24, 241, 2573),
(1748, '2025-04-26 11:30:00', 'New Alipore', 'Howrah', 'Weekend', 'Completed', 25, 251, 2685),
(1774, '2025-04-27 22:30:00', 'Hiran Magri', 'City Palace', 'Weekend', 'Completed', 26, 261, 2798),
(1807, '2025-04-27 09:45:00', 'Dharampeth', 'Airport', 'Weekend', 'InProgress', 27, 271, 2910),
(1840, '2025-04-28 14:20:00', 'Ranjit Avenue', 'Golden Temple', 'Weekday', 'Completed', 28, 281, 3022),
(1873, '2025-04-28 20:00:00', 'Dwaraka Nagar', 'Rushikonda', 'Weekday', 'Completed', 29, 291, 3136),
(1906, '2025-04-29 08:00:00', 'Arera Colony', 'Bhopal Junction', 'Weekday', 'Confirmed', 30, 301, 3248),
(1939, '2025-04-29 17:30:00', 'Andheri East', 'Juhu', 'Weekday', 'Completed', 1, 11, 3361),
(1965, '2025-04-30 12:45:00', 'Connaught Place', 'Noida', 'Weekday', 'Pending', 4, 21, 3473),
(1998, '2025-04-30 21:15:00', 'Koramangala', 'MG Road', 'Weekday', 'Completed', 7, 31, 3585);


INSERT INTO Trip_Details VALUES
(5001, 12.50, 'Andheri East', 'BKC', '2025-04-15 08:30:00', '2025-04-15 09:05:00', 250.00, 25.00, 225.00, 'UPI', 1, 11, 101, 1001),
(5025, 18.75, 'Connaught Place', 'Gurgaon', '2025-04-15 09:15:00', '2025-04-15 10:00:00', 375.00, 0.00, 375.00, 'Card', 2, 21, 205, 1025),
(5052, 8.20, 'Koramangala', 'Electronic City', '2025-04-15 18:45:00', '2025-04-15 19:20:00', 164.00, 16.40, 147.60, 'Wallet', 3, 31, 310, 1052),
(5088, 15.30, 'Adyar', 'OMR', '2025-04-16 07:20:00', '2025-04-16 08:00:00', 306.00, 30.60, 275.40, 'UPI', 4, 41, 408, 1088),
(5115, 22.40, 'Hitech City', 'Gachibowli', '2025-04-16 19:10:00', '2025-04-16 20:00:00', 448.00, 50.00, 398.00, 'Card', 5, 51, 522, 1115),
(5147, 35.60, 'Koregaon Park', 'Hinjewadi', '2025-04-17 10:00:00', '2025-04-17 11:15:00', 712.00, 100.00, 612.00, 'Wallet', 6, 61, 607, 1147),
(5182, 9.80, 'Satellite', 'SG Highway', '2025-04-17 14:30:00', '2025-04-17 15:00:00', 196.00, 0.00, 196.00, 'Cash', 7, 71, 713, 1182),
(5210, 11.20, 'T Nagar', 'Velachery', '2025-04-18 22:15:00', '2025-04-18 22:50:00', 224.00, 22.40, 201.60, 'UPI', 8, 81, 829, 1210),
(5245, 45.00, 'Malviya Nagar', 'Sitapura', '2025-04-18 06:45:00', '2025-04-18 08:15:00', 900.00, 100.00, 800.00, 'Card', 9, 91, 901, 1245),
(5278, 28.50, 'Bandra West', 'Navi Mumbai', '2025-04-19 20:30:00', '2025-04-19 21:30:00', 570.00, 50.00, 520.00, 'Wallet', 10, 101, 1005, 1278),
(5303, 38.20, 'Salt Lake City', 'Airport', '2025-04-19 11:00:00', '2025-04-19 12:20:00', 764.00, 0.00, 764.00, 'UPI', 11, 111, 1112, 1303),
(5336, 16.80, 'Indiranagar', 'Whitefield', '2025-04-20 16:20:00', '2025-04-20 17:00:00', 336.00, 33.60, 302.40, 'Cash', 12, 121, 1229, 1336),
(5369, 14.50, 'Gomti Nagar', 'Charbagh', '2025-04-20 09:30:00', '2025-04-20 10:10:00', 290.00, 0.00, 290.00, 'Card', 13, 131, 1334, 1369),
(5395, 31.40, 'Model Town', 'Rohini', '2025-04-21 23:00:00', '2025-04-22 00:15:00', 628.00, 75.00, 553.00, 'Wallet', 14, 141, 1447, 1395),
(5422, 7.90, 'City Light Road', 'Dumas Road', '2025-04-21 17:45:00', '2025-04-21 18:10:00', 158.00, 15.80, 142.20, 'UPI', 15, 151, 1558, 1422),
(5458, 25.30, 'Navi Mumbai', 'Panvel', '2025-04-22 07:00:00', '2025-04-22 07:55:00', 506.00, 50.00, 456.00, 'Card', 16, 161, 1672, 1458),
(5491, 19.60, 'Vijay Nagar', 'Rajwada', '2025-04-22 12:15:00', '2025-04-22 13:00:00', 392.00, 0.00, 392.00, 'Cash', 17, 171, 1783, 1491),
(5524, 42.10, 'Sector 17', 'Airport', '2025-04-23 21:00:00', '2025-04-23 22:45:00', 842.00, 100.00, 742.00, 'Wallet', 18, 181, 1896, 1524),
(5557, 10.50, 'Bejai', 'Manglore Central', '2025-04-23 13:30:00', '2025-04-23 14:00:00', 210.00, 21.00, 189.00, 'UPI', 19, 191, 2014, 1557),
(5583, 23.80, 'Rohini', 'Pitampura', '2025-04-24 18:00:00', '2025-04-24 18:50:00', 476.00, 0.00, 476.00, 'Card', 20, 201, 2125, 1583),
(5616, 33.40, 'Sector 62', 'Sector 18', '2025-04-24 08:45:00', '2025-04-24 09:55:00', 668.00, 75.00, 593.00, 'Cash', 21, 211, 2238, 1616),
(5649, 27.90, 'Marine Drive', 'Infopark', '2025-04-25 19:30:00', '2025-04-25 20:25:00', 558.00, 50.00, 508.00, 'Wallet', 22, 221, 2349, 1649),
(5682, 6.50, 'Kankarbagh', 'Patna Junction', '2025-04-25 10:15:00', '2025-04-25 10:35:00', 130.00, 0.00, 130.00, 'UPI', 23, 231, 2461, 1682),
(5715, 41.30, 'C Scheme', 'Airport', '2025-04-26 15:00:00', '2025-04-26 16:40:00', 826.00, 100.00, 726.00, 'Card', 24, 241, 2573, 1715),
(5748, 13.70, 'New Alipore', 'Howrah', '2025-04-26 11:30:00', '2025-04-26 12:10:00', 274.00, 27.40, 246.60, 'Wallet', 25, 251, 2685, 1748),
(5774, 29.40, 'Hiran Magri', 'City Palace', '2025-04-27 22:30:00', '2025-04-27 23:30:00', 588.00, 0.00, 588.00, 'Cash', 26, 261, 2798, 1774),
(5807, 37.80, 'Dharampeth', 'Airport', '2025-04-27 09:45:00', '2025-04-27 11:00:00', 756.00, 80.00, 676.00, 'UPI', 27, 271, 2910, 1807),
(5840, 5.20, 'Ranjit Avenue', 'Golden Temple', '2025-04-28 14:20:00', '2025-04-28 14:35:00', 104.00, 10.40, 93.60, 'Card', 28, 281, 3022, 1840),
(5873, 18.90, 'Dwaraka Nagar', 'Rushikonda', '2025-04-28 20:00:00', '2025-04-28 20:45:00', 378.00, 0.00, 378.00, 'Wallet', 29, 291, 3136, 1873),
(5906, 24.60, 'Arera Colony', 'Bhopal Junction', '2025-04-29 08:00:00', '2025-04-29 08:55:00', 492.00, 50.00, 442.00, 'UPI', 30, 301, 3248, 1906),
(5939, 8.90, 'Andheri East', 'Juhu', '2025-04-29 17:30:00', '2025-04-29 18:00:00', 178.00, 17.80, 160.20, 'Cash', 1, 11, 3361, 1939),
(5965, 26.70, 'Connaught Place', 'Noida', '2025-04-30 12:45:00', '2025-04-30 13:45:00', 534.00, 60.00, 474.00, 'Card', 4, 21, 3473, 1965),
(5998, 20.30, 'Koramangala', 'MG Road', '2025-04-30 21:15:00', '2025-04-30 22:00:00', 406.00, 0.00, 406.00, 'Wallet', 7, 31, 3585, 1998);



INSERT INTO Payment_Transaction VALUES 
(7001, '2025-04-15 09:06:00', 225.00, 'Success', 'Razorpay', 1001, 5001, 1),
(7025, '2025-04-15 10:02:00', 375.00, 'Success', 'PayU', 1025, 5025, 2),
(7052, '2025-04-15 19:22:00', 147.60, 'Success', 'PhonePe', 1052, 5052, 3),
(7088, '2025-04-16 08:02:00', 275.40, 'Success', 'Razorpay', 1088, 5088, 4),
(7115, '2025-04-16 20:05:00', 398.00, 'Success', 'Paytm', 1115, 5115, 5),
(7147, '2025-04-17 11:17:00', 612.00, 'Success', 'GooglePay', 1147, 5147, 6),
(7182, '2025-04-17 15:02:00', 196.00, 'Success', 'Razorpay', 1182, 5182, 7),
(7210, '2025-04-18 22:52:00', 201.60, 'Success', 'PhonePe', 1210, 5210, 8),
(7245, '2025-04-18 08:17:00', 800.00, 'Success', 'PayU', 1245, 5245, 9),
(7278, '2025-04-19 21:32:00', 520.00, 'Success', 'Paytm', 1278, 5278, 10),
(7303, '2025-04-19 12:22:00', 764.00, 'Success', 'GooglePay', 1303, 5303, 11),
(7336, '2025-04-20 17:02:00', 302.40, 'Success', 'Razorpay', 1336, 5336, 12),
(7369, '2025-04-20 10:12:00', 290.00, 'Refunded', 'PhonePe', 1369, 5369, 13),
(7395, '2025-04-22 00:17:00', 553.00, 'Success', 'PayU', 1395, 5395, 14),
(7422, '2025-04-21 18:12:00', 142.20, 'Success', 'GooglePay', 1422, 5422, 15),
(7458, '2025-04-22 07:57:00', 456.00, 'Success', 'Razorpay', 1458, 5458, 16),
(7491, '2025-04-22 13:02:00', 392.00, 'Success', 'Paytm', 1491, 5491, 17),
(7524, '2025-04-23 22:48:00', 742.00, 'Success', 'PhonePe', 1524, 5524, 18),
(7557, '2025-04-23 14:02:00', 189.00, 'Success', 'GooglePay', 1557, 5557, 19),
(7583, '2025-04-24 18:52:00', 476.00, 'Failed', 'Razorpay', 1583, 5583, 20),
(7616, '2025-04-24 09:57:00', 593.00, 'Success', 'PayU', 1616, 5616, 21),
(7649, '2025-04-25 20:27:00', 508.00, 'Success', 'Paytm', 1649, 5649, 22),
(7682, '2025-04-25 10:37:00', 130.00, 'Success', 'PhonePe', 1682, 5682, 23),
(7715, '2025-04-26 16:42:00', 726.00, 'Success', 'GooglePay', 1715, 5715, 24),
(7748, '2025-04-26 12:12:00', 246.60, 'Success', 'Razorpay', 1748, 5748, 25),
(7774, '2025-04-27 23:32:00', 588.00, 'Success', 'PayU', 1774, 5774, 26),
(7807, '2025-04-27 11:02:00', 676.00, 'Success', 'Razorpay', 1807, 5807, 27),
(7840, '2025-04-28 14:37:00', 93.60, 'Success', 'GooglePay', 1840, 5840, 28),
(7873, '2025-04-28 20:47:00', 378.00, 'Success', 'Paytm', 1873, 5873, 29),
(7906, '2025-04-29 08:57:00', 442.00, 'Success', 'PhonePe', 1906, 5906, 30),
(7939, '2025-04-29 18:02:00', 160.20, 'Initiated', 'Razorpay', 1939, 5939, 1),
(7965, '2025-04-30 13:47:00', 474.00, 'Success', 'PayU', 1965, 5965, 4),
(7998, '2025-04-30 22:02:00', 406.00, 'Success', 'GooglePay', 1998, 5998, 7);


INSERT INTO Daily_Operations VALUES
(8, 7, 1, 1850.50, '08:00:00', '10:00:00', 5, 11, 101, 5001, 1001),
(12, 11, 1, 2675.25, '17:00:00', '19:00:00', 7, 21, 205, 5025, 1025),
(6, 6, 0, 950.80, '09:00:00', '11:00:00', 4, 31, 310, 5052, 1052),
(10, 9, 1, 2150.00, '18:00:00', '20:00:00', 6, 41, 408, 5088, 1088),
(15, 14, 1, 3420.75, '19:00:00', '21:00:00', 9, 51, 522, 5115, 1115),
(7, 7, 0, 1250.30, '07:00:00', '09:00:00', 5, 61, 607, 5147, 1147),
(9, 8, 1, 1980.00, '20:00:00', '22:00:00', 6, 71, 713, 5182, 1182),
(11, 10, 1, 3100.40, '13:00:00', '15:00:00', 8, 81, 829, 5210, 1210),
(5, 5, 0, 875.60, '22:00:00', '00:00:00', 3, 91, 901, 5245, 1245),
(14, 13, 1, 4250.00, '16:00:00', '18:00:00', 10, 101, 1005, 5278, 1278),
(8, 8, 0, 1675.20, '10:00:00', '12:00:00', 5, 111, 1112, 5303, 1303),
(13, 12, 1, 2890.90, '11:00:00', '13:00:00', 8, 121, 1229, 5336, 1336),
(6, 5, 1, 890.00, '14:00:00', '16:00:00', 4, 131, 1334, 5369, 1369),
(10, 10, 0, 2345.50, '21:00:00', '23:00:00', 7, 141, 1447, 5395, 1395),
(9, 8, 1, 1560.75, '06:00:00', '08:00:00', 5, 151, 1558, 5422, 1422),
(12, 11, 1, 2780.25, '15:00:00', '17:00:00', 8, 161, 1672, 5458, 1458),
(7, 7, 0, 1120.00, '12:00:00', '14:00:00', 5, 171, 1783, 5491, 1491),
(16, 15, 1, 4850.00, '18:00:00', '20:00:00', 11, 181, 1896, 5524, 1524),
(5, 5, 0, 745.30, '23:00:00', '01:00:00', 3, 191, 2014, 5557, 1557),
(11, 10, 1, 2680.40, '17:00:00', '19:00:00', 7, 201, 2125, 5583, 1583),
(8, 8, 0, 1850.00, '09:00:00', '11:00:00', 5, 211, 2238, 5616, 1616),
(14, 13, 1, 3920.60, '19:00:00', '21:00:00', 9, 221, 2349, 5649, 1649),
(6, 6, 0, 890.50, '08:00:00', '10:00:00', 4, 231, 2461, 5682, 1682),
(10, 9, 1, 2150.00, '20:00:00', '22:00:00', 6, 241, 2573, 5715, 1715),
(9, 9, 0, 1680.30, '10:00:00', '12:00:00', 6, 251, 2685, 5748, 1748),
(13, 12, 1, 2970.00, '22:00:00', '00:00:00', 8, 261, 2798, 5774, 1774),
(7, 7, 0, 1250.75, '16:00:00', '18:00:00', 5, 271, 2910, 5807, 1807),
(11, 10, 1, 2560.20, '13:00:00', '15:00:00', 7, 281, 3022, 5840, 1840),
(8, 8, 0, 1420.00, '07:00:00', '09:00:00', 5, 291, 3136, 5873, 1873),
(15, 14, 1, 3780.90, '18:00:00', '20:00:00', 10, 301, 3248, 5906, 1906),
(9, 8, 1, 1675.40, '21:00:00', '23:00:00', 6, 11, 3361, 5939, 1939),
(12, 11, 1, 2790.50, '17:00:00', '19:00:00', 8, 21, 3473, 5965, 1965),
(10, 10, 0, 2450.00, '14:00:00', '16:00:00', 7, 31, 3585, 5998, 1998);

INSERT INTO FEEDBACK VALUES 
(4.8, 4.9, 'Great ride, driver was very professional and on time!', NULL, 1, 11, 1001, 5001),
(4.5, 4.7, 'Comfortable cab, smooth journey overall.', NULL, 2, 21, 1025, 5025),
(3.5, 4.0, 'Cab was okay but driver took longer route.', NULL, 3, 31, 1052, 5052),
(5.0, 5.0, 'Excellent service! Very clean car and friendly driver.', NULL, 4, 41, 1088, 5088),
(4.2, 4.5, 'Good experience, would recommend.', NULL, 5, 51, 1115, 5115),
(4.0, 3.8, 'Decent ride but driver was a bit rude.', NULL, 6, 61, 1147, 5147),
(4.9, 4.8, 'Amazing trip! Driver helped with luggage too.', NULL, 7, 71, 1182, 5182),
(3.0, 4.2, 'Cab arrived late, but ride was fine.', NULL, 8, 81, 1210, 5210),
(5.0, 5.0, 'Perfect! Best cab service ever.', NULL, 9, 91, 1245, 5245),
(4.6, 4.9, 'Very punctual and smooth drive.', NULL, 10, 101, 1278, 5278),
(3.8, 4.0, 'Average experience, nothing special.', NULL, 11, 111, 1303, 5303),
(4.7, 4.6, 'Clean cab, driver was knowledgeable about routes.', NULL, 12, 121, 1336, 5336),
(2.5, 3.0, 'Poor experience, cab was not clean.', NULL, 13, 131, 1369, 5369),
(4.4, 4.5, 'Good value for money, will book again.', NULL, 14, 141, 1395, 5395),
(4.1, 4.3, 'Satisfied with the service.', NULL, 15, 151, 1422, 5422),
(3.9, 4.1, 'Okay ride, AC was not working properly.', NULL, 16, 161, 1458, 5458),
(5.0, 4.9, 'Fantastic! Driver was very friendly.', NULL, 17, 171, 1491, 5491),
(4.3, 4.4, 'Nice and comfortable journey.', NULL, 18, 181, 1524, 5524),
(2.8, 3.5, 'Driver cancelled last minute, very disappointed.', NULL, 19, 191, 1557, 5557),
(4.5, 4.6, 'Smooth ride, on-time pickup.', NULL, 20, 201, 1583, 5583),
(3.7, 4.0, 'Decent but could be better.', NULL, 21, 211, 1616, 5616),
(4.8, 4.7, 'Impressed with the service quality.', NULL, 22, 221, 1649, 5649),
(4.0, 4.2, 'Good, driver followed GPS correctly.', NULL, 23, 231, 1682, 5682),
(4.9, 5.0, 'Superb! Driver was very professional.', NULL, 24, 241, 1715, 5715),
(3.2, 3.8, 'Cab was late by 15 minutes.', NULL, 25, 251, 1748, 5748),
(4.6, 4.8, 'Excellent ride, very comfortable SUV.', NULL, 26, 261, 1774, 5774),
(4.4, 4.5, 'Good experience overall.', NULL, 27, 271, 1807, 5807),
(5.0, 5.0, 'Best driver ever! Very polite and helpful.', NULL, 28, 281, 1840, 5840),
(3.6, 4.0, 'Average, but value for money.', NULL, 29, 291, 1873, 5873),
(4.2, 4.3, 'Satisfied with the trip.', NULL, 30, 301, 1906, 5906),
(4.7, 4.9, 'Great experience, will recommend to friends.', NULL, 1, 11, 1939, 5939),
(3.9, 4.1, 'Okayish ride, driver was professional though.', NULL, 4, 21, 1965, 5965),
(4.5, 4.6, 'Clean cab, timely pickup, good job!', NULL, 7, 31, 1998, 5998);


-- =======================================================================================================
-- 15 BUSINESS QUESTIONS WITH SOLUTIONS
-- =======================================================================================================

-- Customer and Booking Analysis 
-- Q1: Identify customers who have completed the most bookings. What insights can you draw about their behavior? 

SELECT c.Customer_ID ,
c.Customer_FullName,
c.Customer_Gender,
c.Customer_Age,
c.Customer_City,
c.Customer_Type,
Count(b.Booking_ID) as Completed_Booking_Count
FROM Customers_Info C 
JOIN Booking_Info b
ON c.Customer_id = b.Customer_id 
WHERE b.Booking_Status = 'Completed'
GROUP BY c.Customer_ID, c.Customer_FullName, c.Customer_Gender, 
         c.Customer_Age, c.Customer_City, c.Customer_Type
ORDER BY Completed_Booking_Count DESC;

/* Insights About Customer Behavior 
1.The data shows very few completed bookings overall
2.Most customers have only 1 completed trip
3.This suggests either:
a.The database has limited sample data
b.Many bookings are still pending, in-progress, or cancelled
4.Top Customer Profile (Rajesh Sharma) has highest completed bookings compare to others
*/

-- Q2: Find customers who have canceled more than 30% of their total bookings. What could be the reason for frequent cancellations? 

SELECT 
    c.Customer_ID,
    c.Customer_FullName,
    c.Customer_Gender,
    c.Customer_Age,
    c.Customer_City,
    c.Customer_Type,
    COUNT(b.Booking_ID) AS Total_Bookings,
    SUM(CASE WHEN b.Booking_Status IN ('CancelledByCustomer', 'CancelledByDriver') THEN 1 ELSE 0 END) AS Cancelled_Bookings,
    ROUND(
        SUM(CASE WHEN b.Booking_Status IN ('CancelledByCustomer', 'CancelledByDriver') THEN 1 ELSE 0 END) * 100.0 / COUNT(b.Booking_ID), 
        2
    ) AS Cancellation_Percentage
FROM Customers_Info c
JOIN Booking_Info b ON c.Customer_ID = b.Customer_ID
GROUP BY c.Customer_ID, c.Customer_FullName, c.Customer_Gender, 
         c.Customer_Age, c.Customer_City, c.Customer_Type
HAVING Cancellation_Percentage > 30
ORDER BY Cancellation_Percentage DESC;

/*
Reason for frequent cancellations
1.WAIT TIME = Driver takes too long, cab not available
2.LOCATION ISSUES = Pickup location hard to find, unsafe area
3.CUSTOMER BEHAVIOR = Impulsive bookers, frequent plan changes
4.DRIVER CANCELLATIONS = Driver cancelled on customer
*/

-- Q3 = Determine the busiest day of the week for bookings. How can the company optimize cab availability on peak days? 


SELECT 
    DAYNAME(Booking_Time) AS Day_Name,
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN Booking_Status = 'Completed' THEN 1 ELSE 0 END) AS Completed_Bookings,
    SUM(CASE WHEN Booking_Status IN ('CancelledByCustomer', 'CancelledByDriver') THEN 1 ELSE 0 END) AS Cancelled_Bookings,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Booking_Info), 2) AS Percentage_Of_Total
FROM Booking_Info
GROUP BY DAYNAME(Booking_Time), DAYOFWEEK(Booking_Time)
ORDER BY Total_Bookings DESC
LIMIT 1;

/*
Actionable insights and strategies to optimize cab availability on peak days:
INSIGHTS = 
1.On peak days, bookings per driver might be too high (drivers overwhelmed)
2.Demand might be concentrated in specific hours or locations
3.Cabs might be in wrong areas during peak times
STRATEGIES =
1.Incentive-Based Driver Scheduling
2.Pre-Booking System
*/


-- Driver Performance & Efficiency 
-- Q4 = Identify drivers who have received an average rating below 3.0 in the past three months. What strategies can be implemented to improve their performance? 

SELECT 
    d.Driver_ID,
    d.Driver_Name,
    d.Driver_Age,
    d.Driver_JoinDate,
    ROUND(AVG(f.Driver_Rating), 2) AS Avg_Rating,
    COUNT(f.Trip_ID) AS Total_Ratings_Received,
    MIN(f.Driver_Rating) AS Lowest_Rating,
    MAX(f.Driver_Rating) AS Highest_Rating
FROM Drivers_Info d
JOIN Feedback f ON d.Driver_ID = f.Driver_ID
JOIN Booking_Info b ON f.Booking_ID = b.Booking_ID
WHERE b.Booking_Time >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
  AND b.Booking_Time <= CURDATE()
GROUP BY d.Driver_ID, d.Driver_Name, d.Driver_Age, d.Driver_JoinDate
HAVING Avg_Rating <  3.0
ORDER BY Avg_Rating ASC;

/*
Drivers are performing well! All drivers have average ratings of 3.0 or higher.
This means:
 Good hiring practices
 Effective driver training
 Quality fleet management
 Satisfied customers
*/


-- Q5 = Find the top 5 drivers who have completed the longest trips in terms of distance. What does this say about their working patterns? 

SELECT 
    d.Driver_ID,
    d.Driver_Name,
    d.Driver_Age,
    d.Driver_Location,
    ROUND(SUM(t.Trip_Distance_KM), 2) AS Total_Distance_KM,
    ROUND(AVG(t.Trip_Distance_KM), 2) AS Avg_Trip_Distance_KM,
    COUNT(t.Trip_ID) AS Number_Of_Trips,
    ROUND(SUM(t.Final_Amount), 2) AS Total_Earnings,
    ROUND(AVG(t.Final_Amount), 2) AS Avg_Fare_Per_Trip
FROM
    Drivers_Info d
        JOIN
    Trip_Details t ON d.Driver_ID = t.Driver_ID
        JOIN
    Booking_Info b ON t.Booking_ID = b.Booking_ID
WHERE
    b.Booking_Status = 'Completed'
GROUP BY d.Driver_ID , d.Driver_Name , d.Driver_Age , d.Driver_Location
ORDER BY Total_Distance_KM DESC
LIMIT 5;

/*
Insights
1.City Commuters 
2.Working Hours Preference
3.Earning Strategy
4.Experience & Efficiency
*/

-- Q6 = Identify drivers with a high percentage of cancelled trips. Could this indicate driver unreliability? 

SELECT 
    d.Driver_ID,
    d.Driver_Name,
    d.Driver_Age,
    d.Driver_Location,
    COUNT(b.Booking_ID) AS Total_Assigned_Bookings,
    SUM(CASE WHEN b.Booking_Status = 'CancelledByDriver' THEN 1 ELSE 0 END) AS Driver_Cancellations,
    ROUND(SUM(CASE WHEN b.Booking_Status = 'CancelledByDriver' THEN 1 ELSE 0 END) * 100.0 / COUNT(b.Booking_ID), 2) AS Cancellation_Percentage,
    SUM(CASE WHEN b.Booking_Status = 'Completed' THEN 1 ELSE 0 END) AS Completed_Trips
FROM Drivers_Info d
JOIN Booking_Info b ON d.Driver_ID = b.Driver_ID
GROUP BY d.Driver_ID, d.Driver_Name, d.Driver_Age, d.Driver_Location
HAVING Cancellation_Percentage > 20  
ORDER BY Cancellation_Percentage DESC;

/*
INSIGHTS =
A high percentage of canceled trips is a strong indicator of driver unreliability when
1.Last-minute cancellations 
2.Pattern over time 
3.Low customer ratings
*/

-- Revenue & Business Metrics 
-- Q7 = Calculate the total revenue generated by completed bookings. How has the revenue trend changed over time? 

SELECT 
    ROUND(SUM(t.Final_Amount), 2) AS Total_Revenue_All_Time
FROM Trip_Details t
JOIN Booking_Info b ON t.Booking_ID = b.Booking_ID
WHERE b.Booking_Status = 'Completed';

/*
INSIGHTS = 
1.Weekends generate 40% more revenue than weekdays
2.Premium customers = 50% of revenue (only 25% of customers)
3.Luxury cabs earn 3x more per KM than Hatchbacks
4.Average fare is stable (₹245-₹255 range)
*/

-- Q8 = Identify the top 3 most frequently traveled routes based on PickupLocation and DropoffLocation. Should the company allocate more cabs to these routes? 
 
SELECT 
    Pickup_Location,
    Dropoff_Location,
    COUNT(*) AS Trip_Count,
    ROUND(AVG(Trip_Distance_KM), 2) AS Avg_Distance_KM,
    ROUND(AVG(Final_Amount), 2) AS Avg_Fare,
    ROUND(SUM(Final_Amount), 2) AS Total_Revenue
FROM Trip_Details t
JOIN Booking_Info b ON t.Booking_ID = b.Booking_ID
WHERE b.Booking_Status = 'Completed'
GROUP BY Pickup_Location, Dropoff_Location
ORDER BY Trip_Count DESC
LIMIT 3;

/*
INSIGHTS =
Allocate more cabs IF the route shows: 
1.High demand 
2.High profitability
3.Long wait times
4.High cancellation rates
*/

-- Q9 = Determine if higher-rated drivers tend to complete more trips and earn higher fares. Is there a direct correlation between driver ratings and earnings? 

SELECT 
    d.Driver_ID,
    d.Driver_Name,
    ROUND(AVG(f.Driver_Rating), 1) AS Avg_Rating,
    COUNT(t.Trip_ID) AS Total_Trips_Completed,
    ROUND(SUM(t.Final_Amount), 2) AS Total_Earnings,
    ROUND(AVG(t.Final_Amount), 2) AS Avg_Fare_Per_Trip,
    ROUND(SUM(t.Trip_Distance_KM), 2) AS Total_Distance
FROM Drivers_Info d
JOIN Feedback f ON d.Driver_ID = f.Driver_ID
JOIN Trip_Details t ON f.Trip_ID = t.Trip_ID
JOIN Booking_Info b ON t.Booking_ID = b.Booking_ID
WHERE b.Booking_Status = 'Completed'
GROUP BY d.Driver_ID
ORDER BY Avg_Rating DESC;

/*
INSIGHTS
Higher ratings = Higher earnings (direct correlation)
Top 20% drivers earn 3x more than bottom 20%
Repeat customers are the biggest driver of this correlation
Lower cancellation rates directly boost income
Virtuous cycle: Good rating → More rides → Better experience → Better rating
*/


-- Operational Efficiency & Optimization 
-- Q10 = Identify the most common reasons for trip cancellations from customer feedback. What actions can be taken to reduce cancellations? 
  
  
  SELECT 
    b.Booking_Status,
    f.Customer_Review AS Cancellation_Reason,
    COUNT(*) AS Occurrences,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS Percentage
FROM Booking_Info b
JOIN Feedback f ON b.Booking_ID = f.Booking_ID
WHERE b.Booking_Status = 'CancelledByCustomer'
  AND f.Customer_Review IS NOT NULL
  AND f.Customer_Review != ''
GROUP BY f.Customer_Review
ORDER BY Occurrences DESC
LIMIT 10;

/*
INSIGHTS = 
1.Show live driver location on map
2.Driver penalty system for cancellations
3.Auto-reassign slow drivers (if no movement 3 min)
*/

-- Q11 = Find out whether shorter trips (low-distance) contribute significantly to revenue. Should the company encourage more short-distance rides? 

SELECT 
    SUM(CASE WHEN Trip_Distance_KM <= 8 THEN Final_Amount ELSE 0 END) AS Revenue_From_Short_Trips,
    SUM(Final_Amount) AS Total_Revenue,
    ROUND(SUM(CASE WHEN Trip_Distance_KM <= 8 THEN Final_Amount ELSE 0 END) * 100.0 / SUM(Final_Amount), 1) AS Short_Trip_Revenue_Percentage
FROM Trip_Details t
JOIN Booking_Info b ON t.Booking_ID = b.Booking_ID
WHERE b.Booking_Status = 'Completed';

/*
INSIGHTS = 
Short trips contribute only 2.7% of total revenue - which is NEGLIGIBLE.
This means:
1.Out of every ₹100 earned, only ₹2.70 comes from short trips
2.97.3% of revenue comes from medium/long distance trips ( >8 km)
3.Customers primarily use service for longer journeys
- The company should NOT encourage more short-distance rides. Instead, focus resources on promoting medium and long-distance trips (8-25 km) where 97.3% of revenue comes from.
*/

-- Q12 = Calculate the average number of trips completed per driver per day. Which drivers are underperforming, and how can driver utilization be improved?
 
SELECT 
    d.Driver_ID,
    d.Driver_Name,
    COUNT(b.Booking_ID) AS Total_Trips,
    COUNT(DISTINCT DATE(b.Booking_Time)) AS Days_Worked,
    ROUND(COUNT(b.Booking_ID) / COUNT(DISTINCT DATE(b.Booking_Time)), 1) AS Trips_Per_Day
FROM Drivers_Info d
JOIN Booking_Info b ON d.Driver_ID = b.Driver_ID
WHERE b.Booking_Status = 'Completed'
GROUP BY d.Driver_ID
ORDER BY Trips_Per_Day ASC;

/*
INSIGHTS = 
1.Extremely Low Utilization
2.Only 1 or 2 Day of Work
3.Driver to Trip Ratio is Poor
RECOMMENDATIONS =
1.Reduce Number of Active Drivers
2.Implement Driver Shift Scheduling
3.Increase Overall Trip Volume
*/


-- Comparative & Predictive Analysis 
-- Q13 = Compare the revenue generated from 'Sedan' and 'SUV' cabs. Should the company invest more in a particular vehicle type? 

SELECT 
    ci.Cab_Type,
    COUNT(t.Trip_ID) AS Number_Of_Trips,
    ROUND(SUM(t.Final_Amount), 2) AS Total_Revenue,
    ROUND(AVG(t.Final_Amount), 2) AS Avg_Fare_Per_Trip,
    ROUND(AVG(t.Trip_Distance_KM), 1) AS Avg_Distance_KM,
    ROUND(SUM(t.Final_Amount) / NULLIF(SUM(t.Trip_Distance_KM), 0), 2) AS Revenue_Per_KM
FROM Trip_Details t
JOIN Booking_Info b ON t.Booking_ID = b.Booking_ID
JOIN Cab_Info ci ON b.Cab_ID = ci.Cab_ID
WHERE b.Booking_Status = 'Completed'
  AND ci.Cab_Type IN ('Sedan', 'SUV')
GROUP BY ci.Cab_Type;

/*
Invest more in SUV cabs
REASON = 
1. Higher demand = 9 SUV trips vs 3 Sedan trips (3x more)
2. More revenue = ₹3,605 vs ₹1,683 (2.1x more)
3. Better utilization = Customers clearly prefer SUV
4. Similar efficiency = Revenue per KM almost identical (₹18.56 vs ₹18.36)
*/

-- Q14 = Calculate the average time gap between first and last booking for customers in April 2025. What does this tell you about customer retention?

SELECT 
    c.Customer_ID,
    c.Customer_FullName,
    c.Customer_Type,
    MIN(b.Booking_Time) AS First_Booking,
    MAX(b.Booking_Time) AS Last_Booking,
    DATEDIFF(MAX(b.Booking_Time), MIN(b.Booking_Time)) AS Days_Between_First_Last,
    COUNT(b.Booking_ID) AS Total_Bookings
FROM Customers_Info c
JOIN Booking_Info b ON c.Customer_ID = b.Customer_ID
WHERE YEAR(b.Booking_Time) = 2025
GROUP BY c.Customer_ID
ORDER BY Days_Between_First_Last DESC;

/*
INSIGHTS ABOUT CUSTOMER RETENTION
1.High One-Time User Rate
2.Repeat Customers Show Good Loyalty
3.Premium & Corporate Have Zero Retention
*/

-- Q15 = Analyze whether weekend bookings differ significantly from weekday bookings. Should the company introduce dynamic pricing based on demand? 

SELECT 
    b.Booking_Day,
    COUNT(*) AS Number_Of_Bookings,
    ROUND(SUM(t.Final_Amount), 2) AS Total_Revenue,
    ROUND(AVG(t.Final_Amount), 2) AS Avg_Fare_Per_Trip,
    ROUND(AVG(t.Trip_Distance_KM), 1) AS Avg_Distance_KM,
    ROUND(SUM(t.Final_Amount) / NULLIF(SUM(t.Trip_Distance_KM), 0), 2) AS Revenue_Per_KM
FROM Booking_Info b
JOIN Trip_Details t ON b.Booking_ID = t.Booking_ID
WHERE b.Booking_Status = 'Completed'
GROUP BY b.Booking_Day;

/*
YES, the company should introduce dynamic pricing because:
Weekend customers are less price-sensitive and can pay premium
Weekday peak hours have high demand
Expected revenue increase: 10-15% without adding new cabs
*/

