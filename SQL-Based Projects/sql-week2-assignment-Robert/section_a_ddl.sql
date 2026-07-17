# SECTION A - Building the Database (DDL)

**Name:** Ruto Robert  
**Date:** 17/07/2026  
**Database:** PostgreSQL

---

## Q1. Create a schema called greenwood_academy and ensure SQL uses it before you do anything else.

I used alreaduy created database names Assignments

---

## Q2. Create the students' table with the following columns:

```sql
create table students (
student_id	int primary  key,
first_name	varchar(50)	not  null,
last_name	varchar(50)	not null,
gender	varchar(1),
date_of_birth	date,
class	varchar(10),
city	varchar(50)
)
```

---

## Q3. Create the subjects table with the following columns:

```sql
create table subjects(
subject_id	int	primary key,
subject_name	varchar(100) not null unique,
department	varchar(50),
teacher_name	varchar(100),
credits	int
)
```

---

## Q4. Create the exam_results table with the following columns:

```sql
create table exam_results(
result_id	int primary key,
student_id	int not null,
subject_id	int not null,
marks	int not null,
exam_date	date,
grade	varchar(2)
)
```

---

## Q5. After creating the students table, the school realises they forgot to include a phone number column.

Use ALTER TABLE to add a column called phone_number with data type VARCHAR(20).

```sql
alter table students
add column phone_number varchar(20)

select *from students s --To confirm if phone_number colum is created
```

---

## Q6. The column credits in the subjects table needs to be renamed to credit_hours. Write the SQL to rename it.

```sql
alter table  subjects
rename column credits to credit_hours;

select * from subjects s --To confirm  change of credits to credit_hours
```

---

## Q7. The school decides they no longer need the phone_number column you added in Q5.

Write the SQL to remove it completely from the students table.

```sql
alter table students
drop  column phone_number;

select *from students s --To confirm if phone_number colum is dropped
```