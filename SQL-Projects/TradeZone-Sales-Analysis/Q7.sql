-- Q7: Review Ratings and Sales Performance
-- Group products based on their average review rating into High, Mid, and Low categories.
-- For each category, calculate the product count, total revenue, and average unit price.
-- Added: revenue per product, so bands with more products are compared fairly.
-- Revenue definition: orders with status Cancelled or Returned are excluded,
-- since that value was never retained. Revenue = Processing, Shipped and Delivered orders.

WITH product_ratings AS (
    SELECT
        product_id,
        ROUND(AVG(rating)::numeric, 2) AS avg_rating
    FROM reviews
    GROUP BY product_id
),

rated_products AS (
    SELECT
        p.product_id,
        p.unit_price,
        pr.avg_rating,
        CASE
            WHEN pr.avg_rating >= 4.0 THEN 'High Rated'
            WHEN pr.avg_rating >= 3.0 THEN 'Mid Rated'
            ELSE 'Low Rated'
        END AS rating_category
    FROM products p
    JOIN product_ratings pr
        ON p.product_id = pr.product_id
),

product_revenue AS (
    SELECT
        oi.product_id,
        SUM(oi.line_total) AS total_revenue
    FROM order_items oi
    JOIN orders o
        ON o.order_id = oi.order_id
    WHERE o.order_status NOT IN ('Cancelled', 'Returned')
    GROUP BY oi.product_id
)

SELECT
    rp.rating_category,
    COUNT(DISTINCT rp.product_id) AS product_count,
    ROUND(SUM(prv.total_revenue)::numeric, 2) AS total_revenue,
    ROUND((SUM(prv.total_revenue) / COUNT(DISTINCT rp.product_id))::numeric, 2) AS revenue_per_product,
    ROUND(AVG(rp.unit_price)::numeric, 2) AS avg_unit_price
FROM rated_products rp
LEFT JOIN product_revenue prv
    ON rp.product_id = prv.product_id
GROUP BY rp.rating_category
ORDER BY total_revenue DESC;
