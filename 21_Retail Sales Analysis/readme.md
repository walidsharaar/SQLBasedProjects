# Retail Sales Analysis SQL Project

## Project Overview

Project Title: Retail Sales Analysis  

An introductory data analysis project focused on mastering SQL through retail sales exploration. Key features include database configuration, rigorous data cleaning, and Exploratory Data Analysis (EDA). By solving real-world business challenges with complex queries, this project serves as a comprehensive guide for those building a technical foundation in data analytics.

## Objectives

- Data Architecture: Built a robust retail database from raw CSV/SQL datasets.
- Quality Assurance: Cleaned and validated data by removing inconsistencies and missing records.
- Trend Discovery: Performed EDA to define the scope and characteristics of the sales environment.
- Insight Extraction: Developed SQL solutions for complex business scenarios to drive data-informed decision-making.

## Project Structure

### 1. Database Setup

- Database Creation: The project starts by creating a database named `p1_retail_db`.
- Table Creation: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.



```sql
CREATE DATABASE RetailDB;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```
### 2. Data Exploration & Cleaning


```

-- Record Count: Determine the total number of records in the dataset.
-- Customer Count: Find out how many unique customers are in the dataset.
-- Category Count: Identify all unique product categories in the dataset.
-- Null Value Check: Check for any null values in the dataset and delete records with missing data.

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;


SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

```
### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

```
select * from retail_sales


-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date='2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT  
DATETRUNC(MONTH, sale_date) AS sale_month,
*
FROM retail_sales
WHERE category='clothing' AND quantity >= 4 AND DATETRUNC(MONTH, sale_date) = '2022-11-01';

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT 
category,
SUM(total_sale) AS total_sales,
COUNT(1) AS total_orders
FROM retail_sales
GROUP BY category;
-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
AVG(age) AS average_age
FROM retail_sales
WHERE category='Beauty'

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT *
FROM retail_sales
WHERE total_sale > 1000

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT
gender,
category,
COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender, category

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

WITH monthly_avgs AS (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
),
ranked AS (
    SELECT 
        year,
        month,
        avg_sale,
        RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rank
    FROM monthly_avgs
)
SELECT 
    year,
    month,
    avg_sale
FROM ranked
WHERE rank = 1;


-- 8. Write a SQL query to find the top 5 customers based on the highest total sales :
SELECT
TOP 5
SUM(total_sale) AS total_sales,
customer_id
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT 
category,
COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category


-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH shift_classification AS (
    SELECT 
        transaction_id,
        CASE 
            WHEN sale_time < '12:00' THEN 'Morning'
            WHEN sale_time > '17:00' THEN 'Evening'
            ELSE 'Afternoon'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(DISTINCT transaction_id) AS total_orders
FROM shift_classification
GROUP BY shift
ORDER BY total_orders DESC;

```