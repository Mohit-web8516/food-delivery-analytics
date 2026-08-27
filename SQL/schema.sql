-- Food Delivery Analytics
-- Database schema: normalized Customers, Restaurants, Orders tables

USE FoodDeliveryAnalytics;
GO

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Restaurants;
DROP TABLE IF EXISTS Customers;
GO

CREATE TABLE Customers (
    CustomerID VARCHAR(20) PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    SignupTime DATE,
    AcquisitionChannel VARCHAR(50)
);

CREATE TABLE Restaurants (
    RestaurantID VARCHAR(20) PRIMARY KEY,
    RestaurantName VARCHAR(100),
    Cuisine VARCHAR(50),
    City VARCHAR(50),
    AvgRating DECIMAL(3,2)
);

CREATE TABLE Orders (
    OrderID VARCHAR(20) PRIMARY KEY,
    CustomerID VARCHAR(20),
    RestaurantID VARCHAR(20),
    OrderTimestamp DATE,
    OrderAmount DECIMAL(10,2),
    DiscountAmount DECIMAL(10,2),
    DeliveryFee DECIMAL(10,2),
    PaymentMode VARCHAR(20),
    OrderStatus VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);