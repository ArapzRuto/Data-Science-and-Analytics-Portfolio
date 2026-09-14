--HR DATA CLEANING PROJECT

--Project Objectives--
--This project transforms raw, unstructured HR data into an analysis-ready dataset .

--The project outline  is as below;
/*
Phase 1. Create Database
Phase 2. Initial Data Quality Assessment Report
Phase 3. Data Cleaning Steps Employed
         --Step 1: Rename  and Standardize Column Heads
         --Step 2: Based on employee_id; Identify and Remove Duplicates, Missing Rows and Special Characters
         --Step 3. Categorical Columns Cleaning and Standardization
         --Step 4. Numerical and Date Columns Cleaning and Standardization
Phase 4. Final Quality Report
Phase 5.Data Export*/

--Phase 1. Create Database
--I used already created MyPracticeProjects Database

--Step 2: Create Schema
--I created HR_Data_Cleaning_Project Schema
--Having  created schema, i imimported the data directly using postgresql  import wizard
--I loaded all columns as TEXT to avoid import errors.

select *from hr_dirty_datacsv hdd ;

--Step 3: Create a Working Copy/Backup Table/Staging Table
--Never clean the original data.
--Always preserve the raw data.

create table hr_cleaned as select *from hr_dirty_datacsv;
-- Or: SELECT * INTO hr_cleaned FROM hr_dirty_data_text;

select *from hr_cleaned hc

 --Phase 2. Initial Data Quality Assessment Report

--Phase 3. Data Cleaning Steps Employed
--Step 1: Rename  and Standardize Column Heads
    -- Needed to rename  and standardize all all columns names
    -- To replace awkward capitalization and spaces with clean snake_case format.

alter table hr_cleaned rename column "Employee ID" to employee_id;
alter table hr_cleaned rename column "First Name" to first_name;
alter table hr_cleaned rename column "Last Name" to last_name;
alter table hr_cleaned rename column "Department" to department;
alter table hr_cleaned rename column "Salary" to salary;
alter table hr_cleaned rename column "Hire Date" to hire_date;
alter table hr_cleaned rename column "Age" to age;
alter table hr_cleaned rename column "Gender" to gender;
alter table hr_cleaned rename column "Performance Score" to performance_score;
alter table hr_cleaned rename column "Full-Time" to full_time;
alter table hr_cleaned rename column "Bonus" to bonus;
alter table hr_cleaned rename column "Marital Status" to marital_status;
alter table hr_cleaned rename column "Education Level" to education_level;
alter table hr_cleaned rename column "Work Experience (Years)" to work_experience_years;
alter table hr_cleaned rename column "Employee Type" to employee_type;
alter table hr_cleaned rename column "Office Location" to office_location;
alter table hr_cleaned rename column "Project Count" to project_count;
alter table hr_cleaned rename column "Last Promotion Year" to last_promotion_year;
alter table hr_cleaned rename column "Remote Work Status" to remote_work_status;
alter table hr_cleaned rename column "Annual Training Hours" to annual_training_hours;
alter table hr_cleaned rename column "Manager Feedback Score" to manager_feedback_score;

--Step 2: Based on employee_id; Identify and Remove Duplicates, Missing Rows and Special Characters
--Before removing duplicate records and missing rows, standardize employee_id column

--Step 1. Removed Text From employee_id
update hr_cleaned hc 
set employee_id=10081
where employee_id='EMP-10081';

update hr_cleaned hc 
set employee_id=10308
where employee_id='EMP-10308';

update hr_cleaned hc 
set employee_id=10383
where employee_id= 'EMP-10383';

update hr_cleaned hc 
set employee_id=10540
where employee_id= 'EMP-10540';

--Step 2. Removed null employee ids

delete from hr_cleaned
where employee_id=null or employee_id='';

select count(*) as count_of_employees 
from hr_cleaned hc ;--852

select count(*) as count_of_employees 
from hr_dirty_datacsv hdd ;--876

--Step 3. Trim employee_id column  to remove leading and trailing spaces

select trim(employee_id)
from hr_cleaned;

--Step 4.Find  and preview duplicates:

--First Appoach
select employee_id,
count(*) as total_duplicates
from hr_cleaned hc 
group by employee_id
having count(*) > 1;--There are 17 duplicates as per employee_id


--Second Appoach
-- Identify using row_number

with duplicates as 
(
    select employee_id,
    row_number() over (
    partition by employee_id
    order by employee_id
    ) as ranked
    from hr_cleaned
)
select *
from duplicates
where ranked > 1;

--Having identified duplicates delete them using ctid

