-- Q6: Payment Method Preferences by State
-- Analyse payment method preferences across each state.
-- For each state, show the transaction count and total amount for each payment method,
-- and identify the most popular method per state.

WITH payment_summary AS (
    SELECT
        c.state,
        p.payment_method,
        COUNT(*) AS transaction_count,
        ROUND(SUM(p.amount)::numeric, 2) AS total_amount
    FROM payments p
    JOIN orders o
        ON p.order_id = o.order_id
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY
        c.state,
        p.payment_method
),

ranked_methods AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY state
            ORDER BY transaction_count DESC
        ) AS rank
    FROM payment_summary
)

SELECT
    state,
    payment_method,
    transaction_count,
    total_amount,
    CASE
        WHEN rank = 1 THEN 'Most Popular'
        ELSE ''
    END AS popularity_flag
FROM ranked_methods
ORDER BY
    state,
    transaction_count DESC;