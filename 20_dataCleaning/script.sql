


-- 1. Check all records
SELECT * FROM orders;

-- 2. Standardize order_status
SELECT DISTINCT
  order_status,
  CASE
    WHEN LOWER(order_status) LIKE '%pending%' THEN 'Pending'
    WHEN LOWER(order_status) LIKE '%processing%' THEN 'Processing'
    WHEN LOWER(order_status) LIKE '%shipped%' THEN 'Shipped'
    WHEN LOWER(order_status) LIKE '%delivered%' THEN 'Delivered'
    WHEN LOWER(order_status) LIKE '%refunded%' THEN 'Refunded'
    ELSE order_status
  END AS standardized_order_status
FROM orders;

-- 3. Standardize product_name
SELECT DISTINCT
  product_name,
  CASE
    WHEN LOWER(product_name) LIKE '%apple watch%' THEN 'Apple Watch'
    WHEN LOWER(product_name) LIKE '%google pixel%' THEN 'Google Pixel'
    WHEN LOWER(product_name) LIKE '%iphone 14%' THEN 'iPhone 14'
    WHEN LOWER(product_name) LIKE '%macbook pro%' THEN 'MacBook Pro'
    WHEN LOWER(product_name) LIKE '%samsung galaxy s22%' THEN 'Samsung Galaxy S22'
    ELSE product_name
  END AS standardized_product_name
FROM orders;

-- 4. Capitalize names
SELECT
  INITCAP(customer_name) AS customer_name,
  INITCAP(product_name)  AS product_name
FROM orders
WHERE customer_name IS NOT NULL AND product_name IS NOT NULL;

-- 5. Clean quantity (safe version)
SELECT DISTINCT
  quantity,
  CASE
    WHEN LOWER(quantity) LIKE '%two%' THEN 2
    ELSE SAFE_CAST(quantity AS INT64)
  END AS quantity_cleaned
FROM orders;

-- check duplicates based on email and product_name

SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY LOWER(email), LOWER(product_name)
            ORDER BY order_id
        ) AS rn
    FROM orders
) AS t            
WHERE rn > 1;


-- This SQL query performs data cleaning and deduplication on the 'orders' table.
WITH clean_data AS (
  SELECT
    order_id,
    INITCAP(customer_name) AS customer_name,
    LOWER(email) AS email,
    CASE
      WHEN LOWER(order_status) LIKE '%pending%' THEN 'Pending'
      WHEN LOWER(order_status) LIKE '%processing%' THEN 'Processing'
      WHEN LOWER(order_status) LIKE '%shipped%' THEN 'Shipped'
      WHEN LOWER(order_status) LIKE '%delivered%' THEN 'Delivered'
      WHEN LOWER(order_status) LIKE '%refunded%' THEN 'Refunded'
      ELSE order_status
    END AS standardized_order_status,
    CASE
      WHEN LOWER(product_name) LIKE '%apple watch%' THEN 'Apple Watch'
      WHEN LOWER(product_name) LIKE '%google pixel%' THEN 'Google Pixel'
      WHEN LOWER(product_name) LIKE '%iphone 14%' THEN 'iPhone 14'
      WHEN LOWER(product_name) LIKE '%macbook pro%' THEN 'MacBook Pro'
      WHEN LOWER(product_name) LIKE '%samsung galaxy s22%' THEN 'Samsung Galaxy S22'
      ELSE product_name
    END AS standardized_product_name,
    CASE
      WHEN LOWER(quantity) LIKE '%two%' THEN 2
      ELSE SAFE_CAST(quantity AS INT64)
    END AS quantity_cleaned
  FROM orders
),
deduped_data AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY LOWER(email), LOWER(standardized_product_name)   -- fixed column reference
      ORDER BY order_id
    ) AS rn
  FROM clean_data
)
SELECT * FROM deduped_data
WHERE rn = 1;
