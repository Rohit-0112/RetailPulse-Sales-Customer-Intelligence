# RetailPulse --- Business Insights

## 1. Executive Summary

RetailPulse analyzes 9,994 retail sales-line records covering the period
from 2014 to 2017.

The dataset generated:

-   Total Sales: 2,297,200.8603
-   Total Profit: 286,397.0217
-   Total Quantity: 37,873
-   Total Orders: 5,009
-   Total Customers: 793
-   Overall Profit Margin: 12.47%

The analysis indicates continued sales growth after 2015, substantial
differences in profitability across product categories, an association
between higher discounts and weaker profitability, and a meaningful
number of loss-making sales lines.

------------------------------------------------------------------------

## 2. Overall Performance

### Finding

Total sales were approximately 2.297 million and total profit was
approximately 286.4 thousand.

The resulting overall profit margin was approximately 12.47%.

### Interpretation

The business generated positive aggregate profit, but the overall margin
indicates that sales volume alone does not fully describe business
performance.

Profitability needs to be evaluated alongside sales.

------------------------------------------------------------------------

## 3. Sales Growth

  Year          Sales   YoY Growth
  ------ ------------ ------------
  2014     484,247.50          ---
  2015     470,532.51       -2.83%
  2016     609,205.60      +29.47%
  2017     733,215.26      +20.36%

### Observations

-   Sales decreased slightly in 2015.
-   Sales increased strongly in 2016.
-   Sales increased again in 2017.
-   2017 had the highest annual sales value in the dataset.

### Business implication

The dataset shows strong sales expansion from 2015 onward.

However, sales growth should be considered together with profit growth
and margins to determine whether growth was accompanied by improved
profitability.

------------------------------------------------------------------------

## 4. Category Profitability

  Category                Profit
  ----------------- ------------
  Technology          145,454.95
  Office Supplies     122,490.80
  Furniture            18,451.27

### Observation

Technology generated the highest total profit.

Office Supplies also generated substantial profit.

Furniture generated substantially lower total profit than the other two
categories.

### Business implication

Furniture warrants closer profitability investigation.

Further analysis should examine:

-   Sub-category mix
-   Discounts
-   Product-level losses
-   Sales volume
-   Pricing
-   Regional differences

The available dataset alone does not establish the exact reason for
Furniture's lower profitability.

------------------------------------------------------------------------

## 5. Discount and Profitability

### Finding

Higher discount levels were associated with weaker profitability in the
analyzed data.

Some higher-discount ranges produced negative profitability.

### Important limitation

This is an observed association, not proof of causation.

The analysis should therefore be communicated as:

> Higher discount levels were associated with lower profitability in
> this dataset.

It should not be presented as:

> Discounts caused profits to decrease.

Additional variables would be required to establish causality.

------------------------------------------------------------------------

## 6. Loss-Making Sales Lines

The analysis identified:

-   1,871 loss-making sales lines
-   18.72% of all 9,994 sales-line records

### Business implication

A meaningful portion of individual sales lines generated negative
profit.

This suggests that profitability should be monitored at the
transaction/product level rather than relying only on aggregate sales.

Potential areas for further investigation include:

-   Discount levels
-   Product mix
-   Customer segment
-   Region
-   Shipping mode
-   Product-level pricing
-   Sub-category profitability

------------------------------------------------------------------------

## 7. High-Sales but Loss-Making Customers

The SQL analysis identified customers generating relatively high sales
but negative total profit.

### Sean Miller

-   Sales: approximately 25,043
-   Profit: approximately -1,981
-   Margin: approximately -7.91%

### Grant Thornton

-   Sales: approximately 9,351
-   Profit: approximately -4,109
-   Margin: approximately -43.94%

Overall:

-   17 customers had sales above 5,000 and negative total profit.

### Business implication

High revenue does not automatically imply high customer profitability.

These customers represent potential investigation areas.

Possible areas to examine include:

-   Discounting
-   Product mix
-   Order composition
-   Shipping costs or operational patterns
-   Pricing
-   Loss-making products purchased by those customers

The available analysis does not establish which factor caused the
losses.

------------------------------------------------------------------------

## 8. Product Loss Concentration

One significant product-level loss was:

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

### Business implication

Product-level losses may be concentrated rather than evenly distributed.

This suggests that identifying high-contribution loss-making products
can be useful for profitability investigation.

------------------------------------------------------------------------

## 9. Customer Segmentation

The dataset contains three major customer segments:

-   Consumer
-   Corporate
-   Home Office

Power BI provides interactive analysis of:

-   Sales by segment
-   Profit by segment
-   Customer count by segment
-   Segment sales trends
-   Top customers

### Business implication

Segment-level analysis allows sales performance to be evaluated together
with customer composition and profitability.

A segment generating high sales should not automatically be interpreted
as the most profitable without examining its profit contribution.

------------------------------------------------------------------------

## 10. Product Analysis

The Product Intelligence dashboard analyzes:

-   Sales by category
-   Profit by category
-   Sales and profit by sub-category
-   Top 10 products by sales
-   Top 10 products by profit

This makes it possible to distinguish between:

-   High-sales products
-   High-profit products
-   Products with strong sales but weaker profit
-   Products that contribute disproportionately to losses

------------------------------------------------------------------------

## 11. Regional Analysis

Regional analysis was performed using:

-   Central
-   East
-   South
-   West

The Power BI dashboard provides regional sales and profit comparisons.

Regional performance should be interpreted using both sales and profit
rather than sales alone.

------------------------------------------------------------------------

## 12. Operational Analysis

The project also analyzed shipping behavior.

Observed shipping duration:

-   Minimum: 0 days
-   Maximum: 7 days
-   Median: 4 days
-   Mean: approximately 3.96 days

This provides a foundation for further operational analysis involving:

-   Shipping mode
-   Shipping duration
-   Regional performance
-   Profitability
-   Order characteristics

------------------------------------------------------------------------

## 13. Key Business Questions Answered

The project provides analytical support for questions such as:

-   How much revenue is being generated?
-   How much profit is being generated?
-   What is the overall profit margin?
-   How are sales changing over time?
-   Which categories contribute most to profit?
-   Which sub-categories are loss-making?
-   How is discount associated with profitability?
-   How many sales lines are loss-making?
-   Which customer segments generate sales and profit?
-   Which customers generate high sales but negative profit?
-   Which products generate the most sales?
-   Which products generate the most profit?
-   Which products contribute significantly to losses?
-   How do regions compare in sales and profit?

------------------------------------------------------------------------

## 14. Overall Conclusions

The main conclusions from the analysis are:

1.  The business generated approximately 2.297 million in sales and
    286.4 thousand in profit.
2.  Overall profit margin was approximately 12.47%.
3.  Sales declined slightly in 2015 but increased substantially in 2016
    and 2017.
4.  Technology generated the highest total profit among the three major
    categories.
5.  Furniture generated considerably lower profit than Technology and
    Office Supplies.
6.  Higher discount levels were associated with weaker profitability.
7.  1,871 sales lines were loss-making.
8.  Some customers generated relatively high sales while still producing
    negative profit.
9.  Product-level losses were not evenly distributed; some products
    contributed substantially to total losses.
10. Sales performance and profitability should be analyzed together
    rather than relying on revenue alone.

------------------------------------------------------------------------

## 15. Analytical Caveats

-   These findings describe the observed dataset.
-   Historical sales do not constitute a forecast.
-   Associations do not establish causation.
-   Product ID inconsistencies affect interpretation of product counts.
-   Customer and product loss findings identify investigation areas
    rather than definitive explanations.
