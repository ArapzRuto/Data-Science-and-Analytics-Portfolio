--Data Analysis: Education Sector Data
--Introduction
/*This project focused on performing SQL data analysis on a cleaned dataset from the education sector,  
 containing information on students, schools, teachers, subjects, academic performance, attendance, 
 and fee payments. Using PostgreSQL, the analysis applied a wide range of SQL techniques to answer real-world 
 business questions and generate meaningful insights that support data-driven decision-making. 
 The project demonstrated practical SQL skills, including aggregate functions, window functions, subqueries, 
 Common Table Expressions (CTEs), and stored procedures.*/

--1. Executive Performance Dashboard

--1.	How many students are registered in the dataset? 324 students
select *from education_cleaned_data ecd ;

select count(distinct student_id) as Total_students
from education_cleaned_data ecd  ;

--2.	How many schools are represented in the dataset?  13 schools
select count(distinct ecd.school_id ) as Total_schools
from education_cleaned_data ecd  ;

--3.	What is the average student score across all subjects? 58.9
select AVG(ecd.score ) as Avg_Score
from education_cleaned_data ecd  ;

select ceil(AVG(ecd.score )) as Avg_Score
from education_cleaned_data ecd  ;--Rounded up to 0 decimal places

--4.	What is the highest and lowest student score? 
select  max(ecd.score ) as Highest_Score,min(ecd.score ) as Lowes_Score 
from education_cleaned_data ecd  ;

--5.	What is the total outstanding fee balance across all schools? 
select sum(ecd.fee_balance_kes ) as total_outstanding_fee_balance
from education_cleaned_data ecd 


--6.	Which school has the highest average student score? 
 select ecd.school_name ,AVG(score) as highest_average_student_score
 from education_cleaned_data ecd 
 group by ecd.school_name 
 order by ecd.school_name desc;
 
--7.	Which county has the highest average attendance rate? 
select ecd.school_county ,AVG(ecd.attendance_rate_pct  ) as highest_average_attendance_rate
from education_cleaned_data ecd 
group by ecd.school_county
order by ecd.school_county desc;

--8.	Which subject has the highest average score? 
select ecd.subject_name ,AVG(ecd.score ) as highest_average_score
from education_cleaned_data ecd 
group by ecd.subject_name 
order by ecd.subject_name desc;

--9.	How many students have received scholarships? 
select ecd.scholarship_status ,count(ecd.student_id ) as Total_scholarships
from education_cleaned_data ecd 
group by ecd.scholarship_status 
order by Total_scholarships desc;


--10.	Which region has the largest student population? 
select ecd.student_region ,count(ecd.student_id ) as Pop_per_region
from education_cleaned_data ecd 
group by  ecd.student_region
order by Pop_per_region desc;


--2. Student Performance  Analysis

--1.	List all students who scored above 80. 
select ecd.student_full_name ,score
from education_cleaned_data ecd 
where score>=80
group by ecd.student_full_name,score
order by score desc;


--2.	Find students aged between 14 and 16 years. 
select ecd.student_full_name ,ecd.student_age 
from education_cleaned_data ecd 
where ecd.student_age between 14 and 16
group by ecd.student_full_name,ecd.student_age 
order by ecd.student_age desc;

--3.	Display all private schools. 
select ecd.school_name, ecd.school_type
from education_cleaned_data ecd 
where ecd.school_type ='Private'
group by ecd.school_name, ecd.school_type
order  by ecd.school_name asc;

--4.	Find students whose attendance rate is below 60%. 
select ecd.student_full_name ,ecd.attendance_rate_pct 
from education_cleaned_data ecd 
where ecd.attendance_rate_pct <60
group by ecd.student_full_name ,ecd.attendance_rate_pct 
order by ecd.attendance_rate_pct desc;

--5.	Retrieve teachers specializing in Mathematics or English. 
select ecd.teacher_name ,ecd.subject_name 
from education_cleaned_data ecd 
where ecd.subject_name ='Mathematics' 
or ecd.subject_name ='English'
group by ecd.teacher_name ,ecd.subject_name ;


