# RetailPulse --- Project Summary

## Project Name

**RetailPulse --- Sales & Customer Intelligence**

------------------------------------------------------------------------

## Project Type

End-to-end retail analytics and business intelligence portfolio project.

------------------------------------------------------------------------

## Objective

RetailPulse was developed to demonstrate the complete workflow of
converting raw retail transaction data into structured business
intelligence.

The project combines:

-   Python/Pandas
-   PostgreSQL
-   SQL
-   Power BI
-   DAX

The final output is a four-page interactive Power BI dashboard covering
executive performance, profitability, customers, and products.

------------------------------------------------------------------------

## Dataset

-   Dataset: Superstore
-   Raw records: 9,994
-   Raw columns: 21
-   Cleaned records: 9,994
-   Cleaned columns: 25
-   Order date range: 2014-01-03 to 2017-12-30
-   Ship date range: 2014-01-07 to 2018-01-05

------------------------------------------------------------------------

## Data Preparation

Python/Pandas was used for:

-   Data ingestion
-   Encoding handling
-   Data cleaning
-   Missing-value analysis
-   Duplicate analysis
-   Data-type validation
-   Date validation
-   Quantity validation
-   Discount validation
-   Sales validation
-   Profit validation
-   Exploratory data analysis

No important missing values or exact duplicate rows were identified.

------------------------------------------------------------------------

## Major Data-Quality Finding

The analysis found 32 Product IDs associated with multiple distinct
product names.

This meant that Product ID could not safely be treated as a unique
product key.

A surrogate `product_key` was therefore introduced in the PostgreSQL
product dimension.

This issue was also accounted for in the Power BI model.

------------------------------------------------------------------------

## Key Business Metrics

  Metric                            Value
  ---------------------- ----------------
  Sales                    2,297,200.8603
  Profit                     286,397.0217
  Quantity                         37,873
  Orders                            5,009
  Customers                           793
  Distinct Product IDs              1,862
  Profit Margin                    12.47%

There are 9,994 sales-line records but only 5,009 distinct orders.

------------------------------------------------------------------------

## PostgreSQL Implementation

Database:

``` text
retailpulse
```

Main tables:

``` text
sales_raw
dim_customer
dim_product
dim_date
fact_sales
```

The fact table contains 9,994 rows at the grain of one product line
within an order.

The product dimension contains a surrogate `product_key` to address the
Product ID inconsistency.

A Power BI-specific PostgreSQL view was subsequently created:

``` text
fact_sales_powerbi
```

This view safely connects each fact row to the corresponding product
key.

------------------------------------------------------------------------

## SQL Analysis

The SQL phase included:

-   Data validation
-   Aggregations
-   CTEs
-   CASE statements
-   Subqueries
-   Ranking functions
-   Window functions
-   Running totals
-   Rolling averages
-   Year-over-year analysis
-   Customer profitability analysis
-   Product loss analysis

Examples of business analysis included:

-   Top products within categories
-   YoY growth
-   Running totals
-   Rolling three-month averages
-   High-sales but loss-making customers
-   Customer order frequency
-   Product loss concentration
-   Latest customer orders
-   Customer ranking within segments
-   Customers above average sales

------------------------------------------------------------------------

## Important SQL Findings

### Sales Growth

-   2015: -2.83% YoY
-   2016: +29.47% YoY
-   2017: +20.36% YoY

### Category Profit

-   Technology: approximately 145,454.95
-   Office Supplies: approximately 122,490.80
-   Furniture: approximately 18,451.27

### Loss-Making Sales Lines

-   1,871
-   Approximately 18.72% of sales-line records

### High-Sales, Negative-Profit Customers

-   17 customers had sales above 5,000 while having negative total
    profit.

### Product Loss Concentration

`TEC-MA-10000418` contributed approximately:

-   -8,879.97 in loss
-   11.57% of product-level losses

------------------------------------------------------------------------

## Power BI Data Model

The final Power BI model contains:

``` text
dim_customer
dim_date
dim_product
fact_sales_powerbi
```

Relationships:

``` text
dim_customer[customer_id]
        1
        |
        *
fact_sales_powerbi[customer_id]
```

``` text
dim_date[date_key]
        1
        |
        *
fact_sales_powerbi[order_date]
```

``` text
dim_product[product_key]
        1
        |
        *
fact_sales_powerbi[product_key]
```

All relationships are active and use single-direction filtering.

------------------------------------------------------------------------

