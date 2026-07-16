-- =========================================================
-- MISSING VALUES / BLANKS AUDIT ACROSS ALL TABLES
-- Checks NULLs and blank strings in relevant columns
-- =========================================================

SELECT 'customers' AS table_name, 'customer_id' AS column_name,
       COUNT(*) AS total_rows,
       COUNT(*) FILTER (WHERE customer_id IS NULL OR TRIM(customer_id) = '') AS missing_count
FROM customers

UNION ALL
SELECT 'customers', 'first_name',
       COUNT(*),
       COUNT(*) FILTER (WHERE first_name IS NULL OR TRIM(first_name) = '')
FROM customers

UNION ALL
SELECT 'customers', 'last_name',
       COUNT(*),
       COUNT(*) FILTER (WHERE last_name IS NULL OR TRIM(last_name) = '')
FROM customers

UNION ALL
SELECT 'customers', 'email',
       COUNT(*),
       COUNT(*) FILTER (WHERE email IS NULL OR TRIM(email) = '')
FROM customers

UNION ALL
SELECT 'customers', 'city',
       COUNT(*),
       COUNT(*) FILTER (WHERE city IS NULL OR TRIM(city) = '')
FROM customers

UNION ALL
SELECT 'customers', 'state',
       COUNT(*),
       COUNT(*) FILTER (WHERE state IS NULL OR TRIM(state) = '')
FROM customers

UNION ALL
SELECT 'customers', 'signup_date',
       COUNT(*),
       COUNT(*) FILTER (WHERE signup_date IS NULL)
FROM customers

UNION ALL
SELECT 'customers', 'account_status',
       COUNT(*),
       COUNT(*) FILTER (WHERE account_status IS NULL OR TRIM(account_status) = '')
FROM customers


UNION ALL
SELECT 'sellers', 'seller_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE seller_id IS NULL OR TRIM(seller_id) = '')
FROM sellers

UNION ALL
SELECT 'sellers', 'seller_name',
       COUNT(*),
       COUNT(*) FILTER (WHERE seller_name IS NULL OR TRIM(seller_name) = '')
FROM sellers

UNION ALL
SELECT 'sellers', 'onboarding_date',
       COUNT(*),
       COUNT(*) FILTER (WHERE onboarding_date IS NULL)
FROM sellers

UNION ALL
SELECT 'sellers', 'product_category',
       COUNT(*),
       COUNT(*) FILTER (WHERE product_category IS NULL OR TRIM(product_category) = '')
FROM sellers

UNION ALL
SELECT 'sellers', 'city',
       COUNT(*),
       COUNT(*) FILTER (WHERE city IS NULL OR TRIM(city) = '')
FROM sellers

UNION ALL
SELECT 'sellers', 'state',
       COUNT(*),
       COUNT(*) FILTER (WHERE state IS NULL OR TRIM(state) = '')
FROM sellers

UNION ALL
SELECT 'sellers', 'account_status',
       COUNT(*),
       COUNT(*) FILTER (WHERE account_status IS NULL OR TRIM(account_status) = '')
FROM sellers


UNION ALL
SELECT 'products', 'product_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE product_id IS NULL OR TRIM(product_id) = '')
FROM products

UNION ALL
SELECT 'products', 'product_name',
       COUNT(*),
       COUNT(*) FILTER (WHERE product_name IS NULL OR TRIM(product_name) = '')
FROM products

UNION ALL
SELECT 'products', 'category',
       COUNT(*),
       COUNT(*) FILTER (WHERE category IS NULL OR TRIM(category) = '')
FROM products

UNION ALL
SELECT 'products', 'unit_price',
       COUNT(*),
       COUNT(*) FILTER (WHERE unit_price IS NULL)
FROM products

UNION ALL
SELECT 'products', 'seller_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE seller_id IS NULL OR TRIM(seller_id) = '')
FROM products


