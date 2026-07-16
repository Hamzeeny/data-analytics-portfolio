-- Q7: Review Ratings and Sales Performance
-- Group products based on their average review rating into High, Mid, and Low categories.
-- For each category, calculate the product count, total revenue, and average unit price.

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
            WHEN pr.avg_rating BETWEEN 3.0 AND 3.99 THEN 'Mid Rated'
            ELSE 'Low Rated'
        END AS rating_category
    FROM products p
    JOIN product_ratings pr
        ON p.product_id = pr.product_id
),

product_revenue AS (
    SELECT
        product_id,
        SUM(line_total) AS total_revenue
    FROM order_items
    GROUP BY product_id
)

SELECT
    rp.rating_category,
    COUNT(DISTINCT rp.product_id) AS product_count,
    ROUND(SUM(prv.total_revenue)::numeric, 2) AS total_revenue,
    ROUND(AVG(rp.unit_price)::numeric, 2) AS avg_unit_price
FROM rated_products rp
LEFT JOIN product_revenue prv
    ON rp.product_id = prv.product_id
GROUP BY rp.rating_category
ORDER BY total_revenue DESC;