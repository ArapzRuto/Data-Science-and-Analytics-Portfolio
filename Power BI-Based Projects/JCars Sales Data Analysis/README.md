# JCars Sales Data Analysis

## Project Overview

JCars Logistics imports, sells, and delivers vehicles to customers across different regions in Kenya. This project transforms raw sales and logistics data into an interactive Power BI dashboard that provides meaningful insights to support business decision-making.

The project involved cleaning and transforming the dataset, creating DAX measures, designing a star schema data model, and building interactive visualizations to answer key business questions.

---

## Project Objectives

The objectives of this project were to:

- Clean and transform a dirty JCars Logistics dataset using Power Query.
- Develop DAX measures for business analysis.
- Answer key business questions using data.
- Design an interactive Power BI dashboard.
- Generate actionable business insights.
- Provide recommendations to improve sales performance.

---

## Tools Used

- Microsoft Power BI
- Power Query
- DAX (Data Analysis Expressions)
- Microsoft Excel

---

##  Dataset

The dataset contains transactional sales, logistics, and customer information including:



| Order ID | Customer Name | Car Make | Delivery Date |
| Order Date | Customer Type | Car Model | Delivery Fee |
| Revenue Recorded | Customer Age | Vehicle Type | Logistics Cost |
| Unit Selling Price | Customer Rating | Vehicle Year | Delivery Status |
| Unit Cost | Review Count | Fuel Type | Payment Method |
| Discount | Region | Transmission | Payment Status |
| Units Sold | County | Color | Returned |
| Sales Representative | City | | |
| Lead Source | Branch | | |

---

## Data Cleaning

The following transformations were performed using **Power Query**:

- Standardized the **Order ID** column.
- Removed errors, null values, and N/A records.
- Removed duplicate records using Order ID.
- Reduced the dataset from **276** orders to **254** unique orders.
- Corrected inconsistent text formatting using Microsoft Excel.
- Converted columns to the appropriate data types.
- Corrected calculated columns where necessary.
- Created the derived column **Total Costs Recorded (COGS)**.

---

## Data Modeling

A **Star Schema** was implemented consisting of:

### Fact Table

- JCars Sales Dataset

### Dimension Table

- Date Table

This data model improves performance, simplifies DAX calculations, and enables efficient filtering across reports.

---

##  Dashboard Pages

The Power BI dashboard provides a high-level overview of:

- Sales Performance
- Revenue Analysis
- Profitability
- Vehicle Performance
- Customer Analysis
- Branch Performance
- Regional Sales
- Delivery Performance
- Payment Analysis
  
![JCars Sales Performance Dashboard](https://raw.githubusercontent.com/ArapzRuto/Data-Science-and-Analytics-Portfolio/main/Power%20BI-Based%20Projects/JCars%20Sales%20Data%20Analysis/assets/Jcars%20Dashboard.jpg)
---

# Business Questions and Findings

| # | Business Question | Finding |
|---|-------------------|---------|
| 1 | Total cars sold | **417 Units** |
| 2 | Total sales revenue | **KSh 2 Billion** |
| 3 | Gross Profit | **KSh 527 Million** |
| | Gross Profit Margin | **28%** |
| 4 | Highest revenue-generating car make | **Toyota (KSh 765,596,190)** |
| 5 | Highest-selling car model | **Harrier (30 Units)** |
| 6 | Best vehicle type by revenue | **SUV (KSh 1,122,310,370)** |
| | Best vehicle type by units sold | **SUV (164 Units)** |
| 7 | Highest-performing branch | **Thika Yard (KSh 398,693,300)** |
| 8 | Best-performing county | **Kakamega (87 Units)** |
| 9 | Best-performing sales representative | **Faith Achieng (KSh 35,331,190, 54 Units)** |
| 10 | Best lead source | **Referral (66 Units)** |
| 11 | Monthly trend | Revenue and profit peaked in **April** while units sold peaked in **February** |
| 12 | Top payment method | **M-Pesa (KSh 512,160,290)** |
| 13 | Payment status breakdown | Visualized in dashboard |
| 14 | Most common delivery status | **Delivered (134 Orders)** |
| 15 | Average delivery time | **15.27 Days** |
| 16 | Highest logistics cost ratio | **Mombasa (2%)** |
| 17 | Highest profit margin | **Land Cruiser (KSh 132,951,000)** |
| 18 | Highest revenue customer type | **Car Dealer (KSh 548,791,210)** |
| 19 | Discount vs Revenue | Visualized in dashboard |
| 20 | Customer Rating vs Revenue | Visualized in dashboard |
| 21 | Orders requiring investigation | Identified using dashboard filters |
| 22 | Top 10 customers | Visualized in dashboard |
| 23 | Most returned/cancelled cars | Visualized in dashboard |
| 24 | Best-performing vehicle year | Visualized in dashboard |

---

#  Business Insights

## Core Performance Metrics

- **Total Revenue:** KSh **2 Billion**
- **Gross Profit:** KSh **527 Million**
- **Gross Profit Margin:** **28%**
- **Units Sold:** **417**
- **Total Orders:** **254**
- **Average Delivery Time:** **15.27 Days**
- **Average Customer Rating:** **3.56 / 5**

---

## Key Operational Insights


- SUVs dominate the product portfolio, generating **KSh 1.1 Billion** in revenue while accounting for **164 units sold**.
- Sedans rank second with approximately **KSh 200 Million** in revenue and **69 units sold**.
- Vans and saloons contribute the least revenue.
- Vehicle sales peaked in **February**.
- Revenue and gross profit reached their highest levels in **April**.
- Sales declined during the middle of the year before stabilizing toward the end of the year.
- **Faith Achieng** and **Grace** were the top-performing sales representatives, each generating approximately **KSh 350 Million** in revenue.
- Faith sold **54 units**, while Grace sold **53 units**.
- Mary, Brian, and Mercedes consistently sold more than **35 vehicles** each.

The dashboard shows strong sales activity across Kenya, particularly in:

- Nairobi
- Kisumu
- Mombasa
- Eldoret
- Kakamega

---

#  Recommendations

Based on the analysis, JCars Logistics should consider the following actions:

1. Increase inventory allocation and showroom space for **Toyota** vehicles and **SUVs**, which generate the highest revenue.

2. Review logistics operations serving **Eastern** and **Nyanza** regions, where delivery times exceed one month compared to approximately **16 days** in Central Kenya.

3. Investigate the high number of **Cancelled Orders** to identify operational bottlenecks and improve customer retention.

4. Encourage greater use of **Referral Marketing**, as it generated the highest number of vehicle sales.

5. Reward high-performing sales representatives to maintain motivation and improve overall sales performance.

6. Continue monitoring customer ratings and delivery performance to improve customer satisfaction.

---

#  Conclusion

This project demonstrates how Power BI can transform raw transactional data into meaningful business intelligence. Through data cleaning, modeling, DAX calculations, and interactive visualizations, the dashboard provides valuable insights into sales performance, profitability, customer behavior, and logistics operations. The findings support evidence-based decision-making and identify opportunities to improve operational efficiency and business growth.

---

## 👤 Author

**Robert Ruto**

*Data Analytics | Data Science | Business Intelligence | Machine Learning*
