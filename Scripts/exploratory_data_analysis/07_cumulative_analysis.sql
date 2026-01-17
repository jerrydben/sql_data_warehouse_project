/*
===============================================================================
Cumulative (Running Total) Analysis
===============================================================================
Objective: Calculate the running total of sales and the moving average of price.
Optimized using CTE for better readability compared to subqueries.
*/

WITH MonthlyAggregates AS (
    SELECT
        DATETRUNC(year, order_date) AS order_year,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
)
SELECT
    order_year,
    total_sales,
    avg_price,
    -- Cumulative sales calculation
    SUM(total_sales) OVER (ORDER BY order_year) AS running_total_sales,
    -- Cumulative average price calculation
    AVG(avg_price) OVER (ORDER BY order_year) AS running_avg_price
FROM MonthlyAggregates
ORDER BY order_year;