UNION ALL
SELECT 'orders', 'order_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE order_id IS NULL OR TRIM(order_id) = '')
FROM orders

UNION ALL
SELECT 'orders', 'customer_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE customer_id IS NULL OR TRIM(customer_id) = '')
FROM orders

UNION ALL
SELECT 'orders', 'seller_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE seller_id IS NULL OR TRIM(seller_id) = '')
FROM orders

UNION ALL
SELECT 'orders', 'order_date',
       COUNT(*),
       COUNT(*) FILTER (WHERE order_date IS NULL)
FROM orders

UNION ALL
SELECT 'orders', 'delivery_date',
       COUNT(*),
       COUNT(*) FILTER (WHERE delivery_date IS NULL)
FROM orders

UNION ALL
SELECT 'orders', 'order_status',
       COUNT(*),
       COUNT(*) FILTER (WHERE order_status IS NULL OR TRIM(order_status) = '')
FROM orders

UNION ALL
SELECT 'orders', 'total_amount',
       COUNT(*),
       COUNT(*) FILTER (WHERE total_amount IS NULL)
FROM orders


UNION ALL
SELECT 'order_items', 'order_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE order_id IS NULL OR TRIM(order_id) = '')
FROM order_items

UNION ALL
SELECT 'order_items', 'product_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE product_id IS NULL OR TRIM(product_id) = '')
FROM order_items

UNION ALL
SELECT 'order_items', 'quantity',
       COUNT(*),
       COUNT(*) FILTER (WHERE quantity IS NULL)
FROM order_items

UNION ALL
SELECT 'order_items', 'unit_price',
       COUNT(*),
       COUNT(*) FILTER (WHERE unit_price IS NULL)
FROM order_items

UNION ALL
SELECT 'order_items', 'line_total',
       COUNT(*),
       COUNT(*) FILTER (WHERE line_total IS NULL)
FROM order_items


UNION ALL
SELECT 'payments', 'payment_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE payment_id IS NULL OR TRIM(payment_id) = '')
FROM payments

UNION ALL
SELECT 'payments', 'order_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE order_id IS NULL OR TRIM(order_id) = '')
FROM payments

UNION ALL
SELECT 'payments', 'payment_method',
       COUNT(*),
       COUNT(*) FILTER (WHERE payment_method IS NULL OR TRIM(payment_method) = '')
FROM payments

UNION ALL
SELECT 'payments', 'amount',
       COUNT(*),
       COUNT(*) FILTER (WHERE amount IS NULL)
FROM payments

UNION ALL
SELECT 'payments', 'payment_date',
       COUNT(*),
       COUNT(*) FILTER (WHERE payment_date IS NULL)
FROM payments


UNION ALL
SELECT 'reviews', 'review_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE review_id IS NULL OR TRIM(review_id) = '')
FROM reviews

UNION ALL
SELECT 'reviews', 'product_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE product_id IS NULL OR TRIM(product_id) = '')
FROM reviews

UNION ALL
SELECT 'reviews', 'customer_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE customer_id IS NULL OR TRIM(customer_id) = '')
FROM reviews

UNION ALL
SELECT 'reviews', 'order_id',
       COUNT(*),
       COUNT(*) FILTER (WHERE order_id IS NULL OR TRIM(order_id) = '')
FROM reviews

UNION ALL
SELECT 'reviews', 'rating',
       COUNT(*),
       COUNT(*) FILTER (WHERE rating IS NULL)
FROM reviews

UNION ALL
SELECT 'reviews', 'review_date',
       COUNT(*),
       COUNT(*) FILTER (WHERE review_date IS NULL)
FROM reviews

ORDER BY table_name, column_name;
-- missing values found;
-- customers.email → 16, order_items.line_total → 97, order_items.unit_price → 97, orders.delivery_date → 1510, 
-- orders.total_amount → 150, payments.amount → 155, products.unit_price → 4

SELECT *
FROM customers
WHERE email IS NULL OR TRIM(email) = '';


