## Insights for Decision-Making:
  - Access to comprehensive company data for informed decisions
  - Collaboration with all departments: sales, marketing, finance, operations, supply chain
- Interaction with Teams:
    - Marketing Manager's Email:
        - Targeting marketing channels based on customer demographics
        - Request for customer age categories in different regions
    - Supply Chain Manager's Email:
        - Warehouse optimization issue between South and East regions
        - Need for top selling and non-selling products in respective regions
    - Finance Manager's Email:
        - Revenue maintenance and expenditure containment concern
        - Identification of revenue loss due to discount coupons
        - Evaluation of products with high discount-to-revenue ratio

- Interdisciplinary Collaboration:
    - Skill acquisition to address diverse team queries
    - Future ability to independently craft SQL queries for data solutions
    - Anticipation of solutions for various team problems in upcoming video

## Database Overview
  - Three primary tables: customers, products, transactions.
- Customers Table: 
  - Unique customer ID assigned to each registering customer.
  - Stores customer details like name, age, city, state.
- Products Table: 
  - Contains product list with unique Product IDs.
  - Includes product name, subcategory, and category.
- Transaction Table: 
  - Stores sales-related data.
  - Includes product and customer IDs, order and ship dates, selling price, discount, etc.


```
-- first let's check tables' data
select * from customers;
select * from product;
select * from sales;

/* for marketing campaign, team want to have # of customer who belong to the below three categories in all regions:
1. less than 36 years old
2. Between 36 to 54 years
3. Above 54 years old */

select region, case when age > 54 then 'category 3'
                    when age < 36 then 'category 1'
                    else 'Category 2' end as ageGroup,
                    count(*)
from customer group by region, ageGroup
order by region, count desc;

```
