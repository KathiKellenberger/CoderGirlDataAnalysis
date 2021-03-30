--Module 7
--Demo 1

--Find all the customers
--who have placed an order
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE CustomerID IN (SELECT CustomerID FROM Sales.SalesOrderHeader);

--who have not placed an order
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE CustomerID NOT IN
    (SELECT CustomerID FROM Sales.SalesOrderHeader);

--Since subquery returns a null, no results returned
SELECT CurrencyRateID, FromCurrencyCode, ToCurrencyCode
FROM Sales.CurrencyRate
WHERE CurrencyRateID NOT IN
    (SELECT CurrencyRateID
     FROM Sales.SalesOrderHeader);
 
--Make sure that subquery doesn't return NULL
SELECT CurrencyRateID, FromCurrencyCode, ToCurrencyCode
FROM Sales.CurrencyRate
WHERE CurrencyRateID NOT IN
    (SELECT CurrencyRateID
     FROM Sales.SalesOrderHeader
     WHERE CurrencyRateID IS NOT NULL);

--Demo 2
--Use a correlated subquery to return the count
SELECT CustomerID, C.StoreID, C.AccountNumber,
    (SELECT COUNT(*) 
     FROM Sales.SalesOrderHeader AS SOH
     WHERE SOH.CustomerID = C.CustomerID
     ) AS CountOfSales
FROM Sales.Customer AS C
ORDER BY CountOfSales DESC;
 
--Need separate subqueries if more calcs needed
SELECT CustomerID, C.StoreID, C.AccountNumber, 
    (SELECT COUNT(*) AS CountOfSales 
     FROM Sales.SalesOrderHeader AS SOH
     WHERE SOH.CustomerID = C.CustomerID) AS CountOfSales,
    (SELECT SUM(TotalDue)
     FROM Sales.SalesOrderHeader AS SOH
     WHERE SOH.CustomerID = C.CustomerID) AS SumOfTotalDue,
    (SELECT AVG(TotalDue)
     FROM Sales.SalesOrderHeader AS SOH
     WHERE SOH.CustomerID = C.CustomerID) AS AvgOfTotalDue
FROM Sales.Customer AS C
ORDER BY CountOfSales DESC;


--Demo 3
--A derived table is treated like a table
SELECT c.CustomerID, c.StoreID, c.AccountNumber, s.CountOfSales,
    s.SumOfTotalDue, s.AvgOfTotalDue
FROM Sales.Customer AS c 
INNER JOIN
    (SELECT CustomerID, COUNT(*) AS CountOfSales,
         SUM(TotalDue) AS SumOfTotalDue,
         AVG(TotalDue) AS AvgOfTotalDue
     FROM Sales.SalesOrderHeader
     GROUP BY CustomerID) AS s 
ON c.CustomerID = s.CustomerID
ORDER BY CountOfSales DESC;


--Here's the same results, but with a CTE
WITH s AS 
    (SELECT CustomerID, COUNT(*) AS CountOfSales,
        SUM(TotalDue) AS SumOfTotalDue,
        AVG(TotalDue) AS AvgOfTotalDue
     FROM Sales.SalesOrderHeader
     GROUP BY CustomerID) 
SELECT c.CustomerID, c.StoreID, c.AccountNumber, s.CountOfSales,
    s.SumOfTotalDue, s.AvgOfTotalDue
FROM Sales.Customer AS c 
INNER JOIN s
ON c.CustomerID = s.CustomerID
ORDER BY COUntOfSales desc;

--Create and populate a temp table
USE tempdb;
GO
 
DROP TABLE IF EXISTS dbo.Employee;
DROP TABLE IF EXISTS dbo.Contact;
DROP TABLE IF EXISTS dbo.JobHistory;
  
CREATE TABLE [Employee](
        [EmployeeID] [int] NOT NULL,
        [ContactID] [int] NOT NULL,
        [ManagerID] [int] NULL,
        [Title] [nvarchar](50) NOT NULL);
 
