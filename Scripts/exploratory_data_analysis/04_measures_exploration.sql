/*
===============================================================================
Measure Exploration (Numerical Profiling)
===============================================================================
Objective: 
    - Calculate descriptive statistics (Min, Max, Avg) for all numeric measures.
    - Identify potential outliers or data entry errors.

Business Value:
    - Ensures that averages used in "AOV" and "Monthly Spending" are realistic.
    - Validates the financial integrity of the Fact table.
===============================================================================
*/

PRINT '--- Fact Sales: Descriptive Statistics ---';

SELECT 
    -- Sales Amount Profiling
    MIN(sales_amount) AS min_sales,
    MAX(sales_amount) AS max_sales,
    ROUND(AVG(sales_amount), 2) AS avg_sales,
    ROUND(STDEV(sales_amount), 2) AS sales_std_dev, -- Measures data spread/volatility

    -- Quantity Profiling
    MIN(quantity) AS min_qty,
    MAX(quantity) AS max_qty,
    AVG(quantity) AS avg_qty,

    -- Price/Unit Profiling
    MIN(price) AS min_unit_price,
    MAX(price) AS max_unit_price,
    ROUND(AVG(price), 2) AS avg_unit_price

FROM gold.fact_sales;

-- Step 2: Outlier Detection (Z-Score Logic Lite)
-- Objective: Find orders that are 3x higher than the average sales amount.
PRINT '--- Potential Sales Outliers ---';
SELECT 
    order_number,
    customer_key,
    sales_amount
FROM gold.fact_sales
WHERE sales_amount > (SELECT AVG(sales_amount) * 3 FROM gold.fact_sales)
ORDER BY sales_amount DESC;
