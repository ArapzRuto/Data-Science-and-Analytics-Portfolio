--EDUCATION SECTOR DATA CLEANING PIPELINE

--Step 1: Create Database
--I used already created MyPracticeProjects Database
--Then created a schema Education_sector_data_cleaning


--Step 2: Create Raw Table
--Initially, I loaded all columns as TEXT to avoid import errors.

create table education_dirty_data(
record_id TEXT,
student_id TEXT,
student_first_name TEXT,
student_middle_name TEXT,
student_last_name TEXT,
student_full_name TEXT,
gender TEXT,
student_age TEXT,
date_of_birth TEXT,
admission_date TEXT,
grade_level TEXT,
class_stream TEXT,
school_id TEXT,
school_name TEXT,
school_type TEXT,
school_subcounty TEXT,
school_county TEXT,
school_region  TEXT,
school_country TEXT,
student_subcounty TEXT,
student_county TEXT,
student_region TEXT,
student_country TEXT,
teacher_id TEXT,
teacher_name TEXT,
teacher_gender TEXT,
teacher_subject_specialty TEXT,
teacher_subcounty TEXT,
teacher_county TEXT,
teacher_region TEXT,
teacher_country TEXT,
subject_id TEXT,
subject_name TEXT,
term TEXT,
academic_year TEXT,
assessment_type TEXT,
score TEXT,
attendance_rate_pct TEXT,
fee_balance_kes TEXT,
scholarship_status TEXT,
guardian_phone TEXT,
learning_mode TEXT,
created_at TEXT,
data_source TEXT
)
 select * from education_dirty_data;--To confirm that the table is created
 
-- Data import using GUI Import tool . It resulted in education_dirty_text table
  select*from education_dirty_text edt ; --To cornfirm that the data is successfully imported
  
  --Step 3: Create a Working Copy/Backup Table/Staging Table
--Reason: To preserve the raw data.
  
  create table education_cleaned_data as select * from education_dirty_text;
   
  select *from education_cleaned_data; --To confirm back up table
  
  --Step 4: Initial Data Exploration
--Count records:

select count(*) as total_records
from education_cleaned_data ecd ; --The table has 324 records

-- count columns

select count(*) as total_columns
from information_schema.columns
where table_name='education_cleaned_data';--The table has 44 columns

--Explore if duplicates exists
select record_id, count(*) as record_id_duplicates
from education_cleaned_data ecd
group by record_id
having count(*) > 1;--There is  no duplicates based on records id 

select student_id, count(*)  as student_id_duplicates 
from education_cleaned_data ecd 
group by ecd.student_id 
having count(*)>1;--There is  no duplicates based on rd students id
  
 --Step 5: Remove unneccessary columns
-- student first,middle and last  are removed  becuase there is student full name
--term, student,school and teacher country  is removed because  the dataset was captured in a single trem, trem 1 and the country is kenya
--guardian phone ,created at and data sourceis removed  is removed becasue it adds no value to analysis

alter table education_cleaned_data 
drop column student_first_name,
drop column student_middle_name,
drop column student_last_name,
drop column school_country,
drop column student_country,
drop column teacher_country,
drop column term,
drop column academic_year,
drop column guardian_phone,
drop column created_at,
drop column data_source;
  
-- count remaining columns
select count(*) as total_remaining_columns
from information_schema.columns
where table_name='education_cleaned_data';--The table has 33 columns
  
  select *from education_cleaned_data;
  
   --Step 6: Column by colum data cleaning
  --1.student_full_name column
  select distinct(count(student_full_name))
  from education_cleaned_data ecd --No duplicate students
  
  --2.gender column
  select distinct(gender) as gender_category
  from education_cleaned_data ecd 
  
  update education_cleaned_data ecd 
  set gender='M'
  where gender in ('Male','Boy','male','MALE');
  
  update education_cleaned_data ecd 
  set gender='F'
  where gender in ('Female','Girl','female','Femle','FEMALE');
  
  update education_cleaned_data ecd 
  set gender='Unknown'
  where gender in ('');
  
  --3. student_age column
  --Replace blanks by median age
  --First check the column data type. Student_id has character varying(varchar , texts/strings)

