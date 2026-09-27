-- RetailPulse
-- 03_basic_analysis.sql
-- SQL-specific foundational analysis
--
-- Basic Pandas analysis is intentionally not repeated here.
-- These queries demonstrate reusable SQL patterns.

-- ------------------------------------------------------------
-- Conditional aggregation
-- ------------------------------------------------------------

SELECT
    category,
    COUNT(*) AS total_lines,
    SUM(CASE WHEN profit > 0 THEN 1 ELSE 0 END) AS profitable_lines,
    SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS loss_making_lines,
    SUM(CASE WHEN profit > 0 THEN profit ELSE 0 END)
        AS profit_from_profitable_lines,
    SUM(CASE WHEN profit < 0 THEN profit ELSE 0 END)
        AS loss_from_loss_making_lines
FROM sales_raw
GROUP BY category
ORDER BY category;

-- ------------------------------------------------------------
-- HAVING: products with negative aggregate profit
-- ------------------------------------------------------------

SELECT
    product_name,
    SUM(profit) AS total_profit
FROM sales_raw
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- ------------------------------------------------------------
-- Customer JOIN: customer attributes + transaction measures
-- ------------------------------------------------------------

SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM dim_customer c
JOIN fact_sales f
    ON c.customer_id = f.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.segment
ORDER BY total_sales DESC
LIMIT 10;
