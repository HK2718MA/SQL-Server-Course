SELECT 
    e.BusinessEntityID, p.FirstName,p.LastName, e.HireDate
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.HireDate > '2012-01-01'
ORDER BY e.HireDate DESC;


SELECT 
    ProductID, Name,ListPrice,ProductNumber
FROM Production.Product
WHERE ListPrice BETWEEN 100 AND 500
ORDER BY ListPrice ASC;




SELECT 
    c.CustomerID,p.FirstName, p.LastName, a.City
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.Address a ON c.TerritoryID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE a.City IN ('Seattle', 'Portland');



SELECT TOP 15
    p.Name, p.ListPrice,p.ProductNumber,pc.Name AS CategoryName
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
WHERE p.SellEndDate IS NULL
ORDER BY p.ListPrice DESC;



SELECT 
    ProductID,Name,Color,ListPrice
FROM Production.Product
WHERE Name LIKE '%Mountain%' AND Color = 'Black';



SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS FullName,
    e.BirthDate,
    DATEDIFF(YEAR, e.BirthDate, GETDATE()) AS Age
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.BirthDate BETWEEN '1970-01-01' AND '1985-12-31';



SELECT 
    SalesOrderID,OrderDate, CustomerID,TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2013-10-01' AND '2013-12-31';




SELECT 
    ProductID, Name,Weight,Size,
    ProductNumber
FROM Production.Product
WHERE Weight IS NULL AND Size IS NOT NULL;


SELECT 
    pc.Name AS CategoryName,
    COUNT(p.ProductID) AS ProductCount
FROM Production.ProductCategory pc
JOIN Production.ProductSubcategory ps ON pc.ProductCategoryID = ps.ProductCategoryID
JOIN Production.Product p ON ps.ProductSubcategoryID = p.ProductSubcategoryID
GROUP BY pc.Name
ORDER BY ProductCount DESC;


SELECT 
    ps.Name AS SubcategoryName,
    AVG(p.ListPrice) AS AvgListPrice
FROM Production.ProductSubcategory ps
JOIN Production.Product p ON ps.ProductSubcategoryID = p.ProductSubcategoryID
GROUP BY ps.Name
HAVING COUNT(p.ProductID) > 5
ORDER BY AvgListPrice DESC;




SELECT TOP 10
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName
ORDER BY OrderCount DESC;


SELECT 
    DATENAME(MONTH, OrderDate) AS MonthName,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
GROUP BY DATENAME(MONTH, OrderDate), MONTH(OrderDate)
ORDER BY MONTH(OrderDate);




SELECT 
    DATENAME(MONTH, OrderDate) AS MonthName,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
GROUP BY DATENAME(MONTH, OrderDate), MONTH(OrderDate)
ORDER BY MONTH(OrderDate);


SELECT 
    p.ProductID,p.Name,p.SellStartDate,
    YEAR(p.SellStartDate) AS LaunchYear
FROM Production.Product p
WHERE YEAR(p.SellStartDate) = (
    SELECT YEAR(SellStartDate)
    FROM Production.Product
    WHERE Name = 'Mountain-100 Black, 42');


	SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS EmployeeName,
    e.HireDate,
    COUNT(*) AS EmployeesHired
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
GROUP BY e.HireDate, p.FirstName, p.LastName
HAVING COUNT(*) > 1
ORDER BY e.HireDate;




CREATE TABLE Sales.ProductReviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    ReviewDate DATE NOT NULL DEFAULT GETDATE(),
    ReviewText NVARCHAR(1000),
    VerifiedPurchase BIT NOT NULL DEFAULT 0,
    HelpfulVotes INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_ProductReviews_Product FOREIGN KEY (ProductID) REFERENCES Production.Product(ProductID),
    CONSTRAINT FK_ProductReviews_Customer FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID),
    CONSTRAINT UQ_Product_Customer UNIQUE (ProductID, CustomerID));


	ALTER TABLE Production.Product
ADD LastModifiedDate DATETIME DEFAULT GETDATE();



CREATE NONCLUSTERED INDEX IX_Person_LastName
ON Person.Person (LastName)
INCLUDE (FirstName, MiddleName);


ALTER TABLE Production.Product
WITH NOCHECK
ADD CONSTRAINT CHK_ListPrice_Greater_StandardCost
CHECK (ListPrice > StandardCost);



INSERT INTO Sales.ProductReviews (ProductID, CustomerID, Rating, ReviewDate, ReviewText, VerifiedPurchase, HelpfulVotes)
VALUES 
    (707, 11000, 4, '2025-07-01', 'Great product, very durable!', 1, 5),
    (708, 11001, 3, '2025-07-02', 'Good but could be improved.', 1, 2),
    (709, 11002, 5, '2025-07-03', 'Absolutely love this item!', 1, 10);

	

INSERT INTO Production.ProductCategory (Name)
VALUES ('Electronics');
INSERT INTO Production.ProductSubcategory (ProductCategoryID, Name)
VALUES ((SELECT ProductCategoryID FROM Production.ProductCategory WHERE Name = 'Electronics'), 'Smartphones');



CREATE TABLE Sales.DiscontinuedProducts (
    ProductID INT PRIMARY KEY,
    Name NVARCHAR(50),
    ProductNumber NVARCHAR(25),
    SellEndDate DATETIME);
INSERT INTO Sales.DiscontinuedProducts (ProductID, Name, ProductNumber, SellEndDate)
SELECT ProductID, Name, ProductNumber, SellEndDate
FROM Production.Product
WHERE SellEndDate IS NOT NULL;



UPDATE Production.Product
SET ModifiedDate = GETDATE()
WHERE ListPrice > 1000 AND SellEndDate IS NULL;