--6.	List students with fee balances greater than KES 2000. 
select ecd.student_full_name ,ecd.fee_balance_kes 
from education_cleaned_data ecd 
where ecd.fee_balance_kes >2000

--7.	Find students who do not have scholarships. 
select ecd.student_full_name ,ecd.scholarship_status 
from education_cleaned_data ecd 
where ecd.scholarship_status ='No'

--8.	Display schools located in Nairobi or Mombasa counties. 
select ecd.school_name ,ecd.school_county  
from education_cleaned_data ecd 
where ecd.school_region ='Nairobi'
or ecd.school_region ='Mombasa'
group by ecd.school_name ,ecd.school_county 

--9.	Find students admitted after January 1, 2023.
select ecd.student_full_name ,ecd.admission_date 
from education_cleaned_data ecd 
where ecd.admission_date >'2023-01-01'


--10.	List students learning online (Hybrid) with attendance above 90%. 
select ecd.student_full_name ,ecd.learning_mode ,ecd.attendance_rate_pct 
from education_cleaned_data ecd 
where ecd.learning_mode ='Hybrid' and ecd.attendance_rate_pct  =90
group by ecd.student_full_name ,ecd.learning_mode ,ecd.attendance_rate_pct 
order by ecd.attendance_rate_pct  desc;


--3. Data Standardization 

--1.	Display all student names in uppercase. 
select UPPER(ecd.student_full_name)
from education_cleaned_data ecd 

--2.	Convert school names to lowercase. 
select lower(ecd.school_name )
from education_cleaned_data ecd 

--3.	Extract the first name from each student's full name. 
select UPPER(ecd.student_full_name)
from education_cleaned_data ecd 

--4.	Extract the surname from each student's full name. 
select substring(ecd.student_full_name ,11,12)
from education_cleaned_data ecd 

--5.	Count the number of characters in each teacher's name. 
select ecd.teacher_name ,length(ecd.teacher_name )
from education_cleaned_data ecd 

--6.	Find schools whose names contain the word "Academy." 
select ecd.school_name 
from education_cleaned_data ecd 
where ecd.school_name like '%Academy%'

--7.	Replace "School" with "Sch." in school names. 
select replace(ecd.school_name ,'School','Sch.')
from education_cleaned_data ecd 


--8.	Display the first three letters of every county name. 
select substring(ecd.school_county ,1,3)
from education_cleaned_data ecd 

--9.	Remove leading and trailing spaces from student names. 
select trim(ecd.student_full_name) 
from education_cleaned_data ecd 

--10.	Find students whose names start with the letter "A." 
select ecd.student_full_name 
from education_cleaned_data ecd 
where ecd.student_full_name  like 'A%'


--4. Student Enrollment & Demographic Analysis

---1.	Calculate each student's age from the date of birth. 
select 
ecd.student_full_name ,
ecd.date_of_birth ,
ecd.admission_date ,
ecd.student_age,
ecd.admission_date - ecd.date_of_birth as days_difference,
floor((ecd.admission_date - ecd.date_of_birth)/365.25) as student_age_corrected
from education_cleaned_data ecd  ;
 
--Alternatively;
select
    student_full_name,
    date_of_birth,
    admission_date,
    extract(year from age(admission_date, date_of_birth)) as student_age_corrected
from education_cleaned_data;

--2.	Find students admitted in the year 2023. 
select ecd.student_full_name ,
ecd.admission_date,
extract(year from admission_date)as year_admitted
from education_cleaned_data ecd 
where extract(year from admission_date)='2023';


--3.	Count how many students joined each month. 
select 
extract(month from ecd.admission_date) as admission_month,
count (*) as total_students
from education_cleaned_data ecd 
group by admission_month
order by admission_month asc;


--4.	Find students admitted within the last six months. 
select 
ecd.student_full_name ,
ecd.admission_date,
extract(month from ecd.admission_date )
from education_cleaned_data ecd 
where ecd.admission_date>=(
select max(ecd.admission_date)- interval '6 months'
from education_cleaned_data ecd );

