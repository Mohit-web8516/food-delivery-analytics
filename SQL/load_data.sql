-- Populate normalized tables from staging tables
-- Data quality fixes applied:
--   1. City values cleaned (trimmed whitespace, standardized capitalization)
--      e.g. " pune" and "Pune" were merged into one clean "Pune" value
--   2. Order/discount amounts cast to DECIMAL(10,2) to fix float precision artifacts
--   3. 10 orders referencing a non-existent CustomerID ("C00001") were excluded
--      via the WHERE clause below, since that customer was never recorded in
--      the Customers source data — a genuine data quality issue

USE FoodDeliveryAnalytics;
GO

INSERT INTO Customers (CustomerID, CustomerName, City, SignupTime, AcquisitionChannel)
SELECT 
    Customer_id,
    Customer_name,
    UPPER(LEFT(TRIM(City), 1)) + LOWER(SUBSTRING(TRIM(City), 2, LEN(TRIM(City)))) AS CleanCity,
    Signup_Time,
    Acquisition_channel
FROM Staging_Customers;

INSERT INTO Restaurants (RestaurantID, RestaurantName, Cuisine, City, AvgRating)
SELECT 
    restaurant_id,
    restaurant_name,
    cuisine,
    city,
    avg_rating
FROM Staging_Restaurants;

INSERT INTO Orders (OrderID, CustomerID, RestaurantID, OrderTimestamp, OrderAmount, DiscountAmount, DeliveryFee, PaymentMode, OrderStatus)
SELECT 
    so.order_id,
    so.customer_id,
    so.restaurant_id,
    so.order_timestamp,
    CAST(so.order_amount AS DECIMAL(10,2)),
    CAST(so.discount_amount AS DECIMAL(10,2)),
    so.delivery_fee,
    so.payment_mode,
    so.order_status
FROM Staging_Orders so
WHERE so.customer_id IN (SELECT CustomerID FROM Customers)
  AND so.restaurant_id IN (SELECT RestaurantID FROM Restaurants);