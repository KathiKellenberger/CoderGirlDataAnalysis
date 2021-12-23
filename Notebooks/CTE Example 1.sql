USE AdventureWorks2019;
GO
/*
write a query that displays SalesOrderID, OrderDate, TotalDue, CustomerID.
Include the customer's total for all orders, average order, and count of orders

Include a calculation that shows the percent of this order for the customer's overall total
	totalDue/Customer's Total Due * 100

Include a calculation that show the difference between the customer's average order and this ont
	Average - totalDue


*/

--Method 1 CTE
--In a CTE, get calculations by customerID
WITH CustSummary AS (
	SELECT COUNT(*) AS CountOfOrders, SUM(TotalDue) AS CustTotal, 
		AVG(TotalDue) AS AvgOrder, CustomerID
	FROM Sales.SalesOrderHeader AS SOH 
	GROUP BY CustomerID 
)
SELECT soh.SalesOrderID, soh.orderDate, soh.TotalDue, soh.CustomerID, 
	CS.CountOfOrders, CS.CustTotal, CS.AvgOrder,
	soh.TotalDue/CS.CustTotal * 100 AS ThisOrderPercent,
	CS.AvgOrder - soh.TotalDue AS DiffFromAvg       
FROM Sales.SalesOrderHeader AS soh
INNER JOIN CustSummary AS CS
	ON CS.CustomerID = soh.CustomerID;

--Method 2 Derived table
SELECT  soh.SalesOrderID, soh.orderDate, soh.TotalDue, soh.CustomerID, 
	CS.CountOfOrders, CS.CustTotal, CS.AvgOrder,
	soh.TotalDue/CS.CustTotal * 100 AS ThisOrderPercent,
	CS.AvgOrder - soh.TotalDue AS DiffFromAvg 
FROM Sales.SalesOrderHeader AS soh 
INNER JOIN (
	SELECT COUNT(*) AS CountOfOrders, SUM(TotalDue) AS CustTotal, 
		AVG(TotalDue) AS AvgOrder, CustomerID
	FROM Sales.SalesOrderHeader AS SOH 
	GROUP BY CustomerID ) AS CS
ON CS.CustomerID = soh.CustomerID;



--Method 3 Correlated subquery
SELECT  soh.SalesOrderID, soh.orderDate, soh.TotalDue, soh.CustomerID, 
	(
		SELECT COUNT(*) 
		FROM Sales.SalesOrderHeader AS soh2 
		WHERE SOh2.CustomerID = soh.CustomerID
	) AS CountOfOrders, 
	(
		SELECT SUM(TotalDue) 
		FROM Sales.SalesOrderHeader AS soh3
		WHERE soh3.CustomerID = SOH.CustomerID
	) AS CustTotal,
	(
		SELECT AVG(TotalDue) 
		FROM Sales.SalesOrderHeader AS soh4
		WHERE soh4.CustomerID = SOH.CustomerID
	) AS AvgOrder,
	SOH.TotalDue/(
					SELECT SUM(TotalDue) 
					FROM Sales.SalesOrderHeader AS soh3
					WHERE soh3.CustomerID = SOH.CustomerID) * 100 AS ThisOrderPercent,
	(
		SELECT AVG(TotalDue) 
		FROM Sales.SalesOrderHeader AS soh4
		WHERE soh4.CustomerID = SOH.CustomerID
	) - TotalDue AS DiffFromAvg

FROM Sales.SalesOrderHeader AS soh;

--Method 4 temp table
DROP TABLE IF EXISTS #CustSummary;
SELECT COUNT(*) AS CountOfOrders, SUM(TotalDue) AS CustTotal, 
		AVG(TotalDue) AS AvgOrder, SOH.CustomerID
INTO #CustSummary
FROM Sales.SalesOrderHeader AS SOH 
GROUP BY CustomerID;

SELECT soh.SalesOrderID, soh.orderDate, soh.TotalDue, soh.CustomerID, 
	CS.CountOfOrders, CS.CustTotal, CS.AvgOrder,
	soh.TotalDue/CS.CustTotal * 100 AS ThisOrderPercent,
	CS.AvgOrder - soh.TotalDue AS DiffFromAvg       
FROM Sales.SalesOrderHeader AS soh
INNER JOIN #CustSummary AS CS
	ON CS.CustomerID = soh.CustomerID;