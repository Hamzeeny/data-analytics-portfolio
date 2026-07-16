-- Q5: Customer Spend Segmentation
-- Segment customers based on their total spend in 2024 into High, Medium, and Low spenders.
-- For each segment, calculate the customer count, average spend per customer,
-- and total revenue contribution.

WITH customer_spend AS (
    SELECT
        o.customer_id,
        SUM(o.total_amount) AS total_spend_2024
    FROM orders o
    WHERE o.order_date >= DATE '2024-01-01'
      AND o.order_date < DATE '2025-01-01'
    GROUP BY o.customer_id
),

segmented_customers AS (
    SELECT
        customer_id,
        total_spend_2024,
        CASE
            WHEN total_spend_2024 >= 100000 THEN 'High Spenders'
            WHEN total_spend_2024 BETWEEN 50000 AND 99999 THEN 'Medium Spenders'
            ELSE 'Low Spenders'
        END AS spend_segment
    FROM customer_spend
)

SELECT
    spend_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spend_2024)::numeric, 2) AS avg_spend_per_customer,
    ROUND(SUM(total_spend_2024)::numeric, 2) AS total_revenue
FROM segmented_customers
GROUP BY spend_segment
ORDER BY total_revenue DESC;
