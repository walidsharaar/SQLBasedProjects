---- Business Expansion(Solution_1)
```

SELECT 
     contact.user_account_id,
     user_account.first_name,
     user_account.last_name,
     contact.customer_id,
     customer.customer_name,
     count(*) as numbers
FROM
     contact as contact
JOIN 
     user_account as user_account
ON 
     contact.user_account_id = user_account.id
JOIN 
     customer as customer
ON 
     contact.customer_id = customer.id

WHERE (contact.user_account_id, contact.customer_id) IN (
    SELECT user_account_id, customer_id FROM contact GROUP BY user_account_id, customer_id HAVING count(*) > 1
)
GROUP BY 
    contact.user_account_id ,contact.customer_id, user_account.first_name, user_account.last_name, customer.customer_name;
```
---- Business Expansion(Solution_2)
```
SELECT 
      contact.user_account_id,
      user_account.first_name,
      user_account.last_name,
      contact.customer_id,
      customer.customer_name,
      SUM(CASE WHEN contact.user_account_id IS NOT NULL THEN 1 ELSE 0 END) AS numers
FROM
      contact as contact
JOIN
      user_account as user_account
ON
      contact.user_account_id = user_account.id
JOIN
      customer as customer
ON
      contact.customer_id = customer.id
WHERE (contact.user_account_id, contact.customer_id) IN (
    SELECT user_account_id, customer_id FROM contact GROUP BY user_account_id, customer_id HAVING count(*) > 1
)
GROUP BY
      contact.user_account_id ,contact.customer_id, user_account.first_name, user_account.last_name, customer.customer_name;
```

---- Business Expansion(Solution_3)
```
SELECT 
    ua.id,
    ua.first_name,
    ua.last_name,
    cu.id AS customer_id,
    cu.customer_name,
    COUNT(cu.id) AS customer_count
FROM 
    customer as cu
JOIN 
    contact as c ON cu.id = c.customer_id
JOIN 
    user_account as ua ON c.user_account_id = ua.id
GROUP BY 
    ua.id,
    ua.first_name,
    ua.last_name,
    cu.id,
    cu.customer_name
HAVING 
    COUNT(cu.id) > 1;
```
---- Products Sales Per City(Solution_1)
```
SELECT invoice.city_name,
product.product_name,
invoice_item.line_total_price
FROM invoice_item as invoice_item
JOIN product as product
ON invoice_item.product_id = product.id
JOIN (
    SELECT invoice.id,
    customer.city_name
    FROM invoice as invoice
    JOIN (
    SELECT customer.id,city.city_name
        FROM customer as customer
        LEFT JOIN city as city
        ON customer.city_id = city.id
    )as customer
    ON invoice.customer_id = customer.id
) as invoice
ON invoice_item.invoice_id = invoice.id
ORDER BY invoice_item.line_total_price DESC;

```
---- Products Sales Per City(Solution_2)
```
SELECT 
    CI.city_name, 
    PR.product_name, 
    ROUND(SUM(INV_I.line_total_price), 2) AS tot
FROM 
    city as CI, 
    customer as CU, 
    invoice as INV, 
    invoice_item as INV_I, 
    product as PR 
WHERE 
    CI.id = CU.city_id
    AND CU.id = INV.customer_id 
    AND INV.id = INV_I.invoice_id 
    AND INV_I.product_id = PR.id 
GROUP BY 
    CI.city_name, 
    PR.product_name 
ORDER BY 
    tot DESC, 
    CI.city_name, 
    PR.product_name ;
```

---- Products Without Sales(solution_1)


SELECT 
     product.sku, product.product_name
FROM 
     product
WHERE
     product.id NOT IN (SELECT product_id FROM invoice_item);



----- Products Without Sales(solution_2)
```
SELECT 
     product.sku, product.product_name
FROM 
     product
WHERE 
     product.id NOT IN (SELECT product_id FROM invoice_item)
GROUP BY
      1,2
ORDER BY
      product.sku ASC;
```

----- customer Spending
```
SELECT
     c.customer_name, ROUND(SUM(i.total_price), 6)
FROM 
     customer c
INNER JOIN
     invoice i ON c.id=i.customer_id
GROUP BY
     c.customer_name
HAVING 
     SUM(i.total_price)<0.25*(SELECT AVG(total_price) FROM invoice)
ORDER BY
      ROUND(SUM(i.total_price), 6) DESC;
```

----- invoice Spending

```
SELECT 
      cu.customer_name, AVG(i.total_price)
FROM 
      customer cu
JOIN 
      invoice i ON cu.id = i.customer_id 
GROUP BY 
      cu.customer_name
HAVING 
      AVG(i.total_price) <= (SELECT AVG(total_price) FROM invoice) / 4
ORDER BY 
      AVG(i.total_price) DESC;
```
---- invoies per country(solution_1)

```
SELECT 
    co.country_name,
    COUNT(*) AS total_customers,
    ROUND(AVG(i.total_price), 6) AS avg_total_price
FROM 
    country AS co
    INNER JOIN city AS ci ON co.id = ci.country_id
    INNER JOIN customer AS cu ON ci.id = cu.city_id
    INNER JOIN invoice AS i ON cu.id = i.customer_id
GROUP BY 
    co.country_name
HAVING 
    AVG(i.total_price) > (SELECT AVG(total_price) FROM invoice);
```

----- invoies per country(solution_1)

```
SELECT
       co.country_name, count(*), AVG(i.total_price)
FROM 
       country co, city ci, customer cu, invoice i
WHERE 
       co.id = ci.country_id AND ci.id = cu.city_id AND cu.id = i.customer_id
GROUP BY 
        co.country name
HAVING 
        AVG(i.total_price) > (SELECT AVG(total price));
```