select column_name, data_type
from information_schema.columns
where table_schema = 'Education_sector_data_cleaning'
and table_name = 'education_cleaned_data'
order by  ordinal_position;

--Convert to correct datatype
-- On conversion, error on "16yrs" result.
-- Clean the non-numeric character firts

update education_cleaned_data
set student_age = regexp_replace(student_age, '[^0-9.]', '', 'g');

--Now ,convert

alter table education_cleaned_data 
alter column student_age type numeric using  nullif(student_age,'')::numeric;
   
-- Now calculate median=15
   
select PERCENTILE_CONT(0.5) within group (order by student_age) as median_age
from education_cleaned_data ecd 
where student_age is not null;

--Replace nulls in student_id with 15

update education_cleaned_data ecd 
set student_age=15
where student_age is null;


 --Confirm there missing rows. No null or blank rows
select *
from education_cleaned_data ecd 
where student_age is null ;

  
--4. date_of_birth columns
--the columns have nulls and ERROR texts,"31/02/2011"

select date_of_birth from education_cleaned_data ecd 

 --first, "31/02/2011" to "28/02/2011"

update education_cleaned_data 
set date_of_birth='28/02/2011'
where date_of_birth='31/02/2011';

 --convert the data type from varchar to date
  
alter table education_cleaned_data 
alter column date_of_birth  type date using  nullif(nullif(date_of_birth,'ERROR'),'')::date;

--count null rows-- there are 4 null rows
select ecd.date_of_birth 
from education_cleaned_data ecd 
where ecd.date_of_birth  is null;

--5. admission_date columns
select admission_date from education_cleaned_data ecd 

 --convert the data type from varchar to date

alter table education_cleaned_data 
alter column admission_date  type date using  nullif(nullif(admission_date,'ERROR'),'')::date;

--count null rows-- there are 4 null rows
select admission_date
from education_cleaned_data ecd 
where admission_date is null;

--6. grade_level colum- Its clean
select *from education_cleaned_data ecd 

--Determine if there  nulls or blanks
select grade_level
from education_cleaned_data ecd 
where ecd.grade_level is null
or ecd.grade_level =''

--7. class_stream column
select class_stream
from education_cleaned_data ecd 
where ecd.class_stream is null
or ecd.class_stream ='' --there are no nulls or blanks

select class_stream
from education_cleaned_data ecd 
group by ecd.class_stream 
order by class_stream asc

--standardize class 

update education_cleaned_data ecd 
set class_stream = 'Grade 7B'
where ecd.class_stream = 'Grade 7 B'

update education_cleaned_data ecd 
set class_stream = 'Grade 9A'
where ecd.class_stream = '9A'

--8. school-name column
select * from education_cleaned_data ecd 

select school_name
from education_cleaned_data 
group by school_name

-- Standardize school names
--capitalize each word in the colum
update education_cleaned_data ecd 
set school_name=initcap(ecd.school_name )

--standardize abbreviations sch
update education_cleaned_data ecd 
set school_name=replace (school_name, ' Sch', ' School')
where school_name ilike '% Sch'

-- fix attached words
 
update education_cleaned_data
set school_name = replace(school_name, 'School', ' School')
where school_name like '%School' 
and school_name not like '% School'; --There are 12 schools

--9. school_type column

select school_type
from education_cleaned_data ecd 
group by school_type

--Capitalize each word in the column
update education_cleaned_data ecd 
set school_type=initcap(ecd.school_type )

--standardize
update  education_cleaned_data ecd
set school_type='Public'
where school_type='Govt'
or school_type='Government'

update  education_cleaned_data ecd
set school_type='Private'
where school_type='Priv'
or school_type='Pvt'