## DAX

The project includes measures for:

-   Total Sales
-   Total Profit
-   Total Orders
-   Total Customers
-   Total Quantity
-   Profit Margin %
-   Average Order Value
-   Sales YTD
-   Profit YTD
-   Sales LY
-   Profit LY
-   YoY Sales %
-   YoY Profit %
-   Loss-Making Sales Lines
-   Total Products

These measures provide dynamic calculations that respond to Power BI
filters and slicers.

------------------------------------------------------------------------

## Power BI Dashboard

The final report contains four pages.

### 1. Executive Overview

Includes:

-   Total Sales
-   Total Profit
-   Total Orders
-   Total Customers
-   Total Quantity
-   Profit Margin %
-   Monthly Sales & Profit Trend
-   Sales & Profit by Category
-   Sales & Profit by Region
-   Sales vs Previous Year
-   Year slicer
-   Region slicer
-   Category slicer

### 2. Profitability Analysis

Includes:

-   Total Profit
-   Profit Margin %
-   YoY Profit %
-   Loss-Making Sales Lines
-   Profit by Sub-Category
-   Discount vs Profit by Product
-   Profit by Region

### 3. Customer Intelligence

Includes:

-   Total Customers
-   Average Order Value
-   Total Orders
-   Sales & Profit by Segment
-   Customer Distribution by Segment
-   Sales Trend by Segment
-   Profit by Segment
-   Top 10 Customers by Sales

### 4. Product Intelligence

Includes:

-   Total Products
-   Total Quantity
-   Total Sales
-   Total Profit
-   Sales & Profit by Category
-   Top 10 Products by Sales
-   Top 10 Products by Profit
-   Sales & Profit by Sub-Category
-   Category slicer

------------------------------------------------------------------------

## Core Business Insights

The project found that:

-   Total sales were approximately 2.297 million.
-   Total profit was approximately 286.4 thousand.
-   Overall profit margin was approximately 12.47%.
-   Sales increased strongly in 2016 and 2017 after a small decline in
    2015.
-   Technology generated the highest total profit among the major
    categories.
-   Furniture generated substantially lower profit than Technology and
    Office Supplies.
-   Higher discount levels were associated with weaker profitability.
-   1,871 sales lines generated negative profit.
-   Some high-sales customers were still loss-making.
-   Product-level losses were concentrated among a subset of products.

------------------------------------------------------------------------

## Analytical Limitations

-   The analysis is based on historical transactional data.
-   Historical patterns should not be interpreted as forecasts.
-   Observed relationships do not prove causality.
-   Product ID inconsistencies affect product-count interpretation.
-   Customer and product loss patterns identify areas for investigation
    but do not independently explain their causes.

------------------------------------------------------------------------

## Skills Demonstrated

### Python

-   Pandas
-   NumPy
-   Data cleaning
-   Exploratory data analysis
-   Business KPI analysis

### SQL

-   PostgreSQL
-   Data modeling
-   Joins
-   CTEs
-   Aggregations
-   CASE statements
-   Window functions
-   Ranking
-   Time-based analysis
-   Data validation

### Power BI

-   PostgreSQL connectivity
-   Data modeling
-   Star-schema concepts
-   Relationships
-   DAX measures
-   Time intelligence
-   KPI cards
-   Interactive slicers
-   Cross-filtering
-   Top-N analysis
-   Business dashboard design

------------------------------------------------------------------------

## Project Outcome

RetailPulse demonstrates an end-to-end analytical pipeline:

``` text
Raw Data
   ↓
Python / Pandas
   ↓
Data Cleaning & EDA
   ↓
PostgreSQL
   ↓
SQL Analysis & Validation
   ↓
Dimensional Model
   ↓
Power BI
   ↓
DAX
   ↓
Interactive Dashboard
   ↓
Business Insights
```

The project demonstrates the ability to work across the data lifecycle
rather than focusing only on visualization.

------------------------------------------------------------------------

## Current Status

Completed:

-   Data cleaning
-   Exploratory analysis
-   PostgreSQL database
-   SQL validation
-   SQL business analysis
-   Dimensional modeling
-   Power BI model
-   DAX measures
-   Four dashboard pages
-   Interactive filtering
-   Dashboard formatting

Remaining portfolio activities:

-   Final dashboard screenshots
-   GitHub repository cleanup
-   Final README review
-   Business insights documentation
-   Resume project bullets
-   LinkedIn project post
-   Interview preparation
