-- Q2: Product Performance
-- Identify the top 10 products by total revenue in 2024.
-- Include product name, category, total revenue, and total number of orders.
-- Sort results by revenue in descending order.

SELECT
    p.product_id,
    p.product_name,
    p.category,
    ROUND(SUM(oi.line_total)::numeric, 2) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_date >= DATE '2024-01-01'
  AND o.order_date < DATE '2025-01-01'
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_revenue DESC
LIMIT 10;