# E-commerce Product Analysis: A Case Study of Jumia Products

## Project Overview

This project analyzes **109 Jumia e-commerce products** to explore how **product pricing, discounts, ratings, and customer reviews** relate to product performance.

**The business problem**

Jumia and its sellers set discounts and prices without knowing whether they move customer engagement. Nobody can currently say whether higher discounts bring more reviews, whether well-rated products cost more or less than the rest, which listings are performing well, or which need a different pricing or marketing strategy.

Thus the central question was:

> **Does a larger product discount translate into greater customer engagement?**

To investigate this, I used **Microsoft Excel, formulas, PivotTables, PivotCharts, KPIs, and interactive slicers** to transform the dataset into an analytical dashboard.

---

## Project Objectives

The main objectives of this project were to:

- Clean and prepare raw e-commerce product data.
- Identify and remove duplicate records.
- Correct inconsistent data types and formatting.
- Create calculated fields for discount analysis.
- Categorize products by price, discount, and rating.
- Analyze relationships between discounts, prices, ratings, and reviews.
- Build PivotTables and PivotCharts for analysis.
- Create an interactive Excel dashboard using slicers.
- Generate business-oriented insights from the analysis.
- Document the complete analytical workflow as a portfolio project.

---

## Data Dictionary

| Column        | Type                      | Description                                                                                                             | Example                                          |
| ------------- | ------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| Product       | text                      | Listing title as shown on Jumia. Some titles repeat, which is how duplicate rows are spotted.                           | Portable Mini Cordless Car Vacuum Cleaner - Blue |
| Current price | text (KSh)                | Selling price after discount, stored as text with a "KSh" prefix and thousands separator. A few listings show a range.  | KSh 2,199                                        |
| old price     | text (KSh)                | Price before the discount, in the same text format as the current price.                                                | KSh 2,923                                        |
| Discount      | text (percentage)         | Percentage discount on the listing, stored as text with a percent sign.                                                 | 25%                                              |
| Review        | integer (stored negative) | Number of customer reviews, exported as a negative number. Blank where the listing has no reviews.                      | -24                                              |
| Ratingd       | text (out of 5)           | Average customer rating stored as "x out of 5". The header is misspelt in the export. Blank where there are no reviews. | 4.6 out of 5                                     |

After the cleaning and preparation process, the analytical dataset contains **109 products**.

---

# Data Cleaning

The original dataset contained several data-quality issues.

### Cleaning activities included:

- Identifying duplicate records.
- Removing **6 duplicate records**.
- Removing `KSh` text from price fields.
- Cleaning and parsing rating values.
- Removing unnecessary columns.
- Correcting column data types.
- Addressing negative values in the review column.
- Cleaning a product containing price-range values.
- Creating a structured Excel analysis table.

Excel features used included:

- **Conditional Formatting**
- **Find & Replace**
- **Text to Columns**
- **Remove Duplicates**
- **Excel Tables**
- **Data-type formatting**

> The detailed cleaning methodology is documented within the project workbook.

---

# Feature Engineering

Additional calculated fields were created to make the dataset more useful for analysis.

### Discount Amount

The difference between the original and current price:

```excel
=old_price-current_price
```

### Calculated Discount Percentage

```excel
=discount_amount/old_price
```

The calculated discount percentage was used for analysis because the original discount field contained discrepancies.

### Rating Category

Products were categorized into rating groups.

```excel
=IFS(
    rating<=3,"Poor",
    rating<=4,"Average",
    rating>4,"Excellent"
)
```

The category boundaries were reviewed during the project to avoid gaps in the classification logic.

### Discount Category

Products were grouped into:

| Category | Discount |
| -------- | -------: |
| Low      |    < 20% |
| Medium   |  20%–40% |
| High     |    > 40% |

### Price Category

Products were grouped based on current price:

| Category    | Current Price |
| ----------- | ------------: |
| Inexpensive |     ≤ KSh 500 |
| Moderate    | KSh 501–1,500 |
| Expensive   |   > KSh 1,500 |

---

# Dashboard

```markdown
![Jumia Excel Dashboard]((https://github.com/ArapzRuto/Data-Science-and-Analytics-Portfolio/blob/main/Excel-Based%20Projects/E-commerce%20Product%20Analysis%EF%80%BA%20A%20Case%20Study%20of%20Jumia%20Products/assets/dashboard.png)
```

---
