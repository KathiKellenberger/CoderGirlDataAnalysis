/*
Replace instructor with your username


*/

--Demo 1 Script to create a table
USE JunkKCOct21; --Replace with your class' junk database
GO
--2016 syntax
DROP TABLE IF EXISTS instructor.demoCustomer;
/*
--pre-2016 way to check for table existence and drop table
IF EXISTS (SELECT * FROM sys.objects
            WHERE object_id = OBJECT_ID(N'[dbo].[demoCustomer]')
                AND type in (N'U'))
    DROP TABLE dbo.demoCustomer;

*/
CREATE TABLE instructor.demoCustomer(CustomerID INT NOT NULL,
    FirstName NVARCHAR(50) NOT NULL, MiddleName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NOT NULL
    CONSTRAINT PK_demoCustomer PRIMARY KEY (CustomerID)); 

--Create tables with SELECT INTO
DROP TABLE IF EXISTS [instructor].[demoProduct];
GO
 
SELECT * INTO instructor.demoProduct FROM AdventureWorks2019.Production.Product;
 
DROP TABLE IF EXISTS [Instructor].[demoCustomer];
GO
SELECT CustomerID, LastName, FirstName, MiddleName 
INTO Instructor.demoCustomer
FROM AdventureWorks2019.Sales.Customer AS C
JOIN AdventureWorks2019.Person.Person AS P ON C.CustomerID = P.BusinessEntityID;

--Adding One Row at a Time with Literal Values

--1

INSERT INTO instructor.demoCustomer (CustomerID, FirstName, MiddleName, LastName)

VALUES (1, N'Orlando', N'N.', N'Gee');

--2

INSERT INTO instructor.demoCustomer (CustomerID, FirstName, MiddleName, LastName)

SELECT 3, N'Donna', N'F.', N'Cameras';

--3

INSERT INTO instructor.demoCustomer

VALUES (4,N'Janet', N'M.', N'Gates');

--4

INSERT INTO instructor.demoCustomer

SELECT 6,N'Rosmarie', N'J.', N'Carroll';

--5

INSERT INTO instructor.demoCustomer (CustomerID, FirstName, MiddleName, LastName)

VALUES (2, N'Keith', NULL, N'Harris');

--6

INSERT INTO instructor.demoCustomer (CustomerID, FirstName, LastName)

VALUES (5, N'Lucy', N'Harrington');

SELECT * FROM instructor.demoCustomer;



--Attempting to Insert Rows with Invalid INSERT Statements
PRINT '1';
--1
INSERT INTO instructor.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
VALUES (1, N'Dominic', N'P.', N'Gash');
 
PRINT '2';
--2
INSERT INTO instructor.demoCustomer (CustomerID, MiddleName, LastName)
VALUES (10, N'M.', N'Garza');
 
GO
PRINT '3';
GO
 

 --Inserting Multiple Rows with One INSERT
--1
INSERT INTO instructor.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
SELECT 7, N'Dominic', N'P.', N'Gash'
UNION ALL
SELECT 10, N'Kathleen', N'M.', N'Garza'
UNION ALL
SELECT 11, N'Katherine', NULL, N'Harding';
 
--2
INSERT INTO instructor.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
VALUES (12, N'Johnny', N'A.', N'Capino'),
       (16, N'Christopher', N'R.', N'Beck'),
       (18, N'David', N'J.', N'Liu');
 
--3
SELECT CustomerID, FirstName, MiddleName, LastName
FROM instructor.demoCustomer
WHERE CustomerID >=7;


--Inserting Rows from Another Table
--1
INSERT INTO instructor.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
SELECT BusinessEntityID, FirstName, MiddleName, LastName
FROM Person.Person
WHERE BusinessEntityID BETWEEN 19 AND 35;
--2
INSERT INTO instructor.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
SELECT DISTINCT s.SalesOrderID, c.FirstName, c.MiddleName, c.LastName
FROM Person.Person AS c
INNER JOIN Sales.SalesOrderHeader AS s ON c.BusinessEntityID = s.SalesPersonID;

SELECT CustomerID, FirstName, MiddleName, LastName
FROM instructor.demoCustomer
WHERE CustomerID > 18;

--Inserting Missing Rows
--1
SELECT COUNT(CustomerID) AS CustomerCount
FROM instructor.demoCustomer;
 
--2
INSERT INTO instructor.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
SELECT c.BusinessEntityID, c.FirstName, c.MiddleName, c.LastName
FROM Person.Person AS c
WHERE NOT EXISTS (
    SELECT 1 FROM instructor.demoCustomer a
    WHERE a.CustomerID = c.BusinessEntityID);
 
