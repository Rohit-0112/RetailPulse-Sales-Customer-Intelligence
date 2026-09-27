-- RetailPulse
-- 05_advanced_analysis.sql
-- Advanced SQL patterns and analytical queries

-- ------------------------------------------------------------
-- 1. Product loss concentration
-- Which loss-making product IDs contribute most to aggregate losses?
-- ------------------------------------------------------------

WITH product_losses AS (
    SELECT
        product_id,
        SUM(profit) AS total_profit
    FROM fact_sales
    GROUP BY product_id
    HAVING SUM(profit) < 0
),
loss_summary AS (
    SELECT
        product_id,
        total_profit,
        SUM(total_profit) OVER () AS total_loss
    FROM product_losses
)
SELECT
    product_id,
    total_profit,
    ROUND(
        ABS(total_profit) / ABS(total_loss) * 100,
        2
    ) AS loss_share_pct
FROM loss_summary
ORDER BY total_profit
LIMIT 10;

-- ------------------------------------------------------------
-- 2. Latest order for each customer
-- ROW_NUMBER() pattern
-- ------------------------------------------------------------

WITH ranked_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS rn
    FROM fact_sales
)
SELECT
    customer_id,
    order_id,
    order_date
FROM ranked_orders
WHERE rn = 1
ORDER BY order_date DESC;

-- ------------------------------------------------------------
-- 3. Customer profit rank within segment
-- DENSE_RANK() pattern
-- ------------------------------------------------------------

WITH customer_profit AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.segment,
        SUM(f.profit) AS total_profit
    FROM fact_sales f
    JOIN dim_customer c
        ON f.customer_id = c.customer_id
    GROUP BY
        c.customer_id,
        c.customer_name,
        c.segment
)
SELECT
    customer_id,
    customer_name,
    segment,
    total_profit,
    DENSE_RANK() OVER (
        PARTITION BY segment
        ORDER BY total_profit DESC
    ) AS segment_profit_rank
FROM customer_profit
ORDER BY segment, segment_profit_rank;

-- ------------------------------------------------------------
-- 4. Customers above average customer sales
-- Subquery + HAVING pattern
-- ------------------------------------------------------------

SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    SUM(f.sales) AS total_sales
FROM fact_sales f
JOIN dim_customer c
    ON f.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.segment
HAVING SUM(f.sales) > (
    SELECT AVG(customer_sales)
    FROM (
        SELECT
            customer_id,
            SUM(sales) AS customer_sales
        FROM fact_sales
        GROUP BY customer_id
    ) AS customer_totals
)
ORDER BY total_sales DESC;

-- ------------------------------------------------------------
-- 5. Monthly running sales total
-- SUM() OVER() pattern
-- ------------------------------------------------------------

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM(sales) AS monthly_sales
    FROM fact_sales
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    sales_month,
    monthly_sales,
    SUM(monthly_sales) OVER (
        ORDER BY sales_month
    ) AS cumulative_sales
FROM monthly_sales
ORDER BY sales_month;

-- ------------------------------------------------------------
-- 6. Rolling 3-month sales average
-- Window frame pattern
-- ------------------------------------------------------------

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM(sales) AS monthly_sales
    FROM fact_sales
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    sales_month,
    monthly_sales,
    ROUND(
        AVG(monthly_sales) OVER (
            ORDER BY sales_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS rolling_3_month_avg
FROM monthly_sales
ORDER BY sales_month;

-- ------------------------------------------------------------
-- 7. Year-over-year sales comparison
-- LAG() window function
-- ------------------------------------------------------------

WITH yearly_sales AS (
    SELECT
        order_year,
        SUM(sales) AS total_sales
    FROM sales_raw
    GROUP BY order_year
)
SELECT
    order_year,
    total_sales,
    LAG(total_sales) OVER (
        ORDER BY order_year
    ) AS previous_year_sales
FROM yearly_sales
ORDER BY order_year;