UPDATE p
SET p.ListPrice = p.ListPrice * 1.15,
    p.ModifiedDate = GETDATE()
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = 'Bikes';


UPDATE HumanResources.Employee
SET JobTitle = 'Senior ' + JobTitle
WHERE HireDate < '2010-01-01';



DELETE FROM Sales.ProductReviews
WHERE Rating = 1 AND HelpfulVotes = 0;


DELETE FROM Production.Product
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.SalesOrderDetail sod
    WHERE sod.ProductID = Production.Product.ProductID
);




DELETE po
FROM Purchasing.PurchaseOrderHeader po
JOIN Purchasing.Vendor v ON po.VendorID = v.BusinessEntityID
WHERE v.ActiveFlag = 0;


SELECT 
    YEAR(OrderDate) AS SalesYear,
    SUM(TotalDue) AS TotalSales,
    AVG(TotalDue) AS AvgOrderValue,
    COUNT(SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) BETWEEN 2011 AND 2014
GROUP BY YEAR(OrderDate)
ORDER BY SalesYear;


SELECT 
    c.CustomerID,
    COUNT(soh.SalesOrderID) AS TotalOrders,
    SUM(soh.TotalDue) AS TotalAmount,
    AVG(soh.TotalDue) AS AvgOrderValue,
    MIN(soh.OrderDate) AS FirstOrderDate,
    MAX(soh.OrderDate) AS LastOrderDate
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID;


