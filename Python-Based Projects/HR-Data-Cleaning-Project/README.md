# HR DATA CLEANING
 **Project Objectives**
- This project transforms raw, unstructured HR data into an analysis-ready dataset by leveraging modular and reusable Python functions.
## Phase 1:
- Imported the Required Libraries and Loaded the Dataset
## Phase 2: Initial Data Quality Assessment
- Constructed an initial data quality report to evaluate:
1. Column names and total column count
2. Data types per column
3. Total row count
4. Missing value counts and missing percentages
5. Unique value counts per column
## Phase 3: Data Cleaning Steps Employed
 ### Step 1: Renamed and Standardized Column Headers
- Explored existing column headings.
- Cleaned headers by:
1. Converting letters to lowercase
2. Removing leading and trailing spaces
3. Replacing non-alphanumeric characters and spaces with underscores
4. Eliminating consecutive underscores
   
### Step 2: Identified and Removed Duplicates and Missing Values
- Counted duplicate records
- Inspected duplicated rows 
- Removed duplicated rows based on `employee_id`
- Inspected and permanently dropped rows with missing `employee_id`
  
### Step 3: Categorical Columns Cleaning and Standardization
- Selected object/string/category columns
- String Normalization and Typo Correction
- Cleaned columns by removing whitespace and applying title casing
- Resolved misspellings
- Standardized values
- Converted varied inputs into consistent formats
- Standardized geographic names
- Replaced missing values and blanks with Unknown
  
### Step 4: Numerical and Date Field Transformation
- Stripped currency symbols, commas, and spaces.
- Imputed missing entries with the column median.
- Converted hire_date to the date data type.
  
### Phase 4: Final Data Quality Report
- Re-generated a final data quality report to display:
1. Row counts
2. Missing value tallies (0 nulls remaining)
3. Unique value distributions
   
### Phase 5: Data Export
Exported the cleaned dataset to a clean Excel spreadsheet named HR_Cleaned_Data.xlsx.