--5.	Calculate the number of days between the admission date and today. 
select ecd.student_full_name ,ecd.admission_date ,
current_date-ecd.admission_date as days_since_admitted
from education_cleaned_data ecd 

--6.	Display the admission year for every student. 
select ecd.student_full_name ,
extract(year from ecd.admission_date ) as admission_year
from education_cleaned_data ecd 

--7.	Find the oldest student in the dataset. 
select
ecd.student_full_name, 
ecd.student_age
from education_cleaned_data ecd 
order by ecd.student_age desc
limit 1;


--to display multiple students with age 18
select
ecd.student_full_name, 
ecd.student_age
from education_cleaned_data ecd 
where ecd.student_age =(
select max(student_age)
from education_cleaned_data ecd );



--8.	Find the youngest student in the dataset. 
select 
ecd.student_full_name ,
ecd.student_age 
from education_cleaned_data ecd 
where ecd.student_age =2
order  by ecd.student_age asc;
--OR
select 
ecd.student_full_name ,
ecd.student_age 
from education_cleaned_data ecd 
where ecd.student_age =(
select min(ecd.student_age )
from education_cleaned_data ecd );

---9.	Count students born in each year. 
select
extract(year from date_of_birth) as year_of_birth,
count (student_id) as No_of_students
from education_cleaned_data ecd 
group by year_of_birth
order by year_of_birth asc;

select*from education_cleaned_data ecd 

--10.	Determine the average age of students. 
select ceil(AVG(ecd.student_age )) as students_avg_age
from education_cleaned_data ecd 


--5. MAcademic Performance Calculations & Financial Metrics

--1.	Round every student's score to the nearest whole number. 
select ecd.student_full_name ,ecd.score ,ceil(ecd.score ) students_score_to_wholenumber
from education_cleaned_data ecd 


--2.	Round fee balances to two decimal places. 
select ecd.student_full_name ,ceil(ecd.fee_balance_kes ,'2')
from education_cleaned_data ecd 

--3.	Calculate the square root of each student's score. 
select ecd.student_full_name ,ecd.score , sqrt(ecd.score ) as sqrt_per_studentscore
from education_cleaned_data ecd 


--4.	Find the absolute value of the fee balances. 
select ecd.student_full_name ,ecd.fee_balance_kes ,abs(ecd.fee_balance_kes ) as abs_fee_balance
from education_cleaned_data ecd 

--5.	Calculate score percentages out of 100. 
select ecd.student_full_name ,score, ecd.score/100 as percent_score 
from education_cleaned_data ecd 

--6.	Increase every score by 5% for moderation purposes. 
select ecd.student_full_name ,score,
ecd.score/100 as percent_score, 
ecd.score/100+0.05 as moderated_percent_score
from education_cleaned_data ecd 

--7.	Calculate attendance as a decimal fraction. 
select ecd.student_full_name ,ecd.attendance_rate_pct/100  as attendance_rate_in_decimal
from education_cleaned_data ecd 

--8.	Find the ceiling value of student scores. 
select ecd.student_full_name,ceil(ecd.score ) as ceiled_students_score
from education_cleaned_data ecd 

--9.	Find the floor value of attendance percentages. 
select ecd.student_full_name,ceil(ecd.attendance_rate_pct ) as ceiled_attendance_percentages
from education_cleaned_data ecd 

--10.	Calculate the average fee balance per student. 
select ecd.student_full_name ,ecd.fee_balance_kes ,AVG(ecd.fee_balance_kes ) as average_fee_balance_per_student
from education_cleaned_data ecd 
group by ecd.student_full_name,ecd.fee_balance_kes;


--6. School and Regional Performance Reporting

--1.	Count students in each county. 
select ecd.student_county ,count(ecd.student_id ) as students_per_county
from education_cleaned_data ecd 
group by ecd.student_county 
order by students_per_county desc