SELECT TOP 20
    p.Name AS ProductName,
    pc.Name AS CategoryName,
    SUM(sod.OrderQty) AS TotalQuantitySold,
    SUM(sod.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY p.Name, pc.Name
ORDER BY TotalRevenue DESC;



WITH YearlyTotal AS (
    SELECT SUM(TotalDue) AS YearlySales
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2013
)
SELECT 
    DATENAME(MONTH, OrderDate) AS MonthName,
    SUM(TotalDue) AS SalesAmount,
    (SUM(TotalDue) / YearlyTotal.YearlySales * 100) AS PercentOfYearlyTotal
FROM Sales.SalesOrderHeader
CROSS JOIN YearlyTotal
WHERE YEAR(OrderDate) = 2013
GROUP BY DATENAME(MONTH, OrderDate), MONTH(OrderDate), YearlyTotal.YearlySales
ORDER BY MONTH(OrderDate);


SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS FullName,
    DATEDIFF(YEAR, e.BirthDate, GETDATE()) AS Age,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    FORMAT(e.HireDate, 'MMM dd, yyyy') AS FormattedHireDate,
    DATENAME(MONTH, e.BirthDate) AS BirthMonth
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID;



SELECT 
    UPPER(p.LastName) + ', ' + p.FirstName + ' ' + ISNULL(LEFT(p.MiddleName, 1) + '.', '') AS FormattedName,
    SUBSTRING(ea.EmailAddress, CHARINDEX('@', ea.EmailAddress) + 1, LEN(ea.EmailAddress)) AS EmailDomain
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.EmailAddress ea ON p.BusinessEntityID = ea.BusinessEntityID;


SELECT 
    Name,
    ROUND(Weight, 1) AS WeightGrams,
    ROUND(Weight / 453.592, 1) AS WeightPounds,
    CASE 
        WHEN Weight > 0 THEN ROUND(ListPrice / (Weight / 453.592), 2)
        ELSE NULL 
    END AS PricePerPound
FROM Production.Product;


SELECT 
    p.Name AS ProductName,
    pc.Name AS CategoryName,
    ps.Name AS SubcategoryName,
    v.Name AS VendorName
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID;



SELECT 
    soh.SalesOrderID,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    CONCAT(sp.FirstName, ' ', sp.LastName) AS SalesPersonName,
    st.Name AS TerritoryName,
    pr.Name AS ProductName,
    sod.OrderQty,
    sod.LineTotal
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID;





SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS EmployeeName,
    e.JobTitle,
    st.Name AS TerritoryName,
    st.[Group] AS TerritoryGroup,
    sp.SalesYTD
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Sales.SalesPerson sp ON e.BusinessEntityID = sp.BusinessEntityID
LEFT JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID;


SELECT 
    p.Name AS ProductName,
    pc.Name AS CategoryName,
    ISNULL(SUM(sod.OrderQty), 0) AS TotalQuantitySold,
    ISNULL(SUM(sod.LineTotal), 0) AS TotalRevenue
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY p.Name, pc.Name;



SELECT 
    st.Name AS TerritoryName,
    CONCAT(p.FirstName, ' ', p.LastName) AS EmployeeName,
    ISNULL(sp.SalesYTD, 0) AS SalesYTD
FROM Sales.SalesTerritory st
LEFT JOIN Sales.SalesPerson sp ON st.TerritoryID = sp.TerritoryID
LEFT JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID;



SELECT 
    v.Name AS VendorName,
    pc.Name AS CategoryName
FROM Purchasing.Vendor v
FULL OUTER JOIN Purchasing.ProductVendor pv ON v.BusinessEntityID = pv.BusinessEntityID
FULL OUTER JOIN Production.Product p ON pv.ProductID = p.ProductID
FULL OUTER JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
FULL OUTER JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID;


WITH AvgPrice AS (
    SELECT AVG(ListPrice) AS AvgListPrice
    FROM Production.Product
)
SELECT 
    p.ProductID,
    p.Name,
    p.ListPrice,
    p.ListPrice - AvgPrice.AvgListPrice AS PriceDifference
FROM Production.Product p
CROSS JOIN AvgPrice
WHERE p.ListPrice > AvgPrice.AvgListPrice;




SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,
    SUM(sod.LineTotal) AS TotalAmountSpent
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
WHERE pr.Name LIKE '%Mountain%'
GROUP BY p.FirstName, p.LastName;



SELECT 
    p.Name AS ProductName,
    pc.Name AS CategoryName,
    COUNT(DISTINCT soh.CustomerID) AS UniqueCustomerCount
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY p.Name, pc.Name
HAVING COUNT(DISTINCT soh.CustomerID) > 100;



SELECT 
    c.CustomerID,
    COUNT(soh.SalesOrderID) AS OrderCount,
    RANK() OVER (ORDER BY COUNT(soh.SalesOrderID) DESC) AS CustomerRank
FROM Sales.Customer c
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID;


CREATE VIEW vw_ProductCatalog
AS
SELECT 
    p.ProductID,
    p.Name,
    p.ProductNumber,
    pc.Name AS Category,
    ps.Name AS Subcategory,
    p.ListPrice,
    p.StandardCost,
    CASE 
        WHEN p.ListPrice > 0 THEN ((p.ListPrice - p.StandardCost) / p.ListPrice * 100)
        ELSE 0 
    END AS ProfitMarginPercentage,
    ISNULL(pi.Quantity, 0) AS InventoryLevel,
    CASE 
        WHEN p.SellEndDate IS NULL THEN 'Active'
        ELSE 'Discontinued'
    END AS Status
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID;


CREATE VIEW vw_SalesAnalysis
AS
SELECT 
    YEAR(soh.OrderDate) AS SalesYear,
    DATENAME(MONTH, soh.OrderDate) AS SalesMonth,
    st.Name AS Territory,
    SUM(soh.TotalDue) AS TotalSales,
    COUNT(soh.SalesOrderID) AS OrderCount,
    AVG(soh.TotalDue) AS AvgOrderValue,
    (
        SELECT TOP 1 p.Name
        FROM Sales.SalesOrderDetail sod
        JOIN Sales.SalesOrderHeader soh2 ON sod.SalesOrderID = soh2.SalesOrderID
        JOIN Production.Product p ON sod.ProductID = p.ProductID
        WHERE YEAR(soh2.OrderDate) = YEAR(soh.OrderDate)
          AND DATENAME(MONTH, soh2.OrderDate) = DATENAME(MONTH, soh.OrderDate)
          AND soh2.TerritoryID = soh.TerritoryID
        GROUP BY p.Name
        ORDER BY SUM(sod.LineTotal) DESC
    ) AS TopProductName
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
GROUP BY YEAR(soh.OrderDate), DATENAME(MONTH, soh.OrderDate), MONTH(soh.OrderDate), st.Name;


CREATE VIEW vw_EmployeeDirectory
AS
SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS FullName,
    e.JobTitle,
    d.Name AS Department,
    CONCAT(pm.FirstName, ' ', pm.LastName) AS ManagerName,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    ea.EmailAddress,
    pp.PhoneNumber
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
LEFT JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
LEFT JOIN Person.Person pm ON m.BusinessEntityID = pm.BusinessEntityID
LEFT JOIN Person.EmailAddress ea ON p.BusinessEntityID = ea.BusinessEntityID
LEFT JOIN Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID;



SELECT TOP 5 ProductID, Name, ProfitMarginPercentage
FROM vw_ProductCatalog
WHERE Status = 'Active'
ORDER BY ProfitMarginPercentage DESC;
SELECT SalesYear, Territory, TotalSales, OrderCount
FROM vw_SalesAnalysis
WHERE SalesYear = 2013
ORDER BY TotalSales DESC;
SELECT FullName, JobTitle, YearsOfService
FROM vw_EmployeeDirectory
WHERE YearsOfService > 5
ORDER BY YearsOfService DESC;



SELECT 
    CASE 
        WHEN ListPrice > 500 THEN 'Premium'
        WHEN ListPrice BETWEEN 100 AND 500 THEN 'Standard'
        ELSE 'Budget'
    END AS PriceCategory,
    COUNT(*) AS ProductCount,
    AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE ListPrice > 0
GROUP BY CASE 
    WHEN ListPrice > 500 THEN 'Premium'
    WHEN ListPrice BETWEEN 100 AND 500 THEN 'Standard'
    ELSE 'Budget'
END;





SELECT 
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 10 THEN 'Veteran'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 5 AND 9 THEN 'Experienced'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 2 AND 4 THEN 'Regular'
        ELSE 'New'
    END AS ServiceCategory,
    COUNT(*) AS EmployeeCount,
    AVG(Rate) AS AvgSalary,
    MIN(Rate) AS MinSalary,
    MAX(Rate) AS MaxSalary
FROM HumanResources.Employee e
JOIN HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
GROUP BY CASE 
    WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 10 THEN 'Veteran'
    WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 5 AND 9 THEN 'Experienced'
    WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 2 AND 4 THEN 'Regular'
    ELSE 'New'
END;



WITH OrderClassification AS (
    SELECT 
        CASE 
            WHEN TotalDue > 5000 THEN 'Large'
            WHEN TotalDue BETWEEN 1000 AND 5000 THEN 'Medium'
            ELSE 'Small'
        END AS OrderSize,
        COUNT(*) AS OrderCount
    FROM Sales.SalesOrderHeader
    GROUP BY CASE 
        WHEN TotalDue > 5000 THEN 'Large'
        WHEN TotalDue BETWEEN 1000 AND 5000 THEN 'Medium'
        ELSE 'Small'
    END
)
SELECT 
    OrderSize,
    OrderCount,
    (OrderCount * 100.0 / SUM(OrderCount) OVER ()) AS PercentageDistribution
FROM OrderClassification;



SELECT 
    Name,
    ISNULL(CAST(Weight AS NVARCHAR), 'Not Specified') AS Weight,
    ISNULL(Size, 'Standard') AS Size,
    ISNULL(Color, 'Natural') AS Color
FROM Production.Product;



SELECT 
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    COALESCE(ea.EmailAddress, pp.PhoneNumber, a.AddressLine1) AS BestContactMethod
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.EmailAddress ea ON p.BusinessEntityID = ea.BusinessEntityID
LEFT JOIN Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID
LEFT JOIN Person.Address a ON p.BusinessEntityID = a.AddressID;


SELECT 
    ProductID,
    Name,
    Weight,
    Size
FROM Production.Product
WHERE Weight IS NULL AND Size IS NOT NULL;
SELECT 
    ProductID,
    Name,
    Weight,
    Size
FROM Production.Product
WHERE Weight IS NULL AND Size IS NULL;



WITH EmployeeHierarchy AS (
    SELECT 
        CONCAT(p.FirstName, ' ', p.LastName) AS EmployeeName,
        CONCAT(pm.FirstName, ' ', pm.LastName) AS ManagerName,
        e.OrganizationLevel AS HierarchyLevel,
        CAST(e.BusinessEntityID AS VARCHAR(50)) AS Path
    FROM HumanResources.Employee e
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
    LEFT JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
    LEFT JOIN Person.Person pm ON m.BusinessEntityID = pm.BusinessEntityID
)
SELECT 
    EmployeeName,
    ManagerName,
    HierarchyLevel,
    Path
FROM EmployeeHierarchy
ORDER BY HierarchyLevel, EmployeeName;



WITH SalesByYear AS (
    SELECT 
        p.Name AS ProductName,
        YEAR(soh.OrderDate) AS SalesYear,
        SUM(sod.LineTotal) AS TotalSales
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    WHERE YEAR(soh.OrderDate) IN (2013, 2014)
    GROUP BY p.Name, YEAR(soh.OrderDate)
)
SELECT 
    ProductName,
    MAX(CASE WHEN SalesYear = 2013 THEN TotalSales ELSE 0 END) AS Sales2013,
    MAX(CASE WHEN SalesYear = 2014 THEN TotalSales ELSE 0 END) AS Sales2014,
    CASE 
        WHEN MAX(CASE WHEN SalesYear = 2013 THEN TotalSales ELSE 0 END) = 0 THEN NULL
        ELSE ((MAX(CASE WHEN SalesYear = 2014 THEN TotalSales ELSE 0 END) - 
               MAX(CASE WHEN SalesYear = 2013 THEN TotalSales ELSE 0 END)) / 
               MAX(CASE WHEN SalesYear = 2013 THEN TotalSales ELSE 0 END) * 100)
    END AS GrowthPercentage,
    CASE 
        WHEN ((MAX(CASE WHEN SalesYear = 2014 THEN TotalSales ELSE 0 END) - 
               MAX(CASE WHEN SalesYear = 2013 THEN TotalSales ELSE 0 END)) / 
               MAX(CASE WHEN SalesYear = 2013 THEN TotalSales ELSE 0 END) * 100) > 10 THEN 'High Growth'
        WHEN ((MAX(CASE WHEN SalesYear = 2014 THEN TotalSales ELSE 0 END) - 
               MAX(CASE WHEN SalesYear = 2013 THEN TotalSales ELSE 0 END)) / 
               MAX(CASE WHEN SalesYear = 2013 THEN TotalSales ELSE 0 END) * 100) < -10 THEN 'Decline'
        ELSE 'Stable'
    END AS GrowthCategory
FROM SalesByYear
GROUP BY ProductName;




SELECT 
    p.Name AS ProductName,
    pc.Name AS CategoryName,
    SUM(sod.LineTotal) AS SalesAmount,
    RANK() OVER (PARTITION BY pc.Name ORDER BY SUM(sod.LineTotal) DESC) AS Rank,
    DENSE_RANK() OVER (PARTITION BY pc.Name ORDER BY SUM(sod.LineTotal) DESC) AS DenseRank,
    ROW_NUMBER() OVER (PARTITION BY pc.Name ORDER BY SUM(sod.LineTotal) DESC) AS RowNumber
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY p.Name, pc.Name;





WITH MonthlySales AS (
    SELECT 
        DATENAME(MONTH, OrderDate) AS MonthName,
        MONTH(OrderDate) AS MonthNumber,
        SUM(TotalDue) AS MonthlySales
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2013
    GROUP BY DATENAME(MONTH, OrderDate), MONTH(OrderDate)
)
SELECT 
    MonthName,
    MonthlySales,
    SUM(MonthlySales) OVER (ORDER BY MonthNumber) AS RunningTotal,
    (SUM(MonthlySales) OVER (ORDER BY MonthNumber) * 100.0 / SUM(MonthlySales) OVER ()) AS PercentOfYearToDate
FROM MonthlySales
ORDER BY MonthNumber;




WITH MonthlySales AS (
    SELECT 
        st.Name AS Territory,
        DATENAME(MONTH, soh.OrderDate) AS MonthName,
        MONTH(soh.OrderDate) AS MonthNumber,
        YEAR(soh.OrderDate) AS SalesYear,
        SUM(soh.TotalDue) AS MonthlySales
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
    GROUP BY st.Name, DATENAME(MONTH, soh.OrderDate), MONTH(soh.OrderDate), YEAR(soh.OrderDate)
)
SELECT 
    Territory,
    MonthName,
    MonthlySales,
    AVG(MonthlySales) OVER (
        PARTITION BY Territory
        ORDER BY SalesYear, MonthNumber
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS ThreeMonthMovingAvg
FROM MonthlySales
ORDER BY Territory, SalesYear, MonthNumber;




WITH MonthlySales AS (
    SELECT 
        DATENAME(MONTH, OrderDate) AS MonthName,
        MONTH(OrderDate) AS MonthNumber,
        SUM(TotalDue) AS MonthlySales
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2013
    GROUP BY DATENAME(MONTH, OrderDate), MONTH(OrderDate)
)
SELECT 
    MonthName,
    MonthlySales,
    LAG(MonthlySales) OVER (ORDER BY MonthNumber) AS PreviousMonthSales,
    MonthlySales - LAG(MonthlySales) OVER (ORDER BY MonthNumber) AS GrowthAmount,
    CASE 
        WHEN LAG(MonthlySales) OVER (ORDER BY MonthNumber) = 0 THEN NULL
        ELSE ((MonthlySales - LAG(MonthlySales) OVER (ORDER BY MonthNumber)) * 100.0 / LAG(MonthlySales) OVER (ORDER BY MonthNumber))
    END AS GrowthPercentage
FROM MonthlySales
ORDER BY MonthNumber;




WITH CustomerPurchases AS (
    SELECT 
        CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
        SUM(soh.TotalDue) AS TotalPurchases,
        NTILE(4) OVER (ORDER BY SUM(soh.TotalDue)) AS Quartile
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY p.FirstName, p.LastName
)
SELECT 
    CustomerName,
    TotalPurchases,
    Quartile,
    AVG(TotalPurchases) OVER (PARTITION BY Quartile) AS QuartileAverage
FROM CustomerPurchases;




SELECT *
FROM (
    SELECT 
        pc.Name AS CategoryName,
        YEAR(soh.OrderDate) AS SalesYear,
        SUM(sod.LineTotal) AS SalesAmount
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    WHERE YEAR(soh.OrderDate) BETWEEN 2011 AND 2014
    GROUP BY pc.Name, YEAR(soh.OrderDate)
) AS SourceTable
PIVOT (
    SUM(SalesAmount)
    FOR SalesYear IN ([2011], [2012], [2013], [2014])
) AS PivotTable;



SELECT *
FROM (
    SELECT 
        d.Name AS Department,
        e.Gender,
        COUNT(*) AS EmployeeCount
    FROM HumanResources.Employee e
    JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
    JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
    GROUP BY d.Name, e.Gender
) AS SourceTable
PIVOT (
    SUM(EmployeeCount)
    FOR Gender IN (M, F)
) AS PivotTable;




DECLARE @Columns NVARCHAR(MAX), @SQL NVARCHAR(MAX);

SELECT @Columns = STRING_AGG(QUOTENAME(CONCAT(YEAR(OrderDate), 'Q', DATEPART(QUARTER, OrderDate))), ',')
FROM (
    SELECT DISTINCT 
        YEAR(OrderDate) AS Yr,
        DATEPART(QUARTER, OrderDate) AS Qtr,
        CONCAT(YEAR(OrderDate), 'Q', DATEPART(QUARTER, OrderDate)) AS YrQtr
    FROM Sales.SalesOrderHeader
) AS Quarters;

SET @SQL = N'
SELECT *
FROM (
    SELECT 
        pc.Name AS CategoryName,
        CONCAT(YEAR(soh.OrderDate), ''Q'', DATEPART(QUARTER, soh.OrderDate)) AS Quarter,
        SUM(sod.LineTotal) AS SalesAmount
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    GROUP BY pc.Name, YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate)
) AS SourceTable
PIVOT (
    SUM(SalesAmount)
    FOR Quarter IN (' + @Columns + ')
) AS PivotTable;';

EXEC sp_executesql @SQL;





WITH Sales2013 AS (
    SELECT DISTINCT p.Name AS ProductName
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    WHERE YEAR(soh.OrderDate) = 2013
),
Sales2014 AS (
    SELECT DISTINCT p.Name AS ProductName
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    WHERE YEAR(soh.OrderDate) = 2014
)
SELECT 
    ProductName,
    CASE 
        WHEN s13.ProductName IS NOT NULL AND s14.ProductName IS NOT NULL THEN 'Sold in Both 2013 and 2014'
        WHEN s13.ProductName IS NOT NULL THEN 'Sold Only in 2013'
    END AS SalesStatus
FROM Sales2013 s13
FULL OUTER JOIN Sales2014 s14 ON s13.ProductName = s14.ProductName
WHERE s13.ProductName IS NOT NULL;





WITH HighValue AS (
    SELECT DISTINCT pc.Name AS CategoryName
    FROM Production.Product p
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    WHERE p.ListPrice > 1000
),
HighVolume AS (
    SELECT pc.Name AS CategoryName
    FROM Sales.SalesOrderDetail sod
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    GROUP BY pc.Name
    HAVING SUM(sod.OrderQty) > 1000
)
SELECT 
    CategoryName,
    CASE 
        WHEN CategoryName IN (SELECT CategoryName FROM HighValue INTERSECT SELECT CategoryName FROM HighVolume) THEN 'High Value and High Volume'
        WHEN CategoryName IN (SELECT CategoryName FROM HighValue) THEN 'High Value Only'
        WHEN CategoryName IN (SELECT CategoryName FROM HighVolume) THEN 'High Volume Only'
    END AS CategoryType
FROM (
    SELECT CategoryName FROM HighValue
    UNION
    SELECT CategoryName FROM HighVolume
) AS Combined;





DECLARE @CurrentYear INT = YEAR(GETDATE());
DECLARE @TotalSales MONEY;
DECLARE @AvgOrderValue MONEY;

SELECT 
    @TotalSales = SUM(TotalDue),
    @AvgOrderValue = AVG(TotalDue)
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = @CurrentYear;

SELECT 
    @CurrentYear AS SalesYear,
    FORMAT(@TotalSales, 'C') AS TotalSales,
    FORMAT(@AvgOrderValue, 'C') AS AvgOrderValue;







	DECLARE @ProductName NVARCHAR(50) = 'Mountain-100 Black, 42';

IF EXISTS (SELECT 1 FROM Production.Product WHERE Name = @ProductName)
BEGIN
    SELECT 
        p.ProductID,
        p.Name,
        p.ListPrice,
        ISNULL(pi.Quantity, 0) AS InventoryLevel
    FROM Production.Product p
    LEFT JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID
    WHERE p.Name = @ProductName;
END
ELSE
BEGIN
    SELECT 
        p.ProductID,
        p.Name,
        p.ListPrice
    FROM Production.Product p
    WHERE p.Name LIKE '%Mountain%' AND p.Name != @ProductName
    ORDER BY p.ListPrice;
END;






DECLARE @Month INT = 1;
DECLARE @SalesSummary TABLE (MonthName NVARCHAR(20), TotalSales MONEY);

WHILE @Month <= 12
BEGIN
    INSERT INTO @SalesSummary (MonthName, TotalSales)
    SELECT 
        DATENAME(MONTH, DATEADD(MONTH, @Month - 1, '2013-01-01')),
        SUM(TotalDue)
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2013 AND MONTH(OrderDate) = @Month;
    SET @Month = @Month + 1;
END;

SELECT MonthName, FORMAT(TotalSales, 'C') AS TotalSales
FROM @SalesSummary
ORDER BY MONTH(DATEADD(MONTH, MONTH(MonthName) - 1, '2013-01-01'));






CREATE TABLE Sales.PriceUpdateLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    OldPrice MONEY,
    NewPrice MONEY,
    UpdateDate DATETIME,
    ErrorMessage NVARCHAR(1000)
);