--3
SELECT COUNT(CustomerID) AS CustomerCount
FROM instructor.demoCustomer;


--Listing 10-11. Deleting Rows from Tables
--1
SELECT CustomerID
FROM instructor.demoCustomer;
 
--2
DELETE instructor.demoCustomer;
 
--3
SELECT CustomerID
FROM instructor.demoCustomer;
 

--4
SELECT ProductID
FROM instructor.demoProduct
WHERE ProductID > 900;
 
--5
DELETE instructor.demoProduct
WHERE ProductID > 900;
 
--6
SELECT ProductID
FROM instructor.demoProduct
WHERE ProductID > 900;


--Listing 10-12. Deleting as part of a JOIN
--1
DROP TABLE IF EXISTS instructor.demoSalesOrderDetail;
DROP TABLE IF EXISTS instructor.demoSalesOrderHeader;

SELECT * INTO instructor.demoSalesOrderDetail 
FROM Sales.SalesOrderHeader;
SELECT * INTO instructor.demosSalesOrderHeader
FROM Sales.SalesOrderDetail;

SELECT d.SalesOrderID, SalesOrderNumber
FROM instructor.demoSalesOrderDetail AS d
INNER JOIN instructor.demoSalesOrderHeader 
AS h ON d.SalesOrderID = h.SalesOrderID
WHERE h.SalesOrderNumber = 'SO71797';
 
--2
DELETE d
FROM instructor.demoSalesOrderDetail AS d
INNER JOIN instructor.demoSalesOrderHeader 
AS h ON d.SalesOrderID = h.SalesOrderID
WHERE h.SalesOrderNumber = 'SO71797'; 

--3
SELECT d.SalesOrderID, SalesOrderNumber
FROM instructor.demoSalesOrderDetail AS d
INNER JOIN instructor.demoSalesOrderHeader 
AS h ON d.SalesOrderID = h.SalesOrderID
WHERE h.SalesOrderNumber = 'SO71797';
 

--4
SELECT SalesOrderID, ProductID
FROM instructor.demoSalesOrderDetail AS SOD
WHERE NOT EXISTS
    (SELECT *
         FROM instructor.demoProduct AS P
         WHERE P.ProductID = SOD.ProductID);
--5
DELETE SOD
FROM instructor.demoSalesOrderDetail AS SOD
WHERE NOT EXISTS
    (SELECT *
         FROM instructor.demoProduct AS P
         WHERE P.ProductID = SOD.ProductID);
 
--6
SELECT SalesOrderID, ProductID
FROM instructor.demoSalesOrderDetail AS SOD
WHERE NOT EXISTS
    (SELECT *
         FROM instructor.demoProduct AS P
         WHERE P.ProductID = SOD.ProductID); 


TRUNCATE TABLE instructor.demoSalesOrderHeader;

DROP TABLE IF EXISTS instructor.demoCustomer;
SELECT BusinessEntityID, FirstName, MiddleName, LastName INTO instructor.DemoCustomer
FROM AdventureWorks2019.Person.Person
WHERE BusinessEntityID BETWEEN 19 AND 35;


SELECT * 
FROM instructor.demoCustomer
WHERE BusinessEntityID = 19;

UPDATE instructor.DemoCustomer 
SET FirstName = 'John', LastName = 'Smith'
WHERE BusinessEntityID = 19;

SELECT * 
FROM instructor.demoCustomer;


DROP TABLE IF EXISTS instructor.DemoAddress;
SELECT * INTO instructor.DemoAddress 
FROM AdventureWorks2019.Person.Address;

SELECT AddressLine1, AddressLine2
FROM instructor.demoAddress;

SELECT  P.FirstName + ' ' + P.LastName,
    AddressLine2 = AddressLine1 + ISNULL(' ' + AddressLine2,'')
FROM instructor.demoAddress AS dA
INNER JOIN Person.BusinessEntityAddress BEA ON dA.AddressID = BEA.AddressID
INNER JOIN Person.Person P ON P.BusinessEntityID = BEA.BusinessEntityID;
 

UPDATE dA
SET AddressLine1 = P.FirstName + ' ' + P.LastName,
    AddressLine2 = AddressLine1 + ISNULL(' ' + AddressLine2,'')
FROM instructor.demoAddress AS dA
INNER JOIN Person.BusinessEntityAddress BEA ON dA.AddressID = BEA.AddressID
INNER JOIN Person.Person P ON P.BusinessEntityID = BEA.BusinessEntityID;

SELECT AddressLine1, AddressLine2
FROM instructor.demoAddress;
 