--2.	Count students in each school. 
select ecd.school_name  ,count(distinct ecd.student_id ) as students_per_school
from education_cleaned_data ecd 
group by ecd.school_name
order by students_per_school desc

--3.	Count teachers by subject specialty. 
select ecd.teacher_subject_specialty ,count(distinct ecd.teacher_id ) as teachers_by_subject_specialty
from education_cleaned_data ecd 
group by ecd.teacher_subject_specialty;

--4.	Find schools with more than 20 students. 
select ecd.school_name ,count(distinct ecd.student_id ) as no_of_students
from education_cleaned_data ecd
group by  ecd.school_name
having count(distinct ecd.student_id )>20;

--5.	Find counties with an average score above 60. 
select ecd.student_county ,AVG(ecd.score ) as avg_score_percounty
from education_cleaned_data ecd 
group by ecd.student_county
having AVG(ecd.score )>60

--6.	Find subjects with an average attendance above 60%. 
select ecd.subject_name ,AVG(ecd.attendance_rate_pct ) as avg_attendance_per_subject
from education_cleaned_data ecd 
group by ecd.subject_name
having AVG(ecd.attendance_rate_pct )>60
order by avg_attendance_per_subject desc;

--7.	List regions with more than three schools. 
select ecd.school_region ,count(distinct ecd.school_id ) as no_of_schools_per_region
from education_cleaned_data ecd 
group by ecd.school_region 
having count(distinct ecd.school_id )>=3

--8.	Find schools whose total fee balance exceeds KES 30,000. 
select  ecd.school_name ,sum(ecd.fee_balance_kes) as total_fee_balance 
from education_cleaned_data ecd
group by ecd.school_name ,ecd.fee_balance_kes
having sum(ecd.fee_balance_kes) >30000

--9.	Find counties with more than 20 scholarship recipients. 
select  ecd.student_county , count(*) as no_of_scholarships_per_status
from education_cleaned_data ecd 
where ecd.scholarship_status in('Yes','Partial')
group by ecd.student_county 
having count(*) >=20
order by no_of_scholarships_per_status desc;


--10.	List schools where the average score is below 60.
select ecd.school_name , AVG(ecd.score ) as avg_score
from education_cleaned_data ecd 
group by ecd.school_name
having AVG(ecd.score )<60



--7. Student Ranking & Academic Benchmarking

--1.	Rank students by score within each school.
select  ecd.school_name ,
ecd.student_full_name,
rank()over(
partition by ecd.school_name  
order by score desc) as ranked_students
from education_cleaned_data ecd 

--2.	Rank schools based on average performance. 
select ecd.school_name ,
avg(ecd.score ) as avg_score,
rank()over(
order by score)
from education_cleaned_data ecd 
group by ecd.school_name ,ecd.score 

--3.	Find the top three students in every school. 
select*
from(
select 
ecd.school_name,
ecd.student_full_name ,
score,
rank()over(
partition by ecd.school_name 
order by score desc) as ranked_score
from education_cleaned_data ecd ) as ranked_students
where ranked_score<=3
order by school_name ,ranked_score asc;


--4.	Calculate the cumulative fee balance(Running otal) by school. 

select 
ecd.school_name,
ecd.student_full_name ,
sum(ecd.fee_balance_kes )over(
partition by ecd.school_name
order by ecd.fee_balance_kes) as cumulative_fee_balance
from education_cleaned_data ecd 



--5.	Show each student's score alongside their school's average score. 
select 
ecd.student_full_name ,
ecd.score ,
AVG(ecd.score ) over(
partition by ecd.school_name
 )as school_avg_score
from education_cleaned_data ecd 
order by ecd.student_full_name ,ecd.school_name


--6.	Find the difference between each student's score and the school topper. 

select
school_topper.school_name ,
school_topper.student_full_name ,
school_topper.score ,
school_topper.top_score ,
school_topper.top_score-school_topper.score  as score_difference
from(
select 
ecd.school_name ,
ecd.student_full_name ,
ecd.score ,
max(ecd.score )over(
partition by ecd.school_name ) as top_score
from education_cleaned_data ecd) as school_topper 
order by score_difference desc;