/*Why ctid?
-ctid is PostgreSQL's internal row identifier.
-It uniquely identifies each physical row.
-It is commonly used for removing duplicates when there is no unique primary key.*/

with duplicates as 
(
select ctid,
row_number() over (
partition by employee_id
order by employee_id
) as ranked
from hr_cleaned
)
delete from hr_cleaned
where ctid in 
(
select ctid
from duplicates
where ranked > 1
);

select count(*)
from hr_cleaned; -- After id column cleaning, 852 records remained.

--Step 3. Categorical Columns Cleaning and Standardization
-- Fix Category Misspellings, Typos and missing values
--both NULLs and blank strings.
--Count missing values per column:

select
    sum(case when employee_id is null or trim(employee_id) = '' then 1 else 0 end) as missing_employee_id,
    sum(case when first_name is null or trim(first_name) = '' then 1 else 0 end) as missing_first_name,
    sum(case when last_name is null or trim(last_name) = '' then 1 else 0 end) as missing_last_name,
    sum(case when department is null or trim(department) = '' then 1 else 0 end) as missing_department,
    sum(case when gender is null or trim(gender) = '' then 1 else 0 end) as missing_gender,
    sum(case when full_time is null or trim(full_time) = '' then 1 else 0 end) as missing_full_time,    
    sum(case when marital_status is null or trim(marital_status) = '' then 1 else 0 end) as missing_marital_status,
    sum(case when education_level is null or trim(education_level) = '' then 1 else 0 end) as missing_education_level,    
    sum(case when employee_type is null or trim(employee_type) = '' then 1 else 0 end) as missing_employee_type,
    sum(case when office_location is null or trim(office_location) = '' then 1 else 0 end) as missing_office_location,    
    sum(case when remote_work_status is null or trim(remote_work_status) = '' then 1 else 0 end) as missing_remote_work_status    
from hr_cleaned;

--Address Nissing Values
--For text or categorical columns, i replaced blank fields with a placeholder  "Unknown"

update hr_cleaned
set department = 'Unknown'
where department is null or department = '';

update hr_cleaned
set gender = 'Unknown'
where gender is null or gender = '';

update hr_cleaned
set full_time = 'Unknown'
where full_time is null or full_time = '';

update hr_cleaned
set marital_status = 'Unknown'
where marital_status is null or marital_status = '';

update hr_cleaned
set education_level = 'Unknown'
where education_level is null or education_level = '';

update hr_cleaned
set employee_type = 'Unknown'
where employee_type is null or employee_type = '';

update hr_cleaned
set office_location = 'Unknown'
where office_location is null or office_location = '';

update hr_cleaned
set remote_work_status = 'Unknown'
where remote_work_status is null or remote_work_status = '';

-- Standard Categories Per Column

--Standardize department

select distinct trim(department)
from hr_cleaned hc ;

update hr_cleaned hc 
set department = 'IT' 
where department in ('Information Tech','I.T','Info Tech');

update hr_cleaned hc 
set department = 'HR' 
where department in ('Humna Resources','Hr','H.R','human resources','Humman Res.','Human Resources','Human Resource');
 
update hr_cleaned hc 
set department = 'Operations' 
where department in ('Operatons','Ops');

update hr_cleaned hc 
set department = 'Finance' 
where department in ('finance','Finanace');

update hr_cleaned hc 
set department = 'Sales' 
where department in ('Sale');

update hr_cleaned hc 
set department = 'Marketing' 
where department in ('Markting');


----Standardize gender

select distinct trim(gender)
from hr_cleaned hc ;

update hr_cleaned hc 
set gender = 'Female' 
where gender in ('female','Femle','F');

update hr_cleaned hc 
set gender = 'Male' 
where gender in ('M','MALE','male');

update hr_cleaned hc 
set gender = 'Not Provided' 
where gender in ('Prefer not say','');


--Standardize marital status
select distinct trim(marital_status) 
from hr_cleaned hc ;

update hr_cleaned hc 
set marital_status= 'Widowed' 
where hc.marital_status  in ('Widwowed');

update hr_cleaned hc 
set marital_status= 'Married' 
where hc.marital_status  in ('maried');

update hr_cleaned hc 
set marital_status= 'Single' 
where hc.marital_status  in ('single');

--standardize education_level 
select distinct trim(education_level) 
from hr_cleaned hc  

update hr_cleaned hc 
set education_level= 'High School' 
where hc.education_level   in ('high school','High Sch');

update hr_cleaned hc 
set education_level= 'PhD' 
where hc.education_level   in ('PHD','phd');