--check for nulls and blanks

select school_type
from education_cleaned_data ecd 
where school_type is null
or school_type=''-- there are no nulls or blanks

--10. school_subcounty column

select *from education_cleaned_data ecd 

select school_subcounty
from education_cleaned_data ecd 
group by ecd.school_subcounty 
order by ecd.school_subcounty  

--capitalize each word
update education_cleaned_data ecd 
set school_subcounty =initcap(ecd.school_county )

--Now standardize
update education_cleaned_data ecd 
set school_subcounty ='Uasin Gishu'
where ecd.school_subcounty in('Eldoret','U/G','Uasin-Gishu')

update education_cleaned_data ecd 
set school_subcounty ='Kakamega'
where ecd.school_subcounty in('Kakamega County','Kakmega')

update education_cleaned_data ecd 
set school_subcounty ='Kisumu'
where ecd.school_subcounty in('Ksm','Kisum','Kisumu County')

update education_cleaned_data ecd 
set school_subcounty ='Kiambu'
where ecd.school_subcounty in('Kbu','Kiambu County','Kiambo')

update education_cleaned_data ecd 
set school_subcounty ='Machakos'
where ecd.school_subcounty in('Machakoss','Mks')

update education_cleaned_data ecd 
set school_subcounty ='Mombasa'
where ecd.school_subcounty in('Mombasa County','Mombsa','Msa')

update education_cleaned_data ecd 
set school_subcounty ='Nairobi'
where ecd.school_subcounty in('Nairob','Nairobii','Nairobi County','Nrb')

update education_cleaned_data ecd 
set school_subcounty ='Nakuru'
where ecd.school_subcounty in('Nakru','Naks')

--Check if there are nulls or blanks
select count(*) as total_missing_or_blank
from education_cleaned_data ecd 
where ecd.school_subcounty isnull
or school_subcounty =''

--11. school_county column

select *from education_cleaned_data ecd 

select school_county
from education_cleaned_data ecd 
group by ecd.school_county 
order by ecd.school_county 

-- capitalize each word
update education_cleaned_data ecd  
set school_county =initcap(school_county)

--Now standardize
update education_cleaned_data ecd 
set school_county ='Uasin Gishu'
where ecd.school_county in ('Eldoret','U/G','Uasin-Gishu')

update education_cleaned_data ecd 
set school_county ='Kakamega'
where ecd.school_county in('Kakamega County','Kakmega')

update education_cleaned_data ecd 
set school_county ='Kisumu'
where ecd.school_county in('Ksm','Kisum','Kisumu County')

update education_cleaned_data ecd 
set school_county ='Kiambu'
where ecd.school_county in('Kbu','Kiambu County','Kiambo')

update education_cleaned_data ecd 
set school_county ='Machakos'
where ecd.school_county in('Machakoss','Mks')

update education_cleaned_data ecd 
set school_county ='Mombasa'
where ecd.school_county in('Mombasa County','Mombsa','Msa')

update education_cleaned_data ecd 
set school_county ='Nairobi'
where ecd.school_county in('Nairob','Nairobii','Nairobi County','Nrb')

update education_cleaned_data ecd 
set school_county ='Nakuru'
where ecd.school_county in('Nakru','Naks')

--Check if there are nulls or blanks
select count(*) as total_missing_or_blank
from education_cleaned_data ecd 
where ecd.school_county isnull
or school_county =''


--12. school_region column

select *from education_cleaned_data ecd 

select school_region
from education_cleaned_data ecd 
group by ecd.school_region 
order by ecd.school_region 

--capitalize each word

update education_cleaned_data ecd 
set school_region=initcap(ecd.school_region )


--now standadrize
update education_cleaned_data ecd 
set school_region ='Central'
where ecd.school_region in('Centrl')


update education_cleaned_data ecd 
set school_region ='Coast'
where ecd.school_region in('Cost')