--7.	Calculate a running total of student admissions by admission date. 
select 
ecd.school_name ,
ecd.admission_date ,
count(ecd.student_id )over(
order by ecd.admission_date ) as Running_total_admissions
from education_cleaned_data ecd 
order by ecd.admission_date

--8.	Assign quartiles to students based on scores. 
select 
ecd.student_full_name ,
ntile(4)over(
order by ecd.score desc) as score_quartiles
from education_cleaned_data ecd 

--9.	Find the second-highest scorer in every school. 

select *
from(
select 
ecd.school_name ,
ecd.student_full_name,
score,
rank()over(
partition by ecd.school_name 
order by score desc) as ranked_scores
from education_cleaned_data ecd) as top_scorers
group by top_scorers.school_name ,top_scorers.student_full_name,top_scorers.score ,top_scorers.ranked_scores   
having top_scorers.ranked_scores =2


--10.	Calculate each student's percentile rank within their school. 
select 
ecd.school_name ,
ecd.student_full_name ,
score,
percent_rank()over(
partition by ecd.school_name 
order by ecd.score) as percent_rank
from education_cleaned_data ecd 



--8. Strategic Performance Analysis

--1.	Find students who scored above the overall average score.
select
ecd.student_full_name ,
ecd.score 
from education_cleaned_data ecd 
where score>(
select AVG(score) as Overall_avg_score
from education_cleaned_data ecd );

--2.	Find schools with an average attendance higher than the national average. 

select ecd.school_name,
AVG(attendance_rate_pct) as school_avg_attendance
from education_cleaned_data ecd 
group by ecd.school_name 
having AVG(attendance_rate_pct) >(
select AVG(ecd.attendance_rate_pct  )
from education_cleaned_data ecd)
order  by AVG(attendance_rate_pct) desc; 

--3.	Find teachers whose students perform above average. 
select ecd.teacher_name ,avg(score) as student_average
from education_cleaned_data ecd 
group by ecd.teacher_name
having avg(score)>(
select AVG(ecd.score )
from education_cleaned_data ecd )


--4.	List students whose fee balance exceeds the average fee balance. 
select student_full_name ,fee_balance_kes 
from education_cleaned_data 
where fee_balance_kes >(
select AVG(ecd.fee_balance_kes )
from education_cleaned_data ecd )
order by fee_balance_kes desc

--5.	Find schools with more students than the average school size. 

select school_name ,count(ecd.student_id) as school_size 
from education_cleaned_data ecd
group by school_name
having count(ecd.student_id) >(
select count(ecd.student_id )/count(distinct ecd.school_name ) as avg_school_size
from education_cleaned_data ecd) 
order by school_size desc;


--6.	Find the highest-scoring student in each county. 

select e1.student_county ,
e1.student_full_name,
e1.score
from education_cleaned_data e1
where score = (
select max(score) 
from education_cleaned_data e2
where e2.student_county = e1.student_county )
order by e1.student_county ;


--7.	Display schools whose average score exceeds that of private schools. 

select
e1.school_name ,
avg(e1.score ) as school_average
from education_cleaned_data e1 
group by e1.school_name 
having avg(e1.score ) >(
select  
avg(e2.score)
from education_cleaned_data e2 
where e2.school_type = 'Private'
group by e2.school_type) 
order by school_average desc;



--8.	Find subjects with below-average performance. 
select
ecd.subject_name,
avg(score) as subject_average
from education_cleaned_data ecd 
group by ecd.subject_name 
having avg(score)<(
select avg(ecd.score )
from education_cleaned_data ecd) 
order by subject_average asc

--9.	List counties with fewer students than the average county. 
select 
ecd.student_county,
count(distinct ecd.student_id ) as no_of_students_per_county 
from education_cleaned_data ecd 
group by ecd.student_county 
having count(distinct ecd.student_id ) <(
select count(ecd.student_id )*1.0/count(distinct ecd.student_county ) as average_students_per_county
from education_cleaned_data ecd )
order by no_of_students_per_county asc;

