# RetailPulse --- Sales & Customer Intelligence

## Project Overview

RetailPulse is an end-to-end retail analytics and business intelligence
project built using the Superstore dataset.

The project demonstrates the complete workflow from raw transactional
data to an interactive Power BI dashboard:

``` text
Raw Dataset
    ↓
Python / Pandas
    ↓
Data Cleaning & Exploratory Data Analysis
    ↓
PostgreSQL
    ↓
SQL Validation & Business Analysis
    ↓
Dimensional Data Modeling
    ↓
Power BI
    ↓
DAX Measures
    ↓
Interactive Dashboard
    ↓
Business Insights
```

The project was developed as a portfolio project demonstrating practical
skills relevant to Data Analyst and Data Engineer roles.

------------------------------------------------------------------------

## Business Objective

The project analyzes retail transactions to understand:

-   Overall sales and profit performance
-   Year-over-year sales growth
-   Category and sub-category profitability
-   Discount and profitability relationships
-   Customer and segment performance
-   Product performance
-   Regional performance
-   Loss-making sales lines
-   High-sales but loss-making customers
-   Product-level loss concentration

The final Power BI report converts these analyses into an interactive
analytical product.

------------------------------------------------------------------------

## Dataset

-   Dataset: Superstore
-   Original dataset: 9,994 rows and 21 columns
-   Final cleaned dataset: 9,994 rows and 25 columns
-   Processed file:

``` text
data/processed/retailpulse_clean.csv
```

The original CSV required Windows-1252 (`cp1252`) encoding during Pandas
ingestion.

------------------------------------------------------------------------

## Data Quality Assessment

The Pandas phase included:

-   Missing-value checks
-   Exact duplicate checks
-   Data-type validation
-   Date validation
-   Quantity validation
-   Discount validation
-   Sales validation
-   Profit validation
-   Shipping-duration analysis

### Results

-   No important missing values were identified.
-   No exact duplicate rows were found.
-   Order dates range from 2014-01-03 to 2017-12-30.
-   Ship dates range from 2014-01-07 to 2018-01-05.
-   Shipping duration ranges from 0 to 7 days.
-   Median shipping duration: 4 days.
-   Mean shipping duration: approximately 3.96 days.
-   Quantity values are positive.
-   Discount values range from 0 to 1.
-   Sales values are non-negative.
-   Negative profit values were retained because they represent
    legitimate business outcomes.

------------------------------------------------------------------------

## Important Product ID Data-Quality Finding

During the EDA phase, 32 Product IDs were found to map to more than one
distinct product name.

Therefore:

``` text
product_id → product_name
```

was not perfectly one-to-one.

This meant that `product_id` could not safely be treated as a unique
product dimension key.

Rather than silently changing the source data, the inconsistency was
documented and handled during database and Power BI modeling.

A surrogate `product_key` was introduced in the product dimension.

------------------------------------------------------------------------

## Overall Business KPIs

  KPI                                Value
  ----------------------- ----------------
  Total Sales               2,297,200.8603
  Total Profit                286,397.0217
  Total Quantity                    37,873
  Total Orders                       5,009
  Total Customers                      793
  Distinct Product IDs               1,862
  Overall Profit Margin             12.47%

An important distinction is that the dataset contains 9,994 sales-line
rows but only 5,009 distinct orders.

Therefore, order counts use:

``` dax
DISTINCTCOUNT(order_id)
```

rather than row counts.

------------------------------------------------------------------------

## Pandas / EDA

The Python/Pandas phase covered:

-   Overall KPIs
-   Yearly sales
-   Category analysis
-   Sub-category analysis
-   Discount analysis
-   Product analysis
-   Customer analysis
-   Customer segment analysis
-   Regional analysis
-   Monthly analysis
-   Shipping analysis
-   Correlation analysis
-   Profitability analysis

Power BI was then used to add interactivity, dynamic calculations,
filtering, time intelligence, and visual storytelling rather than simply
repeating the notebook analysis.

------------------------------------------------------------------------

## Yearly Sales Analysis

  Year          Sales
  ------ ------------
  2014     484,247.50
  2015     470,532.51
  2016     609,205.60
  2017     733,215.26

Year-over-year growth:

  Year     YoY Growth
  ------ ------------
  2015         -2.83%
  2016        +29.47%
  2017        +20.36%

Observations:

-   Sales declined slightly in 2015.
-   Sales increased substantially in 2016.
-   Sales continued to increase in 2017.
-   2017 recorded the highest annual sales in the dataset.

