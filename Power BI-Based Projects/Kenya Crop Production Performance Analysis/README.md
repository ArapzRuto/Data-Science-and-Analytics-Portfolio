# Kenya Crop Production Performance Analysis

##  Project Overview

Agriculture is one of the largest contributors to Kenya's economy, with crop farming supporting millions of households. This project analyzes agricultural production data collected from multiple counties across Kenya to evaluate farm productivity, profitability, operational efficiency, and environmental factors affecting crop production.

The original dataset contained several data quality issues, including missing values, duplicate records, inconsistent text formatting, and invalid financial calculations. Using **Microsoft Power BI**, the dataset was cleaned, transformed, modeled into a **Star Schema**, and analyzed through interactive dashboards to support evidence-based decision-making.

---

#  Project Objectives

The objectives of this project were to:

- Clean and transform a dirty agricultural dataset using Power Query.
- Build a Star Schema data model for efficient reporting.
- Develop DAX measures for production and financial analysis.
- Design an interactive four-page dashboard in Power BI.
- Identify key production, profitability, and operational trends.
- Provide actionable recommendations for improving agricultural performance.

---

#  Tools Used

- Microsoft Power BI
- Power Query
- DAX (Data Analysis Expressions)
- Microsoft Excel

---

#  Dataset

The dataset contains information on:

- Farmers
- Counties
- Crop Types
- Crop Varieties
- Farming Seasons
- Planted Area (Acres)
- Yield (Kg)
- Market Price
- Revenue
- Cost of Production
- Profit
- Irrigation Method
- Soil Type
- Fertilizer Used
- Weather Impact
- Planting Date
- Harvest Date

---

#  Data Cleaning

The following transformations were performed in Power Query:

- Removed duplicate records.
- Corrected inconsistent text formatting.
- Standardized county and crop names.
- Converted columns to appropriate data types.
- Corrected financial calculations where necessary.
- Created derived columns:
  - Harvest Duration
  - Yield per Acre
  - Profit per Acre
  - Production Cost per Kg
- Replaced missing categorical values with **"Unknown"** where appropriate.
- Removed invalid and incomplete records that would affect analysis.

---

#  Data Model

A **Star Schema** was implemented consisting of:

## Fact Table

- Fact_CropProduction

## Dimension Tables

- Dim_Calendar
- Dim_County
- Dim_Crop
- Dim_Season
- Dim_Soil
- Dim_Irrigation
- Dim_Fertilizer
- Dim_Weather

