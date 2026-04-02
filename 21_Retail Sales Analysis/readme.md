# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  

An introductory data analysis project focused on mastering SQL through retail sales exploration. Key features include database configuration, rigorous data cleaning, and Exploratory Data Analysis (EDA). By solving real-world business challenges with complex queries, this project serves as a comprehensive guide for those building a technical foundation in data analytics.

## Objectives

- Data Architecture: Built a robust retail database from raw CSV/SQL datasets.
- Quality Assurance: Cleaned and validated data by removing inconsistencies and missing records.
- Trend Discovery: Performed EDA to define the scope and characteristics of the sales environment.
- Insight Extraction: Developed SQL solutions for complex business scenarios to drive data-informed decision-making.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

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
