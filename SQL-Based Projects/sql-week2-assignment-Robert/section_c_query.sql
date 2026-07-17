
--SECTION C - Querying the Data (Filtering with WHERE)
--Name: Ruto Robert  
--Date: 17/07/2026  
--Database: PostgreSQL

---Q15. Write a query to find all students who are in Form 4.

select s.student_id ,s.first_name 
from students s 
where class='Form 4';

--Q16. Write a query to find all subjects in the Sciences department.

select s.subject_name ,s.department 
from subjects s  
where s.department ='Sciences';

--Q17. Write a query to find all exam results where the marks are greater than or equal to 70.

select er.result_id ,marks,grade
from exam_results er
where er.marks >=70; 

--Q18. Write a query to find all female students only. (Hint: gender = 'F')

select*
from students s
where gender='F';

--Q19. Write a query to find all students who are in Form 3 AND from Nairobi.

select *
from students s
where class='Form 3' and s.city ='Nairobi';

--Q20. Write a query to find all students who are in Form 2 OR Form 4.

select *
from students s
where s."class"='Form 2' or class='Form 4';

--Or
select *
from students s
where class in('Form 2','Form 4');