update education_cleaned_data ecd 
set school_region ='Eastern'
where ecd.school_region in('Eastn')

update education_cleaned_data ecd 
set school_region ='Nairobi'
where ecd.school_region in('Nairobi Region','Nrb Region')

update education_cleaned_data ecd 
set school_region ='Nyanza'
where ecd.school_region in('Nyanza Region')

update education_cleaned_data ecd 
set school_region ='Rift Valley'
where ecd.school_region in('Rift-Valley','Rv')

update education_cleaned_data ecd 
set school_region ='Western'
where ecd.school_region in('Westn')

--Check if there are nulls or blanks
select count(*) as total_missing_or_blank
from education_cleaned_data ecd 
where ecd.school_region  isnull
or school_region =''

--13. student_subcounty column
select *from education_cleaned_data ecd 

select student_subcounty
from education_cleaned_data ecd 
group by ecd.student_subcounty 
order by ecd.student_subcounty 

--capitalize each word in the column
 update education_cleaned_data ecd 
 set student_subcounty=initcap(ecd.student_subcounty )
 
 -- Standardize
  update education_cleaned_data ecd 
  set student_subcounty ='Athi River'
  where ecd.student_subcounty in('Ath River','Athi-River')
  
  update education_cleaned_data ecd 
  set student_subcounty ='Eldoret East'
  where ecd.student_subcounty in('Eld East','Eldoret E.')
  
  update education_cleaned_data ecd 
  set student_subcounty ='Embakasi East'
  where ecd.student_subcounty in('Embakasi E.','Embkasi E.', 'Embkasi East')
  
   update education_cleaned_data ecd 
  set student_subcounty ='Kisauni'
  where ecd.student_subcounty in('Kisauny')
  
   update education_cleaned_data ecd 
  set student_subcounty ='Kisumu East'
  where ecd.student_subcounty in('Kisumu E','Ksm East')
  
   update education_cleaned_data ecd 
  set student_subcounty ='Athi River'
  where ecd.student_subcounty in('Ath River','Athi-River')
  
   update education_cleaned_data ecd 
  set student_subcounty ='Langata'
  where ecd.student_subcounty in('Lngata')
  
   update education_cleaned_data ecd 
  set student_subcounty ='Lurambi'
  where ecd.student_subcounty in('Lurambii')
  
   update education_cleaned_data ecd 
  set student_subcounty ='Mvita'
  where ecd.student_subcounty in('Mvitaa')
  
   update education_cleaned_data ecd 
  set student_subcounty ='Naivasha'
  where ecd.student_subcounty in('Naivsh')
  
   update education_cleaned_data ecd 
  set student_subcounty ='Ruiru'
  where ecd.student_subcounty in('Ruru')
  
   update education_cleaned_data ecd 
  set student_subcounty ='Thika Town'
  where ecd.student_subcounty in('T. Town','Thika')
  
   update education_cleaned_data ecd 
  set student_subcounty ='Westlands'
  where ecd.student_subcounty in('West Lands','Wstlnds')
  
  --Check if there are nulls or blanks
select count(*) as total_missing_or_blank
from education_cleaned_data ecd 
where ecd.student_subcounty isnull
or student_subcounty =''
  
  
  --14. student_county column
select *from education_cleaned_data ecd 

select student_county
from education_cleaned_data ecd 
group by ecd.student_county 
order by ecd.student_county 

--capitalize each word in the column
 update education_cleaned_data ecd 
 set student_county=initcap(ecd.student_county )
 
 --Now standardize
update education_cleaned_data ecd 
set student_county ='Uasin Gishu'
where ecd.student_county in ('Eldoret','U/G','Uasin-Gishu')

update education_cleaned_data ecd 
set student_county ='Kakamega'
where ecd.student_county in('Kakamega County','Kakmega')

update education_cleaned_data ecd 
set student_county ='Kisumu'
where ecd.student_county in('Ksm','Kisum','Kisumu County')