update hr_cleaned hc 
set education_level= 'Masters' 
where hc.education_level   in ('MSc','Master''s');

update hr_cleaned hc 
set education_level= 'Bachelors' 
where hc.education_level   in ('Bachelor','Bachelor''s','Bachelor''s','Bachelor');

update hr_cleaned hc 
set education_level= 'Associates' 
where hc.education_level   in ('Associate''s');


--standardize employee_type

select distinct trim(employee_type) 
from hr_cleaned hc 

update hr_cleaned hc 
set employee_type= 'Contract' 
where hc.employee_type    in ('Contrct','contractor');

update hr_cleaned hc 
set employee_type= 'Permanent' 
where hc.employee_type    in ('Perm','permanent');

update hr_cleaned hc 
set employee_type= 'Intern' 
where hc.employee_type    in ('Inten','intern');


--standardize office_location 

select distinct trim(office_location) 
from hr_cleaned hc 

update hr_cleaned hc 
set office_location= 'San Fransisco' 
where hc.office_location   in ('SF','San Francisco');

update hr_cleaned hc 
set office_location= 'London' 
where hc.office_location   in ('Londn');

update hr_cleaned hc 
set office_location= 'Nairobi' 
where hc.office_location   in ('NAIROBI','Nairob');

update hr_cleaned hc 
set office_location= 'Berlin' 
where hc.office_location   in ('Berln');

update hr_cleaned hc 
set office_location= 'Tokyo' 
where hc.office_location   in ('Tokio');


update hr_cleaned hc 
set office_location= 'Unknown' 
where hc.office_location   in ('Remote');

--Step 4. Numerical and Date Columns Cleaning and Standardization

--Fix  word numbers,nan,N/A,'', & Data types

--Column By Column Clean Up

--check data types
select column_name, data_type
from information_schema.columns
where table_schema = 'HR_Data_Cleaning_Project'
and table_name = 'hr_cleaned'
order by  ordinal_position;--Indicates that all columns are text (Character Varying)

--1.salary Column

--Remove both currency prefixes

update hr_cleaned
set salary = trim(replace(replace(replace(salary, 'KES ', ''),'$', ''),',',''));

--Convert to integer

alter table hr_cleaned
alter column salary type integer
using nullif(trim(salary), '')::integer;

--2.hire_date Column

--3.Age Column

update hr_cleaned 
set age=30
where age='thirty';

alter table hr_cleaned
alter column age type numeric
using nullif(trim(age), '')::numeric;

--4.performance_score Column

--Check for formatting problems
select distinct performance_score
from hr_cleaned
where performance_score is not null
order by performance_score;

--There two issues, Excellent ,N/A and Poor

update hr_cleaned hc 
set performance_score=9
where performance_score='Excellent';

update hr_cleaned hc 
set performance_score=0
where performance_score='Poor';

update hr_cleaned hc 
set performance_score=''
where performance_score='N/A';

--Now convert data type

alter table hr_cleaned 
alter column performance_score type numeric
using nullif(trim(performance_score), '')::numeric;

--5.bonus Column

--Check for formatting problems
select distinct bonus
from hr_cleaned
where bonus is not null
order by bonus;-- The formatting issue is KES and -

--Remove KES

update hr_cleaned hc 
set bonus= trim(replace(replace(replace(bonus,'KES',''),'-',''),'N/A',''));

--Now convert

alter table hr_cleaned 
alter column bonus type numeric
using nullif(trim(bonus),'')::numeric;

--6. work_experience_years

--Check for formatting problems
select distinct work_experience_years
from hr_cleaned
where work_experience_years is not null
order by work_experience_years;

--Remove years,N/A, -

update hr_cleaned hc 
set work_experience_years= trim(replace(replace(replace(work_experience_years,'years',''),'-',''),'N/A',''));

--Now convert

alter table hr_cleaned 
alter column work_experience_years type numeric
using nullif(trim(work_experience_years),'')::numeric;

--7.project_count
--Check for formatting problems
select distinct project_count
from hr_cleaned
where project_count is not null
order by project_count;

--Remove ten,N/A, -

update hr_cleaned hc 
set project_count= trim(replace(replace(project_count,'ten','10'),'N/A',''));

--Now convert

alter table hr_cleaned 
alter column project_count type numeric
using nullif(trim(project_count),'')::numeric;

--8.last_promotion_year Column

--Check for formatting problems
select distinct last_promotion_year
from hr_cleaned;
  

--Replace never and N/A with blank

update hr_cleaned hc 
set last_promotion_year=''
where last_promotion_year='Never';