BEGIN TRY
    BEGIN TRANSACTION;
    
    UPDATE Production.Product
    SET ListPrice = ListPrice * 1.10,
        ModifiedDate = GETDATE()
    OUTPUT 
        deleted.ProductID,
        deleted.ListPrice,
        inserted.ListPrice,
        GETDATE(),
        NULL
    INTO Sales.PriceUpdateLog (ProductID, OldPrice, NewPrice, UpdateDate, ErrorMessage)
    WHERE ListPrice > 0;
    
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    
    INSERT INTO Sales.PriceUpdateLog (ProductID, OldPrice, NewPrice, UpdateDate, ErrorMessage)
    VALUES (NULL, NULL, NULL, GETDATE(), ERROR_MESSAGE());
    
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;





CREATE FUNCTION Sales.fn_CustomerLifetimeValue
(
    @CustomerID INT,
    @StartDate DATE,
    @EndDate DATE,
    @RecentWeight DECIMAL(4,2)
)
RETURNS DECIMAL(19,2)
AS
BEGIN
    DECLARE @TotalSpent DECIMAL(19,2);
    DECLARE @RecentSpent DECIMAL(19,2);

    SELECT @TotalSpent = SUM(TotalDue)
    FROM Sales.SalesOrderHeader
    WHERE CustomerID = @CustomerID AND OrderDate BETWEEN @StartDate AND @EndDate;

    SELECT @RecentSpent = SUM(TotalDue)
    FROM Sales.SalesOrderHeader
    WHERE CustomerID = @CustomerID AND OrderDate >= DATEADD(MONTH, -6, @EndDate);

    RETURN ISNULL(@TotalSpent, 0) + (ISNULL(@RecentSpent, 0) * @RecentWeight);
