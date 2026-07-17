--SECTION D - Range, Membership & Search Operators
--Name: Ruto Robert  
--Date: 17/07/2026  
--Database: PostgreSQL

--Q21. Write a query to find all exam results where marks are between 50 and 80 (inclusive).

select *
from exam_results er
where er.marks between 50 and 80;

--Q22. Write a query to find all exams that took place between 15th March 2024 and 18th March 2024.

select *
from exam_results er
where er.exam_date  between '2024-03-15' and '2024-03-18';

--Q23. Write a query to find all students who live in Nairobi, Mombasa, or Kisumu - use IN.

select *
from students s 
where city in ('Nairobi', 'Mombasa', 'Kisumu');

--Q24. Write a query to find all students who are NOT in Form 2 or Form 3 - use NOT IN.

select *
from students s 
where class not in ('Form 2', 'Form 3');

--Q25. Write a query to find all students whose first name starts with the letter 'A' or 'E' - use LIKE.

select *
from students s 
where s.first_name like 'A%' 
or s.first_name like 'E%';

--Q26. Write a query to find all subjects whose subject name contains the word 'Studies'.

select *
from subjects s 
where s.subject_name like '%Studies';

