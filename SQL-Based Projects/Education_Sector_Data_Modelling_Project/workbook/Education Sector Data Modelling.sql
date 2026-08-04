--EDUCATION SECTOR DATA MODELING
--STAR SCHEMA

select *from education_cleaned_data ecd 


--Step1: DATA PROFILING 
--Identifying Entities  and the Columns

-- Student;
	--student_id, 
	--student_full_name, 
	--gender, 
	--student_age, 
	--date_of_birth
    --student_subcounty, 
    --student_county, 
    --student_region

--School	
    --school_id, 
    --school_name, 
    --school_type, 
    --school_subcounty, 
    --school_county, 
    --school_region

--Teacher	
    --teacher_id, 
    --teacher_name, 
    --teacher_gender, 
    --teacher_subject_specialty, 
    --teacher_subcounty
    --teacher_county
    --teacher_region

--Subject	
    --subject_id, 
    --subject_name

--Assessment	
   --assessment_type, 


--Facts student performance
  --score
  --attendance_rate_pct
  --fee_balance_kes
  --scholarship_status
  --learning_mode
  --grade_level
  --class_stream
  --admission_date

--Step2: DIMENSIONS CREATION
--Creating Dimension Tables From the Identified Entities

create table dim_student(
    student_id varchar(50) primary key,
    student_full_name varchar(50),
    gender varchar(50),
    student_age int,
    date_of_birth date,
    student_subcounty varchar(50), 
    student_county varchar(50), 
    student_region varchar(50)
);



create table dim_school(
    school_id varchar(20) primary key,
    school_name varchar (50),
    school_type varchar(50),
    school_subcounty varchar(50),
    school_county varchar(50),
    school_region varchar(50)
);
drop table dim_school

alter table dim_school
alter column school_id type varchar(50) ;

create table dim_teacher(	
    teacher_id varchar(50)  primary key,
    teacher_name varchar(50),
    teacher_gender varchar(50),
    teacher_subject_specialty varchar(50),
    teacher_subcounty varchar(50),
    teacher_county varchar(50),
    teacher_region varchar(50)
    );

create table dim_subject(	
    subject_id varchar (50) primary key,
    subject_name varchar (50)
    );

--STEP3;FACT TABLE CREATION

create table fact_student_performance (
    record_id varchar(50) primary key,
    student_id varchar(50),
    school_id varchar(50),
    teacher_id varchar(50),
    subject_id varchar (50),
    admission_date DATE,
    grade_level varchar(50),
    class_stream varchar(50),
    assessment_type varchar (50),
    score numeric,
    attendance_rate_pct numeric,
    fee_balance_kes numeric,
    scholarship_status varchar(50),
    learning_mode varchar(50),
    foreign key (student_id)  references dim_student(student_id),
    foreign key (school_id)   references dim_school(school_id),
    foreign key(teacher_id)   references dim_teacher(teacher_id),
    foreign key (subject_id)  references dim_subject(subject_id)
);



--STEP4: POPULATE DIMENSION TABLES

insert into dim_student(
  student_id ,
    student_full_name,
    gender ,
    student_age ,
    date_of_birth ,
    student_subcounty, 
    student_county, 
    student_region   
    )
select distinct
    student_id ,
    student_full_name,
    gender ,
    student_age ,
    date_of_birth ,
    student_subcounty, 
    student_county, 
    student_region    
from education_cleaned_data 
on conflict (student_id) do nothing;

select * from dim_student ds 


insert into dim_school
select distinct
    school_id ,
    school_name ,
    school_type ,
    school_subcounty ,
    school_county ,
    school_region 
from education_cleaned_data ;

select *from dim_school;


insert into dim_teacher (
    teacher_id,
    teacher_name,
    teacher_gender,
    teacher_subject_specialty,
    teacher_subcounty,
    teacher_county,
    teacher_region
)
select distinct
    teacher_id,
    teacher_name,
    teacher_gender,
    teacher_subject_specialty,
    teacher_subcounty,
    teacher_county,
    teacher_region
from education_cleaned_data
on conflict (teacher_id) do nothing;

select*from dim_teacher;


insert into dim_subject(
    subject_id,
    subject_name
    )
select distinct
    subject_id,
    subject_name
from education_cleaned_data
on conflict (subject_id) do nothing;

select *from dim_subject

--STEP5: POPULATE FACT TABLE

insert into fact_student_performance (
    record_id,
    student_id,
    school_id,
    teacher_id,
    subject_id,
    admission_date,
    grade_level,
    class_stream,
    assessment_type,
    score,
    attendance_rate_pct,
    fee_balance_kes,
    scholarship_status,
    learning_mode
)
select distinct
    record_id,
    student_id,
    school_id,
    teacher_id,
    subject_id,
    admission_date,
    grade_level,
    class_stream,
    assessment_type,
    score,
    attendance_rate_pct,
    fee_balance_kes,
    scholarship_status,
    learning_mode
from education_cleaned_data;

select *from fact_student_performance;

--STEP6: DATA VALIDATION

--Student Validation
select count(*) as dimension_students
from dim_student;

select count(distinct student_id) as source_students
from education_cleaned_data;

--School Validation
select count(*) as dimension_schools
from dim_school;

select count(distinct school_id) as source_schools
from education_cleaned_data;

--Teacher Validation
select count (*) as dimension_teachers
from dim_teacher;

select count (distinct teacher_id) as source_teachers
from education_cleaned_data;

--Subject Validation
select count (*) as dimension_subjects
from dim_subject;

select count(distinct subject_id) as source_subjects
from education_cleaned_data;

--Fact Validation
select count (*)
from fact_student_performance;

select count (*)
from education_cleaned_data;

--END