------------------------------------------------------------------------

## Category Profitability

  Category                Profit
  ----------------- ------------
  Technology          145,454.95
  Office Supplies     122,490.80
  Furniture            18,451.27

Technology generated the highest total profit, while Furniture generated
substantially lower profit than Technology and Office Supplies.

------------------------------------------------------------------------

## Discount and Profitability

The analysis showed an association between higher discount levels and
weaker profitability.

This is reported as an association rather than a causal relationship.

The analysis does not establish that discounts directly caused profit to
decrease.

------------------------------------------------------------------------

## Loss-Making Sales Lines

The analysis identified:

-   1,871 loss-making sales lines
-   Approximately 18.72% of the 9,994 sales-line records

This metric is included in the Power BI Profitability Analysis page.

------------------------------------------------------------------------

## PostgreSQL Data Model

The cleaned data was loaded into PostgreSQL database:

``` text
retailpulse
```

Main analytical tables:

### `sales_raw`

-   Cleaned source data
-   9,994 rows

### `dim_customer`

Columns:

``` text
customer_id
customer_name
segment
```

-   793 unique customers
-   `customer_id` used as the customer key

### `dim_product`

Columns include:

``` text
product_key
product_id
product_name
category
sub_category
```

-   Surrogate `product_key` introduced because Product ID was not
    perfectly unique.
-   1,894 product records in the dimension.

### `dim_date`

Columns:

``` text
date_key
year
month
month_name
quarter
```

-   1,458 dates
-   Date range: 2014-01-03 to 2017-12-30

### `fact_sales`

-   9,994 rows
-   Grain: one product line within an order

Important fields:

``` text
row_id
order_id
order_date
ship_date
customer_id
product_id
ship_mode
region
sales
quantity
discount
profit
shipping_days
```

------------------------------------------------------------------------

## Data Validation

The SQL phase validated that the transformation preserved the source
data.

``` text
Raw rows  = 9,994
Fact rows = 9,994
```

``` text
Raw Sales  = 2,297,200.8603
Fact Sales = 2,297,200.8603
```

``` text
Raw Profit  = 286,397.0217
Fact Profit = 286,397.0217
```

------------------------------------------------------------------------

## SQL Analysis

SQL analysis included:

-   CTEs
-   CASE statements
-   Aggregations
-   HAVING
-   Subqueries
-   RANK
-   DENSE_RANK
-   ROW_NUMBER
-   LAG
-   Window functions
-   PARTITION BY
-   Running totals
-   Rolling averages

Business analyses included:

-   Top products within categories
-   Year-over-year growth
-   Running totals
-   Rolling three-month averages
-   High-sales but loss-making customers
-   Customer order frequency
-   Product loss concentration
-   Latest order per customer
-   Customer ranking within segment
-   Customers above average sales

------------------------------------------------------------------------

## Customer Profitability Findings

The SQL analysis identified customers with relatively high sales but
negative total profit.

Examples:

### Sean Miller

-   Sales: approximately 25,043
-   Profit: approximately -1,981
-   Margin: approximately -7.91%

### Grant Thornton

-   Sales: approximately 9,351
-   Profit: approximately -4,109
-   Margin: approximately -43.94%

Overall:

-   17 customers had sales above 5,000 while having negative total
    profit.

These are investigation signals rather than explanations of the causes
of the losses.

------------------------------------------------------------------------

## Product Loss Concentration

One major example was:

``` text
TEC-MA-10000418
```

with approximately:

-   Loss: -8,879.97
-   Loss share: approximately 11.57%

Other significant loss contributors included:

``` text
TEC-MA-10000822
TEC-MA-10004125
```

------------------------------------------------------------------------

# Power BI Implementation

The Power BI report uses PostgreSQL as the data source.

The final model contains:

``` text
dim_customer
dim_date
dim_product
fact_sales_powerbi
```

A PostgreSQL view named `fact_sales_powerbi` was created to safely bring
`product_key` into the fact table.

The view was validated with:

-   9,994 total rows
-   9,994 rows with a product key
-   1,894 distinct product keys
-   0 unmatched rows

------------------------------------------------------------------------

## Power BI Relationships

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

Relationships are active and use single-direction filtering.

------------------------------------------------------------------------

## DAX Measures

The report includes:

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

Examples:

``` dax
Total Sales =
SUM('public fact_sales_powerbi'[sales])
```

``` dax
Total Profit =
SUM('public fact_sales_powerbi'[profit])
```

