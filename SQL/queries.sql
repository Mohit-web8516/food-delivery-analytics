-- Food Delivery Analytics — Business Analysis Queries

USE FoodDeliveryAnalytics;
GO

-- ============================================================
-- Query 1: Order Fulfillment Rate
-- What % of orders are Delivered vs Cancelled vs Refunded —
-- a core health metric for any delivery platform.
-- ============================================================
SELECT 
    OrderStatus,
    COUNT(*) AS NumOrders,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS PercentOfTotal
FROM Orders
GROUP BY OrderStatus
ORDER BY NumOrders DESC;


-- ============================================================
-- Query 2: Revenue & Average Order Value
-- Core revenue metrics, filtered to only successfully Delivered
-- orders (Cancelled/Refunded shouldn't count as real revenue).
-- ============================================================
SELECT 
    COUNT(*) AS TotalOrders,
    SUM(OrderAmount) AS TotalRevenue,
    AVG(OrderAmount) AS AvgOrderValue,
    SUM(DiscountAmount) AS TotalDiscountGiven,
    AVG(DeliveryFee) AS AvgDeliveryFee
FROM Orders
WHERE OrderStatus = 'Delivered';


-- ============================================================
-- Query 3: Acquisition Channel Performance
-- Which acquisition channel (Organic, Referral, Instagram Ads,
-- etc.) brings in customers who actually order and spend the most.
-- ============================================================
SELECT 
    c.AcquisitionChannel,
    COUNT(DISTINCT c.CustomerID) AS NumCustomers,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.OrderAmount) AS TotalRevenue,
    AVG(o.OrderAmount) AS AvgOrderValue
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID AND o.OrderStatus = 'Delivered'
GROUP BY c.AcquisitionChannel
ORDER BY TotalRevenue DESC;


-- ============================================================
-- Query 4: Top Cuisines by Revenue
-- Which cuisines drive the most orders/revenue, and whether
-- higher-rated cuisines actually sell more.
-- ============================================================
SELECT 
    r.Cuisine,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.OrderAmount) AS TotalRevenue,
    AVG(r.AvgRating) AS AvgRating
FROM Orders o
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID
WHERE o.OrderStatus = 'Delivered'
GROUP BY r.Cuisine
ORDER BY TotalRevenue DESC;


-- ============================================================
-- Query 5: City-wise Performance & Cancellation Rate
-- Which cities generate the most revenue, and whether any city
-- has an unusually high cancellation rate worth investigating.
-- ============================================================
SELECT 
    c.City,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(CASE WHEN o.OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders,
    CAST(SUM(CASE WHEN o.OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(o.OrderID) AS DECIMAL(5,2)) AS CancellationRatePercent,
    SUM(CASE WHEN o.OrderStatus = 'Delivered' THEN o.OrderAmount ELSE 0 END) AS DeliveredRevenue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.City
ORDER BY DeliveredRevenue DESC;