--10.	Find students whose attendance exceeds the average attendance in their school. 

select 
e1.student_full_name ,
e1.school_name ,
sum(e1.attendance_rate_pct )as total_attendance_rate_per_student
from education_cleaned_data e1
group by e1.school_name,e1.student_full_name  
having sum(e1.attendance_rate_pct )>(
select 
avg(e2.attendance_rate_pct ) as attendance_rate_per_school
from education_cleaned_data e2
where e2.school_name =e1.school_name  )
order by sum(e1.attendance_rate_pct ) desc;



--9. Advanced Educational Intelligence Reporting

--1.	Use a CTE to calculate the average score for each school.

with avg_score_per_school as (
select 
ecd.school_name,
avg(ecd.score ) as avg_score
from education_cleaned_data ecd 
group by ecd.school_name )
select*from avg_score_per_school


--2.	Use a CTE to rank schools based on average performance. 

with ranked_schools as (
select
ecd.school_name ,
avg(ecd.score ) as average_performance,
rank()over(
order by avg(ecd.score ) desc) as school_rank
from education_cleaned_data ecd 
group by ecd.school_name
)
select*from ranked_schools 


--3.	Create a CTE to identify the top-performing student in every school. 
 With top_students as (
 select 
 ecd.school_name ,
 ecd.student_full_name ,
 score,
 row_number()over(
 partition by ecd.school_name 
 order by score desc) as ranked_score
 from education_cleaned_data ecd
  )
select *
from top_students 
where ranked_score =1

--4.	Use a CTE to calculate total fee balances by county. 

with total_fee_balances as (
select 
ecd.student_county, 
sum(ecd.fee_balance_kes ) as total_fee_balances
from education_cleaned_data ecd
group by ecd.student_county 
)
select *
from total_fee_balances ;


--5.	Create a CTE to classify students into Pass and Fail categories. 
with student_category as (
select 
ecd.student_full_name, 
case
when ecd.score >=50 then 'Pass' 
else 'Fail'
end as student_status
from education_cleaned_data ecd )
select*
from student_category

--6.	Use a CTE to calculate average attendance by region.
with avg_regional_attendance as (
select
ecd.student_region,
avg(ecd.attendance_rate_pct )
from education_cleaned_data ecd 
group by ecd.student_region )
select *
from avg_regional_attendance 

--7.	Create a CTE to identify schools with declining performance "schools performing below average". 
with declining_performance as (
select 
ecd.school_name, 
avg(score) as avg_score
from education_cleaned_data ecd
group by ecd.school_name )
select *
from declining_performance 
where avg_score <(
select avg(score)
from education_cleaned_data ecd)


--8.	Use multiple CTEs to compare public and private school performance. 
with public_schools as (
select 
avg(ecd.score ) as avg_public
from education_cleaned_data ecd 
where ecd.school_type ='Public'),
private_schools as (
select 
avg(ecd.score ) as avg_private
from education_cleaned_data ecd 
where ecd.school_type ='Private')
select
avg_public,
avg_private
from public_schools 
cross join private_schools ;


--9.	Create a CTE that identifies scholarship recipients with scores above 80. 
with scholarship_recipient_score as (
select
ecd.student_full_name,
score
from education_cleaned_data ecd 
where ecd.score >80 
and ecd.scholarship_status in('Yes','Partial')
)
select*
from scholarship_recipient_score 
order by scholarship_recipient_score.score  desc



--10. Automated Decision Support System


--1.	Create a stored procedure to return all students in a selected school. 

--Normal Script
select 
ecd.student_full_name ,
ecd.school_name 
from education_cleaned_data ecd 
where ecd.school_name ='Athi River Stem School'

--Drop Function or procedeure
drop function if exists return_all_students;

 --Create stored function
create or replace function return_all_students(
selected_school_name varchar
)
returns table(
student_full_name VARCHAR,
school_name VARCHAR
)
language plpgsql
as $$
begin
return query
select 
ecd.student_full_name ,
ecd.school_name 
from education_cleaned_data ecd 
where ecd.school_name = selected_school_name;
end;
$$;