CREATE TABLE [Contact] (
        [ContactID] [int] NOT NULL,
        [FirstName] [nvarchar](50) NOT NULL,
        [MiddleName] [nvarchar](50) NULL,
        [LastName] [nvarchar](50) NOT NULL);
 
CREATE TABLE JobHistory(
    EmployeeID INT NOT NULL, 
    EffDate DATE NOT NULL, 
    EffSeq INT NOT NULL,
    EmploymentStatus CHAR(1) NOT NULL,
    JobTitle VARCHAR(50) NOT NULL,
    Salary MONEY NOT NULL,
    ActionDesc VARCHAR(20)
 CONSTRAINT PK_JobHistory PRIMARY KEY CLUSTERED 
(
    EmployeeID, EffDate, EffSeq
));
 
GO
  
INSERT INTO dbo.Contact (ContactID, FirstName, MiddleName, LastName) VALUES 
        (1030,'Kevin','F','Brown'),
        (1009,'Thierry','B','DHers'),
        (1028,'David','M','Bradley'),
        (1070,'JoLynn','M','Dobney'),
        (1071,'Ruth','Ann','Ellerbrock'),
        (1005,'Gail','A','Erickson'),
        (1076,'Barry','K','Johnson'),
        (1006,'Jossef','H','Goldberg'),
        (1001,'Terri','Lee','Duffy'),
        (1072,'Sidney','M','Higa'),
        (1067,'Taylor','R','Maxwell'),
        (1073,'Jeffrey','L','Ford'),
        (1068,'Jo','A','Brown'),
        (1074,'Doris','M','Hartwig'),
        (1069,'John','T','Campbell'),
        (1075,'Diane','R','Glimp'),
        (1129,'Steven','T','Selikoff'),
        (1231,'Peter','J','Krebs'),
        (1172,'Stuart','V','Munson'),
        (1173,'Greg','F','Alderson'),
        (1113,'David','N','Johnson'),
        (1054,'Zheng','W','Mu'),
        (1007, 'Ovidiu', 'V', 'Cracium'),
        (1052, 'James', 'R', 'Hamilton'),
        (1053, 'Andrew', 'R', 'Hill'),
        (1056, 'Jack', 'S', 'Richins'),
        (1058, 'Michael', 'Sean', 'Ray'),
        (1064, 'Lori', 'A', 'Kane'),
        (1287, 'Ken', 'J', 'Sanchez');
 
INSERT INTO dbo.Employee (EmployeeID, ContactID, ManagerID, Title) VALUES 
        (1, 1209, 16,'Production Technician - WC60'),
        (2, 1030, 6,'Marketing Assistant'),
        (3, 1002, 12,'Engineering Manager'),
        (4, 1290, 3,'Senior Tool Designer'),
        (5, 1009, 263,'Tool Designer'),
        (6, 1028, 109,'Marketing Manager'),
        (7, 1070, 21,'Production Supervisor - WC60'),
        (8, 1071, 185,'Production Technician - WC10'),
        (9, 1005, 3,'Design Engineer'),
        (10, 1076, 185,'Production Technician - WC10'),
        (11, 1006, 3,'Design Engineer'),
        (12, 1001, 109,'Vice President of Engineering'),
        (13, 1072, 185,'Production Technician - WC10'),
        (14, 1067, 21,'Production Supervisor - WC50'),
        (15, 1073, 185,'Production Technician - WC10'),
        (16, 1068, 21,'Production Supervisor - WC60'),
        (17, 1074, 185,'Production Technician - WC10'),
        (18, 1069, 21,'Production Supervisor - WC60'),
        (19, 1075, 185,'Production Technician - WC10'),
        (20, 1129, 173,'Production Technician - WC30'),
        (21, 1231, 148,'Production Control Manager'),
        (22, 1172, 197,'Production Technician - WC45'),
        (23, 1173, 197,'Production Technician - WC45'),
        (24, 1113, 184,'Production Technician - WC30'),
        (25, 1054, 21,'Production Supervisor - WC10'),
        (109, 1287, NULL, 'Chief Executive Officer'),
        (148, 1052, 109, 'Vice President of Production'),
        (173, 1058, 21, 'Production Supervisor - WC30'),
        (184, 1056, 21, 'Production Supervisor - WC30'),
        (185, 1053, 21, 'Production Supervisor - WC10'),
        (197, 1064, 21, 'Production Supervisor - WC45'),
        (263, 1007, 3, 'Senior Tool Designer');       
 