SELECT *
FROM order_items
WHERE unit_price IS NULL;

SELECT *
FROM order_items
WHERE unit_price IS NULL;

-- both unit price and line total are dependent on each other and both largely depend on products.unit_price 
-- (the 4 missing values therein) as shown below;
SELECT oi.product_id,
       COUNT(*) AS affected_order_items,
       SUM(oi.quantity) AS total_units_affected
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE p.unit_price IS NULL
GROUP BY oi.product_id
ORDER BY affected_order_items DESC;

-- checking if those 4 products have unit_price available somewhere in the order_items table
SELECT product_id,
       COUNT(unit_price) AS non_null_prices,
       AVG(unit_price) AS avg_price,
       MIN(unit_price) AS min_price,
       MAX(unit_price) AS max_price
FROM order_items
WHERE product_id IN ('PROD0088','PROD0104','PROD0205','PROD0245')
GROUP BY product_id;
-- none has recorded unit_price

-- checking the category of the products with missing unit_prices
SELECT product_id, product_name, category, seller_id, unit_price
FROM products
WHERE product_id IN ('PROD0088','PROD0104','PROD0205','PROD0245');

-- trying to see if it can be filled with the category_seller average
SELECT category,
       seller_id,
       COUNT(*) AS product_count,
       ROUND(AVG(unit_price)::numeric, 2) AS avg_price
FROM products
WHERE unit_price IS NOT NULL
GROUP BY category, seller_id
ORDER BY category;
-- found irregularities in the category names, so fixing that first;
UPDATE products
SET category = CASE
    WHEN LOWER(TRIM(category)) IN ('beauty', 'beauty & personal care', 'beauty and personal care')
        THEN 'Beauty & Personal Care'
    WHEN LOWER(TRIM(category)) IN ('books', 'books & stationery', 'books and stationery')
        THEN 'Books & Stationery'
    WHEN LOWER(TRIM(category)) IN ('electronics', 'electronis')
        THEN 'Electronics'
    WHEN LOWER(TRIM(category)) IN ('fashion', 'fashon')
        THEN 'Fashion'
    WHEN LOWER(TRIM(category)) IN ('food', 'food & beverages', 'food and beverages')
        THEN 'Food & Beverages'
    WHEN LOWER(TRIM(category)) IN ('home & garden', 'home and garden')
        THEN 'Home & Garden'
    WHEN LOWER(TRIM(category)) IN ('sports', 'sports & fitness', 'sports and fitness')
        THEN 'Sports & Fitness'
    ELSE INITCAP(TRIM(category))
END;
-- fixed

-- trying to see if the products with missing prices even have category/seller duplicate(s) so as to fill with the average
SELECT p.product_id,
       p.product_name,
       p.category,
       p.seller_id,
       COUNT(p2.product_id) AS priced_peer_products_same_seller_category
FROM products p
LEFT JOIN products p2
  ON p.category = p2.category
 AND p.seller_id = p2.seller_id
 AND p2.unit_price IS NOT NULL
WHERE p.product_id IN ('PROD0088', 'PROD0104', 'PROD0205', 'PROD0245')
GROUP BY p.product_id, p.product_name, p.category, p.seller_id
ORDER BY p.product_id;
-- only one product does

select * 
from products
where category = 'Home & Garden' and seller_id = 'SELL071';
-- one product is a knife and the other is a bedsheet
-- Missing product prices will not be imputed using seller-level averages
-- because some seller-category groups contained only a single priced product,
-- which could lead to unrealistic assumptions (e.g., using a bedsheet price for a knife).
-- Instead, category-level averages will be used to provide a more stable and representative estimate'

UPDATE products p
SET unit_price = c.avg_price
FROM (
    SELECT category,
           ROUND(AVG(unit_price)::numeric, 2) AS avg_price
    FROM products
    WHERE unit_price IS NOT NULL
    GROUP BY category
) c
WHERE p.category = c.category
  AND p.unit_price IS NULL;
