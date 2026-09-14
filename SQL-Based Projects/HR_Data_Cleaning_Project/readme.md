# HR Data Cleaning Project

## Project Objectives
This project transforms raw, unstructured HR data into an analysis-ready dataset.

---

## Project Outline
* **Phase 1:** Create Database & Setup Environment
* **Phase 2:** Initial Data Quality Assessment Report
* **Phase 3:** Data Cleaning Steps Employed
  * **Step 1:** Rename and Standardize Column Heads
  * **Step 2:** Based on `employee_id`; Identify and Remove Duplicates, Missing Rows, and Special Characters
  * **Step 3:** Categorical Columns Cleaning and Standardization
  * **Step 4:** Numerical and Date Columns Cleaning and Standardization
* **Phase 4:** Final Quality Report
* **Phase 5:** Data Export

---

## Phase 1. Create Database & Setup

### Step 1: Database Setup
- I used the already created `MyPracticeProjects` Database.

### Step 2: Create Schema & Import Data
- I created the `HR_Data_Cleaning_Project` Schema.
- Having created the schema, I imported the data directly using the PostgreSQL import wizard.
- **Note:** I loaded all columns as `TEXT` to avoid import errors.

### Step 3: Create a Working Copy / Backup Table / Staging Table
- **Rule of Thumb:** Never clean the original data. Always preserve the raw data.
- I created a copy table using:
  ```sql
  CREATE TABLE hr_cleaned AS SELECT * FROM hr_dirty_datacsv;
  -- Or: SELECT * INTO hr_cleaned FROM hr_dirty_data_text;
  ```

---

## Phase 2. Initial Data Quality Assessment Report
*(Initial run to profile and understand the dirty text data before modifications).*

---

## Phase 3. Data Cleaning Steps Employed

### Step 1: Rename & Standardize Column Heads
- Needed to rename and standardize all column names.
- This replaces awkward capitalization and spaces with a clean, lowercase `snake_case` format.

### Step 2: Employee ID Cleaning & Deduplication
*Before removing duplicate records and missing rows, standardize the `employee_id` column:*
1. **Remove Special Characters:** Handled variations like text code footprints in IDs.
2. **Remove Null IDs:** Removed null and blank employee IDs.
3. **Trim Spaces:** Used `TRIM` on the `employee_id` column to remove leading and trailing spaces.
4. **Find & Preview Duplicates:** Grouped records to isolate duplicates.
5. **Deduplication Strategy (Second Approach):** 
   - Identified duplicates using a `ROW_NUMBER()` window function.
   - Having identified the duplicates, I deleted them using **`ctid`**.

> **Why ctid?**  
> `ctid` is PostgreSQL's internal row identifier. It uniquely identifies each physical row on the disk. It is commonly used for safely removing duplicates when a table lacks a unique primary key column.

### Step 3. Categorical Columns Cleaning and Standardization
- **Goal:** Fix category misspellings, typos, and missing values (handling both database `NULL`s and blank strings `''`).
- **Count Missing Values:** Calculated missing value metrics per column.
- **Address Missing Values:** For text or categorical columns, I replaced blank fields with a placeholder tracking value: **`'Unknown'`**.

### Step 4. Numerical and Date Columns Cleaning and Standardization
- **Goal:** Fix word numbers, `nan`, `N/A`, `''` (empty strings), and enforce correct database data types.
- **Workflow:** Executed a column-by-column clean-up.
- **Missing Value Strategy:** Replaced missing values with the **Column Median** (calculated using the exact middle value of data distributions). 
- *Exception:* Columns like `hire_date` and `last_promotion_year` only received data type conversions instead of median replacements.

---

## Phase 4. Final Quality Report
Validating the cleaned data by performing final database checks:
- Row count matches target
- Duplicate checks return zero rows
- Missing values handled
- Data types securely changed from `TEXT` to structural metrics (`INT`, `NUMERIC`, `DATE`)
- Summary statistics verification

---

## Phase 5. Data Export
The production-ready table is now ready for local system extraction or analytics warehouse pipeline ingestion.


## 👤 Author

**Robert Ruto**
*Data Analyst | Data Scientist | Researcher*

---

## 🔗 Connect With Me

* LinkedIn: https://www.linkedin.com/in/robert-ruto-4b2166112
* GitHub: https://github.com/ArapzRuto

---
## Article Link

[Link to your published article](https://dev.to/arapzruto/how-i-cleaned-messy-hr-dataset-using-postgresql-a-step-by-step-guide-5255)
