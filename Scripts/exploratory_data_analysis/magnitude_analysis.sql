/*
===============================================================================
6. Magnitude Analysis (Volume vs. Value)
===============================================================================
Objective: 
    - Categorize products based on their "Magnitude" (Total Sales) 
    - Break down results into 'High', 'Medium', and 'Low' impact groups.

Business Value:
    - Identifies which products contribute the most to the bottom line (Pareto 80/20).
    - Helps in strategic pricing and inventory stock-level decisions.
===============================================================================
*/

-- Step 1: Aggregate sales and calculate contribution percentages
WITH product_magnitude AS (
    SELECT 
        p.product_name,
        p.category,
        SUM(f.sales_amount) AS total_sales,
        SUM(f.quantity) AS total_quantity,
        -- Calculate the average price per unit sold for this product
        AVG(f.price) AS avg_unit_price
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    GROUP BY p.product_name, p.category
),

-- Step 2: Rank products by magnitude (Total Sales)
ranked_magnitude AS (
    SELECT 
        *,
        SUM(total_sales) OVER() AS global_total_sales,
        CAST(total_sales AS FLOAT) / SUM(total_sales) OVER() AS pct_contribution
    FROM product_magnitude
)

-- Step 3: Assign Magnitude Categories
SELECT 
    product_name,
    category,
    total_sales,
    total_quantity,
    avg_unit_price,
    ROUND(pct_contribution * 100, 2) AS pct_contribution,
    CASE 
        WHEN pct_contribution >= 0.05 THEN 'High Magnitude (Major Driver)'
        WHEN pct_contribution >= 0.01 THEN 'Medium Magnitude (Steady)'
        ELSE 'Low Magnitude (Niche/Tail)'
    END AS magnitude_category
FROM ranked_magnitude
ORDER BY total_sales DESC;
