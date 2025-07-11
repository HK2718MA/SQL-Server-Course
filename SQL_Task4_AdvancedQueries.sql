USE StoreDB;
GO
SELECT COUNT(*) 
FROM production.products;

SELECT AVG(list_price), MIN(list_price), MAX(list_price) 
FROM production.products;

SELECT category_id, COUNT(*) 
FROM production.products 
GROUP BY category_id;

SELECT store_id, COUNT(*) 
FROM sales.orders 
GROUP BY store_id;

SELECT UPPER(first_name), LOWER(last_name) 
FROM sales.customers 
WHERE customer_id <= 10;

SELECT product_name, LEN(product_name) 
FROM production.products 
WHERE product_id <= 10;

SELECT customer_id, LEFT(phone, 3) AS area_code 
FROM sales.customers 
WHERE customer_id BETWEEN 1 AND 15;

SELECT GETDATE();
SELECT order_id, YEAR(order_date), MONTH(order_date) 
FROM sales.orders 
WHERE order_id <= 10;

SELECT p.product_name, c.category_name 
FROM production.products p 
JOIN production.categories c ON p.category_id = c.category_id 
WHERE p.product_id <= 10;

SELECT c.first_name + ' ' + c.last_name, o.order_date 
FROM sales.customers c 
JOIN sales.orders o ON c.customer_id = o.customer_id 
WHERE o.order_id <= 10;

SELECT p.product_name, COALESCE(b.brand_name, 'No Brand') 
FROM production.products p 
LEFT JOIN production.brands b ON p.brand_id = b.brand_id;

SELECT product_name, list_price 
FROM production.products 
WHERE list_price > (
    SELECT AVG(list_price) FROM production.products
);

SELECT customer_id, first_name + ' ' + last_name 
FROM sales.customers 
WHERE customer_id IN (
    SELECT customer_id FROM sales.orders
);

SELECT c.first_name + ' ' + c.last_name, 
       (SELECT COUNT(*) FROM sales.orders o WHERE o.customer_id = c.customer_id) 
FROM sales.customers c;

DROP VIEW IF EXISTS easy_product_list;
GO
CREATE VIEW easy_product_list AS 
SELECT p.product_name, c.category_name, p.list_price 
FROM production.products p 
JOIN production.categories c ON p.category_id = c.category_id;
GO

SELECT * 
FROM easy_product_list 
WHERE list_price > 100;

DROP VIEW IF EXISTS customer_info;
GO
CREATE VIEW customer_info AS 
SELECT customer_id, first_name + ' ' + last_name AS full_name, email, city + ', ' + state AS location 
FROM sales.customers;
GO

SELECT * 
FROM customer_info 
WHERE location LIKE '%, CA';

SELECT product_name, list_price 
FROM production.products 
WHERE list_price BETWEEN 50 AND 200 
ORDER BY list_price ASC;

SELECT state, COUNT(*) 
FROM sales.customers 
GROUP BY state 
ORDER BY COUNT(*) DESC;

SELECT c.category_name, p.product_name, p.list_price 
FROM production.products p 
JOIN production.categories c ON p.category_id = c.category_id 
WHERE p.list_price = (
    SELECT MAX(p2.list_price) 
    FROM production.products p2 
    WHERE p2.category_id = p.category_id
);

SELECT s.store_name, s.city, COUNT(o.order_id) 
FROM sales.stores s 
LEFT JOIN sales.orders o ON s.store_id = o.store_id 
GROUP BY s.store_name, s.city;