END;






CREATE FUNCTION Production.fn_GetProductsByPriceAndCategory
(
    @MinPrice MONEY,
    @MaxPrice MONEY,
    @CategoryName NVARCHAR(50)
)
RETURNS @Result TABLE (
    ProductID INT,
    Name NVARCHAR(50),
    ListPrice MONEY,
    CategoryName NVARCHAR(50)
)
AS
BEGIN
    IF @MinPrice < 0 OR @MaxPrice < @MinPrice
    BEGIN
        INSERT INTO @Result (ProductID, Name, ListPrice, CategoryName)
        VALUES (0, 'Error: Invalid price range', 0, NULL);
        RETURN;
    END;

    INSERT INTO @Result (ProductID, Name, ListPrice, CategoryName)
    SELECT 
        p.ProductID,
        p.Name,
        p.ListPrice,
        pc.Name
    FROM Production.Product p
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    WHERE p.ListPrice BETWEEN @MinPrice AND @MaxPrice
    AND pc.Name = @CategoryName;

    RETURN;
END;






CREATE FUNCTION HumanResources.fn_EmployeesUnderManager
(
    @ManagerID INT
)
RETURNS TABLE
AS
RETURN
WITH EmployeeHierarchy AS (
    SELECT 
        BusinessEntityID,
        CONCAT(FirstName, ' ', LastName) AS EmployeeName,
        0 AS HierarchyLevel,
        CAST(CONCAT('/', FirstName, ' ', LastName) AS NVARCHAR(MAX)) AS Path
    FROM HumanResources.Employee e
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
    WHERE e.BusinessEntityID = @ManagerID
    UNION ALL
    SELECT 
        e.BusinessEntityID,
        CONCAT(p.FirstName, ' ', p.LastName),
        eh.HierarchyLevel + 1,
        eh.Path + '/' + CONCAT(p.FirstName, ' ', p.LastName)
    FROM HumanResources.Employee e
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
    JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
    JOIN EmployeeHierarchy eh ON m.BusinessEntityID = eh.BusinessEntityID
)
SELECT 
    BusinessEntityID,
    EmployeeName,
    HierarchyLevel,
    Path
