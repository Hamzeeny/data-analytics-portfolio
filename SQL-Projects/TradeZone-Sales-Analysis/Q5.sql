-- Q5: Customer Spend Segmentation
-- Segment customers based on their total spend in 2024 into High, Medium, and Low spenders.
-- For each segment, calculate the customer count, average spend per customer,
-- and total revenue contribution.
-- Thresholds (analyst-defined): High >= 100,000; Medium 50,000 to under 100,000; Low below 50,000.
-- Revenue definition: orders with status Cancelled or Returned are excluded,
-- since that value was never retained. Revenue = Processing, Shipped and Delivered orders.

WITH customer_spend AS (
    SELECT
        o.customer_id,
        SUM(o.total_amount) AS total_spend_2024
    FROM orders o
    WHERE o.order_date >= DATE '2024-01-01'
      AND o.order_date < DATE '2025-01-01'
      AND o.order_status NOT IN ('Cancelled', 'Returned')
    GROUP BY o.customer_id
),

segmented_customers AS (
    SELECT
        customer_id,
        total_spend_2024,
        CASE
            WHEN total_spend_2024 >= 100000 THEN 'High Spenders'
            WHEN total_spend_2024 >= 50000 THEN 'Medium Spenders'
            ELSE 'Low Spenders'
        END AS spend_segment
    FROM customer_spend
)

SELECT
    spend_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spend_2024)::numeric, 2) AS avg_spend_per_customer,
    ROUND(SUM(total_spend_2024)::numeric, 2) AS total_revenue,
    ROUND(100.0 * SUM(total_spend_2024) / SUM(SUM(total_spend_2024)) OVER (), 2) AS revenue_share_pct
FROM segmented_customers
GROUP BY spend_segment
ORDER BY total_revenue DESC;
