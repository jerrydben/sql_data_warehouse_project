/*
===============================================================================
Product Report View (Gold Layer)
===============================================================================
Objective: 
    - Create a comprehensive product-centric report for BI tools.
    - Consolidate product metadata, sales performance, and lifecycle metrics.

Business Value:
    - Provides a "Single Source of Truth" for product performance.
    - Enables inventory optimization and category-level financial analysis.
===============================================================================
*/

-- Truncate/Drop existing view to ensure a clean deployment
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

-- Step 1: Base data retrieval and joining metadata
WITH base_query AS (
    SELECT 
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

-- Step 2: Aggregate metrics at the product level
product_aggregations AS (
    SELECT 
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_sell_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        -- Use NULLIF to handle potential zero quantity and prevent errors
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

-- Step 3: Final reporting layer with segmentation and financial KPIs
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sell_date,
    -- Calculate how many months since the product was last sold
    DATEDIFF(MONTH, last_sell_date, GETDATE()) AS recency_in_months,
    
    -- Product Segmentation Logic based on Total Revenue
    CASE 
        WHEN total_sales > 50000 THEN 'High Performance'
        WHEN total_sales > 10000 THEN 'Mid Performance'
        ELSE 'Low Performance'
    END AS product_segment,

    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    -- Financial Ratios: Average Revenue per Order
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / NULLIF(total_orders, 0)
    END AS avg_order_revenue,

    -- Financial Ratios: Average Monthly Revenue over the product's lifespan
    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / NULLIF(lifespan, 0)
    END AS avg_monthly_revenue

FROM product_aggregations;
GO
