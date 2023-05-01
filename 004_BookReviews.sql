/*
In this exercise we’re going to use the BookReview database.

BookReview is a fictional social cataloging website that allows individuals to search its database of books, and rate them (available to registered users only).
*/

/*
 * 1. a. Write a query to display the first_name, last_name, email, birthdate, and gender for all users

b. Restrict your query to display only users who were born on 2002

c. Write a query to display the number of users who were born each year. Sort the output by year (ascending)
d. Repeat your last query, only this time display only years with more than 54 users (who were born on that year)
 */


select first_name,last_name,email,birthdate,g.gender 
from users u inner join genders g 
on u.gender_id = u.gender_id ;


select first_name,last_name,email,birthdate,g.gender 
from users u inner join genders g 
on u.gender_id = u.gender_id 
where date_part('year',u.birthdate )  = 2002;

select date_part ('year', u.birthdate) AS "year_of_birth", count(*) AS "num_of_users"
from   users u join genders g 
on u.gender_id = g.gender_id
group by date_part ('year', u.birthdate)
order by date_part('year', u.birthdate);


select date_part('year', u.birthdate) AS "year_of_birth", count(*) AS "num_of_users"
from   users u join genders g 
on u.gender_id = g.gender_id
group by date_part('year', u.birthdate)
having count(*) > 54
order by date_part('year', u.birthdate);

/*
 * 2.a. Write a query to display the first_name, last_name, email, birthdate, country and city for all users

b. Restrict your query to display only users living in the UK

c. Write a query to break down the number of users living in each country and city. Sort the output by the number of users (descending)

d. Restrict your query to count only users above the age 30
 */

select u.first_name, u.last_name, u.email, u.birthdate, l.country, l.city
from users u join locations l 
on u.location_id = l.location_id;

select u.first_name, u.last_name, u.email, u.birthdate, l.country, l.city
from users u join locations l 
on u.location_id = l.location_id
where country = 'United Kingdom';

select l.country, l.city, count(*) as "number_of_users"
from users u join locations l 
on u.location_id = l.location_id
group by l.country, l.city
order by count(*) desc;


select l.country, l.city, count(*) as "number_of_users"
from users u join locations l 
on u.location_id = l.location_id
where date_part ('year', current_date) - date_part ('year', birthdate) > 30
group by l.country, l.city
order by count(*) desc;
/*
  3. a. Write a query to display the first_name, last_name, email, age, and occupation_name for all users

b. Write a query to display the average age for each occupation

c. Restrict your query to display only occupations with average age greater than 40
 */

select u.first_name, u.last_name, u.email, 
       date_part('year', current_date) - date_part('year', u.birthdate) AS "age", 
     o.occupation_name
from users u join occupations o 
on u.occupation_id = o.occupation_id 


select avg(date_part('year', current_date) - date_part('year', u.birthdate)) AS "avg_age", o.occupation_name
from users u join occupations o 
on u.occupation_id = o.occupation_id 
group by o.occupation_name;


select avg(date_part('year', current_date) - date_part('year', u.birthdate)) AS "avg_age", o.occupation_name
from users u join occupations o 
on u.occupation_id = o.occupation_id 
group by o.occupation_name
having avg(date_part('year',current_date)-date_part('year',u.birthdate))>40;  

/*
 4.Write a query to display the average num_pages for each author. Sort the output by the average number of pages (descending)
 */

select authors, avg(num_pages) AS "average_num_pages"
from books b join authors a 
on b.author_id = a.author_id
group by authors
order by avg(num_pages) desc;



/*
5.Write a query to display the number of books for each language, Sort the output by the number of books (descending)
 */


select language_name, count(*) AS "num_of_book"
from books b join languages l 
on   b.language_code = l.language_code
group by l.language_name
order by count(*) desc;




/*
6. Write a query to display the number of unique publishers by each language, Sort the output by the number of unique publishers (descending)
 */


select l.language_name, count(distinct publisher_id) as "num_of_publishers"
from books b join languages l
on   b.language_code = l.language_code
group by l.language_name
order by count(distinct publisher_id) desc;

/*
 * 7.

a. Write a query to display the first_name, last_name, email, birthdate, occupation_name, country and city for all users

b. Write a query to breakdown the number of users for each country and occupation
*/

select us.first_name, us.last_name, us.email, us.birthdate,o.occupation_name, loc.country, loc.city  
from locations loc inner join users us
on loc.location_id = us.location_id 
inner join occupations o 
on o.occupation_id= us.occupation_id ;

select o.occupation_name, loc.country , count(*) as "users"
from users us join locations loc
on loc.location_id = us.location_id 
join occupations o 
on o.occupation_id = us.occupation_id 
group by o.occupation_id, loc.country ; 

/*
 8.

a. Write a query to display the rating_id, rating_date, rating, book title, and user's full name for each rating

b. Restrict your query to display ratings related to the 'Harry Potter' book-series

c. How many unique users have rated titles related to the 'Harry Potter' book-series?
*/

select r.rating_id, r.rating_date, r.rating, b.title,
concat(u.first_name,' ' , u.last_name) as "full_name"
from ratings r join books b 
on r.book_id  = b.book_id 
join users u 
on u.user_id = r.user_id ;

select r.rating_id, r.rating_date, r.rating, b.title,
concat(u.first_name,' ' , u.last_name) as "full_name"
from ratings r join books b 
on r.book_id  = b.book_id 
join users u 
on u.user_id = r.user_id 
where b.title  like '%Harry Potter%';

select count(distinct u.user_id) as "Users"
from ratings r join books b 
on r.book_id  = b.book_id 
join users u 
on u.user_id = r.user_id 
where b.title  like '%Harry Potter%';


/*
 9.How many unique users have rated titles related to the 'Harry Potter' book-series. Break down your result by each country
 
 
 */

select l.country, count(distinct us.user_id) as "Users"
from ratings r join books b 
on r.book_id = b.book_id 
join users us 
on us.user_id = r.user_id 
join locations l
on us.location_id = l.location_id 
where b.title like '%harry potter%'
group by l.country ;


/*
 10. a. Write a query to display the book title, num_pages and publisher name for all books, including those with no publisher details

b. Restrict your query to display only books with no publisher details
 */

select b.title,b.num_pages,p.publisher_name 
from books b  left join publishers p 
on b.publisher_id  = p.publisher_id ;


select b.title,b.num_pages,p.publisher_name 
from books b  left join publishers p 
on b.publisher_id  = p.publisher_id 
where p.publisher_id  is null;

/*
11. a. Write a query to display the book title, num_pages, publication_date, and authors for all books, including those with no author details

b. Restrict your query to display only books with no author details
 */

select b.title, b.num_pages, b.publication_date, a.authors
from books b left join authors a 
on b.author_id = a.author_id;


select b.title, b.num_pages, b.publication_date, a.authors
from books b left join authors a 
on b.author_id = a.author_id 
where a.author_id is null;

/*
12.How many books have never been rated
 */

select count(*)
from books b left join ratings r 
on b.book_id = r.book_id 
where r.rating_id is null;



