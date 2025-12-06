

# ✅ Case Study #2 - Pizza Runner 🍕

![Case Study 2 Image](https://8weeksqlchallenge.com/images/case-study-designs/2.png)

## Case Study Questions


## A. Pizza Metrics

1.  **How many pizzas were ordered?**

````sql
SELECT COUNT(*) AS pizza_order_count
FROM #customer_orders;
````
- Total of 14 pizzas were ordered.

2.  **How many unique customer orders were made?**
````sql
SELECT 
  COUNT(DISTINCT order_id) AS unique_order_count
FROM #customer_orders;
````
- There are 10 unique customer orders.

3.  **How many successful orders were delivered by each runner?**
````sql
SELECT 
  runner_id, 
  COUNT(order_id) AS successful_orders
FROM #runner_orders
WHERE distance != 0
GROUP BY runner_id;
````
- Runner 1 has 4 successful delivered orders.
- Runner 2 has 3 successful delivered orders.
- Runner 3 has 1 successful delivered order.
4.  **How many of each type of pizza was delivered?**
````sql
SELECT 
  p.pizza_name, 
  COUNT(c.pizza_id) AS delivered_pizza_count
FROM #customer_orders AS c
JOIN #runner_orders AS r
  ON c.order_id = r.order_id
JOIN pizza_names AS p
  ON c.pizza_id = p.pizza_id
WHERE r.distance != 0
GROUP BY p.pizza_name;
````
- There are 9 delivered Meatlovers pizzas and 3 Vegetarian pizzas.

5.  **How many Vegetarian and Meatlovers were ordered by each customer?**
````sql
SELECT 
  c.customer_id, 
  p.pizza_name, 
  COUNT(p.pizza_name) AS order_count
FROM #customer_orders AS c
JOIN pizza_names AS p
  ON c.pizza_id= p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id;
````
- Customer 101 ordered 2 Meatlovers pizzas and 1 Vegetarian pizza.
- Customer 102 ordered 2 Meatlovers pizzas and 2 Vegetarian pizzas.
- Customer 103 ordered 3 Meatlovers pizzas and 1 Vegetarian pizza.
- Customer 104 ordered 1 Meatlovers pizza.
- Customer 105 ordered 1 Vegetarian pizza.

6.  **What was the maximum number of pizzas delivered in a single order?**
````sql
WITH pizza_count_cte AS
(
  SELECT 
    c.order_id, 
    COUNT(c.pizza_id) AS pizza_per_order
  FROM #customer_orders AS c
  JOIN #runner_orders AS r
    ON c.order_id = r.order_id
  WHERE r.distance != 0
  GROUP BY c.order_id
)

SELECT 
  MAX(pizza_per_order) AS pizza_count
FROM pizza_count_cte;
````
- Maximum number of pizza delivered in a single order is 3 pizzas.

7.  **For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**
````sql
SELECT 
  c.customer_id,
  SUM(
    CASE WHEN c.exclusions <> ' ' OR c.extras <> ' ' THEN 1
    ELSE 0
    END) AS at_least_1_change,
  SUM(
    CASE WHEN c.exclusions = ' ' AND c.extras = ' ' THEN 1 
    ELSE 0
    END) AS no_change
FROM #customer_orders AS c
JOIN #runner_orders AS r
  ON c.order_id = r.order_id
WHERE r.distance != 0
GROUP BY c.customer_id
ORDER BY c.customer_id;
````
- Customer 101 and 102 likes his/her pizzas per the original recipe.
- Customer 103, 104 and 105 have their own preference for pizza topping and requested at least 1 change (extra or exclusion topping) on their pizza.

8.  **How many pizzas were delivered that had both exclusions and extras?**
````sql
SELECT  
  SUM(
    CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1
    ELSE 0
    END) AS pizza_count_w_exclusions_extras
FROM #customer_orders AS c
JOIN #runner_orders AS r
  ON c.order_id = r.order_id
WHERE r.distance >= 1 
  AND exclusions <> ' ' 
  AND extras <> ' ';
````
- Only 1 pizza delivered that had both extra and exclusion topping. That’s one fussy customer!

9.  **What was the total volume of pizzas ordered for each hour of the day?**
````sql
SELECT 
  DATEPART(HOUR, [order_time]) AS hour_of_day, 
  COUNT(order_id) AS pizza_count
FROM #customer_orders
GROUP BY DATEPART(HOUR, [order_time]);
````
- Highest volume of pizza ordered is at 13 (1:00 pm), 18 (6:00 pm) and 21 (9:00 pm).
- Lowest volume of pizza ordered is at 11 (11:00 am), 19 (7:00 pm) and 23 (11:00 pm).

10. **What was the volume of orders for each day of the week?**

````sql
SELECT 
  FORMAT(DATEADD(DAY, 2, order_time),'dddd') AS day_of_week, -- add 2 to adjust 1st day of the week as Monday
  COUNT(order_id) AS total_pizzas_ordered
FROM #customer_orders
GROUP BY FORMAT(DATEADD(DAY, 2, order_time),'dddd');
````
- There are 5 pizzas ordered on Friday and Monday.
- There are 3 pizzas ordered on Saturday.
- There is 1 pizza ordered on Sunday.


## B. Runner and Customer Experience

1.  **How many runners signed up for each 1 week period? (i.e., week starts 2021-01-01)**

````sql
SELECT 
  DATEPART(WEEK, registration_date) AS registration_week,
  COUNT(runner_id) AS runner_signup
FROM runners
GROUP BY DATEPART(WEEK, registration_date);
````


- On Week 1 of Jan 2021, 2 new runners signed up.
- On Week 2 and 3 of Jan 2021, 1 new runner signed up.

2.  **What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order?**

````sql
WITH time_taken_cte AS
(
  SELECT 
    c.order_id, 
    c.order_time, 
    r.pickup_time, 
    DATEDIFF(MINUTE, c.order_time, r.pickup_time) AS pickup_minutes
  FROM #customer_orders AS c
  JOIN #runner_orders AS r
    ON c.order_id = r.order_id
  WHERE r.distance != 0
  GROUP BY c.order_id, c.order_time, r.pickup_time
)

SELECT 
  AVG(pickup_minutes) AS avg_pickup_minutes
FROM time_taken_cte
WHERE pickup_minutes > 1;
````


- The average time taken in minutes by runners to arrive at Pizza Runner HQ to pick up the order is 15 minutes.
3.  **Is there any relationship between the number of pizzas and how long the order takes to prepare?**

````sql
WITH prep_time_cte AS
(
  SELECT 
    c.order_id, 
    COUNT(c.order_id) AS pizza_order, 
    c.order_time, 
    r.pickup_time, 
    DATEDIFF(MINUTE, c.order_time, r.pickup_time) AS prep_time_minutes
  FROM #customer_orders AS c
  JOIN #runner_orders AS r
    ON c.order_id = r.order_id
  WHERE r.distance != 0
  GROUP BY c.order_id, c.order_time, r.pickup_time
)

SELECT 
  pizza_order, 
  AVG(prep_time_minutes) AS avg_prep_time_minutes
FROM prep_time_cte
WHERE prep_time_minutes > 1
GROUP BY pizza_order;
````


- On average, a single pizza order takes 12 minutes to prepare.
- An order with 3 pizzas takes 30 minutes at an average of 10 minutes per pizza.
- It takes 16 minutes to prepare an order with 2 pizzas which is 8 minutes per pizza — making 2 pizzas in a single order the ultimate efficiency rate.
4.  **What was the average distance traveled for each customer?**

````sql
SELECT 
  c.customer_id, 
  AVG(r.distance) AS avg_distance
FROM #customer_orders AS c
JOIN #runner_orders AS r
  ON c.order_id = r.order_id
WHERE r.duration != 0
GROUP BY c.customer_id;
````

_(Assuming that distance is calculated from Pizza Runner HQ to customer’s place)_

- Customer 104 stays the nearest to Pizza Runner HQ at average distance of 10km, whereas Customer 105 stays the furthest at 25km.

5.  **What was the difference between the longest and shortest delivery times for all orders?**


````sql
SELECT 
  order_id, duration
FROM #runner_orders
WHERE duration not like ' ';
````


```sql
SELECT MAX(duration::NUMERIC) - MIN(duration::NUMERIC) AS delivery_time_difference
FROM runner_orders2
where duration not like ' ';
```


- The difference between longest (40 minutes) and shortest (10 minutes) delivery time for all orders is 30 minutes.
6.  **What was the average speed for each runner for each delivery, and do you notice any trend for these values?**

````sql
SELECT 
  r.runner_id, 
  c.customer_id, 
  c.order_id, 
  COUNT(c.order_id) AS pizza_count, 
  r.distance, (r.duration / 60) AS duration_hr , 
  ROUND((r.distance/r.duration * 60), 2) AS avg_speed
FROM #runner_orders AS r
JOIN #customer_orders AS c
  ON r.order_id = c.order_id
WHERE distance != 0
GROUP BY r.runner_id, c.customer_id, c.order_id, r.distance, r.duration
ORDER BY c.order_id;
````

_(Average speed = Distance in km / Duration in hour)_
- Runner 1’s average speed runs from 37.5km/h to 60km/h.
- Runner 2’s average speed runs from 35.1km/h to 93.6km/h. Danny should investigate Runner 2 as the average speed has a 300% fluctuation rate!
- Runner 3’s average speed is 40km/h

7.  **What is the successful delivery percentage for each runner?**


````sql
SELECT 
  runner_id, 
  ROUND(100 * SUM(
    CASE WHEN distance = 0 THEN 0
    ELSE 1 END) / COUNT(*), 0) AS success_perc
FROM #runner_orders
GROUP BY runner_id;
````


- Runner 1 has 100% successful delivery.
- Runner 2 has 75% successful delivery.
- Runner 3 has 50% successful delivery

## C. Ingredient Optimisation

1.  **What are the standard ingredients for each pizza?**

````sql
with table1 as 
(
select 
	unnest(string_to_array(toppings,', '))::numeric as recipes_id,
	pr.pizza_id,
	pizza_name
from pizza_recipes as pr
left join pizza_names as pn
ON pn.pizza_id = pr.pizza_id
)
select pizza_name,
	   pt.topping_name		 
from table1 as t1
left join pizza_toppings as pt
ON t1.recipes_id = pt.topping_id
order by pizza_id
`````

2.  **What was the most commonly added extra?**

````sql
with table1 as 
(
select order_id,
	   unnest(string_to_array(extras,', '))::numeric as extras_id
from customer_orders as co
where extras is not null
)
select count(order_id),
	   pt.topping_name
from table1 as t1
left join pizza_toppings as pt
ON pt.topping_id = t1.extras_id
group by 2
order by 1 desc
`````

3.  **What was the most common exclusion?**

````sql
with table1 as 
(
select order_id,
	   unnest(string_to_array(exclusions, ', '))::numeric as exclusions_id
from customer_orders as co
)
select count(exclusions_id) as count_exclusions,
	   topping_name
from table1 as t1
left join pizza_toppings as pt
ON pt.topping_id = t1.exclusions_id
group by 2
order by 1 desc
`````

4.  **Generate an order item for each record in the `customers_orders` table in the format of one of the following:**
    - Meat Lovers
    - Meat Lovers - Exclude Beef
    - Meat Lovers - Extra Bacon
    - Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

  ````sql
with table1 as 
(
select customer_id,
	   order_id,
	   pizza_id,
	   unnest(string_to_array(exclusions, ', '))::numeric as exclusions_id,
	   unnest(string_to_array(extras, ', '))::numeric as extras_id
from customer_orders as co
),
table2 as 
(
	with table22 as
	(
	select pizza_id ,
		   unnest(string_to_array(toppings,', ')) as topping_id
	from pizza_recipes as pr
	)
	select t22.topping_id,
		   pt.topping_name,
		   pizza_id
	from table22 as t22
	left join pizza_toppings as pt
	ON pt.topping_id = t22.topping_id::numeric
)
select DISTINCT
  t1.order_id,
  CASE
    WHEN t1.exclusions_id = t2.topping_id::numeric THEN 'Meatlovers - exc '||t1.exclusions_id
    WHEN t1.extras_id = t2.topping_id::numeric THEN 'Meatlover - ext 2x '||t1.extras_id
	else 'non exc or ext'
  END AS topping_segment
from table1 as t1
left join table2 as t2
ON t1.pizza_id = t2.pizza_id
where t1.pizza_id = 1
order by order_id
`````

5.  **Generate an alphabetically ordered comma-separated ingredient list for each pizza order from the `customer_orders` table and add a `2x` in front of any relevant ingredients.**
    - *For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"*

````sql
with table1 as 
(
select customer_id,
	   order_id,
	   pizza_id,
	   unnest(string_to_array(exclusions, ', '))::numeric as exclusions_id,
	   unnest(string_to_array(extras, ', '))::numeric as extras_id
from customer_orders as co
),
table2 as 
(
	with table22 as
	(
	select pizza_id ,
		   unnest(string_to_array(toppings,', ')) as topping_id
	from pizza_recipes as pr
	)
	select t22.topping_id,
		   pt.topping_name,
		   pizza_id
	from table22 as t22
	left join pizza_toppings as pt
	ON pt.topping_id = t22.topping_id::numeric
)
select DISTINCT
  t1.order_id,
  CASE
    WHEN t1.exclusions_id = t2.topping_id::numeric THEN 'Meatlovers - exc '||t1.exclusions_id
    WHEN t1.extras_id = t2.topping_id::numeric THEN 'Meatlover - ext 2x '||t1.extras_id
	else 'non exc or ext'
  END AS topping_segment
from table1 as t1
left join table2 as t2
ON t1.pizza_id = t2.pizza_id
where t1.pizza_id = 1
order by order_id
`````
6.  **What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?**
   
```` WITH cte_cleaned_customer_orders AS (
SELECT
  *,
  ROW_NUMBER() OVER () AS original_row_number
FROM 
	clean_customer_orders
),
-- split the toppings using our previous solution
cte_regular_toppings AS (
  SELECT
  	pizza_id,
    	REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+')::INTEGER AS topping_id
  FROM 
  	pizza_runner.pizza_recipes
),
-- now we can should left join our regular toppings with all pizzas orders
cte_base_toppings AS (
  SELECT
  	t1.order_id,
      t1.customer_id,
      t1.pizza_id,
      t1.order_time,
      t1.original_row_number,
      t2.topping_id
  FROM 
  	cte_cleaned_customer_orders AS t1
  LEFT JOIN 
  	cte_regular_toppings AS t2
  ON 
  	t1.pizza_id = t2.pizza_id
),
-- now we can generate CTEs for exclusions and extras by the original row number
cte_exclusions AS (
  SELECT
  	order_id,
  	customer_id,
  	pizza_id,
  	order_time,
  	original_row_number,
  	REGEXP_SPLIT_TO_TABLE(exclusions, '[,\s]+')::INTEGER AS topping_id
	FROM 
		cte_cleaned_customer_orders
	WHERE 
		exclusions IS NOT NULL
),
cte_extras AS (
  SELECT
  	order_id,
  	customer_id,
  	pizza_id,
  	order_time,
  	original_row_number,
  	REGEXP_SPLIT_TO_TABLE(extras, '[,\s]+')::INTEGER AS topping_id
	FROM 
		cte_cleaned_customer_orders
	WHERE 
		extras IS NOT NULL
),
-- now we can perform an except and a union all on the respective CTEs
cte_combined_orders AS (
  SELECT * 
  FROM 
  	cte_base_toppings
	EXCEPT
	SELECT * 
	FROM 
		cte_exclusions
	UNION ALL
	SELECT * 
	FROM 
		cte_extras
)
-- perform aggregation on topping_id and join to get topping names
SELECT
	t2.topping_name,
	COUNT(*) AS topping_count
FROM 
  cte_combined_orders AS t1
JOIN 
  pizza_runner.pizza_toppings AS t2
ON 
  t1.topping_id = t2.topping_id
GROUP BY 
  t2.topping_name
ORDER BY 
  topping_count DESC;
````

## D. Pricing and Ratings

1.  **If a Meat Lovers pizza costs $12 and a Vegetarian pizza costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?**

````sql
with meatlovers as
		(
select 
	 count(co.order_id) as order_count
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
where pizza_id = 1 and cancellation is null
		),
vegetarian as 
		(
select 
	count(co.order_id) as order_count
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
where pizza_id = 2 and cancellation is null
		)
select concat((m.order_count*12+v.order_count*10),'$') as total_cost
from meatlovers as m
cross join vegetarian as v
`````

2.  **What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra.**

````sql
with t1 as 
(
    select *,
           length(extras) - length(replace(extras, ',', '')) + 1 as topping_count
    from customer_orders
    inner join pizza_names using (pizza_id)
    inner join runner_orders using (order_id)
    where cancellation is null
    order by order_id
),

t2 as 
(
select sum(case when pizza_id = 1 then 12 else 10 end) as pizza_revenue,
       sum(topping_count) as topping_revenue
from t1
)
select concat('$', topping_revenue + pizza_revenue) as total_revenue
from t2;
`````

3.  **The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner. How would you design an additional table for this new dataset? Generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.**

````sql
CREATE TABLE runner_rating (order_id INTEGER, 
							rating INTEGER, 
							review TEXT)
-- rating point 1-5
-- Order 6 and 9 were cancelled
INSERT INTO runner_rating
VALUES ('1', '1'),
       ('2', '1'),
       ('3', '4'),
       ('4', '1'),
       ('5', '2'),
       ('7', '5'),
       ('8', '2'),
       ('10', '5')

select * from runner_rating
`````

4.  **Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?**
    - `customer_id`
    - `order_id`
    - `runner_id`
    - `rating`
    - `order_time`
    - `pickup_time`
    - `Time between order and pickup`
    - `Delivery duration`
    - `Average speed`
    - `Total number of pizzas`

````sql
select
		co.customer_id,
		co.order_id,
		ro.order_id,
		rr.rating,
		co.order_time,
		ro.pickup_time,
	    EXTRACT(minute FROM AGE(ro.pickup_time::timestamp, co.order_time::timestamp))::numeric AS delivery_duration,
		ro.duration,
		round(ro.distance::numeric*60/ro.duration::numeric,2) as avg_speed,
		count(co.order_id) as order_count
from customer_orders as co
left join pizza_names as pn
ON pn.pizza_id= co.pizza_id
left join runner_orders as ro
ON ro.order_id = co.order_id
left join runner_rating as rr
ON rr.order_id = ro.order_id
where ro.cancellation is null
group by 1,2,3,4,5,6,7,8,9
order by customer_id
`````

5.  **If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometer traveled - how much money does Pizza Runner have left over after these deliveries?**

````sql
with table1 as 
(
select  sum(case 
		when pizza_id = 1 then 12 else 10 end) as total_cost,
		round(sum(distance::numeric)*0.30,2) as sum_distance
from customer_orders as co
left join runner_orders as ro
ON ro.order_id = co.order_id
where cancellation is null
)
select total_cost-sum_distance as runner_orders_cost
from table1 
`````

## E. Bonus Questions

1.  **If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an `INSERT` statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu.**
````
DROP TABLE IF EXISTS temp_pizza_names;
CREATE TEMP TABLE temp_pizza_names AS (
  SELECT *
	FROM
		pizza_runner.pizza_names
);

INSERT INTO temp_pizza_names
VALUES
(3, 'Supreme');


DROP TABLE IF EXISTS temp_pizza_recipes;
CREATE TABLE temp_pizza_recipes AS (
  SELECT *
	FROM
		pizza_runner.pizza_recipes
);

INSERT INTO temp_pizza_recipes
VALUES
(3, '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');

SELECT
  t1.pizza_id,
  t1.pizza_name,
  t2.toppings
FROM 
  temp_pizza_names AS t1
JOIN
  temp_pizza_recipes AS t2
ON
  t1.pizza_id = t2.pizza_id;
  ````