update education_cleaned_data ecd 
set student_county ='Kiambu'
where ecd.student_county in('Kbu','Kiambu County','Kiambo')

update education_cleaned_data ecd 
set student_county ='Machakos'
where ecd.student_county in('Machakoss','Mks')

update education_cleaned_data ecd 
set student_county ='Mombasa'
where ecd.student_county in('Mombasa County','Mombsa','Msa')

update education_cleaned_data ecd 
set student_county ='Nairobi'
where ecd.student_county in('Nairob','Nairobii','Nairobi County','Nrb','Nairobiii')

update education_cleaned_data ecd 
set student_county ='Nakuru'
where ecd.student_county in('Nakru','Naks')

--Check if there are nulls or blanks
select count(*) as total_missing_or_blank
from education_cleaned_data ecd 
where ecd.student_county isnull
or student_county =''
  

 --15. student_region column
select *from education_cleaned_data ecd 

select student_region
from education_cleaned_data ecd 
group by ecd.student_region 
order by ecd.student_region 

--capitalize each word in the column
 update education_cleaned_data ecd 
 set student_region=initcap(ecd.student_region )
 
 --now standadrize
update education_cleaned_data ecd 
set student_region ='Central'
where ecd.student_region in('Centrl')


update education_cleaned_data ecd 
set student_region ='Coast'
where ecd.student_region in('Cost')

update education_cleaned_data ecd 
set student_region ='Eastern'
where ecd.student_region in('Eastn')

update education_cleaned_data ecd 
set student_region ='Nairobi'
where ecd.student_region in('Nairobi Region','Nrb Region')

update education_cleaned_data ecd 
set student_region ='Nyanza'
where ecd.student_region in('Nyanza Region')

update education_cleaned_data ecd 
set student_region ='Rift Valley'
where ecd.student_region in('Rift-Valley','Rv')

update education_cleaned_data ecd 
set student_region ='Western'
where ecd.student_region in('Westn')

--Check if there are nulls or blanks
select count(*) as total_missing_or_blank
from education_cleaned_data ecd 
where ecd.student_region  isnull
or student_region =''
  


--16. teacher_name column
select *from education_cleaned_data ecd 

select teacher_name
from education_cleaned_data ecd 
group by ecd.teacher_name
order by ecd.teacher_name 

--capitalize each word in the column
 update education_cleaned_data ecd 
 set teacher_name=initcap(ecd.teacher_name )
 
 --17. teacher_gender column
select *from education_cleaned_data ecd 

select teacher_gender
from education_cleaned_data ecd 
group by ecd.teacher_gender
order by ecd.teacher_gender

--capitalize each word in the column
 update education_cleaned_data ecd 
 set teacher_gender=initcap(ecd.teacher_gender )
 
 --Standardize
 
 update education_cleaned_data ecd 
 set teacher_gender='F'
 where ecd.teacher_gender in('Female')
 
  update education_cleaned_data ecd 
 set teacher_gender='M'
 where ecd.teacher_gender in('Male')
 
 --There are nulls and blanks
 
 select teacher_gender, ecd.teacher_name 
 from education_cleaned_data ecd 
 where ecd.teacher_gender in('','null')
 group by ecd.teacher_name ,ecd.teacher_gender 
 
 -- No update  nulls and blanks
 
 update education_cleaned_data ecd 
 set teacher_gender='M'
 where ecd.teacher_name in ('Brian Kiptoo','Daniel Otieno','Peter Mwangi')
 
 update education_cleaned_data ecd 
 set teacher_gender='F'
 where ecd.teacher_name in ('Amina Wanjiru','Esther Naliaka','Fatuma Ali')

 
 
  --18. teacher_subject_specialty column
select *from education_cleaned_data ecd 

select teacher_subject_specialty
from education_cleaned_data ecd 
group by ecd.teacher_subject_specialty
order by ecd.teacher_subject_specialty

