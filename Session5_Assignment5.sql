USE StoreDB;
GO

SELECT product_name, list_price,
       CASE
           WHEN list_price < 300 THEN 'Economy'
           WHEN list_price BETWEEN 300 AND 999 THEN 'Standard'
           WHEN list_price BETWEEN 1000 AND 2499 THEN 'Premium'
           ELSE 'Luxury'
       END AS price_category
FROM production.products;

SELECT order_id, order_date,
       CASE order_status
           WHEN 1 THEN 'Order Received'
           WHEN 2 THEN 'In Preparation'
           WHEN 3 THEN 'Order Cancelled'
           WHEN 4 THEN 'Order Delivered'
       END AS status_description,
       CASE
           WHEN order_status = 1 AND DATEDIFF(DAY, order_date, GETDATE()) > 5 THEN 'URGENT'
           WHEN order_status = 2 AND DATEDIFF(DAY, order_date, GETDATE()) > 3 THEN 'HIGH'
           ELSE 'NORMAL'
       END AS priority
FROM sales.orders;

SELECT s.staff_id, s.first_name, COUNT(o.order_id) AS total_orders,
       CASE
           WHEN COUNT(o.order_id) = 0 THEN 'New Staff'
           WHEN COUNT(o.order_id) BETWEEN 1 AND 10 THEN 'Junior Staff'
           WHEN COUNT(o.order_id) BETWEEN 11 AND 25 THEN 'Senior Staff'
           ELSE 'Expert Staff'
       END AS staff_level
FROM sales.staffs s
LEFT JOIN sales.orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.first_name;

SELECT customer_id, first_name, last_name,
       ISNULL(phone, 'Phone Not Available') AS phone,
       COALESCE(phone, email, 'No Contact Method') AS preferred_contact
FROM sales.customers;

SELECT p.product_id, p.product_name, s.quantity,
       ISNULL(NULLIF(p.list_price / NULLIF(s.quantity, 0), NULL), 0) AS price_per_unit,
       CASE
           WHEN s.quantity = 0 OR s.quantity IS NULL THEN 'Out of Stock'
           ELSE 'In Stock'
       END AS stock_status
FROM production.products p
LEFT JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.store_id = 1;

SELECT customer_id,
       COALESCE(street, '') + ', ' +
       COALESCE(city, '') + ', ' +
       COALESCE(state, '') + ', ' +
       COALESCE(zip_code, 'No ZIP') AS formatted_address
FROM sales.customers;

