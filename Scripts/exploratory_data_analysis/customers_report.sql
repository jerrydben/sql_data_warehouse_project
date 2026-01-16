/*
===============================================================================
Customer Report View (Gold Layer)
===============================================================================
Objective: 
    - Create a comprehensive customer-centric report for BI tools.
    - Consolidate demographics, purchasing behavior, and segments.

Business Value:
    - Provides a single source of truth for "Customer 360" analysis.
    - Enables segmentation-driven marketing and cohort analysis.
===============================================================================
*/

-- Truncate existing view if necessary (Standard practice for refresh scripts)
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

-- Step 1: Base data retrieval with basic transformations
WITH base_query AS (
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        -- Calculate age accurately based on current date
        DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
),

-- Step 2: Aggregate metrics at the customer level
customer_aggregations AS (
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        -- Calculate tenure in months
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)

-- Step 3: Final reporting layer with segmentation and financial ratios
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    
    -- Demographics: Age Grouping
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 & Above'
    END AS age_group,

    -- Loyalty: Advanced Customer Segmentation
    CASE 
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Loyal/Regular'
        WHEN lifespan < 12 AND total_sales > 2000 THEN 'High Potential (New)'
        ELSE 'Standard/New'
    END AS customer_segment,

    -- Recency: Months since last purchase
    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,

    -- Core KPIs
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,

    -- Financial Ratios (Using NULLIF to prevent Division by Zero errors)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / NULLIF(total_orders, 0)
    END AS average_order_value,

    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / NULLIF(lifespan, 0)
    END AS avg_monthly_spending

FROM customer_aggregations;
GO