-- 4 missing unit_prices updated
-- confirming....
SELECT COUNT(*)
FROM products
WHERE unit_price IS NULL;
-- yess!

-- handling missing values in order_items table(unit_price and line_total respectively);
UPDATE order_items oi
SET unit_price = p.unit_price
FROM products p
WHERE oi.product_id = p.product_id
  AND oi.unit_price IS NULL;
-- 97 missing values updated

UPDATE order_items
SET line_total = quantity * unit_price
WHERE line_total IS NULL;
-- 97 missing values updated

-- handling missing values in orders.total_amount
UPDATE orders o
SET total_amount = sub.total
FROM (
    SELECT order_id, SUM(line_total) AS total
    FROM order_items
    WHERE line_total IS NOT NULL
    GROUP BY order_id
) sub
WHERE o.order_id = sub.order_id
  AND o.total_amount IS NULL;
-- 150 missing values updated

-- remaining the 155 missing payments.amount
select *
from payments
--where amount is null;

-- checking the uniquenesss of order_ids
SELECT order_id, COUNT(*) AS payment_count
FROM payments
GROUP BY order_id
ORDER BY payment_count DESC;

SELECT p.order_id,
       COUNT(*) AS payment_count
FROM payments p
WHERE p.amount IS NULL
GROUP BY p.order_id
ORDER BY payment_count DESC;

SELECT order_id
      FROM payments
      GROUP BY order_id
      HAVING COUNT(*) = 1;

SELECT order_id, amount
      FROM payments
      GROUP BY order_id, amount
      HAVING COUNT(*) > 1;
-- 13 order_ids are not unique in the payments_table

-- confirming that payment.amount is supposed to be the same thing as orders.total_amount
select amount, total_amount
from payments p
join orders o
on p.order_id = o.order_id;


-- validation
SELECT o.order_id,
       o.total_amount,
       SUM(p.amount) AS total_payment_amount,
       o.total_amount - SUM(p.amount) AS difference
FROM orders o
JOIN payments p
  ON o.order_id = p.order_id
WHERE p.amount IS NOT NULL
GROUP BY o.order_id, o.total_amount
ORDER BY ABS(o.total_amount - SUM(p.amount)) DESC;
-- Missing values in payments.amount will be imputed using orders.total_amount.
-- Validation showed that for orders with multiple(2) payment records,
-- the full order amount is duplicated across rows rather than split.
-- Therefore, using orders.total_amount provides a consistent and accurate fill.

-- filling the missing amounts in the payments table using orders.total_amount
UPDATE payments p
SET amount = o.total_amount
FROM orders o
WHERE p.order_id = o.order_id
  AND p.amount IS NULL;
-- 155 missing values updated

-- delivery_date(1510 missing)
SELECT order_status, COUNT(*) AS cnt
FROM orders
WHERE delivery_date IS NULL
GROUP BY order_status
ORDER BY cnt DESC;
-- delivery_date contains NULL values across multiple order statuses.
-- Missing values are expected for Processing, Cancelled, and Returned orders.
-- However, some Shipped orders also have NULL delivery dates, indicating potential data incompleteness.
-- No imputation was performed, as delivery dates cannot be reliably inferred.
-- Orders with NULL delivery_date will be excluded from fulfilment time analysis.

-- Email (16 missing)
-- Missing customer email values were retained as NULL.
-- Email is not required for the analytical questions in this task,
-- and cannot be reliably inferred without risking duplicate or incorrect entries.


-- =========================================================
-- DUPLICATE RECORDS...
-- In Customers, sellers and orders 
-- =========================================================
-- Customers
SELECT first_name, last_name, email, COUNT(*)
FROM customers
GROUP BY first_name, last_name, email
HAVING COUNT(*) > 1;
-- Duplicate check identified one case of repeated customer names (Tunde Adeyemi) where email was NULL.
-- These records were not removed because names alone are not sufficient to confirm duplication,
-- and deleting them could result in loss of valid customer data.

