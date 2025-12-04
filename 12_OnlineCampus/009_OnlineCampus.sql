/** In this exercise we're going to use the OnlineCampus database.

OnlineCampus is a fictional online open course platform that offers paid academic courses.

The OnlineCampus database consists of a single table: Courses - which provides information about the various courses hosted by OnlineCampus
**/

-- 1. Write a query to display all of the information inside courses table

select * from courses;


--2. Write a query to display for each course - the course_id, price_usd, num_students, and content_duration_minutes

SELECT course_id, price_usd, num_students, content_duration_minutes
FROM courses;

/**
3. Write a query to display the :

a. course_title

b. num_students

c. positive_reviews + negative_reviews (name this calculation: `total_reviews` for example)

d. A new column representing the ratio between the total_reviews & num_students: (positive_reviews + negative_reviews) / num_students
**/
SELECT course_title,
num_students,
positive_reviews + negative_reviews as total_reviews,
(positive_reviews + negative_reviews) / num_students  as ratio
from courses;

/**
Write a query to display the course_id, course_title, num_lessons, content_duration_minutes, and a new column representing the average duration for each lecture (content_duration_minutes / num_lessons)
**/

select course_id,
course_title,
num_lessons,
content_duration_minutes,
(content_duration_minutes / num_lessons) as duration_average
from courses;

/**
5. Write a query to display the

a. course_id

b. course_title

c. num_students

d. price_usd (the column represents price in USD)

e. Total course revenues in USD (num_students * price_usd)
**/


select course_id,
course_title,
num_students,
price_usd,
(num_students * price_usd) as revenues

from courses;

/**
6. Write a query to display the course_id, and course_subject concatenated with course_title
**/

select course_id,
concat(course_subject,' ',course_title) as subject
from courses;

/**
7. Write a query to display the course_id, price_usd, content_duration_minutes,

and a new column representing the content duration in hours (content_duration_minutes / 60)
**/

select course_id,
price_usd,
content_duration_minutes,
(content_duration_minutes / 60) as duration_in_hour
from courses;


/**
8. Write a query to display the distinct values in course_subject column
**/

select distinct course_subject
from courses;

/**
9. Write a query to display the unique values in course_level column
**/

select distinct course_level
from courses;

/**
10.Write a query to display the distinct combination of values in course_subject and course_level columns
**/
select  distinct course_level,course_subject
from courses;