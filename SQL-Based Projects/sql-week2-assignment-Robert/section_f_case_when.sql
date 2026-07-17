--SECTION F - CASE WHEN
--Name: Ruto Robert  
--Date:17/07/2026  
--Database: PostgreSQL

--Q29. Write a query using CASE WHEN to label each exam result with a grade description:
--•	'Distinction' if marks >= 80
--•	'Merit' if marks >= 60
--•	'Pass' if marks >= 40
--•	'Fail' if marks below 40
--Call the new column performance.

select *from exam_results er 

--added column performance
alter table exam_results 
add column performance varchar (30)

update exam_results er 
set performance = case
when marks >= 80 then 'Distinction'
when marks >= 60 then'Merit'
when marks >= 40 then 'Pass'
else'Fail'
end ;

--Q30. Write a query using CASE WHEN to label each student as:

--•	'Senior' if they are in Form 3 or Form 4
--•	'Junior' if they are in Form 2 or Form 1
--Call the new column student_level. Show the student's first name, last name, class, and student_level in your result.

select *from students s ;

 select first_name, last_name, class, case
 	when class='Form 3'
 	or class='Form 4' then 'Senior'
 	else 'Junior'
 end as student_level
 from students;
 
 
