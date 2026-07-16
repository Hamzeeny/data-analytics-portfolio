-- Q1: Customer Acquisition & 30-Day Conversion
-- Find the top 5 states by number of new customer sign-ups in 2024,
-- and calculate the percentage of these customers who made at least
-- one purchase within 30 days of signing up.

WITH customers_2024 AS (
    SELECT
        customer_id,
        state,
        signup_date
    FROM customers
    WHERE signup_date >= DATE '2024-01-01'
      AND signup_date < DATE '2025-01-01'
),

customer_conversion AS (
    SELECT
        c.customer_id,
        c.state,
        c.signup_date,
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM orders o
                WHERE o.customer_id = c.customer_id
                  AND o.order_date >= c.signup_date
                  AND o.order_date <= c.signup_date + INTERVAL '30 days'
            ) THEN 1
            ELSE 0
        END AS converted_within_30_days
    FROM customers_2024 c
),

state_summary AS (
    SELECT
        state,
        COUNT(*) AS new_customers_2024,
        SUM(converted_within_30_days) AS customers_converted_30d,
        ROUND(
            100.0 * SUM(converted_within_30_days) / COUNT(*),
            2
        ) AS conversion_rate_30d_pct
    FROM customer_conversion
    GROUP BY state
)

SELECT
    state,
    new_customers_2024,
    customers_converted_30d,
    conversion_rate_30d_pct
FROM state_summary
ORDER BY new_customers_2024 DESC, conversion_rate_30d_pct DESC
LIMIT 5;