FROM EmployeeHierarchy;






CREATE PROCEDURE Production.usp_GetProductsByCategory
    @CategoryName NVARCHAR(50),
    @MinPrice MONEY,
    @MaxPrice MONEY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @MinPrice < 0 OR @MaxPrice < @MinPrice
            THROW 50001, 'Invalid price range.', 1;

        IF NOT EXISTS (SELECT 1 FROM Production.ProductCategory WHERE Name = @CategoryName)
            THROW 50002, 'Category does not exist.', 1;

        SELECT 
            p.ProductID,
            p.Name,
            p.ListPrice,
            pc.Name AS CategoryName
        FROM Production.Product p
        JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
        JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
        WHERE pc.Name = @CategoryName AND p.ListPrice BETWEEN @MinPrice AND @MaxPrice;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;






CREATE PROCEDURE Production.usp_UpdateProductPricing
    @ProductID INT,
    @NewPrice MONEY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @NewPrice <= 0
            THROW 50001, 'New price must be positive.', 1;

        IF NOT EXISTS (SELECT 1 FROM Production.Product WHERE ProductID = @ProductID)
            THROW 50002, 'Product does not exist.', 1;

        BEGIN TRANSACTION;

        INSERT INTO Sales.PriceUpdateLog (ProductID, OldPrice, NewPrice, UpdateDate, ErrorMessage)
        SELECT ProductID, ListPrice, @NewPrice, GETDATE(), NULL
        FROM Production.Product
        WHERE ProductID = @ProductID;

        UPDATE Production.Product
        SET ListPrice = @NewPrice,
            ModifiedDate = GETDATE()
        WHERE ProductID = @ProductID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        INSERT INTO Sales.PriceUpdateLog (ProductID, OldPrice, NewPrice, UpdateDate, ErrorMessage)
        VALUES (@ProductID, NULL, @NewPrice, GETDATE(), ERROR_MESSAGE());

        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;