This structure improves model performance, simplifies DAX calculations, and enables efficient filtering across reports.
## Star Schema Overview
![Star Schema Overview](https://github.com/ArapzRuto/Data-Science-and-Analytics-Portfolio/blob/main/Power%20BI-Based%20Projects/Kenya%20Crop%20Production%20Performance%20Analysis/assets/Kenya_Crops_Analysis%20Data%20Modelling.jpg)

---

#  Dashboard Pages

##  Page 1 – Executive Overview

Provides a high-level summary of:

- Total Revenue
- Total Profit
- Total Cost
- Total Yield
- Total Farmers
- Profit Margin
- Revenue by County
- Profit by Crop Type
- Revenue Trend by Season

---

##  Page 2 – Production Analysis

Analyzes production efficiency through:

- Yield by Crop Type
- Yield by County
- Yield Distribution
- Yield per Acre
- Harvest Duration
- Production Summary Matrix

---

##  Page 3 – Profitability Analysis

Focuses on financial performance using:

- Top Performing Farmers
- Profit by Soil Type
- Profit by Weather Impact
- Profit by Irrigation Method
- Profit by Fertilizer Used
- Yield vs Profit Analysis

---

##  Page 4 – Farm Operations Analysis

Examines operational efficiency through:

- Harvest Duration
- Production Cost per Kg
- Profit per Acre
- Farmer-Level Operational Summary

---

#  Business Questions and Findings

## 1. Which county generates the highest revenue?

Analysis of revenue by county indicates that **Nairobi** generates the highest overall revenue, followed closely by **Kisumu** and **Machakos**.

###  Business Insight

Counties with higher revenue may benefit from better market access, improved farming practices, or larger cultivated areas. These regions can serve as benchmarks for best practices.

---

## 2. Which crop is the most profitable?

**Rice** emerged as the most profitable crop, generating the highest total profit, followed by **Cassava** and **Tea**.

###  Business Insight

Rice combines strong market prices with relatively high yields, making it the best-performing crop in terms of profitability. Farmers seeking to maximize returns may prioritize crops with similar economic characteristics.

---

## 3. Which farming season produces the highest yield?

The **Long Rains** season consistently produces the highest crop yields compared to the **Short Rains** and **Dry Season**.

###  Business Insight

Favorable rainfall during the Long Rains significantly improves crop productivity. Planning planting schedules around this season can increase overall farm output.

---

## 4. Which irrigation method performs best?

The analysis shows that **Flood Irrigation** generates the highest overall profit, followed closely by **Drip Irrigation**.

###  Business Insight

While Flood Irrigation currently produces higher aggregate profits, Drip Irrigation offers efficient water usage and may provide greater long-term sustainability, particularly in water-scarce regions.

---

## 5. Which soil type gives the highest yield?

**Silty Soil** produces the highest yields, followed by **Clay** and **Sandy** soils.

###  Business Insight

Silty soils provide excellent moisture retention and nutrient availability, making them highly suitable for crop production.

---

## 6. Which fertilizer contributes to the highest profit?

Records indicate that **CAN fertilizer** contributes to the highest profit among the known fertilizer types. The **Unknown** category also shows high profit but represents incomplete data rather than a meaningful recommendation.

###  Business Insight

Proper fertilizer selection has a measurable impact on profitability. Improving fertilizer data quality would support more accurate agronomic recommendations.

---

## 7. Which weather condition negatively affects production?

**Severe weather conditions** are associated with the lowest profits and reduced production performance compared to **Mild** weather. The **Unknown** category highlights missing environmental data that should be addressed.

###  Business Insight

Extreme weather remains one of the largest production risks. Climate-smart agricultural practices and early warning systems can help reduce weather-related losses.

---

## 8. Which farmers consistently generate the highest profits?

The highest-performing farmers include:

- Farmer 402
- Farmer 23
- Farmer 458
- Farmer 266
- Farmer 126
- Farmer 80
- Farmer 198
- Farmer 313
- Farmer 316

###  Business Insight

Studying the practices adopted by these farmers may reveal techniques that can be shared across farming communities to improve overall productivity.

---

## 9. Which counties have the highest production costs?

The counties with the highest production costs include:

- Nairobi
- Kisumu
- Machakos
- Nakuru

These counties also report relatively high production volumes.

###  Business Insight

Higher production costs do not necessarily indicate poor performance if they are accompanied by proportionally higher revenues and profits. Cost efficiency should therefore be evaluated alongside revenue generation.

---

## 10. What factors influence profitability the most?

The dashboard indicates that profitability is primarily influenced by:

- Crop Type
- Yield
- Market Price
- Production Cost
- Irrigation Method
- Weather Conditions
- Soil Type
- Farming Season

Among these, **Yield** and **Production Cost** have the strongest direct impact on profitability.

###  Business Insight

Increasing yields while controlling production costs provides the greatest opportunity for improving farm profitability.

---

#  Key Insights

- Rice is the highest-profit crop.
- Nairobi generates the highest revenue.
- Long Rains produce the highest yields.
- Flood Irrigation currently generates the highest profits.
- Silty soils provide the highest crop yields.
- CAN fertilizer is associated with the best financial performance among known fertilizer types.
- Severe weather significantly reduces profitability.
- Higher production costs are concentrated in high-output counties.
- Yield and production cost are the primary drivers of farm profitability.

---

#  Recommendations

Based on the analysis, the following recommendations are proposed:

- Expand best farming practices observed in high-performing counties to other regions.
- Promote cultivation of highly profitable crops such as Rice and Cassava where agroecological conditions permit.
- Optimize planting schedules to maximize production during the Long Rains season.
- Encourage adoption of efficient irrigation systems while balancing profitability and sustainability.
- Improve soil management practices to enhance productivity, particularly in lower-yield regions.
- Standardize fertilizer application and improve data collection to reduce the number of unknown records.
- Invest in climate-resilient farming techniques to reduce weather-related production risks.
- Monitor production costs closely and implement cost-control measures without compromising yield.
- Facilitate knowledge sharing from consistently high-performing farmers to improve sector-wide productivity.

---

