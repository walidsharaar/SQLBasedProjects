/*
 The students_survey database consists of a single table - survey, which contains fictional data which were obtained in a survey of students
 */


-- 1. Write a query to display the student_id, full_name and university_id for all students who go to the same university as student_id 6043

select student_id,full_name, university_id
from survey 
where university_id = (select university_id from survey where student_id = 6034);

-- 2. Write a query to display the survey_id and survey_date for all surveys that were taken on the same date as survey_id 532

select survey_id,survey_date 
from survey 
where survey_date= (select survey_date from survey where survey_id=532);

-- 3. Write a query to display the student_id, full_name and height for all students who are taller than Josephina Athow (full_name)

select student_id,full_name, height_cm
from survey 
where height_cm >(select height_cm from survey where full_name='Josephina Athow');

-- 4. Write a query to display the student_id, full_name and age for all students younger than the student who filled survey number 10
select student_id,full_name,age,survey_id 
from survey 
where age<(select age from survey where survey_id=10);

-- 5. Write a query to display the student_id, full_name, and father_job, for all students whose father works in the same job as (the father of) Christina Rediers (full_name)

select student_id, full_name, father_job, mother_job
from survey 
where father_job = (select father_job from survey where full_name ='Christina Rediers ');
/* 6. Write a query to display the student_id, full_name, father_job, and mother_job for all students whose:

a. Father works in the same job as (the father of) Christina Rediers and

b. Mother works in the same job as (the mother of) Christina Rediers and
*/
select student_id, full_name, father_job, mother_job
from survey 
where father_job = (select father_job from survey where full_name ='Christina Rediers ')
and mother_job =(select mother_job from survey where full_name ='Christina Rediers ');


-- 7. Write a query to display the student_id, full_name and age for all students older than the average

select student_id, full_name, age
from survey 
where age>(select avg(age) from survey);


-- 8. Write a query to display the student_id, full_name, age and height for all students older than the average, and taller than the average

select student_id, full_name, age, height_cm
from survey 
where age>(select avg(age) from survey)
and height_cm >(select avg(height_cm) from survey );


-- 9.Write a query to display the student_id, full_name, age, and academic_major for all students taking the same major as students who are 40 years old

select student_id,full_name,age,academic_major
from survey 
where age<( select distinct  age from survey where age=40);

/*
 10. Write a query to display the student_id, full_name, age, academic_major for all students who

a. take major in Philosophy and

b. their age equals to (the age of one of) the students who take major in Medical physics
 */

select student_id, full_name, age, academic_major 
from survey 
where academic_major = 'Philosophy'
and age in (select distinct age from survey where academic_major = 'Medical physics');


