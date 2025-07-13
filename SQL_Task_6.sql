USE StoreDB 
Go  

DECLARE @customer_id INT = 1;
DECLARE @total_spent DECIMAL(10,2);

SELECT @total_spent = SUM(oi.quantity * oi.list_price * (1 - oi.discount))
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.customer_id = @customer_id;

IF @total_spent > 5000
    PRINT 'Customer is VIP - Total Spent: ' + CAST(@total_spent AS VARCHAR);
ELSE
    PRINT 'Customer is Regular - Total Spent: ' + CAST(@total_spent AS VARCHAR);




DECLARE @threshold DECIMAL(10,2) = 1500;
DECLARE @count INT;

SELECT @count = COUNT(*) 
FROM production.products 
WHERE list_price > @threshold;

PRINT 'Number of products over $' + CAST(@threshold AS VARCHAR) + ' is: ' + CAST(@count AS VARCHAR);




DECLARE @staff_id INT = 2;
DECLARE @year INT = 2017;
DECLARE @total_sales DECIMAL(10,2);

SELECT @total_sales = SUM(oi.quantity * oi.list_price * (1 - oi.discount))
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.staff_id = @staff_id AND YEAR(o.order_date) = @year;

PRINT 'Total sales for staff ' + CAST(@staff_id AS VARCHAR) + ' in ' + CAST(@year AS VARCHAR) + ' is: ' + CAST(@total_sales AS VARCHAR);


SELECT
    @@SERVERNAME AS server_name,
    @@VERSION AS sql_version,
    @@ROWCOUNT AS last_rowcount;



DECLARE @quantity INT;

SELECT @quantity = quantity
FROM production.stocks
WHERE product_id = 1 AND store_id = 1;

IF @quantity > 20
    PRINT 'Well stocked';
ELSE IF @quantity BETWEEN 10 AND 20
    PRINT 'Moderate stock';
ELSE IF @quantity < 10
    PRINT 'Low stock - reorder needed';


DECLARE @rows_updated INT = 1;

WHILE @rows_updated > 0
BEGIN
    UPDATE TOP (3) production.stocks
    SET quantity = quantity + 10
    WHERE quantity < 5;

    SET @rows_updated = @@ROWCOUNT;

    PRINT 'Updated ' + CAST(@rows_updated AS VARCHAR) + ' records';
END


SELECT product_id, product_name, list_price,
    CASE 
        WHEN list_price < 300 THEN 'Budget'
        WHEN list_price BETWEEN 300 AND 800 THEN 'Mid-Range'
        WHEN list_price BETWEEN 801 AND 2000 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_category
FROM production.products;



DECLARE @customer_id INT = 5;

IF EXISTS (SELECT 1 FROM sales.customers WHERE customer_id = @customer_id)
BEGIN
    SELECT COUNT(*) AS order_count
    FROM sales.orders
    WHERE customer_id = @customer_id;
END
ELSE
BEGIN
    PRINT 'Customer does not exist';
END



CREATE FUNCTION dbo.CalculateShipping(@order_total DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN
        CASE 
            WHEN @order_total > 100 THEN 0
            WHEN @order_total BETWEEN 50 AND 99.99 THEN 5.99
            ELSE 12.99
        END
END;



CREATE FUNCTION dbo.GetProductsByPriceRange(@min_price DECIMAL(10,2), @max_price DECIMAL(10,2))
RETURNS TABLE
AS
RETURN
(
    SELECT p.product_id, p.product_name, p.list_price,
           b.brand_name, c.category_name
    FROM production.products p
    JOIN production.brands b ON p.brand_id = b.brand_id
    JOIN production.categories c ON p.category_id = c.category_id
    WHERE p.list_price BETWEEN @min_price AND @max_price
);



CREATE FUNCTION dbo.GetCustomerYearlySummary(@customer_id INT)
RETURNS @summary TABLE (
    OrderYear INT,
    TotalOrders INT,
    TotalSpent DECIMAL(10,2),
    AvgOrderValue DECIMAL(10,2)
)
AS
BEGIN
    INSERT INTO @summary
    SELECT 
        YEAR(o.order_date),
        COUNT(DISTINCT o.order_id),
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)),
        AVG(oi.quantity * oi.list_price * (1 - oi.discount))
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @customer_id
    GROUP BY YEAR(o.order_date);

    RETURN;
