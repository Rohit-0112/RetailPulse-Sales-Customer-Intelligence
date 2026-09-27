-- RetailPulse
-- 01_database_setup.sql
-- PostgreSQL database and analytical model setup

-- Database creation is normally executed from the default postgres database:
-- CREATE DATABASE retailpulse;
-- Then connect to it:
-- \c retailpulse

-- ------------------------------------------------------------
-- 1. Source / staging table
-- ------------------------------------------------------------

CREATE TABLE sales_raw (
    row_id INTEGER,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    shipping_days INTEGER,
    ship_mode VARCHAR(30),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    country VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code INTEGER,
    region VARCHAR(30),
    product_id VARCHAR(30),
    product_name VARCHAR(255),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    sales NUMERIC(14,4),
    quantity INTEGER,
    discount NUMERIC(5,2),
    profit NUMERIC(14,4),
    profit_margin NUMERIC(8,4),
    order_year INTEGER,
    order_month INTEGER
);

-- Load the cleaned CSV. Adjust the path for your local machine.
-- \copy sales_raw FROM 'C:/Users/yadav/Desktop/RetailPulse/data/processed/retailpulse_clean.csv'
-- WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

-- ------------------------------------------------------------
-- 2. Customer dimension
-- ------------------------------------------------------------

CREATE TABLE dim_customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(30)
);

INSERT INTO dim_customer (customer_id, customer_name, segment)
SELECT DISTINCT
    customer_id,
    customer_name,
    segment
FROM sales_raw;

-- ------------------------------------------------------------
-- 3. Product dimension
-- ------------------------------------------------------------
-- Product ID was found to map to multiple product names for
-- 32 IDs. Therefore product_id cannot be the primary key here.
-- A surrogate product_key preserves the source records.

CREATE TABLE dim_product (
    product_id VARCHAR(30),
    product_name VARCHAR(255),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

ALTER TABLE dim_product
ADD COLUMN product_key SERIAL PRIMARY KEY;

INSERT INTO dim_product (
    product_id,
    product_name,
    category,
    sub_category
)
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM sales_raw;

-- ------------------------------------------------------------
-- 4. Date dimension
-- ------------------------------------------------------------

CREATE TABLE dim_date (
    date_key DATE PRIMARY KEY,
    year INTEGER,
    month INTEGER,
    month_name VARCHAR(20),
    quarter INTEGER
);

INSERT INTO dim_date (
    date_key,
    year,
    month,
    month_name,
    quarter
)
SELECT
    d::DATE AS date_key,
    EXTRACT(YEAR FROM d)::INTEGER AS year,
    EXTRACT(MONTH FROM d)::INTEGER AS month,
    TO_CHAR(d, 'Month') AS month_name,
    EXTRACT(QUARTER FROM d)::INTEGER AS quarter
FROM generate_series(
    (SELECT MIN(order_date) FROM sales_raw),
    (SELECT MAX(order_date) FROM sales_raw),
    INTERVAL '1 day'
) AS d;

-- ------------------------------------------------------------
-- 5. Fact table
-- Grain: one product line within an order
-- ------------------------------------------------------------

CREATE TABLE fact_sales (
    row_id INTEGER PRIMARY KEY,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    customer_id VARCHAR(20),
    product_id VARCHAR(30),
    ship_mode VARCHAR(30),
    region VARCHAR(30),
    sales NUMERIC(14,4),
    quantity INTEGER,
    discount NUMERIC(5,2),
    profit NUMERIC(14,4),
    shipping_days INTEGER
);

INSERT INTO fact_sales (
    row_id,
    order_id,
    order_date,
    ship_date,
    customer_id,
    product_id,
    ship_mode,
    region,
    sales,
    quantity,
    discount,
    profit,
    shipping_days
)
SELECT
    row_id,
    order_id,
    order_date,
    ship_date,
    customer_id,
    product_id,
    ship_mode,
    region,
    sales,
    quantity,
    discount,
    profit,
    shipping_days
FROM sales_raw;

-- ------------------------------------------------------------
-- 6. Enforced relationships
-- ------------------------------------------------------------

ALTER TABLE sales_raw
ADD CONSTRAINT fk_sales_customer
FOREIGN KEY (customer_id)
REFERENCES dim_customer(customer_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_date
FOREIGN KEY (order_date)
REFERENCES dim_date(date_key);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_customer
FOREIGN KEY (customer_id)
REFERENCES dim_customer(customer_id);

-- Product relationship is intentionally not enforced because
-- product_id is not unique in dim_product.
