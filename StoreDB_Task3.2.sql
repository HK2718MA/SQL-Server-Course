
USE StoreDB;
GO

SELECT * FROM production.products
WHERE list_price > 1000;

SELECT * FROM sales.customers
WHERE state IN ('CA', 'NY');

SELECT * FROM sales.orders
WHERE YEAR(order_date) = 2023;

SELECT * FROM sales.customers
WHERE email LIKE '%@gmail.com';

SELECT * FROM sales.staffs
WHERE active = 0;

SELECT TOP 5 product_name, list_price
FROM production.products
ORDER BY list_price DESC;

SELECT TOP 10 *
FROM sales.orders
ORDER BY order_date DESC;

SELECT TOP 3 *
FROM sales.customers
ORDER BY last_name ASC;

SELECT * FROM sales.customers
WHERE phone IS NULL;

SELECT * FROM sales.staffs
WHERE manager_id IS NOT NULL;

SELECT category_id, COUNT(*) AS product_count
FROM production.products
GROUP BY category_id;

SELECT state, COUNT(*) AS customer_count
FROM sales.customers
GROUP BY state;

SELECT brand_id, AVG(list_price) AS avg_price
FROM production.products
GROUP BY brand_id;

SELECT staff_id, COUNT(*) AS order_count
FROM sales.orders
GROUP BY staff_id;

SELECT customer_id, COUNT(*) AS order_count
FROM sales.orders
GROUP BY customer_id
HAVING COUNT(*) > 2;

SELECT * FROM production.products
WHERE list_price BETWEEN 500 AND 1500;

SELECT * FROM sales.customers
WHERE city LIKE 'S%';

SELECT * FROM sales.orders
WHERE order_status IN (2, 4);

SELECT * FROM production.products
WHERE category_id IN (1, 2, 3);

SELECT * FROM sales.staffs
WHERE store_id = 1 OR phone IS NULL;