END;



CREATE FUNCTION dbo.CalculateBulkDiscount(@quantity INT)
RETURNS INT
AS
BEGIN
    RETURN
        CASE 
            WHEN @quantity BETWEEN 1 AND 2 THEN 0
            WHEN @quantity BETWEEN 3 AND 5 THEN 5
            WHEN @quantity BETWEEN 6 AND 9 THEN 10
            ELSE 15
        END
END;



CREATE PROCEDURE sp_GetCustomerOrderHistory
    @customer_id INT,
    @start_date DATE = NULL,
    @end_date DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT o.order_id, o.order_date, o.order_status,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_total
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @customer_id
      AND (@start_date IS NULL OR o.order_date >= @start_date)
      AND (@end_date IS NULL OR o.order_date <= @end_date)
    GROUP BY o.order_id, o.order_date, o.order_status
    ORDER BY o.order_date DESC;
END;



CREATE PROCEDURE sp_RestockProduct
    @store_id INT,
    @product_id INT,
    @restock_quantity INT,
    @old_quantity INT OUTPUT,
    @new_quantity INT OUTPUT,
    @success BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @old_quantity = quantity
    FROM production.stocks
    WHERE store_id = @store_id AND product_id = @product_id;

    IF @old_quantity IS NOT NULL
    BEGIN
        UPDATE production.stocks
        SET quantity = quantity + @restock_quantity
        WHERE store_id = @store_id AND product_id = @product_id;

        SELECT @new_quantity = quantity
        FROM production.stocks
        WHERE store_id = @store_id AND product_id = @product_id;

        SET @success = 1;
    END
    ELSE
    BEGIN
        SET @old_quantity = 0;
        SET @new_quantity = 0;
        SET @success = 0;
    END
END;


CREATE PROCEDURE sp_ProcessNewOrder
    @customer_id INT,
    @product_id INT,
    @quantity INT,
    @store_id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @order_id INT;

        INSERT INTO sales.orders (customer_id, order_status, order_date, store_id)
        VALUES (@customer_id, 1, GETDATE(), @store_id);

        SET @order_id = SCOPE_IDENTITY();

        INSERT INTO sales.order_items (order_id, item_id, product_id, quantity, list_price, discount)
        VALUES (@order_id, 1, @product_id, @quantity, 
               (SELECT list_price FROM production.products WHERE product_id = @product_id), 0);

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT ERROR_MESSAGE();
    END CATCH
END;



CREATE PROCEDURE sp_SearchProducts
    @search_term NVARCHAR(100) = NULL,
    @category_id INT = NULL,
    @min_price DECIMAL(10,2) = NULL,
    @max_price DECIMAL(10,2) = NULL,
    @sort_column NVARCHAR(50) = 'list_price'
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX) = '
        SELECT product_id, product_name, list_price
        FROM production.products
        WHERE 1=1';

    IF @search_term IS NOT NULL
        SET @sql += ' AND product_name LIKE ''%' + @search_term + '%''';

    IF @category_id IS NOT NULL
        SET @sql += ' AND category_id = ' + CAST(@category_id AS NVARCHAR);

    IF @min_price IS NOT NULL
        SET @sql += ' AND list_price >= ' + CAST(@min_price AS NVARCHAR);

    IF @max_price IS NOT NULL
        SET @sql += ' AND list_price <= ' + CAST(@max_price AS NVARCHAR);

    SET @sql += ' ORDER BY ' + QUOTENAME(@sort_column);

    EXEC sp_executesql @sql;
END;


DECLARE @start_date DATE = '2017-01-01';
DECLARE @end_date DATE = '2017-12-31';

SELECT s.staff_id, s.first_name, s.last_name,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales,
       CASE 
           WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 50000 THEN '20% Bonus'
           WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 30000 THEN '10% Bonus'
           WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 10000 THEN '5% Bonus'
           ELSE 'No Bonus'
       END AS bonus_tier
FROM sales.staffs s
JOIN sales.orders o ON s.staff_id = o.staff_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.order_date BETWEEN @start_date AND @end_date
GROUP BY s.staff_id, s.first_name, s.last_name;