--capitalize each word in the column
 update education_cleaned_data ecd 
 set teacher_subject_specialty=initcap(ecd.teacher_subject_specialty )
 
 --Standardize
 
 update education_cleaned_data ecd 
 set teacher_subject_specialty= 'Business Studies'
 where teacher_subject_specialty in ('B/Studies','Bus','Business')
 
  update education_cleaned_data ecd 
 set teacher_subject_specialty= 'Biology'
 where teacher_subject_specialty in ('Bio','Biolgy')
 
  update education_cleaned_data ecd 
 set teacher_subject_specialty= 'Computer Studies'
 where teacher_subject_specialty in ('Comp','Comp Studies','Computer','Ict')
 
  update education_cleaned_data ecd 
 set teacher_subject_specialty= 'English'
 where teacher_subject_specialty in ('Eng','Englis')
 
  update education_cleaned_data ecd 
 set teacher_subject_specialty= 'Kiswahili'
 where teacher_subject_specialty in ('Kis','Kisw','Swahili')
 
  update education_cleaned_data ecd 
 set teacher_subject_specialty= 'Mathematics'
 where teacher_subject_specialty in ('Math','Mathematic','Maths')
 
 --Check if there are nulls or blanks
select count(*) as total_missing_or_blank
from education_cleaned_data ecd 
where ecd.teacher_subject_specialty  isnull
or teacher_subject_specialty =''


--19. teacher_subcounty column
select *from education_cleaned_data ecd 

select teacher_subcounty
from education_cleaned_data ecd 
group by ecd.teacher_subcounty
order by ecd.teacher_subcounty

--capitalize each word in the column
 update education_cleaned_data ecd 
 set teacher_subcounty=initcap(ecd.teacher_subcounty )
 
 -- Standardize
   
  update education_cleaned_data ecd 
  set teacher_subcounty ='Eldoret East'
  where ecd.teacher_subcounty in('Eld East','Eldoret E.')
  
   update education_cleaned_data ecd 
  set teacher_subcounty ='Kisumu East'
  where ecd.teacher_subcounty in('Kisumu E','Ksm East')
  
   update education_cleaned_data ecd 
  set teacher_subcounty ='Mvita'
  where ecd.teacher_subcounty in('Mvitaa')
  
   update education_cleaned_data ecd 
  set teacher_subcounty ='Ruiru'
  where ecd.teacher_subcounty in('Ruru')
  
   update education_cleaned_data ecd 
  set teacher_subcounty ='Thika Town'
  where ecd.teacher_subcounty in('T. Town','Thika')
  
   update education_cleaned_data ecd 
  set teacher_subcounty ='Westlands'
  where ecd.teacher_subcounty in('West Lands','Wstlnds')
  
  --Check if there are nulls or blanks
select count(*) as total_missing_or_blank
from education_cleaned_data ecd 
where ecd.teacher_subcounty isnull
or teacher_subcounty =''


  --20. teacher_county column
select *from education_cleaned_data ecd 

select teacher_county
from education_cleaned_data ecd 
group by ecd.teacher_county 
order by ecd.teacher_county

--capitalize each word in the column
 update education_cleaned_data ecd 
 set teacher_county=initcap(ecd.teacher_county )
 
 --Now standardize
update education_cleaned_data ecd 
set teacher_county ='Uasin Gishu'
where ecd.teacher_county in ('Eldoret','U/G','Uasin-Gishu')

update education_cleaned_data ecd 
set teacher_county ='Kakamega'
where ecd.teacher_county in('Kakamega County','Kakmega')

update education_cleaned_data ecd 
set teacher_county ='Kisumu'
where ecd.teacher_county in('Ksm','Kisum','Kisumu County')

update education_cleaned_data ecd 
set teacher_county ='Kiambu'
where ecd.teacher_county in('Kbu','Kiambu County','Kiambo','Kiammbu')

