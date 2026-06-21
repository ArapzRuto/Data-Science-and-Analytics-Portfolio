# Hospital & Pharmacy Data Analysis 


## Project Overview

The Hospital & Pharmacy Data Analysis Dashboard is an interactive Power BI solution developed to analyze patient visits, disease patterns, departmental performance, and pharmacy operations within a county referral hospital. The project integrates data from multiple hospital departments and pharmacy records to provide actionable insights that support evidence-based decision-making.

The primary objective of the project was to transform messy healthcare data into meaningful business intelligence through data cleaning, modeling, analysis, and visualization. The dashboard enables hospital management to monitor key performance indicators, identify healthcare trends, optimize resource allocation, and improve service delivery.

---

## Business Problem

Healthcare facilities generate large volumes of operational and clinical data daily. However, without proper analysis, it becomes difficult to identify disease trends, evaluate departmental performance, understand medication consumption patterns, and manage pharmacy expenditure effectively.

Hospital management sought answers to the following business questions:

1. Which diseases are most common across counties?
2. Does a higher number of patient visits always lead to higher pharmacy revenue?
3. Which departments generate the highest pharmacy costs?
4. Are there age groups that consume more medication than others?
5. Are some diagnoses associated with longer hospital stays but lower pharmacy spending?

The dashboard was designed to address these questions and support strategic decision-making.

---

## Dataset Information

The project utilized data collected from three primary sources.

### Patients Dataset

Contains demographic information, including:

* Patient ID
* Age
* Gender
* County of Residence

### Visits Dataset

Contains hospital encounter information, including:

* Visit ID
* Patient ID
* Visit Date
* Department
* Diagnosis
* Length of Stay

### Pharmacy Transactions Dataset

Contains medication and financial information, including:

* Transaction ID
* Visit ID
* Drug Category
* Quantity Dispensed
* Pharmacy Cost

---

## Data Preparation and Transformation

The source data originated from different departments and required significant cleaning and transformation before analysis.

### Data Cleaning Activities

The following steps were performed using Power Query:

* Removed duplicate records
* Handled missing and incomplete values
* Standardized categorical fields
* Corrected inconsistent data entries
* Converted fields to appropriate data types
* Validated data relationships
* Created age group classifications
* Created a Date Dimension table for time-based analysis

### Data Modeling

A Star Schema model was implemented to improve performance and analytical flexibility.

#### Fact Tables

* Visits
* Pharmacy Transactions

#### Dimension Tables

* Patients
* Date Dimension

The model enabled efficient filtering and cross-analysis across patients, visits, diagnoses, departments, and pharmacy transactions.

---

## Dashboard Features

### Key Performance Indicators (KPIs)

| KPI                    | Description                                  |
| ---------------------- | -------------------------------------------- |
| Total Visits           | Total hospital visits recorded               |
| Total Pharmacy Revenue | Total pharmacy revenue generated             |
| Average Length of Stay | Average hospitalization duration             |
| Total Patients         | Unique patients served                       |
| Revenue per Visit      | Average pharmacy revenue generated per visit |

### Visualizations

The dashboard contains:

* Disease Trends Over Time
* Most Common Diseases by County
* Pharmacy Cost Breakdown by Drug Category
* Department Pharmacy Cost Analysis
* Patient Visits vs Pharmacy Revenue Analysis
* Medication Consumption by Age Group
* County-Level Healthcare Analysis
* Diagnosis vs Length of Stay and Pharmacy Spending
* Interactive Slicers for County, Diagnosis, and Date

---

## Key Findings

### 1. Disease Distribution

Some diseases were reported more frequently than others across the counties. This indicates areas where healthcare resources may need to be focused.

### 2. Patient Visits and Pharmacy Revenue

The analysis showed that an increase in patient visits does not always result in higher pharmacy revenue. Some departments generated high revenue despite having fewer visits.

### 3. Department Pharmacy Costs

Certain departments recorded higher pharmacy costs than others. This suggests differences in treatment requirements and medication usage across departments.

### 4. Medication Consumption by Age Group

Medication usage varied among age groups. Older patients generally consumed more medication compared to younger patients.

### 5. Length of Stay and Pharmacy Spending

Some diagnoses were associated with longer hospital stays but did not always lead to high pharmacy spending. This shows that hospital stay duration and medication costs do not always move together.

---

## Recommendations

Based on the analysis, the following recommendations were made:

* Monitor common diseases and allocate resources appropriately.
* Track departments with high pharmacy costs.
* Improve planning for medication demand among older patients.
* Monitor diagnoses associated with long hospital stays.
* Use data-driven insights to support budgeting and operational decisions.

---

## Tools Used

* Microsoft Power BI
* Power Query
* Data Modeling
* DAX Measures
* Interactive Visualizations

---

## Conclusion

This project demonstrated how Power BI can transform healthcare data into meaningful insights. The dashboard helps hospital management understand disease patterns, pharmacy performance, and patient trends, enabling better decision-making and resource planning.

---

## Dashboard Preview

### Executive Dashboard

![Dashboard Overview](assets/dashboard-overview.png)


---

## Author

**Robert Ruto**

*Data Analytics |Data Science | Business Intelligence | Machine Learning*