INSERT INTO JobHistory(EmployeeID, EffDate, EffSeq, EmploymentStatus, 
    JobTitle, Salary, ActionDesc)
VALUES 
    (1000,'07-31-2018',1,'A','Intern',2000,'New Hire'),
    (1000,'05-31-2019',1,'A','Production Technician',2000,'Title Change'),
    (1000,'05-31-2019',2,'A','Production Technician',2500,'Salary Change'),
    (1000,'11-01-2019',1,'A','Production Technician',3000,'Salary Change'),
    (1200,'01-10-2019',1,'A','Design Engineer',5000,'New Hire'),
    (1200,'05-01-2019',1,'T','Design Engineer',5000,'Termination'),
    (1100,'08-01-2018',1,'A','Accounts Payable Specialist I',2500,'New Hire'),
    (1100,'05-01-2019',1,'A','Accounts Payable Specialist II',2500,'Title Change'),
    (1100,'05-01-2019',2,'A','Accounts Payable Specialist II',3000,'Salary Change'); 


--Multiple CTEs
USE tempdb;
WITH 
Emp AS(
    SELECT e.EmployeeID, e.ManagerID,e.Title AS EmpTitle,
        c.FirstName + ISNULL(' ' + c.MiddleName,'') + ' ' + c.LastName AS EmpName
    FROM dbo.Employee AS e
    INNER JOIN dbo.Contact AS c
    ON e.ContactID = c.ContactID 
    ),
Mgr AS(
    SELECT e.EmployeeID AS ManagerID,e.Title AS MgrTitle,
        c.FirstName + ISNULL(' ' + c.MiddleName,'') + ' ' + c.LastName AS MgrName
    FROM dbo.Employee AS e
    INNER JOIN dbo.Contact AS c
    ON e.ContactID = c.ContactID 
    )
SELECT EmployeeID, Emp.ManagerID, EmpName, EmpTitle, MgrName, MgrTitle
FROM Emp INNER JOIN Mgr ON Emp.ManagerID = Mgr.ManagerID
ORDER BY EmployeeID;


--A CTE can call another CTE
WITH MonthTotal AS (
	SELECT SUM(TotalDue) AS MonthTotal, YEAR(OrderDate) AS OrderYear, 
		MONTH(OrderDate) AS OrderMonth
	FROM Sales.SalesOrderHeader 
	GROUP BY YEAR(OrderDate), MONTH(OrderDate)
	),
YearTotal AS (
	SELECT SUM(MonthTotal) AS YearTotal, OrderYear
	FROM MonthTotal
	GROUP BY OrderYear
	),
Sales AS (
	SELECT SalesOrderID, OrderDate, TotalDue, 
		YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth
	FROM Sales.SalesOrderHeader) 
SELECT Sales.SalesOrderID, Sales.OrderDate, Sales.TotalDue, 
	YearTotal.YearTotal, MonthTotal.MonthTotal
FROM Sales 
INNER JOIN YearTotal ON YearTotal.OrderYear = Sales.OrderYear 
INNER JOIN MonthTotal ON MonthTotal.OrderMonth = Sales.OrderMonth 
	AND MonthTotal.OrderMonth = Sales.OrderMonth
ORDER BY MonthTotal.OrderYear, MonthTotal.OrderMonth;