update education_cleaned_data ecd 
set teacher_county ='Machakos'
where ecd.teacher_county in('Machakoss','Mks')

update education_cleaned_data ecd 
set teacher_county ='Mombasa'
where ecd.teacher_county in('Mombasa County','Mombsa','Msa')

update education_cleaned_data ecd 
set teacher_county ='Nairobi'
where ecd.teacher_county in('Nairob','Nairobii','Nairobi County','Nrb','Nairobiii')

update education_cleaned_data ecd 
set teacher_county ='Nakuru'
where ecd.teacher_county in('Nakru','Naks')

--Check if there are nulls or blanks
select count(*) as total_missing_or_blank
from education_cleaned_data ecd 
where ecd.teacher_county isnull
or teacher_county =''


 --21. teacher_region column
select *from education_cleaned_data ecd 

select teacher_region
from education_cleaned_data ecd 
group by ecd.teacher_region
order by ecd.teacher_region

--capitalize each word in the column
 update education_cleaned_data ecd 
 set teacher_region=initcap(ecd.teacher_region )
 
 --now standadrize
update education_cleaned_data ecd 
set teacher_region ='Central'
where ecd.teacher_region in('Centrl')


update education_cleaned_data ecd 
set teacher_region ='Coast'
where ecd.teacher_region in('Cost')

update education_cleaned_data ecd 
set teacher_region ='Eastern'
where ecd.teacher_region in('Eastn')

update education_cleaned_data ecd 
set teacher_region ='Nairobi'
where ecd.teacher_region in('Nairobi Region','Nrb Region')

update education_cleaned_data ecd 
set teacher_region ='Nyanza'
where ecd.teacher_region in('Nyanza Region')

update education_cleaned_data ecd 
set teacher_region ='Rift Valley'
where ecd.teacher_region in('Rift-Valley','Rv')

update education_cleaned_data ecd 
set teacher_region ='Western'
where ecd.teacher_region in('Westn')

--Check if there are nulls or blanks
select count(*) as total_missing_or_blank
from education_cleaned_data ecd 
where ecd.teacher_region  isnull
or teacher_region =''



  --22. subject_name column
select *from education_cleaned_data ecd 

select subject_name
from education_cleaned_data ecd 
group by ecd.subject_name
order by ecd.subject_name

--capitalize each word in the column
 update education_cleaned_data ecd 
 set subject_name=initcap(ecd.subject_name )
 
 --Standardize
 
 update education_cleaned_data ecd 
 set subject_name= 'Business Studies'
 where subject_name in ('B/Studies','Bus','Business')
 
  update education_cleaned_data ecd 
 set subject_name= 'Biology'
 where subject_name in ('Bio','Biolgy')
 
  update education_cleaned_data ecd 
 set subject_name= 'Computer Studies'
 where subject_name in ('Comp','Comp Studies','Computer','Ict')
 
  update education_cleaned_data ecd 
 set subject_name= 'English'
 where subject_name in ('Eng','Englis')
 
  update education_cleaned_data ecd 
 set subject_name= 'Kiswahili'
 where subject_name in ('Kis','Kisw','Swahili')
 
  update education_cleaned_data ecd 
 set subject_name= 'Mathematics'
 where subject_name in ('Math','Mathematic','Maths')
 
 --Check if there are nulls or blanks
select count(*) as total_missing_or_blank
from education_cleaned_data ecd 
where ecd.subject_name  isnull
or subject_name =''


 --23. assessment_type column
select *from education_cleaned_data ecd 

select assessment_type
from education_cleaned_data ecd 
group by ecd.assessment_type
order by ecd.assessment_type

