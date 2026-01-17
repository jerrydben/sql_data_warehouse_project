/*
===============================================================================
7. Dimension Analysis (Attribute Distribution)
===============================================================================
Objective: 
    - Analyze the composition of the Product and Customer dimensions.
    - Understand the density of products per category and subcategory.

Business Value:
    - Identifies "Over-saturated" vs "Under-represented" product categories.
    - Validates the granularity of the dimension tables.
===============================================================================
*/

-- Step 1: Product Dimension Analysis (Variety per Category)
PRINT '--- Product Category Distribution ---';
SELECT 
    category,
    COUNT(product_key) AS unique_products,
    COUNT(DISTINCT subcategory) AS subcategory_count,
    -- Calculate the average cost per category to see value distribution
    ROUND(AVG(cost), 2) AS avg_category_cost
FROM gold.dim_products
GROUP BY category
ORDER BY unique_products DESC;

-- Step 2: Customer Demographic Distribution (Dimension Profiling)
PRINT '--- Customer Segmentation by Gender & Country ---';
-- Assuming these columns exist in your dim_customers
SELECT 
    country,
    gender,
    COUNT(customer_key) AS total_customers,
    -- Percentage of total customer base
   CONCAT(
    CAST(ROUND(COUNT(customer_key) * 100.0 / SUM(COUNT(customer_key)) OVER(), 2) AS DECIMAL(10,2)),
    '%'
) AS pct_of_base
FROM gold.dim_customers
GROUP BY country, gender
ORDER BY country, total_customers DESC;

-- Step 3: Product-to-Sales Coverage (Density Analysis)
-- Objective: Find out how many products have NEVER been sold.
PRINT '--- Product Coverage (Active vs Inactive) ---';
SELECT 
    CASE WHEN f.product_key IS NULL THEN 'Inactive (Never Sold)' 
         ELSE 'Active (Has Sales)' 
    END AS product_status,
    COUNT(p.product_key) AS product_count
FROM gold.dim_products p
LEFT JOIN gold.fact_sales f ON p.product_key = f.product_key
GROUP BY CASE WHEN f.product_key IS NULL THEN 'Inactive (Never Sold)' 
              ELSE 'Active (Has Sales)' END;
