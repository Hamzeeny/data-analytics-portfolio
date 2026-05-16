-- Q8: Top Seller Bonus Qualification
-- Identify the top 10 sellers in 2024 by total revenue who completed at least 10 orders
-- and have an average customer rating of 4.0 or above.
-- Include total orders, average rating, and total revenue.

WITH seller_orders AS (
    SELECT
        seller_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(total_amount) AS total_revenue
    FROM orders
    WHERE order_date >= DATE '2024-01-01'
      AND order_date < DATE '2025-01-01'
      AND order_status = 'Delivered'
    GROUP BY seller_id
),

seller_ratings AS (
    SELECT
        o.seller_id,
        ROUND(AVG(r.rating)::numeric, 2) AS avg_rating
    FROM reviews r
    JOIN orders o
        ON r.order_id = o.order_id
    GROUP BY o.seller_id
)

SELECT
    so.seller_id,
    s.seller_name,
    so.total_orders,
    sr.avg_rating,
    ROUND(so.total_revenue::numeric, 2) AS total_revenue
FROM seller_orders so
JOIN seller_ratings sr
    ON so.seller_id = sr.seller_id
JOIN sellers s
    ON so.seller_id = s.seller_id
WHERE so.total_orders >= 10
  AND sr.avg_rating >= 4.0
ORDER BY so.total_revenue DESC
LIMIT 10;