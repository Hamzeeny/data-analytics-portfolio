-- Q4: Quarterly Revenue Trends
-- Compare quarterly revenue across 2023 and 2024.
-- For each quarter, calculate total revenue, average order value,
-- and total number of orders.

SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(QUARTER FROM order_date) AS quarter,
    ROUND(SUM(total_amount)::numeric, 2) AS total_revenue,
    ROUND(AVG(total_amount)::numeric, 2) AS avg_order_value,
    COUNT(order_id) AS total_orders
FROM orders
WHERE order_date >= DATE '2023-01-01'
  AND order_date < DATE '2025-01-01'
GROUP BY
    year,
    quarter
ORDER BY
    year,
    quarter;


-- Identify quarter with highest revenue growth (2024 vs 2023)

WITH quarterly_data AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        EXTRACT(QUARTER FROM order_date) AS quarter,
        SUM(total_amount) AS total_revenue
    FROM orders
    WHERE order_date >= DATE '2023-01-01'
      AND order_date < DATE '2025-01-01'
    GROUP BY year, quarter
),

pivot_data AS (
    SELECT
        quarter,
        SUM(CASE WHEN year = 2023 THEN total_revenue END) AS revenue_2023,
        SUM(CASE WHEN year = 2024 THEN total_revenue END) AS revenue_2024
    FROM quarterly_data
    GROUP BY quarter
)

SELECT
    quarter,
    ROUND(revenue_2023::numeric, 2) AS revenue_2023,
    ROUND(revenue_2024::numeric, 2) AS revenue_2024,
    ROUND((revenue_2024 - revenue_2023)::numeric, 2) AS growth
FROM pivot_data
ORDER BY growth DESC
LIMIT 1;