CREATE PROCEDURE Sales.usp_GenerateSalesReport
    @StartDate DATE,
    @EndDate DATE,
    @TerritoryID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @StartDate > @EndDate
            THROW 50001, 'Start date must be before end date.', 1;

        IF NOT EXISTS (SELECT 1 FROM Sales.SalesTerritory WHERE TerritoryID = @TerritoryID)
            THROW 50002, 'Invalid territory ID.', 1;

        -- Summary Statistics
        SELECT 
            st.Name AS TerritoryName,
            COUNT(soh.SalesOrderID) AS TotalOrders,
            SUM(soh.TotalDue) AS TotalSales,
            AVG(soh.TotalDue) AS AvgOrderValue
        FROM Sales.SalesOrderHeader soh
        JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
        WHERE soh.OrderDate BETWEEN @StartDate AND @EndDate
        AND soh.TerritoryID = @TerritoryID
        GROUP BY st.Name;

        -- Detailed Breakdown
        SELECT 
            soh.SalesOrderID,
            soh.OrderDate,
            CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
            SUM(sod.LineTotal) AS OrderTotal
        FROM Sales.SalesOrderHeader soh
        JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
        JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
        JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
        WHERE soh.OrderDate BETWEEN @StartDate AND @EndDate
        AND soh.TerritoryID = @TerritoryID
        GROUP BY soh.SalesOrderID, soh.OrderDate, p.FirstName, p.LastName
        ORDER BY soh.OrderDate;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;






CREATE PROCEDURE Sales.usp_ProcessBulkOrders
    @OrderXML XML
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @Orders TABLE (
            SalesOrderID INT,
            CustomerID INT,
            OrderDate DATE,
            TotalDue MONEY
        );

        -- Validate and extract XML data
        INSERT INTO @Orders (CustomerID, OrderDate, TotalDue)
        SELECT 
            x.c.value('(CustomerID)[1]', 'INT'),
            x.c.value('(OrderDate)[1]', 'DATE'),
            x.c.value('(TotalDue)[1]', 'MONEY')
        FROM @OrderXML.nodes('/Orders/Order') AS x(c);

        -- Validate customer IDs
        IF EXISTS (SELECT 1 FROM @Orders o WHERE NOT EXISTS (SELECT 1 FROM Sales.Customer WHERE CustomerID = o.CustomerID))
            THROW 50001, 'Invalid customer ID in XML.', 1;

        -- Insert orders
        INSERT INTO Sales.SalesOrderHeader (CustomerID, OrderDate, TotalDue, Status)
        OUTPUT inserted.SalesOrderID, inserted.CustomerID, inserted.OrderDate, inserted.TotalDue
        INTO @Orders (SalesOrderID, CustomerID, OrderDate, TotalDue)
        SELECT CustomerID, OrderDate, TotalDue, 5 -- Status 5 = In Process
        FROM @Orders;

        COMMIT TRANSACTION;

        -- Return confirmation details
        SELECT 
            SalesOrderID,
            CustomerID,
            OrderDate,
            TotalDue
        FROM @Orders;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;