--capitalize each word in the column
 update education_cleaned_data ecd 
 set assessment_type=initcap(ecd.assessment_type )
 
 --Standardize
 update education_cleaned_data ecd 
 set assessment_type ='CAT-2'
 where assessment_type in ('Cat-2')
 
 update education_cleaned_data ecd 
 set assessment_type ='CAT-1'
 where assessment_type in ('Cat1','Cat 1')
 
 update education_cleaned_data ecd 
 set assessment_type ='Mid-Term'
 where assessment_type in ('Midterm', 'Mid Term')
 
 update education_cleaned_data ecd 
 set assessment_type ='Practical'
 where assessment_type in ('Prac','Project')
 
 update education_cleaned_data ecd 
 set assessment_type ='Unknown'
 where assessment_type in ('')
 
 
 --24. score column
select *from education_cleaned_data ecd 

select score
from education_cleaned_data ecd 
group by ecd.score
order by ecd.score

--change data type from text to numeric
-- Clean the non-numeric character firts

update education_cleaned_data
set score = regexp_replace(score, '[^0-9.]', '', 'g');

--Now ,convert

alter table education_cleaned_data 
alter column score type numeric using  nullif(score,'')::numeric;

-- Now calculate median=58.5
   
select PERCENTILE_CONT(0.5) within group (order by score) as median_age
from education_cleaned_data ecd 
where score is not null;

--Replace nulls in student_id with 15

update education_cleaned_data ecd 
set score=58.5
where score is null;

 --25. attendance_rate_pct column
select *from education_cleaned_data ecd 

select attendance_rate_pct
from education_cleaned_data ecd 
group by ecd.attendance_rate_pct
order by ecd.attendance_rate_pct

--change data type from text to numeric
-- Clean the non-numeric character firts

update education_cleaned_data
set attendance_rate_pct = regexp_replace(attendance_rate_pct, '[^0-9.]', '', 'g');

--Now ,convert

alter table education_cleaned_data 
alter column attendance_rate_pct type numeric using  nullif(attendance_rate_pct,'')::numeric;

-- Now calculate median=77
   
select PERCENTILE_CONT(0.5) within group (order by attendance_rate_pct) as median_age
from education_cleaned_data ecd 
where attendance_rate_pct is not null;

--Replace nulls in student_id with 77

update education_cleaned_data ecd 
set attendance_rate_pct=77
where attendance_rate_pct is null;

---N/B For the attendance_rate_pct, i think empty or error rows should be replace by 0. Because students might not have atanded classes.

--Replace 77 in student_id with 0

update education_cleaned_data ecd 
set attendance_rate_pct=0
where attendance_rate_pct =77;


--26. fee_balance_kes column
select *from education_cleaned_data ecd 

select fee_balance_kes
from education_cleaned_data ecd 
group by ecd.fee_balance_kes
order by ecd.fee_balance_kes

--change data type from text to numeric
-- Clean the non-numeric character firts

update education_cleaned_data
set fee_balance_kes = regexp_replace(fee_balance_kes, '[^0-9.]', '', 'g');

--Now ,convert

alter table education_cleaned_data 
alter column fee_balance_kes type numeric using  nullif(fee_balance_kes,'')::numeric;

--Replace nulls with 0

update education_cleaned_data ecd 
set fee_balance_kes =0
where fee_balance_kes is null


 --27. scholarship_status column
select *from education_cleaned_data ecd 

select scholarship_status
from education_cleaned_data ecd 
group by ecd.scholarship_status
order by ecd.scholarship_status

--capitalize each word in the column
 update education_cleaned_data ecd 
 set scholarship_status=initcap(ecd.scholarship_status )

 --standardize
 
 update education_cleaned_data ecd 
 set scholarship_status='No'
 where scholarship_status in ('N/A','')
 
 
  --28. learning_mode column
select *from education_cleaned_data ecd 

select learning_mode
from education_cleaned_data ecd 
group by ecd.learning_mode
order by ecd.learning_mode

--capitalize each word in the column
 update education_cleaned_data ecd 
 set learning_mode=initcap(ecd.learning_mode )

 --standardize
 
 update education_cleaned_data ecd 
 set learning_mode='Unknown'
 where learning_mode in ('')

 
 --END

