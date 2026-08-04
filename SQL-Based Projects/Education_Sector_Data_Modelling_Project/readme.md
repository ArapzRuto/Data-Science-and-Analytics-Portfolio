## Data Modeling

This project implements a **Star Schema** data model to organize education sector data for efficient reporting and analysis. The project used the previously cleaned education sector data .

---

## Data Model

The formulated star schema consists of the following dimension and fact tables;

- **`dim_student`** – Stores student demographic and location information.
- **`dim_school`** – Stores school details such as school name, type, county, and region.
- **`dim_teacher`** – Stores teacher information, including gender, subject specialization, and location.
- **`dim_subject`** – Stores the list of academic subjects.

- **`fact_student_performance`** – Stores student performance metrics, including assessment scores, attendance rates, fee balances, scholarship status, learning mode, grade level, class stream, and admission date. This table is linked to all dimension tables through foreign keys.

---

## Data Modeling Process

The following steps were followed to build the data model:

### 1. Data Profiling
- Identified business entities and measurable attributes by  grouping them  into **dimensions** and **facts**.

### 2. Dimension Table Creation
- Created normalized dimension tables  each with  **primary keys** to uniquely identify each entity.

### 3. Fact Table Creation
- Created a central fact table with a **foreign key** .

### 4. Data Loading (ETL)
- Loaded unique records into each dimension  and fact table.


### 5. Data Validation
- Checked for duplicate and missing records to ensure data integrity and consistency.