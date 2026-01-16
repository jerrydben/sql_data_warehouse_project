/*
===============================================================================
5. Customer Segmentation Analysis (RFM Lite)
===============================================================================
Objective: 
    - Group customers based on their spending habits and tenure (lifespan).
    - Identify high-value VIPs versus new or low-value customers.

Business Value:
    - Allows for targeted marketing campaigns (Loyalty programs vs. Re-engagement).
    - Helps predict Customer Lifetime Value (CLV).
===============================================================================
*/

-- Step 1: Calculate individual customer metrics
WITH customer_metrics AS (
    SELECT 
        f.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(f.order_date) AS first_order,
        MAX(f.order_date) AS last_order,
        DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan
    FROM gold.fact_sales f
    GROUP BY f.customer_key
),

-- Step 2: Assign segments based on spending and tenure
customer_segments AS (
    SELECT 
        customer_key,
        total_spending,
        lifespan,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Loyal/Regular'
            WHEN lifespan < 12 AND total_spending > 2000 THEN 'High Potential (New)'
            ELSE 'Standard/New'
        END AS segment
    FROM customer_metrics
)

-- Step 3: Aggregate segments for executive reporting
SELECT 
    segment,
    COUNT(customer_key) AS total_customers,
    SUM(total_spending) AS total_revenue,
    ROUND(AVG(total_spending), 2) AS avg_spending_per_customer
FROM customer_segments
GROUP BY segment
ORDER BY total_customers DESC;