--Call stored function
select*
from return_all_students ('Athi River Stem School');


--2.	Create a stored procedure that returns the top-performing students for a selected county. 
--Normal Script
select
ecd.student_full_name ,
ecd.student_county ,
ecd.score ,
rank()over(
partition by ecd.student_county 
order by ecd.score desc) as ranked_students
from education_cleaned_data ecd 

--Drop the function if exists
drop function if exists top_performing_students;

--Create a stored function 

create or replace function top_performing_students(
selected_county_name varchar)
returns table(
student_full_name  varchar,
student_county varchar,
score numeric,
ranked_students bigint
)
language plpgsql
as $$
begin
return query
select
ecd.student_full_name ,
ecd.student_county ,
ecd.score ,
rank()over(
partition by ecd.student_county 
order by ecd.score desc) as ranked_students
from education_cleaned_data ecd 
where ecd.student_county=selected_county_name;
end;
$$;


select*
from top_performing_students('Kakamega');

--3.	Create a stored function to calculate the average score for a specified subject.

--Nomrmal Query
select
ecd.subject_name ,
avg(ecd.score ) avg_score
from education_cleaned_data ecd 
where ecd.subject_name ='Mathematics'
group by ecd.subject_name 
order by avg_score desc

--Stored Procedure

drop function if exists Get_subject_average_score;

create or replace function Get_subject_average_scores(
subject_average_score varchar)
returns table(
subject_name varchar,
avg_score numeric
)
language plpgsql
as $$
begin
return query
select
ecd.subject_name ,
avg(ecd.score ) avg_score
from education_cleaned_data ecd 
where ecd.subject_name = subject_average_score
group by ecd.subject_name 
order by avg_score desc;
end;
$$;

select*
from get_subject_average_scores('Mathematics');


--4.	Create a stored function that returns students with outstanding fee balances above a specified amount. 

--Normal query
 select 
 ecd.student_full_name ,
 ecd.fee_balance_kes 
 from education_cleaned_data ecd 
 where ecd.fee_balance_kes >=15000
 
 --store function
 
 create or replace function Get_student_fee_balance(
 fee_amount numeric
 )
 returns table(
 student_full_name varchar,
 fee_balance_kes numeric
)
language plpgsql
as $$
begin
return query
select
ecd.student_full_name ,
ecd.fee_balance_kes 
from education_cleaned_data ecd 
where ecd.fee_balance_kes >= fee_amount;
end;
$$;


select*
from Get_student_fee_balance (10000);

--5.	Create a stored procedure to generate a school performance summary. 

select
ecd.school_name ,
ecd.teacher_name ,
ecd.subject_name ,
score,
avg(ecd.score )over(
partition by ecd.school_name ) avg_score_per_school,
avg(ecd.score )over(
partition by ecd.teacher_name ) avg_score_per_teacher,
avg(ecd.score )over(
partition by ecd.subject_name ) avg_score_per_subject
from education_cleaned_data ecd 

--store function

create or replace function Get_school_performance_summary()
returns table(
school_name varchar,
teacher_name varchar,
subject_name varchar,
score numeric,
avg_score_per_school numeric,
avg_score_per_teacher numeric,
avg_score_per_subject numeric)
language plpgsql
as $$
begin
return query
select
ecd.school_name ,
ecd.teacher_name ,
ecd.subject_name ,
ecd.score,
avg(ecd.score )over(
partition by ecd.school_name ) avg_score_per_school,
avg(ecd.score )over(
partition by ecd.teacher_name ) avg_score_per_teacher,
avg(ecd.score )over(
partition by ecd.subject_name ) avg_score_per_subject
from education_cleaned_data ecd ;
end;
$$;

select*
from Get_school_performance_summary()


--6.	Create a stored function that lists scholarship recipients by region. 

--Normal query
select
ecd.student_full_name ,
ecd.student_region ,
ecd.scholarship_status 
from education_cleaned_data ecd
where student_region='Nyanza' ;