update hr_cleaned hc 
set last_promotion_year=''
where last_promotion_year='N/A';

--Now convert

alter table hr_cleaned 
alter column last_promotion_year type date
using to_date (nullif(trim(last_promotion_year),''),'YYYY');

--9. annual_training_hours
--Check for formatting problems
select distinct annual_training_hours
from hr_cleaned;
  

--Replace never and N/A with blank

update hr_cleaned hc 
set annual_training_hours=''
where annual_training_hours='None';

update hr_cleaned hc 
set annual_training_hours=''
where annual_training_hours='N/A';

--Now convert

alter table hr_cleaned 
alter column annual_training_hours type numeric
using nullif(trim(annual_training_hours),'')::numeric;

--10. manager_feedback_score
--Check for formatting problems
select distinct manager_feedback_score
from hr_cleaned;
  

--Replace Good and N/A with blank

update hr_cleaned hc 
set manager_feedback_score=4
where manager_feedback_score='Good';

update hr_cleaned hc 
set manager_feedback_score=''
where manager_feedback_score='N/A';

--Now convert

alter table hr_cleaned 
alter column manager_feedback_score type numeric
using nullif(trim(manager_feedback_score),'')::numeric;


 -- Handle Remaining Missing Values(Numerical Columns)
--Identify Missing Values
select    
    sum(case when salary is null  then 1 else 0 end) as missing_salary,
    sum(case when hire_date is null or trim(hire_date) = '' then 1 else 0 end) as missing_hire_date,
    sum(case when age is null  then 1 else 0 end) as missing_age,    
    sum(case when performance_score is null  then 1 else 0 end) as missing_performance_score,    
    sum(case when bonus is null  then 1 else 0 end) as missing_bonus,    
    sum(case when work_experience_years is null  then 1 else 0 end) as missing_work_experience_years,    
    sum(case when project_count is null then 1 else 0 end) as missing_project_count,
    sum(case when last_promotion_year is null then 1 else 0 end) as missing_last_promotion_year,    
    sum(case when annual_training_hours is null  then 1 else 0 end) as missing_annual_training_hours,
    sum(case when manager_feedback_score is null then 1 else 0 end) as missing_manager_feedback_score
from hr_cleaned;

-- Replace Missing Vlaues  with Column Median
--Except,hire_date,last promotion_year (Just Change Data types)

-- Salary Column
-- Claculate median
select percentile_cont(0.5) within group(order by salary) as median_salary
from hr_cleaned hc 

--Now replace null values
update hr_cleaned hc 
set salary=76023.0
where salary is null;

-- Age Column
select percentile_cont(0.5) within group(order by age) as median_age
from hr_cleaned hc 

--Now replace null values
update hr_cleaned hc 
set age=41
where age is null;

-- performance_score Column
select percentile_cont(0.5) within group(order by performance_score) as performance_score
from hr_cleaned hc 

--Now replace null values
update hr_cleaned hc 
set performance_score=5
where performance_score is null;

-- bonus Column
select percentile_cont(0.5) within group(order by bonus) as median_bonus
from hr_cleaned hc 

--Now replace null values
update hr_cleaned hc 
set bonus=5097.905000000001
where bonus is null;


-- work_experience_years Column
select percentile_cont(0.5) within group(order by work_experience_years) as median_work_experience_years
from hr_cleaned hc 

--Now replace null values
update hr_cleaned hc 
set work_experience_years=20
where work_experience_years is null;

-- project_count Column
select percentile_cont(0.5) within group(order by project_count ) as median_project_count 
from hr_cleaned hc 

--Now replace null values
update hr_cleaned hc 
set project_count =10
where project_count  is null;


-- annual_training_hours Column
alter table hr_cleaned 
alter column annual_training_hours type int 
using nullif(trim(annual_training_hours), '')::integer;


select percentile_cont(0.5) within group(order by annual_training_hours) as median_annual_training_hours
from hr_cleaned hc 

--Now replace null values
update hr_cleaned hc 
set annual_training_hours=20
where annual_training_hours is null;

-- manager_feedback_score Column
select percentile_cont(0.5) within group(order by manager_feedback_score) as median_manager_feedback_score
from hr_cleaned hc 

--Now replace null values
update hr_cleaned hc 
set manager_feedback_score=3.1
where manager_feedback_score is null;


--Phase 4. Final Quality Report
--Validate the Cleaned Data
/*
 Perform final checks:
-row count
-duplicate check
-missing values
-data types
-summary statistics*/

select *from hr_cleaned;



--Phase 5.Data Export
