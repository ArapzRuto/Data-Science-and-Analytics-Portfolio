# Education Sector Data Cleaning Using SQL

## Project Overview

This project focuses on cleaning a dirty education sector dataset using **PostgreSQL**. The dataset contains information about students, schools, teachers, subjects, locations, academic performance, fee payments, and other related records.

The goal is to transform raw, inconsistent data into a clean, reliable dataset that is ready for analysis.

---

## Objective

The objective of this project is to clean and prepare the dataset entirely using SQL by:

- Loading the dirty dataset from Microsoft Excel into PostgreSQL.
- Identifying and correcting data quality issues.
- Standardizing values across the dataset.
- Converting columns to appropriate data types.
- Producing a clean dataset suitable for analysis and reporting.

---

## Data Quality Issues Addressed

The dataset contained several common data quality problems, including:

- Inconsistent category names
- Mixed uppercase and lowercase values
- Misspelled values
- Short forms and abbreviations
- Missing (NULL) values
- Error values
- Incorrect data types
- Invalid numeric values
- Dates stored in incorrect formats
- Duplicate records where applicable
- Inconsistent location names
- Inconsistent school, teacher, and student information
- Incorrect or unclear values in performance and payment-related fields

---

## SQL Skills Demonstrated

This project demonstrates the following SQL skills:

- `CREATE TABLE`
- `ALTER TABLE`
- `UPDATE`
- `GROUP BY`
- `HAVING`
- Aggregate Functions
- Regular Expressions (`regexp_replace`)
- Date Conversion
- Numeric Conversion
- NULL Handling
- Data Validation
- Information Schema Queries

---

## Data Cleaning Process

### Step 1: Create Raw Table

Created a table with all columns initially defined as `TEXT` to simplify data import and avoid conversion errors.

### Step 2: Import Raw Dataset

Imported the dirty dataset from Excel into PostgreSQL.

### Step 3: Create a Staging Table

Created a working copy of the raw dataset to preserve the original data.

### Step 4: Explore the Data

Performed initial data profiling by:

- Counting records
- Counting columns
- Checking for duplicate records
- Reviewing unique values
- Identifying missing data

### Step 5: Remove Unnecessary Columns

Dropped columns that were not required for analysis.

### Step 6: Clean Individual Columns

Performed data cleaning on:

- Student names
- Gender
- Age
- Dates
- Counties
- Regions
- Subjects
- School types
- Assessment types
- Scores
- Attendance rates
- Fee balances
- Scholarship status
- Learning mode

Cleaning tasks included:

- Standardizing text values
- Correcting spelling mistakes
- Expanding abbreviations
- Replacing missing values
- Removing invalid characters
- Converting text columns to numeric and date data types

### Step 7: Validate the Cleaned Data

Performed validation checks to ensure:

- No unexpected NULL values remained
- Valid gender categories
- Scores were within acceptable ranges
- Data was ready for analysis

---

## Dataset Summary

| Metric | Value |
|---------|------:|
| Total Records | 324 |
| Raw Columns | 44 |
| Cleaned Columns | 33 |

---

## Technologies Used

- PostgreSQL
- SQL

---

## Project Outcome

By completing this project, the dataset was transformed into a clean, standardized, and analysis-ready format. The project demonstrates practical SQL data cleaning techniques commonly used in real-world data analytics and ETL workflows.