/*
In this concluding exercise we're going to use the CarsOnline dataset

Have you found the car just right for you, but it's miles away? No worries, just contact us at CarsOnline, buy the car online and your car will be delivered right to your door.

CarsOnline is a fictional online platform, allowing customers to find the right car for them, buy it online, and get it right at their doorstep.
*/


/*
 1.
  a. Write a query to display the car_id, price, car_make, car_model, and car_year for each car

b. restrict your query to display only cars made by bmw on 2019

c. Display the average price for each car model during this year

*/

select c.car_id, c.price, ct.car_make, ct.car_model, ct.car_year
from cars c join car_types ct 
on c.car_type_id = ct.car_type_id ;


select c.car_id, c.price, ct.car_make, ct.car_model, ct.car_year 
from cars c join car_types ct 
on   c.car_type_id = ct.car_type_id
where ct.car_make = 'bmw' and ct.car_year between 2015 and 2019;

select ct.car_model, avg(c.price) as "average_price"
from cars c join car_types ct 
on   c.car_type_id = ct.car_type_id
where ct.car_make = 'bmw' and ct.car_year = 2019
group by ct.car_model;

/*
 2. 
 
a. Write a query to display the car_id, price and fuel_type_name for each car

b. Display the number of cars by each fuel_type_name. Sort the output by the number of cars (descending)

*/

select c.car_id, c.price, ft.fuel_type_name
from cars c join fuel_types ft 
on c.fuel_type_id = ft.fuel_type_id;

select ft.fuel_type_name, count(*) as "number_of_cars"
from cars c join fuel_types ft 
on   c.fuel_type_id = ft.fuel_type_id
group by ft.fuel_type_name
order by count(*) desc;


/*
 3.
 a. Write a query to display the car_id, price and transmission_name for each car

b. Display the average price for each transmission_name. Sort the output by the average price (descending)
 
 */
select c.car_id, c.price, tt.transmission_name
from cars c join transmission_types tt 
on   c.transmission_type_id = tt.transmission_type_id;

select tt.transmission_name, avg(c.price) as "average_price" 
from cars c join transmission_types tt 
on   c.transmission_type_id = tt.transmission_type_id
group by tt.transmission_name
order by avg(c.price) desc;

/*
 4.
 Write a query to display the number of manual-gearbox cars, by each car_year and car_make. Sort the output by the year (ascending)
 **/

select ct.car_make, count(distinct ct.car_model) as "number_of_hybrid_cars"
from cars c join fuel_types ft 
on   c.fuel_type_id = ft.fuel_type_id
			join car_types ct 
on   c.car_type_id = ct.car_type_id
where ft.fuel_type_name = 'Hybrid'
group by car_make
order by count(distinct car_model) desc;




/*
 5.
Write a query to display the number of manual-gearbox cars, by each car_year and car_make. Sort the output by the year (ascending)
 */

select ct.car_year, ct.car_make, count(*) as "number_of_cars"
from cars c join transmission_types tt 
on   c.transmission_type_id = tt.transmission_type_id
			join car_types ct 
on   c.car_type_id = ct.car_type_id
where tt.transmission_name = 'Manual'
group by ct.car_year, ct.car_make
order by ct.car_year;

/*
 6.
 a. Write a query to display the customer_id, first_name, last_name, birth_date, and gender

b. Display the number of customers by each gender

c. Display the number of customers by each gender and age. Sort the output by the number of customers (descending)

d. Restrict your query to for customers above the age 59
 
 */
select c.customer_id, c.first_name, c.last_name, c.birth_date, g.gender
from customers c join genders g
on   c.gender_code = g.gender_code;

select g.gender, count(*) as "number_of_customers"
from customers c join genders g
on   c.gender_code = g.gender_code
group by g.gender;

select g.gender, 
       date_part('year', current_date) - date_part('year', c.birth_date) as "age", 
       count(*) as "number_of_customers"
from customers c join genders g
on   c.gender_code = g.gender_code
group by g.gender, date_part('year', current_date) - date_part('year', c.birth_date)
order by count(*) desc;

select g.gender, date_part('year', current_date) - date_part('year', c.birth_date) as "age", 
       count(*) as "number_of_customers"
from customers c join genders g
on   c.gender_code = g.gender_code
where date_part('year', current_date) - date_part('year', c.birth_date) > 59
group by g.gender, date_part('year', current_date) - date_part('year', c.birth_date)
order by count(*) desc;
/*
 7.
 a. Write a query to display the number of customers living in Australia .

b. Write another query to display the number of customers with updated phone_number living in Australia (customers who has value in phone_number)

c. Write another query to display the number of australian customers with NULL value in their phone_number, break down the result for each city, sort it by the count (descending).
 */

select count(*) as "number_of_customers"
from customers c join locations l 
on   c.location_code = l.location_code
where l.country = 'Australia';

select count(phone_number) as "number_of_customers"
from customers c join locations l 
on   c.location_code = l.location_code
where l.country = 'Australia';

select city, count(*) as "number_of_customers"
from customers c join locations l 
on   c.location_code = l.location_code
where l.country = 'Australia' and phone_number is null
group by city
order by count(*) desc;



/*
 8.
 Write a query to display the customer_id and full name of customers who bought more than 5 cars
 */

select c.customer_id, concat(c.first_name,'  ' ,c.last_name) as "full_name", count(*) as "number_of_cars"
from sales s join customers c 
on s.customer_id = c.customer_id
group by c.customer_id, concat(c.first_name,'  ', c.last_name)
having count(*) > 5 ;

/*
 9.
 Not every car on the cars table has been sold. Write a query to display the percent of sold cars.
 */

select count(s.customer_id) / cast(count(*) as decimal) * 100 as "percent_of_sold_cars"
from sales s right outer join cars c 
on s.car_id = c.car_id;


/*
 10.
 On 2019 (of purchase date), What was the average price of sold cars made by Audi?
 */

select avg(cr.price) as "average_price"
from sales s join cars cr 
on s.car_id = cr.car_id
			  join car_types ct
on  ct.car_type_id = cr.car_type_id
where date_part('year', s.purchase_date) = 2019 and ct.car_make = 'Audi';




