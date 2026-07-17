# Education Sector Data Analysis using Power BI

## Project Overview

The Education Sector Data Analysis project is an end-to-end Power BI solution that transforms a dirty flat dataset into a structured analytical model to support educational decision-making. The project involved cleaning inconsistent data, designing a normalized star schema, creating reusable DAX measures, and building interactive dashboards to analyze student enrollment, school performance, teacher allocation, academic achievement, attendance, payments, and geographical trends.

The solution provides stakeholders with meaningful insights that help monitor institutional performance, identify underperforming schools, optimize resource allocation, and support data-driven decision-making.

---

## Project Objectives

The objectives of this project were to:

- Clean and prepare a dirty education dataset for analysis.
- Normalize the flat dataset into a well-structured star schema.
- Build relationships between fact and dimension tables.
- Create reusable DAX measures for key educational metrics.
- Analyze student enrollment, academic performance, attendance, teachers, schools, and revenue.
- Develop interactive dashboards for educational reporting.
- Provide actionable insights to improve academic outcomes and institutional performance.

---

## Tools Used

- Microsoft Power BI
- Power Query
- DAX (Data Analysis Expressions)
- Microsoft Excel

---

## Dataset

The dataset contains information on:

- record_id
- student_id
- student_full_name
- gender
- student_age
- date_of_birth
- admission_date
- grade_level
- class_stream
- school_id
- school_name
- school_type
- school_subcounty
- school_county
- school_region
- school_country
- student_subcounty
- student_county
- student_region
- student_country
- teacher_id
- teacher_name
- teacher_gender
- teacher_subject_specialty
- teacher_subcounty
- teacher_county
- teacher_region
- teacher_country
- subject_id
- subject_name
- term
- academic_year
- assessment_type
- score
- attendance_rate_pct
- fee_balance_kes
- scholarship_status
- learning_mode

---

## Data Cleaning

The following transformations were performed in Power Query:

- Removed duplicate records after validation.
- Corrected inconsistent spelling of schools, counties, regions, teachers, and subjects.
- Standardized text formatting using Proper Case.
- Replaced null and missing values where appropriate.
- Removed error values.
- Corrected invalid attendance percentages and academic scores.
- Converted dates into proper Date format.
- Corrected numeric and currency data types.
- Standardized gender values and category names.
- Standardized county, region, and sub-county names.
- Validated payment, fee balance, and scholarship information.
- Removed unnecessary columns.
- Ensured unique primary keys for all dimension tables.

These transformations produced a clean, reliable dataset suitable for analysis and reporting.

---

## Data Modeling

A Star Schema was implemented to improve performance and simplify reporting.

### Fact Table

**FactTable**

Stores measurable educational records, including:

- Student Scores
- Attendance Rate
- Fee Balance
- Scholarship Status
- Admission Date
- Academic Year

### Dimension Tables

**DimStudentTable**

Contains:

- Student ID
- Student Name
- Gender
- Grade Level
- Learning Mode
- County
- Region
- Sub-county
- Class Stream

**DimTeacherTable**

Contains:

- Teacher ID
- Teacher Name
- Gender
- Subject Specialization
- County
- Region
- Sub-county

**DimSchoolTable**

Contains:

- School ID
- School Name
- School Type
- County
- Region
- Sub-county

**DimSubjectTable**

Contains:

- Subject ID
- Subject Name
- Assessment Type

**DimDateTable**

Contains:

- Date
- Month
- Quarter
- Year

### Relationships

- One-to-Many (1:*) relationships
- Single-direction filtering
- Primary and foreign keys used throughout the model
- Optimized for efficient filtering and DAX calculations

This model reduces redundancy, improves performance, and supports interactive reporting across all educational dimensions.

![Data Modelling](https://github.com/ArapzRuto/Data-Science-and-Analytics-Portfolio/blob/main/Power%20BI-Based%20Projects/Education%20Sector%20%20Data%20%20Analysis/assets/Edu%20star%20schema.jpg)
---

## Dashboard Pages

### 1. Student Analysis Dashboard

Provides insights into:

- Total Students
- Attendance Rate
- Average Score
- Pass Rate
- Failure Rate
- Student Distribution by County
- Student Distribution by School
- Gender Distribution
- Enrollment by School
- School Pass and Failure Rates

---

### 2. School Analysis Dashboard

Displays:

- Total Schools
- Total Students
- Total Teachers
- Monthly Attendance Trend
- School Enrollment
- Student Distribution
- County Performance
- Student Population by School

---

### 3. Teacher Analysis Dashboard

Shows:

- Total Teachers
- Teacher-to-Student Ratio
- Pass Rate per Teacher
- Failure Rate per Teacher
- Teacher Distribution by County
- Teacher Workload
- Student Distribution Across Teacher Locations

---

### 4. Academic Performance Dashboard

Provides analysis on:

- Average Student Score
- Overall Pass Rate
- Overall Failure Rate
- Highest Performing Schools
- County Academic Performance
- Subject Failure Rate
- Students Below Pass Mark

---

## Insights From The Dashboards

### Core Performance Metrics

- Total Students: 324
- Total Schools: 13
- Total Teachers: 6
- Average Attendance Rate: 78%
- Average Student Score: 55.4
- Overall Pass Rate: 59–62%
- Overall Failure Rate: 38–41%

### Student & School Insights

- Nairobi County has the highest student population.
- Langata Plains School and Mvita Coast School have the largest student enrollment.
- Student gender distribution is relatively balanced.
- Enrollment varies significantly across schools.

### Teacher Insights

- Average teacher-to-student ratio is approximately 1:54.
- Kiambu has the highest number of teachers.
- Teacher distribution is fairly balanced, although additional teachers may improve learner support.

### Academic Performance Insights

- Kisauni Future School records the highest average academic score.
- Kisumu County has the best overall academic performance.
- Garden Court Academy and Athi River STEM School show comparatively lower academic performance and may require targeted support.
- Subject failure rates are relatively consistent across all subjects.

### Attendance Insights

- Attendance averages approximately 78%.
- Highest attendance occurs in February, November, and December.
- July records the lowest attendance.

### Geographic Insights

- Nairobi has the highest student population.
- Kisumu achieves the strongest academic performance despite lower enrollment.

---

## Recommendations

Based on the analysis, the following recommendations are proposed:

- Increase academic intervention programs in lower-performing schools.
- Recruit additional teachers to improve the teacher-to-student ratio.
- Strengthen attendance monitoring during low-attendance periods.
- Adopt best practices from high-performing schools such as Kisauni Future School.
- Allocate more educational resources to schools with high enrollment.
- Implement targeted support for students performing below the pass mark.
- Use the Power BI dashboards for continuous performance monitoring and evidence-based decision-making.

---

## Key Features

- Interactive Power BI dashboards
- Star schema data model
- Dynamic slicers and filters
- KPI Cards
- Drill-through capabilities
- Time intelligence using a Date dimension
- DAX measures for reusable calculations
- Cross-filtering across reports
- Responsive and user-friendly dashboard design

---

## Prepared By

**Robert Ruto**

*Data Analytics | Data Science | Business Intelligence | Machine Learning*
