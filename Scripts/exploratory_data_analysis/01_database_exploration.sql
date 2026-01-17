/*
===============================================================================
Database Exploration & Data Quality Audit
===============================================================================
Objective: 
    - Profile the Gold Layer to ensure data integrity.
    - Check for missing values, unique constraints, and date boundaries.
    
Business Value:
    - Prevents "Garbage In, Garbage Out" in Power BI reports.
    - Validates that the ETL process from Silver to Gold was successful.
===============================================================================
*/

-- 1. Table Overview: Record Counts
-- Objective: Ensure the volume of data matches expectations.
PRINT '--- Table Row Counts ---';
SELECT 'Fact Sales' AS table_name, COUNT(*) AS total_rows FROM gold.fact_sales
UNION ALL
SELECT 'Dim Products', COUNT(*) FROM gold.dim_products
UNION ALL
SELECT 'Dim Customers', COUNT(*) FROM gold.dim_customers;

-- 2. Check for NULLs in Critical Columns
-- Objective: Identify data gaps that could break calculations (like AOV).
PRINT '--- Null Value Check (Fact Sales) ---';
SELECT 
    SUM(CASE WHEN order_number IS NULL THEN 1 ELSE 0 END) AS null_orders,
    SUM(CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END) AS null_customers,
    SUM(CASE WHEN product_key IS NULL THEN 1 ELSE 0 END) AS null_products,
    SUM(CASE WHEN sales_amount IS NULL THEN 1 ELSE 0 END) AS null_sales
FROM gold.fact_sales;

-- 3. Date Range Validation
-- Objective: Ensure no "future dates" or "ancient dates" exist in the data.
PRINT '--- Date Range Audit ---';
SELECT 
    MIN(order_date) AS earliest_order, 
    MAX(order_date) AS latest_order,
    DATEDIFF(DAY, MIN(order_date), MAX(order_date)) AS total_days_of_data
FROM gold.fact_sales;

-- 4. Uniqueness Check
-- Objective: Ensure Dimension tables have unique primary keys (no duplicates).
PRINT '--- Duplicate Check (Products) ---';
SELECT 
    product_key, 
    COUNT(*) as duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- 5. Foreign Key Integrity (Orphan Check)
-- Objective: Find sales records that refer to products NOT in the Product table.
PRINT '--- Integrity Check (Orphaned Sales) ---';
SELECT COUNT(*) AS orphaned_records
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
WHERE p.product_key IS NULL;
