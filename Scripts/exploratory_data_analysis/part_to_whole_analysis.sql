/*
===============================================================================
4. Part-to-Whole Analysis (Category Contribution)
===============================================================================
Objective: 
    - Determine the financial contribution of each product category to total sales.
    - Identify dominant categories and those with growth potential.

Business Value:
    - Informs inventory prioritization and marketing spend.
    - Helps stakeholders understand the revenue mix at a glance.
===============================================================================
*/

-- Step 1: Aggregate sales at the category level
WITH category_sales AS (
    SELECT 
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.category
)

-- Step 2: Calculate global total and percentage contribution
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    -- Calculate percentage and format as string with '%'
    CONCAT(
        ROUND(CAST(total_sales AS FLOAT) / SUM(total_sales) OVER() * 100, 2), 
        '%'
    ) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
