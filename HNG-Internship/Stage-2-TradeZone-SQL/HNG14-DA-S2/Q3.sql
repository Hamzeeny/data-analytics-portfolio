-- Q3: Seller Fulfilment Efficiency
-- Calculate the average time in hours between order placement and delivery for each seller.
-- Return the top 20 sellers with the fastest average fulfilment times among sellers
-- who have completed at least 20 orders, including their total completed orders
-- and average customer rating.

WITH completed_orders AS (
    SELECT
        o.order_id,
        o.seller_id,
        ((o.delivery_date - o.order_date) * 24) AS fulfilment_hours
    FROM orders o
    WHERE o.order_status = 'Delivered'
),

seller_fulfilment AS (
    SELECT
        seller_id,
        COUNT(*) AS total_completed_orders,
        ROUND(AVG(fulfilment_hours)::numeric, 2) AS avg_fulfilment_hours
    FROM completed_orders
    GROUP BY seller_id
    HAVING COUNT(*) >= 20
),

seller_ratings AS (
    SELECT
        o.seller_id,
        ROUND(AVG(r.rating)::numeric, 2) AS avg_customer_rating
    FROM reviews r
    JOIN orders o
        ON r.order_id = o.order_id
    GROUP BY o.seller_id
)

SELECT
    sf.seller_id,
    s.seller_name,
    sf.total_completed_orders,
    sf.avg_fulfilment_hours,
    sr.avg_customer_rating
FROM seller_fulfilment sf
JOIN sellers s
    ON sf.seller_id = s.seller_id
LEFT JOIN seller_ratings sr
    ON sf.seller_id = sr.seller_id
ORDER BY sf.avg_fulfilment_hours ASC
LIMIT 20;