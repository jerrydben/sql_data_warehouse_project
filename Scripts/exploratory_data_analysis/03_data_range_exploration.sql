/*
===============================================================================
Data Range Exploration (Temporal Audit)
===============================================================================
Objective: 
    - Determine the start and end dates of the sales data.
    - Calculate the total timespan of the data warehouse.

Business Value:
    - Validates that the "Gold Layer" contains the expected historical period.
    - Essential for verifying 'Recency' and 'Year-over-Year' (YoY) metrics.
===============================================================================
*/

PRINT '--- Fact Sales: Date Boundary Audit ---';

SELECT 
    -- Earliest date in the dataset
    MIN(order_date) AS first_order_date, 
    
    -- Latest date in the dataset
    MAX(order_date) AS last_order_date,
    
    -- Total duration of data in days
    DATEDIFF(DAY, MIN(order_date), MAX(order_date)) AS total_days_covered,
    
    -- Total duration in months (useful for Lifespan checks)
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS total_months_covered,
    
    -- Count of years available for YoY Analysis
    COUNT(DISTINCT YEAR(order_date)) AS available_years
    
FROM gold.fact_sales
WHERE order_date IS NOT NULL;

/* Observation Tip: 
If 'first_order_date' shows a year like 1900 or 1753, check your 
Silver Layer cleaning logic for default date handling.
*/
