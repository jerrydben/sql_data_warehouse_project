/* =============================================================================
EDA #4: Product Cost Segmentation
Author: Jeremiah Ngiri
Layer: Gold
Description:
    - Segments products into cost-based buckets
    - Enables distribution analysis of products across price ranges
    - Supports pricing strategy and product portfolio insights
============================================================================= */

WITH product_cost_segmentation AS (
    SELECT
        product_key,
        product_name,
        cost,

        /* Cost bucket classification */
        CASE
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100 - 500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500 - 1000'
            ELSE 'Above 1000'
        END AS cost_range

    FROM gold.dim_products
)

SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_cost_segmentation
GROUP BY cost_range
ORDER BY total_products DESC;