``` dax
Total Orders =
DISTINCTCOUNT('public fact_sales_powerbi'[order_id])
```

``` dax
Profit Margin % =
DIVIDE(
    [Total Profit],
    [Total Sales],
    0
)
```

``` dax
Average Order Value =
DIVIDE(
    [Total Sales],
    [Total Orders],
    0
)
```

``` dax
Loss-Making Sales Lines =
CALCULATE(
    COUNTROWS('public fact_sales_powerbi'),
    'public fact_sales_powerbi'[profit] < 0
)
```

------------------------------------------------------------------------

# Power BI Dashboard Pages

## Page 1 --- Executive Overview

### KPIs

-   Total Sales
-   Total Profit
-   Total Orders
-   Total Customers
-   Total Quantity
-   Profit Margin %

### Visuals

-   Monthly Sales & Profit Trend
-   Sales & Profit by Category
-   Sales & Profit by Region
-   Sales vs Previous Year

### Slicers

-   Year
-   Region
-   Category

------------------------------------------------------------------------

## Page 2 --- Profitability Analysis

### KPIs

-   Total Profit
-   Profit Margin %
-   YoY Profit %
-   Loss-Making Sales Lines

### Visuals

-   Profit by Sub-Category
-   Discount vs Profit by Product
-   Profit by Region

The page focuses on identifying profitability differences, loss-making
areas, and the relationship between discount and profit.

------------------------------------------------------------------------

## Page 3 --- Customer Intelligence

### KPIs

-   Total Customers
-   Average Order Value
-   Total Orders

### Visuals

-   Sales & Profit by Segment
-   Customer Distribution by Segment
-   Sales Trend by Segment
-   Profit by Segment
-   Top 10 Customers by Sales

Segments:

``` text
Consumer
Corporate
Home Office
```

------------------------------------------------------------------------

## Page 4 --- Product Intelligence

### KPIs

-   Total Products
-   Total Quantity
-   Total Sales
-   Total Profit

### Visuals

-   Sales & Profit by Category
-   Top 10 Products by Sales
-   Top 10 Products by Profit
-   Sales & Profit by Sub-Category

### Slicer

-   Category

------------------------------------------------------------------------

# Tools & Technologies

-   Python
-   Pandas
-   NumPy
-   Matplotlib
-   Jupyter Notebook
-   PostgreSQL
-   pgAdmin
-   SQL
-   Microsoft Power BI
-   DAX

------------------------------------------------------------------------

# Repository Structure

``` text
RetailPulse/
│
├── data/
│   ├── raw/
│   │   └── Superstore.csv
│   └── processed/
│       └── retailpulse_clean.csv
│
├── notebooks/
│   └── 01_data_audit.ipynb
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_data_validation.sql
│   ├── 03_basic_analysis.sql
│   ├── 04_business_analysis.sql
│   └── 05_advanced_analysis.sql
│
├── powerbi/
│   └── RetailPulse.pbix
│
├── reports/
│   ├── business_insights.md
│   └── project_summary.md
│
├── screenshots/
│
└── README.md
```

------------------------------------------------------------------------

# Key Project Outcomes

-   Built a complete analytics pipeline from raw CSV data to Power BI.
-   Performed structured data-quality assessment using Python.
-   Identified and handled a non-trivial Product ID inconsistency.
-   Built a relational analytical model in PostgreSQL.
-   Validated that SQL transformations preserved sales and profit
    totals.
-   Applied advanced SQL analytical techniques.
-   Created reusable DAX measures.
-   Implemented Power BI time intelligence.
-   Built four interactive analytical dashboard pages.
-   Added slicers and cross-filtering.
-   Converted raw transactional data into business-oriented insights.

------------------------------------------------------------------------

# Limitations

-   The dataset is historical and should not be treated as a forecast.
-   Observed associations do not establish causation.
-   Product ID inconsistencies affect how product counts should be
    interpreted.
-   Customer and product loss patterns identify areas for investigation
    but do not independently explain the underlying causes.
-   Discount-profit relationships should be interpreted as associations
    within this dataset.

------------------------------------------------------------------------

# Project Status

Completed:

-   Data ingestion
-   Data cleaning
-   Exploratory analysis
-   PostgreSQL setup
-   SQL validation
-   SQL business analysis
-   Dimensional modeling
-   Power BI data model
-   DAX measures
-   Four dashboard pages
-   Dashboard interactivity
-   Dashboard formatting


