# Food Delivery Analytics — SQL, Python & Power BI

An end-to-end data analytics project analyzing order fulfillment, customer 
acquisition, and restaurant performance for a food delivery platform, built 
on a synthetic Zomato-style dataset (customers, restaurants, and orders).

## Problem Statement

A food delivery platform wants to understand why growth has plateaued and 
where operational issues might be hurting the business. This project 
analyzes ~50,000 orders across ~5,000 customers and 200 restaurants to 
answer three core questions:

1. How healthy is order fulfillment — are orders actually completing?
2. Which customer acquisition channels and cuisines drive the most value?
3. Are there city-level or operational patterns behind order cancellations?

## Tools Used

- **SQL Server** — data cleaning, normalization, and business analysis queries
- **Python (Pandas, NumPy, Matplotlib, Seaborn)** — validation, feature 
  engineering, and visualization
- **Power BI** — interactive dashboard
- **Git/GitHub** — version control

## Project Structure
food-delivery-analytics/
├── data/ # Raw CSVs and cleaned dataset
├── sql/ # Schema, data load, verification, and analysis queries
├── notebooks/ # Python EDA and visualization notebooks
├── dashboard/ # Power BI file and exported chart images
└── README.md



## Dataset

Three related tables, originally provided as Google Sheets/CSV exports:

- **Customers** (~5,000 rows): customer ID, name, city, signup date, 
  acquisition channel
- **Restaurants** (200 rows): restaurant ID, name, cuisine, city, average rating
- **Orders** (50,000 rows): order ID, customer ID, restaurant ID, timestamp, 
  order amount, discount, delivery fee, payment mode, order status 
  (Delivered / Cancelled / Refunded)

## Data Cleaning & Data Quality Issues Found

Real-world messy data was genuinely present in this dataset, and handling it 
properly is a core part of this project:

- **Inconsistent city formatting** — the same city appeared as both `"Pune"` 
  and `" pune"` (lowercase, with leading whitespace) in the raw data. Fixed 
  using `TRIM()` and standardized capitalization in SQL.
- **Column type misdetection on import** — `restaurant_id` was auto-detected 
  as a numeric type on first import, silently stripping the "R" prefix 
  (e.g., "R0115" became "115.00"). Caught by inspecting the imported data 
  and re-imported with the correct `nvarchar` type.
- **Orphaned foreign key records** — 10 orders referenced a `customer_id` 
  ("C00001") that didn't exist anywhere in the Customers table. These orders 
  were excluded from the final `Orders` table rather than silently forced 
  in, and documented as a known data limitation.
- **Illogical signup/order sequencing** — a large portion of orders had an 
  `OrderTimestamp` that occurred *before* the customer's `SignupTime` 
  (minimum: -699 days). Rather than fabricate a fix, this was documented as 
  a synthetic-data limitation and excluded from any tenure-based analysis.

## SQL Analysis — Key Findings

**1. Nearly 40% of all orders fail to complete.**
Only 59.67% of orders are successfully Delivered; 20.19% are Cancelled and 
20.14% are Refunded. This order failure rate is the single most critical 
finding in this project — a platform losing 2 in 5 orders represents a major 
operational or trust problem.

**2. No acquisition channel significantly outperforms others.**
All five acquisition channels (Organic, Referral, Instagram Ads, Google Ads, 
WhatsApp Campaign) produce nearly identical average order values (₹892–908) 
and total revenue (₹53.3L–54.1L). Customer spending behavior doesn't appear 
to be meaningfully influenced by how they were acquired.

**3. North Indian cuisine leads, but rating doesn't predict revenue.**
North Indian is the top cuisine by both order volume (5,869) and revenue 
(₹52.3L), followed by Pizza and Fast Food. Average ratings are tightly 
clustered (4.20–4.36) across all cuisines, showing no strong correlation 
between rating and popularity.

**4. City performance is fairly even, with Chennai showing the highest 
cancellation rate.**
Revenue across the 8 cities is relatively balanced (₹32.2L–36.0L), with 
Noida leading. Chennai has the highest cancellation rate (21.08%) while 
Mumbai has the lowest (19.56%).

**5. Cancellation rate is consistent across payment modes and cuisines.**
Payment mode cancellation rates range narrowly from 19.96% (Card) to 20.63% 
(Cash); cuisine cancellation rates range from 19.79% (Pizza) to 20.67% (Fast 
Food) — both under 1 percentage point of spread. This suggests the high 
order failure rate is a **systemic, platform-wide issue** rather than one 
tied to a specific payment type or food category — likely rooted in delivery 
logistics or restaurant fulfillment capacity rather than customer behavior.

## Business Recommendations

- Investigate the root cause of the ~40% order failure rate as the top 
  priority — this materially impacts both revenue and customer trust
- Re-evaluate acquisition channel budget allocation based on cost-per-
  acquisition rather than assumed revenue differences, since all channels 
  perform similarly once a customer orders
- Investigate Chennai's elevated cancellation rate specifically — possible 
  restaurant capacity or delivery partner availability issues
- Since cancellation isn't tied to payment mode or cuisine, focus root-cause 
  analysis on delivery logistics and restaurant-side fulfillment rather than 
  customer-facing factors

## Python Analysis

The Python notebooks (`/notebooks`) connect directly to the SQL Server 
database, cross-validate every SQL finding above, and add two additional 
insights not easily visible in SQL:

- Cancellation rate is nearly flat across payment modes (19.96%–20.63%)
- Cancellation rate is nearly flat across cuisines (19.79%–20.67%)

Both reinforce finding #5 above — the order failure problem is systemic, 
not segment-specific.

## Power BI Dashboard

An interactive single-page dashboard connected live to the SQL Server 
database, including:
- KPI cards for total revenue, fulfillment rate, average order value, and 
  cancellation rate
- Order status breakdown
- Acquisition channel and cuisine revenue comparisons
- City-level cancellation rate chart
- Monthly revenue trend
- Region/category slicers for interactive filtering

*(Dashboard screenshots to be added here.)*

## How to Reproduce

1. Import the CSVs in `/data` into SQL Server (or run `/sql/schema.sql` and 
   `/sql/load_data.sql` after loading the raw CSVs into staging tables)
2. Run `/sql/verify.sql` to confirm row counts and check data quality
3. Run `/sql/queries.sql` for the core business analysis
4. Open `/notebooks/01_eda_and_cleaning.ipynb` to reproduce the Python 
   cleaning and validation
5. Open `/notebooks/02_data_visualization.ipynb` to reproduce the charts
6. Open the Power BI file in `/dashboard` to explore the interactive dashboard