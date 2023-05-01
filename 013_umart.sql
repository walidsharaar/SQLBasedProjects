/**
 we're going to use the Umart database.

Umart is a fictional retail company, selling items of various categories. Inside the Umart database you’ll find a single table - Orders, which has the data of all the orders that have been placed.

**/


select * from orders; 

-- 1.Write a query to display the row_id, discount, unit_price and customer_id for all orders made by customer_id 3

select row_id,
	   discount,
	   unit_price,
	   customer_id
from orders
where customer_id = 3;
-- 2.Write a query to display the order_id, shipping_cost, and customer_name for all orders made by 'Skyler Youster'
select order_id,
	   shipping_cost,
	   customer_name,
	   customer_id
from orders
where customer_name ='Skyler Youster';

-- 3.Write a query to display the order_id, order_date, customer_region and customer_country for all orders made before '2012/01/01'
select order_id,
	   order_date,
	   customer_region,
	   customer_country
from orders
where date(order_date)< '2012/01/01';

-- 4.Write a query to display the customer_segment, customer_id, and customer_name for all customers belong to the 'Corporate' customer_segment

select customer_segment,
	   customer_id,
	   customer_name
from orders
where customer_segment= 'Corporate';


-- 5.Write a query to display the order_priority, discount, customer_name, and customer_region for all orders made in the 'Central' or 'West' regions

select order_priority,
	   discount,
	   customer_name
from orders 
where customer_region in('Central','West');

-- 6. Write a query to display the order_id, ship_mode, customer_segment, and product_id for all orders not made by a 'Small Business' or 'Corporate' customer_segment

select order_id,
	   ship_mode,
	   customer_segment,
	   product_id
from orders 
where customer_segment not in('Small Business','Corporate');



-- 7. Write a query to display the order_id, ship_mode, customer_segment, and unit_price for all orders with unit_price in the range of 10-20
select order_id,
	   ship_mode,
	   customer_segment,
	   product_id
from orders 
where unit_price  between 10 and 20;

-- 8. Write a query to display the order_id, discount, unit_price, amount_of_products, profit and discount for all orders with profit in the range of 100-200

select order_id,
	   discount,
	   unit_price,
	   amount_of_products,
	   profit,
	   discount
from orders 
where profit  between 100 and 200;

-- 9. Write a query to display the customer_id and customer_name for all customers with customer_name starts with an 'E'

select 
customer_id,
customer_name
from orders
where customer_name like 'E%' 

-- 10. Write a query to display the customer_id and customer_name for all customers with customer_name ends with an 'e'

select 
customer_id,
customer_name
from orders
where customer_name like '%e'

-- 11.Write a query to display the customer_id and customer_name for all customers with customer_name that contains an 'e' (somewhere)


select 
customer_id,
customer_name
from orders
where customer_name like '%e%'



--12. Write a query to display the customer_id and customer_name for all customers with customer_name starts with an 'E' or 'A'

select 
customer_id,
customer_name
from orders
where customer_name like 'E%' or customer_name like 'A%'

-- 13. Write a query to display the customer_id and customer_name for all customers with customer_name ends with an 'e' or 'i'

select 
customer_id,
customer_name
from orders
where customer_name like '%e ' or customer_name like ' %i'

-- 14. Write a query to display the customer_id, customer_country, and customer_region for all customers with no region

select customer_id,
customer_country,
customer_region
from orders
where customer_region   isnull 

-- 15. Write a query to display the order_priority, discount, shipping_cost, ship_mode and discount for all orders with 'High' order_priority and 'Regular Air' ship_mode

Select order_priority,
discount,
shipping_cost,
ship_mode,
discount
from orders
where order_priority = 'High' and ship_mode='Regular Air'

--16. Write a query to display the order_priority, discount, shipping_cost, ship_mode and discount for all orders with 'High' order_priority or 'Regular Air' ship_mod
Select order_priority,
discount,
shipping_cost,
ship_mode,
discount
from orders
where order_priority = 'High' or  ship_mode='Regular Air'

--17. Write a query to display the order_id, customer_id, customer_region, customer_country, and customer_segment for orders made by:
--a. customers belong to the 'Small Business' or 'Corporate' customer_segment and:
--b. customers not living in the ‘North’ or ‘South’ regions

select order_id,
customer_region,
customer_segment
from orders
where customer_segment in ('Small Business','Corporate') and   customer_region not in('North','South')

-- 18.Write a query to display the order_id, discount, unit_price, profit and discount for all orders with profit in the range of 100-200 and discount not in the range of 0.1-0.5

select order_id,
discount,
unit_price,
profit,
 discount
 from orders
 where profit in (100,200) and discount not in(0.1,0.5)


--19.Write a query to display the order_id, discount, unit_price, and profit.
--a. Restrict the results to display only orders with profit > 100
--b. Sort the output by discount in a descending order


select order_id,
discount,
unit_price,
profit
from orders
where profit > 100
order by discount desc;

--20. Write a query to display the order_id, discount, unit_price, and profit.
--a. Restrict the results to display only orders with profit > 100
--b. Sort the output by discount in a descending order, and then by profit in an ascending order

select order_id,
discount,
unit_price,
profit
from orders
where profit > 100
order by discount desc,profit;



-- 21. Write a query to display the row_id, order_priority, unit_price, shipping_cost and customer_name
--a. Sort the output by shipping_cost
--b. Limit your output to the first 5 rows

select row_id,
order_priority,
unit_price,
shipping_cost,
customer_name
from orders
order by shipping_cost 
limit 5

-- 22. Write a query to display the row_id, order_priority, unit_price, shipping_cost and profit
--a. Sort the output by profit (ascending)
--b. Limit your output to the first 3 rows

select row_id,
order_priority,
unit_price,
shipping_cost,
customer_name
from orders
order by profit 
limit 3