CREATE PROCEDURE Production.usp_FlexibleProductSearch
    @ProductName NVARCHAR(50) = NULL,
    @CategoryName NVARCHAR(50) = NULL,
    @MinPrice MONEY = NULL,
    @MaxPrice MONEY = NULL,
    @SellStartDate DATE = NULL,
    @SellEndDate DATE = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @PageNumber < 1 OR @PageSize < 1
            THROW 50001, 'Invalid pagination parameters.', 1;

        DECLARE @SQL NVARCHAR(MAX) = '
        SELECT 
            p.ProductID,
            p.Name AS ProductName,
            pc.Name AS CategoryName,
            p.ListPrice,
            p.SellStartDate,
            p.SellEndDate
        FROM Production.Product p
        JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
        JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
        WHERE 1=1';

        IF @ProductName IS NOT NULL
            SET @SQL += ' AND p.Name LIKE ''%' + @ProductName + '%''';
        IF @CategoryName IS NOT NULL
            SET @SQL += ' AND pc.Name = ''' + @CategoryName + '''';
        IF @MinPrice IS NOT NULL
            SET @SQL += ' AND p.ListPrice >= ' + CAST(@MinPrice AS NVARCHAR);
        IF @MaxPrice IS NOT NULL
            SET @SQL += ' AND p.ListPrice <= ' + CAST(@MaxPrice AS NVARCHAR);
        IF @SellStartDate IS NOT NULL
            SET @SQL += ' AND p.SellStartDate >= ''' + CAST(@SellStartDate AS NVARCHAR) + '''';
        IF @SellEndDate IS NOT NULL
            SET @SQL += ' AND p.SellEndDate <= ''' + CAST(@SellEndDate AS NVARCHAR) + '''';

        -- Add pagination
        SET @SQL += '
        ORDER BY p.ProductID
        OFFSET ' + CAST((@PageNumber - 1) * @PageSize AS NVARCHAR) + ' ROWS
        FETCH NEXT ' + CAST(@PageSize AS NVARCHAR) + ' ROWS ONLY;';

        -- Execute paginated query
        EXEC sp_executesql @SQL;

        -- Return total count
        SET @SQL = '
        SELECT COUNT(*) AS TotalCount
        FROM Production.Product p
        JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
        JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
        WHERE 1=1';

        IF @ProductName IS NOT NULL
            SET @SQL += ' AND p.Name LIKE ''%' + @ProductName + '%''';
        IF @CategoryName IS NOT NULL
            SET @SQL += ' AND pc.Name = ''' + @CategoryName + '''';
        IF @MinPrice IS NOT NULL
            SET @SQL += ' AND p.ListPrice >= ' + CAST(@MinPrice AS NVARCHAR);
        IF @MaxPrice IS NOT NULL
            SET @SQL += ' AND p.ListPrice <= ' + CAST(@MaxPrice AS NVARCHAR);
        IF @SellStartDate IS NOT NULL
            SET @SQL += ' AND p.SellStartDate >= ''' + CAST(@SellStartDate AS NVARCHAR) + '''';
        IF @SellEndDate IS NOT NULL
            SET @SQL += ' AND p.SellEndDate <= ''' + CAST(@SellEndDate AS NVARCHAR) + '''';

        EXEC sp_executesql @SQL;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;





CREATE TRIGGER Sales.trg_UpdateInventoryAndStats
ON Sales.SalesOrderDetail
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Update inventory
        UPDATE Production.ProductInventory
        SET Quantity = Quantity - i.OrderQty
        FROM Production.ProductInventory pi
        JOIN inserted i ON pi.ProductID = i.ProductID
        WHERE pi.Quantity >= i.OrderQty;

        IF @@ROWCOUNT != (SELECT COUNT(*) FROM inserted)
            THROW 50001, 'Insufficient inventory for one or more products.', 1;

        -- Update sales statistics (assuming a SalesStats table exists)
        UPDATE Sales.SalesStats
        SET TotalQuantitySold = TotalQuantitySold + i.OrderQty,
            TotalRevenue = TotalRevenue + i.LineTotal
        FROM Sales.SalesStats ss
        JOIN inserted i ON ss.ProductID = i.ProductID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        INSERT INTO Sales.PriceUpdateLog (ProductID, OldPrice, NewPrice, UpdateDate, ErrorMessage)
        SELECT i.ProductID, NULL, NULL, GETDATE(), ERROR_MESSAGE()
        FROM inserted i;
        THROW;
    END CATCH;
END;





CREATE VIEW Sales.vw_OrderDetails
AS
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    c.CustomerID,
    p.Name AS ProductName,
    sod.OrderQty,
    sod.LineTotal
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID;

GO

CREATE TRIGGER Sales.trg_InsteadOfInsertOrderDetails
ON Sales.vw_OrderDetails
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @NewOrders TABLE (SalesOrderID INT, CustomerID INT, OrderDate DATE);

        -- Insert into SalesOrderHeader
        INSERT INTO Sales.SalesOrderHeader (CustomerID, OrderDate, Status)
        OUTPUT inserted.SalesOrderID, inserted.CustomerID, inserted.OrderDate
        INTO @NewOrders
        SELECT DISTINCT CustomerID, OrderDate, 5 -- Status 5 = In Process
        FROM inserted;

        -- Insert into SalesOrderDetail
        INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice, LineTotal)
        SELECT 
            no.SalesOrderID,
            p.ProductID,
            i.OrderQty,
            p.ListPrice,
            i.LineTotal
        FROM inserted i
        JOIN @NewOrders no ON i.CustomerID = no.CustomerID AND i.OrderDate = no.OrderDate
        JOIN Production.Product p ON i.ProductName = p.Name;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;




CREATE TRIGGER Production.trg_AuditProductPriceChanges
ON Production.Product
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(ListPrice)
    BEGIN
        INSERT INTO Sales.PriceUpdateLog (ProductID, OldPrice, NewPrice, UpdateDate, ErrorMessage)
        SELECT 
            i.ProductID,
            d.ListPrice AS OldPrice,
            i.ListPrice AS NewPrice,
            GETDATE(),
            'Updated by ' + SUSER_SNAME()
        FROM inserted i
        JOIN deleted d ON i.ProductID = d.ProductID
        WHERE i.ListPrice != d.ListPrice;
    END;
END;





CREATE NONCLUSTERED INDEX IX_Product_ActiveProducts
ON Production.Product (ProductID, Name, ListPrice)
WHERE SellEndDate IS NULL;


CREATE NONCLUSTERED INDEX IX_SalesOrderHeader_RecentOrders
ON Sales.SalesOrderHeader (SalesOrderID, OrderDate, CustomerID)
WHERE OrderDate >= DATEADD(YEAR, -2, GETDATE());


SET STATISTICS TIME ON;
SELECT ProductID, Name, ListPrice
FROM Production.Product
WHERE SellEndDate IS NULL;
SET STATISTICS TIME OFF;




