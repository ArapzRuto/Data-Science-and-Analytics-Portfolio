--SECTION E - COUNT
--Name: Ruto Robert  
--Date: 17/07/2026  
--Database: PostgreSQL

--Q27. How many students are currently in Form 3? Write the query.

select count(*) as form3_students
from students s 
where class ='Form 3';--4 students


--Q28. How many exam results have a mark of 70 or above? Write the query.

select count(*) as results_above70marks
from exam_results er
where er.marks >=70;--6 exam results