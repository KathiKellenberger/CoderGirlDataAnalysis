--Module 5 

--Demo 1
--Joining Two Tables 
SELECT * --31,465
FROM Sales.SalesOrderHeader;

SELECT * --121,317
FROM Sales.SalesOrderDetail;


SELECT s.SalesOrderID, s.OrderDate, s.TotalDue, d.SalesOrderDetailID,        
	d.ProductID, d.OrderQty    
FROM Sales.SalesOrderHeader AS s    
INNER JOIN Sales.SalesOrderDetail AS d 
ON s.SalesOrderID = d.SalesOrderID;   

--Writing an Incorrect Query 
--Cartesian Product
SELECT s.SalesOrderID, OrderDate, TotalDue, SalesOrderDetailID,        
	d.ProductID, d.OrderQty    
FROM Sales.SalesOrderHeader AS s    
INNER JOIN Sales.SalesOrderDetail d 
ON 1 = 1;   

--Wrong results!
SELECT s.SalesOrderID, OrderDate, TotalDue, SalesOrderDetailID,        
	d.ProductID, d.OrderQty    
FROM Sales.SalesOrderHeader AS s    
INNER JOIN Sales.SalesOrderDetail d 
ON s.SalesOrderID = d.SalesOrderDetailID;  

SELECT s.SalesOrderID, OrderDate, TotalDue, SalesOrderDetailID,        
	d.ProductID, d.OrderQty    
FROM Sales.SalesOrderHeader AS s    
INNER JOIN Sales.SalesOrderDetail d 
ON s.SalesOrderID = d.OrderQty;  



--Joining Two Tables with Different Column Names 
SELECT c.CustomerID, c.PersonID, p.BusinessEntityID, p.LastName    
FROM Sales.Customer AS c    
INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID;   

SELECT * FROM Sales.SpecialOfferProduct
order by ProductID 

select * from sales.SalesOrderDetail

--Joining Two Columns --54
SELECT sod.SalesOrderID, sod.SalesOrderDetailID,        
	so.ProductID, so.SpecialOfferID, so.ModifiedDate    
FROM Sales.SalesOrderDetail AS sod    
INNER JOIN Sales.SpecialOfferProduct AS so        
	ON so.ProductID = sod.ProductID 
	AND so.SpecialOfferID = sod.SpecialOfferID    
WHERE sod.SalesOrderID IN (51116,51112); 


--Joining Three Tables 
SELECT soh.SalesOrderID, soh.OrderDate, p.ProductID, p.Name    
FROM Sales.SalesOrderHeader as soh    
INNER JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID    
INNER JOIN Production.Product AS p ON sod.ProductID = p.ProductID    
ORDER BY soh.SalesOrderID;   


--Demo 2 OUTER JOIN
--Using LEFT OUTER JOIN 
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.SalesOrderHeader

--32,166
SELECT c.CustomerID, C.AccountNumber, S.SalesOrderID, s.OrderDate    
FROM Sales.Customer AS c  LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID    
ORDER BY C.CustomerID; 

--Using RIGHT OUTER JOIN --Not recommended
SELECT c.CustomerID, C.AccountNumber,S.SalesOrderID, s.OrderDate    
FROM Sales.SalesOrderHeader AS s  RIGHT OUTER JOIN Sales.Customer AS c ON c.CustomerID = s.CustomerID    
ORDER BY C.CustomerID;   

--What happens when you add a second table to a LEFT join?
SELECT C.CustomerID, C.AccountNumber, SOD.SalesOrderID, SOD.SalesOrderDetailID, SOD.ProductID    
FROM Sales.Customer AS C    
LEFT OUTER JOIN Sales.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID    
INNER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID    
ORDER BY C.CustomerID; 

--Continue the LEFT path 
SELECT C.CustomerID,C.AccountNumber, SOH.SalesOrderID, SOD.SalesOrderDetailID, SOD.ProductID    
FROM Sales.Customer AS C    
LEFT OUTER JOIN Sales.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID    
LEFT OUTER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID    
ORDER BY C.CustomerID; 

--FULL OUTER JOIN Demonstration
/* Run this in your own server to create the table
IF OBJECT_ID('Production.ProductColor') IS NOT NULL BEGIN        
	DROP TABLE Production.ProductColor;    
END    
CREATE table Production.ProductColor        
	(Color nvarchar(15) NOT NULL PRIMARY KEY);    
GO    
--Insert most of the existing colors    
INSERT INTO Production.ProductColor    
SELECT DISTINCT Color    
FROM Production.Product    
WHERE Color IS NOT NULL and Color <> 'Silver';
 
--Insert some additional colors    
INSERT INTO Production.ProductColor    
VALUES ('Green'),('Orange'),('Purple'); 
*/

SELECT * FROM Production.ProductColor

--Here is the query:    
SELECT c.Color AS "Color from list", p.Color, p.ProductID    
FROM Production.Product AS p    
FULL OUTER JOIN Production.ProductColor AS c ON p.Color = c.Color    
ORDER BY p.ProductID;  

--Only the exact matches
SELECT c.Color AS "Color from list", p.Color, p.ProductID    
FROM Production.Product AS p    
INNER JOIN Production.ProductColor AS c ON p.Color = c.Color    
ORDER BY p.ProductID;  

--Demo 3

--A left join. Lots of customers with no order returned
SELECT c.CustomerID, s.SalesOrderID, s.OrderDate    
FROM Sales.Customer AS c    
LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID 
ORDER BY s.SalesOrderID;

--Using LEFT OUTER JOIN to Find the Rows with No Matches 
SELECT c.CustomerID, s.SalesOrderID, s.OrderDate    
FROM Sales.Customer AS c    
LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID    
WHERE s.SalesOrderID IS NULL;  

--231
select * from sales.SalesOrderHeader as s
where S.OrderDate BETWEEN '2011-07-01' AND '2011-07-31'

SELECT c.CustomerID, s.SalesOrderID, s.OrderDate    
FROM Sales.Customer AS c    
LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID    
WHERE S.OrderDate BETWEEN '2011-07-01' AND '2011-07-31' 
order by s.SalesOrderID  

--Add the right filter to the join
SELECT c.CustomerID, s.SalesOrderID, s.OrderDate    
FROM Sales.Customer AS c    
LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID    
	AND S.OrderDate BETWEEN '2011-07-01' AND '2011-07-31'
ORDER BY s.SalesOrderID;  