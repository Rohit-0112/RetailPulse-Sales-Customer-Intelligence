-- RetailPulse
-- 04_business_analysis.sql
-- Business-focused SQL analysis

-- ------------------------------------------------------------
-- High-sales customers with negative total profit
-- ------------------------------------------------------------

SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM fact_sales f
JOIN dim_customer c
    ON f.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.segment
HAVING
    SUM(f.sales) > 5000
    AND SUM(f.profit) < 0
ORDER BY total_sales DESC;

-- ------------------------------------------------------------
-- Customers with highest order frequency
-- ------------------------------------------------------------

SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    COUNT(DISTINCT f.order_id) AS order_count,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM fact_sales f
JOIN dim_customer c
    ON f.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.segment
ORDER BY order_count DESC, total_sales DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Top 3 products by profit within each category
-- ------------------------------------------------------------

WITH product_ranks AS (
    SELECT
        category,
        product_name,
        SUM(profit) AS total_profit,
        RANK() OVER (
            PARTITION BY category
            ORDER BY SUM(profit) DESC
        ) AS profit_rank
    FROM sales_raw
    GROUP BY category, product_name
)
SELECT
    category,
    product_name,
    total_profit,
    profit_rank
FROM product_ranks
WHERE profit_rank <= 3
ORDER BY category, profit_rank;

-- ------------------------------------------------------------
-- Year-over-year sales growth
-- ------------------------------------------------------------

WITH yearly_sales AS (
    SELECT
        order_year,
        SUM(sales) AS total_sales
    FROM sales_raw
    GROUP BY order_year
),
sales_comparison AS (
    SELECT
        order_year,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY order_year
        ) AS previous_year_sales
    FROM yearly_sales
)
SELECT
    order_year,
    total_sales,
    previous_year_sales,
    ROUND(
        (total_sales - previous_year_sales)
        / NULLIF(previous_year_sales, 0) * 100,
        2
    ) AS yoy_growth_pct
FROM sales_comparison
ORDER BY order_year;
