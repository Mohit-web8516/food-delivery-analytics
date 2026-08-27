-- Verification checks after loading data

USE FoodDeliveryAnalytics;
GO

SELECT COUNT(*) AS CustomerCount FROM Customers;    -- expect 4999
SELECT COUNT(*) AS RestaurantCount FROM Restaurants; -- expect 200
SELECT COUNT(*) AS OrderCount FROM Orders;           -- expect 49990

-- Confirms City cleaning worked (should show each city exactly once)
SELECT DISTINCT City FROM Customers ORDER BY City;

-- Data quality check: orders referencing a customer that doesn't exist
SELECT so.customer_id, COUNT(*) AS OrphanOrderCount
FROM Staging_Orders so
LEFT JOIN Customers c ON so.customer_id = c.CustomerID
WHERE c.CustomerID IS NULL
GROUP BY so.customer_id;

-- Same check for restaurant_id (confirms none found)
SELECT so.restaurant_id, COUNT(*) AS OrphanOrderCount
FROM Staging_Orders so
LEFT JOIN Restaurants r ON so.restaurant_id = r.RestaurantID
WHERE r.RestaurantID IS NULL
GROUP BY so.restaurant_id;