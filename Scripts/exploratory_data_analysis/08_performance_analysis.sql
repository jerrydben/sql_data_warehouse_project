/*
===============================================================================
Performance Analysis (YoY & Deviation)
===============================================================================
Objective: 
  - Compare current sales to the product's historical average.
  - Calculate Year-over-Year (YoY) sales growth and status.
*/

WITH YearlyProductSales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales 
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY YEAR(f.order_date), p.product_name
)

SELECT
    order_year,
    product_name,
    current_sales,
    
    -- Comparison against product's lifetime average sales
    AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg_sales,
    CASE 
        WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Average'
        WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Average'
        ELSE 'Average'
    END AS avg_status,

    -- Year-over-Year (YoY) Analysis using LAG function
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS prev_yr_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS yoy_diff,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increasing'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decreasing'
        ELSE 'No Change'
    END AS yoy_status
FROM YearlyProductSales
ORDER BY product_name, order_year;
