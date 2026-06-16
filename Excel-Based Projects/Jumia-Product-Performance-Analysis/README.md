# 🛒 Jumia Product Performance Dashboard

## 📖 Project Overview

The Jumia Product Performance Dashboard is an interactive Excel-based analytics solution developed to evaluate product performance on Jumia by analyzing pricing, discounts, customer ratings, and reviews. The dashboard transforms raw product data into actionable business insights that help identify top-performing products, understand customer behavior, and assess the effectiveness of discount strategies.

The project demonstrates the use of Microsoft Excel for data cleaning, transformation, analysis, and dashboard development.

---

## 🎯 Business Problem

E-commerce platforms such as Jumia offer a wide variety of products with different pricing strategies, discount levels, and customer feedback. However, without proper analysis, it becomes difficult to determine:

* Which products perform best.
* Whether discounts influence customer engagement.
* Which products require improvement.
* How customer ratings relate to reviews and product popularity.

This dashboard helps stakeholders make data-driven decisions regarding pricing, promotions, and product management.

---

## 📊 Dataset Information

The dataset contains information about products listed on Jumia.

### Key Data Fields

* Product Name
* Current Price (KSh)
* Old Price (KSh)
* Discount Percentage
* Number of Reviews
* Product Rating

The dataset was cleaned and transformed to support meaningful analysis and reporting.

---

## 🧹 Data Preparation

Several data-cleaning and transformation processes were performed before analysis.

### Data Cleaning Activities

* Removed duplicate records.
* Checked for missing values.
* Converted price fields into numeric format.
* Standardized rating values.
* Verified review counts.
* Corrected formatting inconsistencies.

### Data Enrichment

Additional calculated fields were created, including:

#### Discount Amount

```excel
=Old Price - Current Price
```

#### Rating Category

| Rating  | Category  |
| ------- | --------- |
| Below 3 | Poor      |
| 3 – 4.4 | Average   |
| 4.5 – 5 | Excellent |

#### Discount Category

| Discount %    | Category        |
| ------------- | --------------- |
| Less than 20% | Low Discount    |
| 20% – 40%     | Medium Discount |
| Above 40%     | High Discount   |

---

## 📈 Dashboard Features

The dashboard was designed to provide interactive analysis through Pivot Tables, Charts, KPI Cards, and Slicers.

### Interactive Features

* Product Filter
* Rating Category Slicer
* Discount Category Slicer
* Dynamic Charts
* KPI Summary Cards

Users can quickly explore product performance by applying different filters.

---

## 🎯 Key Performance Indicators (KPIs)

The dashboard tracks the following metrics:

| KPI              | Value |
| ---------------- | ----- |
| Total Products   | 108   |
| Average Rating   | 2.01  |
| Average Discount | 36%   |
| Total Reviews    | 721   |

These KPIs provide a high-level overview of overall product performance.

---

## 📊 Visualizations

The dashboard includes:

### Overview Section

* Total Products KPI Card
* Average Rating KPI Card
* Average Discount KPI Card
* Total Reviews KPI Card

### Trend Analysis

* Relationship Between Discount Percentage and Reviews
* Relationship Between Rating and Reviews

### Product Performance Analysis

* Top 5 Products with Highest Ratings
* Top 10 Products with Highest Discounts

### Product Category Analysis

* Rating Category Filter
* Discount Category Filter

### Interactive Filtering

* Product Slicer
* Rating Category Slicer
* Discount Category Slicer

---

## 🔍 Key Findings

### 1. Customer Ratings Are Relatively Low

The average product rating is **2.01 out of 5**, indicating relatively low customer satisfaction across many products.

#### Business Impact

Low ratings may reduce customer trust and affect future sales.

---

### 2. Higher-Rated Products Receive More Reviews

Products rated between **4 and 5 stars** generate significantly more customer reviews than lower-rated products.

#### Insight

This suggests that customer satisfaction encourages engagement and feedback.

#### Business Impact

Promoting highly rated products can increase customer confidence and conversions.

---

### 3. Discounts Have Limited Influence on Customer Engagement

The relationship between discount percentage and review volume appears weak.

#### Insight

Large discounts do not consistently generate higher numbers of reviews.

#### Business Impact

Product quality and customer experience may have a greater influence on engagement than discounts alone.

---

### 4. Several Products Receive Extremely High Discounts

The Top 10 Products with Highest Discounts chart shows products with substantial price reductions.

#### Business Impact

While discounts may attract attention, excessive discounting can:

* Reduce profit margins
* Lower perceived product value
* Create dependency on promotions

---

### 5. Top-Rated Products Maintain Excellent Customer Satisfaction

The highest-rated products consistently achieve ratings close to 5.0.

#### Business Impact

These products can serve as benchmarks for:

* Product quality
* Pricing strategy
* Customer satisfaction

---

## 💡 Recommendations

### Improve Product Quality

Investigate products with consistently low ratings and address quality concerns raised by customers.

### Promote High-Performing Products

Feature highly rated products in marketing campaigns and product recommendations.

### Optimize Discount Strategies

Rather than offering excessive discounts, focus on targeted promotions that maximize profitability.

### Encourage Customer Reviews

Implement review collection campaigns to increase customer engagement and gather valuable feedback.

### Monitor Low-Rated Products

Regularly track products with poor ratings and take corrective action where necessary.

### Balance Pricing and Customer Value

Ensure that pricing strategies remain competitive while maintaining product quality and profitability.

---

## 🛠️ Tools and Technologies

### Microsoft Excel

The dashboard was built using:

* Data Cleaning Techniques
* Pivot Tables
* Pivot Charts
* KPI Cards
* Interactive Dashboard Design
* Conditional Formatting
* Slicers
* Data Transformation Techniques

---

## 📦 Project Deliverables

* Cleaned Jumia Product Dataset
* Interactive Excel Dashboard
* Business Insights and Recommendations
* Data Visualization Report

---

## 📷 Dashboard Preview

Dashboard screenshot below:

![Jumia Product Performance Dashboard](https://github.com/ArapzRuto/Jumia-Product-Performance-Analysis/blob/main/Jumia%20product%20Dashboard.jpg)

---

## 👤 Author

**Robert Ruto**
*Data Analyst | Data Scientist | Researcher*

---

## 🔗 Connect With Me

* LinkedIn: https://www.linkedin.com/in/robert-ruto-4b2166112
* GitHub: https://github.com/ArapzRuto

---

## 📄 License

This project is available for educational and portfolio purposes.

---
