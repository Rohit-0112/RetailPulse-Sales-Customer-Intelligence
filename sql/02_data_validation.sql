-- RetailPulse
-- 02_data_validation.sql
-- Data and model validation checks

-- ------------------------------------------------------------
-- Source table checks
-- ------------------------------------------------------------

SELECT COUNT(*) AS row_count
FROM sales_raw;

SELECT COUNT(*) AS null_key_count
FROM sales_raw
WHERE row_id IS NULL
   OR order_id IS NULL
   OR order_date IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL;

SELECT
    COUNT(*) AS duplicate_row_ids
FROM (
    SELECT row_id
    FROM sales_raw
    GROUP BY row_id
    HAVING COUNT(*) > 1
) d;

SELECT
    MIN(order_date) AS min_order_date,
    MAX(order_date) AS max_order_date,
    MIN(ship_date) AS min_ship_date,
    MAX(ship_date) AS max_ship_date
FROM sales_raw;

SELECT
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    MIN(discount) AS min_discount,
    MAX(discount) AS max_discount,
    MIN(sales) AS min_sales,
    MAX(sales) AS max_sales
FROM sales_raw;

-- ------------------------------------------------------------
-- Customer dimension validation
-- ------------------------------------------------------------

SELECT COUNT(*) AS customer_count
FROM dim_customer;

SELECT COUNT(*) AS unmatched_customers
FROM sales_raw s
LEFT JOIN dim_customer c
    ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- ------------------------------------------------------------
-- Product dimension validation
-- ------------------------------------------------------------

SELECT COUNT(*) AS product_dimension_rows
FROM dim_product;

SELECT
    product_id,
    COUNT(DISTINCT product_name) AS product_name_count
FROM sales_raw
GROUP BY product_id
HAVING COUNT(DISTINCT product_name) > 1
ORDER BY product_name_count DESC, product_id;

SELECT COUNT(*) AS unmatched_products
FROM sales_raw s
LEFT JOIN dim_product p
    ON s.product_id = p.product_id
WHERE p.product_id IS NULL;

-- ------------------------------------------------------------
-- Date dimension validation
-- ------------------------------------------------------------

SELECT
    MIN(date_key) AS start_date,
    MAX(date_key) AS end_date,
    COUNT(*) AS date_rows
FROM dim_date;

SELECT COUNT(*) AS unmatched_dates
FROM sales_raw s
LEFT JOIN dim_date d
    ON s.order_date = d.date_key
WHERE d.date_key IS NULL;

-- ------------------------------------------------------------
-- Fact grain and reconciliation
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS sales_rows,
    COUNT(DISTINCT order_id) AS distinct_orders,
    ROUND(
        COUNT(*)::NUMERIC / COUNT(DISTINCT order_id),
        2
    ) AS avg_lines_per_order
FROM sales_raw;

SELECT
    COUNT(*) AS fact_rows,
    COUNT(DISTINCT order_id) AS distinct_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM fact_sales;

SELECT
    COUNT(*) AS fact_rows,
    COUNT(c.customer_id) AS matched_customers,
    COUNT(d.date_key) AS matched_dates
FROM fact_sales f
LEFT JOIN dim_customer c
    ON f.customer_id = c.customer_id
LEFT JOIN dim_date d
    ON f.order_date = d.date_key;

-- Final source-to-fact reconciliation
SELECT
    (SELECT COUNT(*) FROM sales_raw) AS raw_rows,
    (SELECT COUNT(*) FROM fact_sales) AS fact_rows,
    (SELECT SUM(sales) FROM sales_raw) AS raw_sales,
    (SELECT SUM(sales) FROM fact_sales) AS fact_sales,
    (SELECT SUM(profit) FROM sales_raw) AS raw_profit,
    (SELECT SUM(profit) FROM fact_sales) AS fact_profit;
