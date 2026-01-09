/*
===============================================================================
Script: Data Quality Checks - Gold Layer
Project: Sales Data Warehouse (CRM & ERP Integration)
Author: Jeremiah Ngiri
Description:
    - Validates Business Rules, Referential Integrity, and Uniqueness.
    - Tests the final "Star Schema" views (gold.dim_customers, gold.dim_products, gold.fact_sales).
===============================================================================
*/

-- ============================================================================
-- 1. VALIDATION: gold.dim_customers
-- ============================================================================
PRINT '>>> Checking for duplicates in gold.dim_customers...';

-- Expectation: 0 records
-- Validates that the JOIN logic didn't create a Cartesian product.
SELECT 
    customer_id, 
    COUNT(*) AS record_count 
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check Gender Standardization Integration
-- Expectation: Only 'Male', 'Female', or 'N/A'
-- Validates the COALESCE logic between CRM and ERP.
SELECT DISTINCT gender FROM gold.dim_customers;


-- ============================================================================
-- 2. VALIDATION: gold.dim_products
-- ============================================================================
PRINT '>>> Checking for duplicates in gold.dim_products...';

-- Expectation: 0 records
-- Validates that 'WHERE prd_end_dt IS NULL' correctly filtered current records.
SELECT 
    product_number, 
    COUNT(*) AS record_count 
FROM gold.dim_products
GROUP BY product_number
HAVING COUNT(*) > 1;


-- ============================================================================
-- 3. VALIDATION: gold.fact_sales (Referential Integrity)
-- ============================================================================
PRINT '>>> Checking Referential Integrity: Fact to Dimensions...';

-- Check: Sales to Customers
-- Expectation: 0 records
-- Ensures every sale is mapped to a valid customer surrogate key.
SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

-- Check: Sales to Products
-- Expectation: 0 records
-- Ensures every sale is mapped to a valid product surrogate key.
SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
WHERE p.product_key IS NULL;


-- ============================================================================
-- 4. VALIDATION: Business Rule Consistency
-- ============================================================================
PRINT '>>> Checking for logical date sequences in Fact Sales...';

-- Expectation: 0 records
SELECT * FROM gold.fact_sales 
WHERE shipping_date < order_date 
   OR due_date < order_date;
