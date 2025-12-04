/*
 The AppStore database consists of a single table - apps, which contains information about the different available apps.
 */

-- 1. Write a query to display the app_id, app_name, category and reviews for apps with more reviews than app_id 64

select app_id,app_name,category,reviews
from apps where reviews > (select reviews from apps where app_id=64)  ;

-- 2. Write a query to display the app_name, category, size_in_mb, and rating, for apps in the same category as Redhold (app_name)
select app_name,category,size_in_mb,rating 
from apps where category < (select category from apps where app_name ='Redhold')  ;

-- 3. Write a query to display the app_name, category, app_version, and last_updated, for apps which were last_updated before app_id 29

select app_name,category,app_version,last_updated 
from apps where last_updated < (select last_updated from apps where app_id =29)  ;

-- 4. Write a query to display the app_name, category, app_version, and rating, for apps with rating higher than the average

select app_name,category,app_version,rating 
from apps where rating  > (select avg(rating) from apps )  ;

-- 5. Write a query to display the categories having apps in the same size_in_mb as apps in the education category

/* 6. Minimum and Maximum Ratings

a. What is the min rating of apps in the Education category ? (subqueries are not needed to answer this one)

b. What is the max rating of apps in the Education category ? (subqueries are not needed to answer this one)

c. Write a query to display the app_name and rating for apps with rating in the range of Education min and max values
*/

-- 7. Write a query to display the app_id, app_name, rating and reviews for app with rating higher than app_id 131 and (number of) reviews higher than app_id 28