DECLARE @product_id INT = 1;
DECLARE @category_id INT;
DECLARE @quantity INT;

SELECT @category_id = p.category_id, @quantity = s.quantity
FROM production.products p
JOIN production.stocks s ON p.product_id = s.product_id
WHERE p.product_id = @product_id AND s.store_id = 1;

IF @quantity < 10
BEGIN
    IF @category_id = 1
        UPDATE production.stocks SET quantity += 30 WHERE product_id = @product_id AND store_id = 1;
    ELSE IF @category_id = 2
        UPDATE production.stocks SET quantity += 20 WHERE product_id = @product_id AND store_id = 1;
    ELSE
        UPDATE production.stocks SET quantity += 10 WHERE product_id = @product_id AND store_id = 1;
END;

SELECT c.customer_id, c.first_name, c.last_name,
       ISNULL(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS total_spent,
       CASE 
           WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 10000 THEN 'Platinum'
           WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 5000 THEN 'Gold'
           WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 1000 THEN 'Silver'
           ELSE 'Bronze'
       END AS loyalty_tier
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
LEFT JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name;



CREATE PROCEDURE sp_DiscontinueProduct
    @product_id INT,
    @replacement_product_id INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM sales.order_items oi
        JOIN sales.orders o ON oi.order_id = o.order_id
        WHERE oi.product_id = @product_id AND o.order_status IN (1, 2)
    )
    BEGIN
        IF @replacement_product_id IS NOT NULL
        BEGIN
            UPDATE sales.order_items
            SET product_id = @replacement_product_id
            WHERE product_id = @product_id AND order_id IN (
                SELECT order_id FROM sales.orders WHERE order_status IN (1, 2)
            );
        END
    END

    DELETE FROM production.stocks WHERE product_id = @product_id;
    UPDATE production.products SET model_year = NULL, list_price = 0 WHERE product_id = @product_id;

    PRINT 'Product discontinued successfully.';
END;


WITH MonthlyTrends AS (
    SELECT MONTH(order_date) AS order_month,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY MONTH(order_date)
)
SELECT * FROM MonthlyTrends;

WITH StaffPerformance AS (
    SELECT s.staff_id, s.first_name + ' ' + s.last_name AS staff_name,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
    FROM sales.staffs s
    JOIN sales.orders o ON s.staff_id = o.staff_id
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY s.staff_id, s.first_name, s.last_name
)
SELECT * FROM StaffPerformance ORDER BY total_sales DESC;

WITH CategoryAnalysis AS (
    SELECT c.category_name,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS category_sales
    FROM production.categories c
    JOIN production.products p ON c.category_id = p.category_id
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY c.category_name
)
SELECT * FROM CategoryAnalysis ORDER BY category_sales DESC;


CREATE PROCEDURE sp_ValidateAndInsertOrder
    @customer_id INT,
    @product_id INT,
    @quantity INT,
    @store_id INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM sales.customers WHERE customer_id = @customer_id)
    BEGIN
        PRINT ' Customer does not exist';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM production.products WHERE product_id = @product_id)
    BEGIN
        PRINT ' Product does not exist';
        RETURN;
    END

    DECLARE @available_quantity INT;

    SELECT @available_quantity = quantity
    FROM production.stocks
    WHERE store_id = @store_id AND product_id = @product_id;

    IF @available_quantity IS NULL OR @available_quantity < @quantity
    BEGIN
        PRINT ' Insufficient stock';
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @order_id INT;

        INSERT INTO sales.orders (customer_id, order_status, order_date, store_id)
        VALUES (@customer_id, 1, GETDATE(), @store_id);

        SET @order_id = SCOPE_IDENTITY();

        INSERT INTO sales.order_items (order_id, item_id, product_id, quantity, list_price, discount)
        VALUES (
            @order_id,
            1,
            @product_id,
            @quantity,
            (SELECT list_price FROM production.products WHERE product_id = @product_id),
            0
        );

        UPDATE production.stocks
        SET quantity -= @quantity
        WHERE store_id = @store_id AND product_id = @product_id;

        COMMIT;
        PRINT 'Order successfully inserted and validated.';
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;

