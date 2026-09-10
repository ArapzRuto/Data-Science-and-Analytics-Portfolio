Phase 1: Imported the Required Libraries and Loaded the Dataset
Library Import:
Dataset Loading:
Phase 2: Initial Data Quality Assessment
Constructed an initial data quality report to evaluate:
Column names and total column count
Data types per column
Total row count
Missing value counts and missing percentages
Unique value counts per column
Phase 3: Data Cleaning Steps Employed
Step 1: Renamed and Standardized Column Headers
Explored existing column headings.
Cleaned headers by:
Converting letters to lowercase
Removing leading and trailing spaces
Replacing non-alphanumeric characters and spaces with underscores
Eliminating consecutive underscores
Step 2: Identified and Removed Duplicates and Missing Values
Counted duplicate records using:
Inspected duplicated rows using:
Removed duplicated rows using:
Inspected and permanently dropped rows with missing employee_id.
Step 3: Categorical Columns Cleaning and Standardization
Selected object/string/category columns using:
String Normalization and Typo Correction:
Cleaned columns by removing whitespace and applying title casing
Resolved misspellings
Standardized values
Converted varied inputs into consistent formats
Corrected typos
Standardized geographic names
Replaced missing values and blanks with Unknown
Step 4: Numerical and Date Field Transformation
Stripped currency symbols, commas, and spaces.
Imputed missing entries with the column median.
Converted hire_date to the date data type.
Phase 4: Final Data Quality Report
Re-generated a final data quality report to display:
Row counts
Missing value tallies (0 nulls remaining)
Unique value distributions
Phase 5: Data Export
Exported the cleaned dataset to a clean Excel spreadsheet named HR_Cleaned_Data.xlsx.