--Stored function

create or replace function Get_regional_scholarship_lists (
scholarship_region varchar)
returns table(
student_full_name varchar,
student_region varchar,
scholarship_status varchar)
language plpgsql
as $$
begin
return query
select
ecd.student_full_name ,
ecd.student_region ,
ecd.scholarship_status 
from education_cleaned_data ecd
where ecd.student_region=scholarship_region
and ecd.scholarship_status in ('Yes', 'Partial'); 
end;
$$;

select *
from Get_regional_scholarship_lists ('Nyanza')

--7.	Create a stored function that returns attendance statistics for a selected school. 

--Normal query

select
ecd.school_name,
avg(ecd.attendance_rate_pct) as avg_attendance,
percentile_cont(0.5) within group (order by ecd.attendance_rate_pct)::numeric as median_attendance,
mode() within group (order by ecd.attendance_rate_pct) as mode_attendance,
max(ecd.attendance_rate_pct) as max_attendance,
min(ecd.attendance_rate_pct) as min_attendance
from education_cleaned_data ecd
where ecd.school_name = 'Athi River Stem School'
group by ecd.school_name;

--stored function

drop function if exists get_school_attendance_statistics(
selected_school varchar)

create or replace function get_school_attendance_statistics(
selected_school varchar)
returns table(
school_name varchar,
avg_attendance numeric,
median_attendance numeric,
mode_attendance numeric,
max_attendance numeric,
min_attendance numeric)
language plpgsql
as $$
begin
return query
select
ecd.school_name,
avg(ecd.attendance_rate_pct) as avg_attendance,
percentile_cont(0.5) within group (order by ecd.attendance_rate_pct)::numeric as median_attendance,
mode() within group (order by ecd.attendance_rate_pct) as mode_attendance,
max(ecd.attendance_rate_pct) as max_attendance,
min(ecd.attendance_rate_pct) as min_attendance
from education_cleaned_data ecd
where ecd.school_name=selected_school 
group by ecd.school_name ;
end;
$$;

select*
from get_school_attendance_statistics('Athi River Stem School')

--8.	Create a stored procedure that updates scholarship status based on student performance. 

--Normal query


update education_cleaned_data 
set scholarship_status=
case  
when score  >=75 then 'Yes'
when score  >=50 then 'Partial'
else 'No'
end

--stored procedure

create or replace procedure updates_scholarship_status()
language plpgsql
as $$
begin
update education_cleaned_data 
set scholarship_status=
case  
when score  >=75 then 'Yes'
when score  >=50 then 'Partial'
else 'No'
end;
end;
$$;


call updates_scholarship_status()

--Confirm if scholrahsip column is updated

select 
ecd.scholarship_status ,
score
from education_cleaned_data ecd 
where ecd.scholarship_status ='No'


--9.	Create a stored function to return the top N students for any school specified by the user. 

--Normal query

select*
from (
select 
ecd2.school_name ,
ecd2.student_full_name ,
row_number()over(
partition by ecd2.school_name 
order by ecd2.score desc) as student_rank
from education_cleaned_data ecd2 
where ecd2.school_name ='Athi River Stem School') as ranked_students
where ranked_students.student_rank <=3;

--stored function

drop function if exists top_N_students_per_school(varchar,int)

create or replace function top_N_students_per_school(
specified_school varchar,
top_n int
)
returns table(
school_name varchar,
student_full_name varchar,
student_rank bigint
)
language plpgsql
as $$
begin
return query
select*
from (
select 
ecd2.school_name ,
ecd2.student_full_name ,
row_number()over(
partition by ecd2.school_name 
order by ecd2.score desc) as student_rank
from education_cleaned_data ecd2 
where ecd2.school_name =specified_school) as ranked
where student_rank <=top_n;
end;
$$;


select *
from top_N_students_per_school('Athi River Stem School',   3)



--10.	Create a stored procedure that generates a dashboard summary showing student count, teacher count, average score, average attendance, total fee balance, and scholarship count for every school. 