WITH customer_spending AS (
    SELECT o.customer_id, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT c.customer_id, c.first_name + ' ' + c.last_name AS customer_name, cs.total_spent
FROM customer_spending cs
JOIN sales.customers c ON c.customer_id = cs.customer_id
WHERE cs.total_spent > 1500
ORDER BY cs.total_spent DESC;

WITH category_revenue AS (
    SELECT p.category_id, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM production.products p
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category_id
), category_avg_order AS (
    SELECT p.category_id, AVG(oi.quantity * oi.list_price * (1 - oi.discount)) AS avg_order_value
    FROM production.products p
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category_id
)
SELECT c.category_id, cr.total_revenue, cao.avg_order_value,
       CASE
           WHEN cr.total_revenue > 50000 THEN 'Excellent'
           WHEN cr.total_revenue > 20000 THEN 'Good'
           ELSE 'Needs Improvement'
       END AS performance
FROM category_revenue cr
JOIN category_avg_order cao ON cr.category_id = cao.category_id
JOIN production.categories c ON c.category_id = cr.category_id;

WITH monthly_sales AS (
    SELECT MONTH(order_date) AS month, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY MONTH(order_date)
), previous_month AS (
    SELECT month, LAG(revenue) OVER (ORDER BY month) AS prev_revenue, revenue
    FROM monthly_sales
)
SELECT month, revenue, prev_revenue,
       ROUND((revenue - prev_revenue) * 100.0 / NULLIF(prev_revenue, 0), 2) AS growth_percentage
FROM previous_month;

SELECT category_id, product_name, list_price,
       ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS row_num,
       RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS rank,
       DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS dense_rank
FROM production.products;

WITH customer_spending AS (
    SELECT o.customer_id, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT c.customer_id, c.first_name + ' ' + c.last_name AS customer_name, cs.total_spent,
       RANK() OVER (ORDER BY cs.total_spent DESC) AS rank,
       NTILE(5) OVER (ORDER BY cs.total_spent DESC) AS spending_group,
       CASE NTILE(5) OVER (ORDER BY cs.total_spent DESC)
           WHEN 1 THEN 'VIP'
           WHEN 2 THEN 'Gold'
           WHEN 3 THEN 'Silver'
           WHEN 4 THEN 'Bronze'
           ELSE 'Standard'
       END AS tier
FROM customer_spending cs
JOIN sales.customers c ON cs.customer_id = c.customer_id;

WITH store_revenue AS (
    SELECT o.store_id, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.store_id
), store_orders AS (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT s.store_id, s.store_name, sr.revenue, so.order_count,
       PERCENT_RANK() OVER (ORDER BY sr.revenue) AS revenue_percentile
FROM sales.stores s
JOIN store_revenue sr ON s.store_id = sr.store_id
JOIN store_orders so ON s.store_id = so.store_id;

SELECT category_name,
       COUNT(CASE WHEN brand_name = 'Electra' THEN 1 END) AS Electra,
       COUNT(CASE WHEN brand_name = 'Haro' THEN 1 END) AS Haro,
       COUNT(CASE WHEN brand_name = 'Trek' THEN 1 END) AS Trek,
       COUNT(CASE WHEN brand_name = 'Surly' THEN 1 END) AS Surly
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
JOIN production.brands b ON p.brand_id = b.brand_id
GROUP BY category_name;

SELECT s.store_name,
       SUM(CASE WHEN MONTH(o.order_date) = 1 THEN oi.quantity * oi.list_price * (1 - oi.discount) ELSE 0 END) AS Jan,
       SUM(CASE WHEN MONTH(o.order_date) = 2 THEN oi.quantity * oi.list_price * (1 - oi.discount) ELSE 0 END) AS Feb,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS Total
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.stores s ON o.store_id = s.store_id
GROUP BY s.store_name;

SELECT s.store_name,
       COUNT(CASE WHEN o.order_status = 1 THEN 1 END) AS Pending,
       COUNT(CASE WHEN o.order_status = 2 THEN 1 END) AS Processing,
       COUNT(CASE WHEN o.order_status = 3 THEN 1 END) AS Cancelled,
       COUNT(CASE WHEN o.order_status = 4 THEN 1 END) AS Delivered
FROM sales.orders o
JOIN sales.stores s ON o.store_id = s.store_id
GROUP BY s.store_name;

SELECT b.brand_name,
       SUM(CASE WHEN YEAR(o.order_date) = 2016 THEN oi.quantity * oi.list_price * (1 - oi.discount) ELSE 0 END) AS Revenue_2016,
       SUM(CASE WHEN YEAR(o.order_date) = 2017 THEN oi.quantity * oi.list_price * (1 - oi.discount) ELSE 0 END) AS Revenue_2017,
       SUM(CASE WHEN YEAR(o.order_date) = 2018 THEN oi.quantity * oi.list_price * (1 - oi.discount) ELSE 0 END) AS Revenue_2018
FROM production.products p
JOIN production.brands b ON p.brand_id = b.brand_id
JOIN sales.order_items oi ON p.product_id = oi.product_id
JOIN sales.orders o ON oi.order_id = o.order_id
GROUP BY b.brand_name;

SELECT p.product_id, p.product_name, 'In Stock' AS status
FROM production.products p
JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.quantity > 0
UNION
SELECT p.product_id, p.product_name, 'Out of Stock'
FROM production.products p
JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.quantity = 0 OR s.quantity IS NULL
UNION
SELECT p.product_id, p.product_name, 'Discontinued'
FROM production.products p
WHERE p.product_id NOT IN (SELECT product_id FROM production.stocks);

SELECT customer_id, first_name, last_name
FROM sales.customers
WHERE customer_id IN (
    SELECT o.customer_id
    FROM sales.orders o
    WHERE YEAR(o.order_date) = 2017
)
INTERSECT
SELECT customer_id, first_name, last_name
FROM sales.customers
WHERE customer_id IN (
    SELECT o.customer_id
    FROM sales.orders o
    WHERE YEAR(o.order_date) = 2018
);

SELECT product_id FROM production.stocks WHERE store_id = 1
INTERSECT
SELECT product_id FROM production.stocks WHERE store_id = 2
INTERSECT
SELECT product_id FROM production.stocks WHERE store_id = 3
UNION
SELECT product_id FROM production.stocks WHERE store_id = 1
EXCEPT
SELECT product_id FROM production.stocks WHERE store_id = 2;

SELECT customer_id, 'Lost' AS status
FROM sales.orders
WHERE YEAR(order_date) = 2016
EXCEPT
SELECT customer_id, 'Lost'
FROM sales.orders
WHERE YEAR(order_date) = 2017
UNION ALL
SELECT customer_id, 'New'
FROM sales.orders
WHERE YEAR(order_date) = 2017
EXCEPT
SELECT customer_id, 'New'
FROM sales.orders
WHERE YEAR(order_date) = 2016
UNION ALL
SELECT customer_id, 'Retained'
FROM sales.orders
WHERE YEAR(order_date) = 2016
INTERSECT
SELECT customer_id, 'Retained'
FROM sales.orders
WHERE YEAR(order_date) = 2017;