--Sellers
SELECT seller_name, COUNT(*)
FROM sellers
GROUP BY seller_name
HAVING COUNT(*) > 1;
-- found none

-- Orders
SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
-- found none


-- =========================================================
-- Inconsistent Formatting 
-- =========================================================
-- City
UPDATE customers
SET city = INITCAP(TRIM(city))
WHERE city IS NOT NULL;

SELECT city, COUNT(*)
FROM customers
GROUP BY city
ORDER BY city;
-- found further irregularities

UPDATE customers
SET city = CASE
    WHEN LOWER(TRIM(city)) IN ('lago s') 
        THEN 'Lagos'
        
    WHEN LOWER(TRIM(city)) IN ('port-harcourt', 'port harcourt', 'portharcourt') 
        THEN 'Port Harcourt'
        
    ELSE INITCAP(TRIM(city))
END
WHERE city IS NOT NULL;

-- Date
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name IN ('customers', 'orders', 'reviews', 'payments')
  AND column_name IN ('signup_date', 'order_date', 'delivery_date', 'review_date', 'payment_date')
ORDER BY table_name, column_name;
-- Date columns were reviewed and confirmed to be stored using appropriate data types.
-- Most date fields are stored as DATE, while payment_date is stored as TIMESTAMP,
-- which includes both date and time information.
-- Since PostgreSQL enforces consistent internal date representation,
-- no additional formatting or conversion was required.

--categories have been regularized during cleaning using;
-- UPDATE products
-- SET category = CASE
--     WHEN LOWER(TRIM(category)) IN ('beauty', 'beauty & personal care', 'beauty and personal care')
--         THEN 'Beauty & Personal Care'
--     WHEN LOWER(TRIM(category)) IN ('books', 'books & stationery', 'books and stationery')
--         THEN 'Books & Stationery'
--     WHEN LOWER(TRIM(category)) IN ('electronics', 'electronis')
--         THEN 'Electronics'
--     WHEN LOWER(TRIM(category)) IN ('fashion', 'fashon')
--         THEN 'Fashion'
--     WHEN LOWER(TRIM(category)) IN ('food', 'food & beverages', 'food and beverages')
--         THEN 'Food & Beverages'
--     WHEN LOWER(TRIM(category)) IN ('home & garden', 'home and garden')
--         THEN 'Home & Garden'
--     WHEN LOWER(TRIM(category)) IN ('sports', 'sports & fitness', 'sports and fitness')
--         THEN 'Sports & Fitness'
--     ELSE INITCAP(TRIM(category))
-- END;


-- =========================================================
-- Data Validation 
-- =========================================================
SELECT o.order_id,
       o.total_amount,
       SUM(oi.line_total) AS calculated_total,
       ABS(o.total_amount - SUM(oi.line_total)) AS difference,
	   'FLAGGED' AS validation_status
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
  GROUP BY o.order_id, o.total_amount
  HAVING ABS(o.total_amount - SUM(oi.line_total)) > 10
  ORDER BY difference DESC;
-- Orders with differences greater than ₦10 between stored total_amount
-- and summed order_items line totals were flagged for review.
-- These rows were not overwritten automatically because some line-item values
-- were imputed and may not reflect original transaction prices.

SELECT *
FROM reviews
WHERE rating < 1
   OR rating > 5;
-- found 5
DELETE FROM reviews
WHERE rating < 1
   OR rating > 5;
   
SELECT *
FROM reviews
WHERE rating < 1
   OR rating > 5;
-- Review ratings were validated to ensure they fall within the acceptable range (1–5).
-- A small number of records with invalid ratings (e.g., -1, 0, 7) were identified
-- and removed, as they likely represent data entry errors and could distort analysis.

SELECT *
FROM products
WHERE unit_price < 0;
-- none found

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'products';
-- Discount percentage validation was not performed because no discount-related column exists in the products table.
