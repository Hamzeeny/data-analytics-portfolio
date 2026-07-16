# TradeZone Sales Analysis — Technical Documentation

`SQL` `PostgreSQL` `Data Cleaning` `CTEs` `Window Functions` `Stakeholder Reporting`

For the business context and full findings, see the [main portfolio README](../../README.md#-tradezone-sales-analysis).

## Dataset

A PostgreSQL e-commerce database (TradeZone) with six related tables: `customers`, `sellers`, `products`, `orders`, `order_items`, `payments`, and `reviews`, covering activity from 2023–2024.

## Part 1: Data Cleaning & Quality Audit

### Missing Values Audit
Rather than checking columns one at a time, a single audit query used `UNION ALL` across every relevant column in every table to produce one consolidated report of null/blank counts — surfacing all data quality issues at once:
- `customers.email` → 16 missing
- `order_items.line_total` / `order_items.unit_price` → 97 missing each
- `orders.delivery_date` → 1,510 missing
- `orders.total_amount` → 150 missing
- `payments.amount` → 155 missing
- `products.unit_price` → 4 missing

### Handling Missing Product Prices
The 4 missing `products.unit_price` values required careful judgment rather than a default fill:
1. First checked whether the same product had a price recorded elsewhere in `order_items` — none did.
2. Considered filling with a **seller + category average**, but investigation showed some seller-category groups contained only one priced product — and in one case, that single product was a completely different item (e.g. a knife averaged against a bedsheet in the same seller/category group). Using that would produce an unrealistic estimate.
3. Instead, used a **category-level average** (across all sellers) for a more stable, representative estimate.
4. This decision — and the reasoning for rejecting the seller-level approach — is documented directly in the SQL comments, which is good practice for reproducibility.

### Cascading the Fix Downstream
Since `order_items.unit_price` and `line_total` depend on `products.unit_price`, missing values were resolved in dependency order:
1. Fixed `products.unit_price` (4 rows) using category averages.
2. Used the now-complete `products.unit_price` to fill missing `order_items.unit_price` (97 rows).
3. Recalculated `order_items.line_total = quantity × unit_price` for the same 97 rows.
4. Filled missing `orders.total_amount` (150 rows) by summing the now-complete `order_items.line_total` per order.

### Handling Missing Payment Amounts
Before filling `payments.amount` (155 missing), the relationship between `payments` and `orders` was validated first:
- Checked whether `order_id` was unique in `payments` — found 13 orders had multiple payment records.
- Compared `payments.amount` to `orders.total_amount` for orders with multiple payment rows, and found the **full order amount was duplicated across each row rather than split** between them.
- This validation confirmed that `orders.total_amount` was a safe, consistent source to fill missing `payments.amount` values from.

### Handling Missing Delivery Dates
Rather than imputing all 1,510 missing `delivery_date` values, the pattern was checked first: missing dates were expected for orders still `Processing`, `Cancelled`, or `Returned` — but some `Shipped` orders also had missing delivery dates, indicating a genuine data gap rather than a logical non-event. Since delivery dates can't be reliably inferred, these rows were **excluded from fulfilment-time analysis** rather than filled with a guess.

### Duplicates
Checked `customers`, `sellers`, and `orders` for duplicate records. One case of repeated customer names was found (with a missing email), but was **not deleted**, since a name match alone isn't sufficient evidence of duplication — removing it risked losing valid, distinct customer data.

### Formatting Standardization
- Standardized inconsistent `city` values (e.g. "lago s" → "Lagos", "port-harcourt"/"port harcourt" → "Port Harcourt") using `INITCAP`, `TRIM`, and explicit `CASE` mapping for known irregular spellings.
- Standardized inconsistent `category` values (e.g. "electronis" → "Electronics", "sports" → "Sports & Fitness") the same way.
- Verified all date columns used appropriate PostgreSQL types (`DATE` vs. `TIMESTAMP` for `payment_date`), requiring no further conversion.

### Data Validation
- Flagged orders where `orders.total_amount` differed from the summed `order_items.line_total` by more than ₦10 — these were **not overwritten**, since some line-item values were themselves imputed, and the original order total was treated as the source of truth.
- Found and removed 5 review records with out-of-range ratings (below 1 or above 5), treating them as data entry errors.

## Part 2: Analytical Queries (Q1–Q8)

**Q1 — Customer Acquisition & 30-Day Conversion**
Found the top 5 states by 2024 sign-ups, then used a correlated `EXISTS` subquery to flag whether each customer placed an order within 30 days of signing up, aggregating to a state-level conversion rate.

**Q2 — Product Performance**
Joined `orders`, `order_items`, and `products` to find the top 10 products by 2024 revenue, including order count per product.

**Q3 — Seller Fulfilment Efficiency**
Calculated average fulfilment time (order to delivery, in hours) per seller, restricted to sellers with at least 20 completed orders (`HAVING COUNT(*) >= 20`), and joined in average customer rating via a separate CTE.

**Q4 — Quarterly Revenue Trends**
Aggregated revenue, average order value, and order count by year/quarter, then used a **pivot-style CTE** (`SUM(CASE WHEN year = ... THEN ... END)`) to compare each quarter's 2023 vs. 2024 revenue side by side and identify the quarter with the highest growth.

**Q5 — Customer Spend Segmentation**
Segmented customers into High/Medium/Low spenders using a `CASE` statement on total 2024 spend, then calculated customer count, average spend, and total revenue contribution per segment.

**Q6 — Payment Method Preferences by State**
Aggregated transaction count and total amount per state/payment-method combination, then used `ROW_NUMBER() OVER (PARTITION BY state ORDER BY transaction_count DESC)` to flag the single most popular payment method per state.

**Q7 — Review Ratings and Sales Performance**
Grouped products into High/Mid/Low rated categories based on average review rating, then compared total revenue and average unit price across the three groups.

**Q8 — Top Seller Bonus Qualification**
Identified the top 10 sellers by 2024 revenue, restricted to those with at least 10 completed orders **and** an average rating of 4.0+ — combining a volume threshold and a quality threshold in the same qualification query.

## Key Design Decisions

- **Investigated before imputing** — for every missing-value decision, the underlying pattern was checked first (e.g. whether missing values clustered by order status, whether a seller-category group had enough real data to average) rather than applying a default fill blindly.
- **Rejected an imputation method that looked reasonable but wasn't** — the seller-level price average was discarded once it was shown to produce an unrealistic result (averaging unrelated products), in favor of the more stable category-level average.
- **Didn't force-fix everything** — flagged discrepancies and left `NULL` values in place (delivery dates, total_amount mismatches) where a confident fix wasn't possible, rather than guessing.
- Used `UNION ALL` for a single consolidated audit query instead of running dozens of separate `COUNT` queries — more efficient and easier to review at a glance.

## Files in This Folder
- `cleaned_dump.sql` — cleaned database dump used as the basis for all analytical queries
- `part_1.sql` — full data cleaning and quality audit script
- `q1.sql` through `q8.sql` — the 8 analytical queries
- `analyst_memo.pdf` — stakeholder-facing memo with executive summary, findings, and recommendations

⬅️ [Back to main portfolio](../../README.md)
