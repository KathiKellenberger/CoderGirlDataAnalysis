--Module 4
--Demo 1
SELECT 'ab' + 'c';     

SELECT 1 + 1 AS ADDITION, 10.0 / 3 AS DIVISION, 10 / 3 AS [Integer Division], 10 % 3 AS MODULO;      


SELECT BusinessEntityID, FirstName + ' ' + LastName AS [Full Name]    
FROM Person.Person;       
   
SELECT BusinessEntityID, LastName + ', ' + FirstName AS "Full Name"    
FROM Person.Person;  

SELECT SalesOrderID, SalesOrderID + 10
FROM Sales.SalesOrderHeader;

SELECT BusinessEntityID, FirstName + ' ' + MiddleName +        
	' ' + LastName AS [Full Name]    
FROM Person.Person;  

--Use ISNULL
SELECT BusinessEntityID, FirstName + ' ' + ISNULL(MiddleName,'') +        
	' ' + LastName AS [Full Name]    
FROM Person.Person; 

--Fix extra space
SELECT BusinessEntityID, FirstName +  ISNULL(' ' +MiddleName,'') +        
	' ' + LastName AS [Full Name]    
FROM Person.Person;  

--Use COALSECE 
SELECT BusinessEntityID, FirstName + ' ' + COALESCE(MiddleName,'') +        
	' ' + LastName AS [Full Name]    
FROM Person.Person;  

SELECT BusinessEntityID, FirstName +  COALESCE(' ' +MiddleName,'') +        
	' ' + LastName AS [Full Name]    
FROM Person.Person;  

--Coalesce returns the first non-null
SELECT COALESCE(NULL,NULL,'a','b',NULL,'c','d');

SELECT Style, Size,Color, COALESCE(Style, Size,Color)
FROM Production.Product;

--Cast 
SELECT BusinessEntityID + LastName 
FROM Person.Person;

SELECT CAST(BusinessEntityID AS VARCHAR(10)) + LastName 
FROM Person.Person;

--Convert 
SELECT CONVERT(VARCHAR(10), BusinessEntityID) + LastName 
FROM Person.Person;

SELECT BusinessEntityID, BusinessEntityID + 1 AS "Adds 1",        
	CAST(BusinessEntityID AS NVARCHAR(10)) + '1'AS "Appends 1"    
FROM Person.Person; 



--Demo 2
CREATE TABLE #trimExample (COL1 VARCHAR(10));    
GO    
--Populate the table    
INSERT INTO #trimExample (COL1)    
VALUES ('a'),('b  '),('  c'),('  d  ');       

SELECT * FROM #trimExample;
--Select the values using the functions    
SELECT '*' + COL1 + '*', '*' + RTRIM(COL1) + '*' AS "RTRIM",        
	'*' + LTRIM(COL1) + '*' AS "LTRIM", '*' + TRIM(COL1) + '*'  AS "TRIM",
	'*' + LTRIM(RTRIM(COL1)) + '*'  AS "Nested TRIM"
FROM #trimExample;       
--Clean up    
DROP TABLE #trimExample;  

--Using the LEFT and RIGHT Functions 
SELECT LastName,LEFT(LastName,5) AS "LEFT",        
	RIGHT(LastName,4) AS "RIGHT"    
FROM Person.Person    
WHERE BusinessEntityID IN (293,295,211,297,299,3057,15027); 

--Using the LEN and DATALENGTH Functions 
SELECT LastName,LEN(LastName) AS "Length",        
	DATALENGTH(LastName) AS "Internal Data Length"    
FROM Person.Person    
WHERE BusinessEntityID IN (293,295,211,297,299,3057,15027); 

--Using the CHARINDEX Function 
SELECT LastName, CHARINDEX('e',LastName) AS "Find e",        
	CHARINDEX('e',LastName,4) AS "Skip 4 Characters",        
	CHARINDEX('be',LastName) AS "Find be",        
	CHARINDEX('Be',LastName) AS "Find Be"    
FROM Person.Person    
WHERE BusinessEntityID IN (293,295,211,297,299,3057,15027); 

--Using the SUBSTRING Function 
SELECT LastName, SUBSTRING(LastName,1,4) AS "First 4",        
	SUBSTRING(LastName,5,50) AS "Characters 5 and later"    
FROM Person.Person    
WHERE BusinessEntityID IN (293,295,211,297,299,3057,15027); 


 --Using the CHOOSE Function 
SELECT CHOOSE (4, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'); 

--Using the UPPER and LOWER Functions 
SELECT LastName, UPPER(LastName) AS "UPPER",        
	LOWER(LastName) AS "LOWER"    
FROM Person.Person    
WHERE BusinessEntityID IN (293,295,211,297,299,3057,15027); 


--Using the REPLACE Function 
SELECT LastName, REPLACE(LastName,'A','Z') AS "Replace A",        
	REPLACE(LastName,'A','ZZ') AS "Replace with 2 characters",        
	REPLACE(LastName,'ab','') AS "Remove string"    
FROM Person.Person    
WHERE BusinessEntityID IN (293,295,211,297,299,3057,15027);       
    
SELECT BusinessEntityID,LastName,MiddleName,        
	REPLACE(LastName,'a',MiddleName) AS "Replace with MiddleName",        
	REPLACE(LastName,MiddleName,'a') AS "Replace MiddleName"    
FROM Person.Person    
WHERE BusinessEntityID IN (285,293,10314);


--Nesting Functions 
SELECT EmailAddress,        
	SUBSTRING(EmailAddress,CHARINDEX('@',EmailAddress) + 1,50) AS DOMAIN    
FROM Production.ProductReview; 

--Reverse 
SELECT REVERSE(FirstName)
FROM Person.Person

--CONCAT
SELECT CONCAT ('I ', 'love', ' writing', ' T-SQL') AS RESULT;       

SELECT BusinessEntityID, CONCAT(FirstName, ' ' + MiddleName,' ', LastName) AS [Full Name]    
FROM Person.Person; 

SELECT CONCAT(BusinessEntityID,LastName) 
FROM Person.Person;--

--Demo 3
SELECT GETDATE(), SYSDATETIME();

SELECT OrderDate, DATEADD(year,1,OrderDate) AS OneMoreYear,        
	DATEADD(month,1,OrderDate) AS OneMoreMonth,        
	DATEADD(day,-1,OrderDate) AS OneLessDay    
FROM Sales.SalesOrderHeader    
WHERE SalesOrderID in (43659,43714,60621);       

SELECT OrderDate, GETDATE() CurrentDateTime,        
	DATEDIFF(year,OrderDate,GETDATE()) AS YearDiff,        
	DATEDIFF(month,OrderDate,GETDATE()) AS MonthDiff,        
	DATEDIFF(d,OrderDate,GETDATE()) AS DayDiff    
FROM Sales.SalesOrderHeader    
WHERE SalesOrderID in (43659,43714,60621); 

SELECT OrderDate, DATEPART(year,OrderDate) AS OrderYear,        
	DATEPART(month,OrderDate) AS OrderMonth,        
	DATEPART(day,OrderDate) AS OrderDay,        
	DATEPART(weekday,OrderDate) AS OrderWeekDay    
FROM Sales.SalesOrderHeader    
WHERE SalesOrderID in (43659,43714,60621);       
  
SELECT OrderDate, DATENAME(year,OrderDate) AS OrderYear,        
	DATENAME(month,OrderDate) AS OrderMonth,        
	DATENAME(day,OrderDate) AS OrderDay,        
	DATENAME(weekday,OrderDate) AS OrderWeekDay    
FROM Sales.SalesOrderHeader    
WHERE SalesOrderID in (43659,43714,60621);  

SELECT OrderDate, YEAR(OrderDate) AS OrderYear,        
	MONTH(OrderDate) AS OrderMonth,        
	DAY(OrderDate) AS OrderDay 
FROM Sales.SalesOrderHeader    
WHERE SalesOrderID in (43659,43714,60621);  


SELECT CONVERT(VARCHAR(10),OrderDate,1) AS "1",        
	CONVERT(VARCHAR(10),OrderDate,101) AS "101",        
	CONVERT(VARCHAR(10),OrderDate,2) AS "2",        
	CONVERT(VARCHAR(10),OrderDate,102) AS "102"  ,
	CONVERT(VARCHAR(10),OrderDate,20) AS "20"
FROM Sales.SalesOrderHeader   
WHERE SalesOrderID in (43659,43714,60621);    


--FORMAT Function Examples 
DECLARE @d DATETIME = GETDATE();       
SELECT FORMAT( @d, 'dd', 'en-US' ) AS Result;    
SELECT FORMAT( @d, 'yyyy-M-d') AS Result;    
SELECT FORMAT( @d, 'MM/dd/yyyy', 'en-US' ) AS Result;   


-- DATEFROMPARTS Examples 
SELECT DATEFROMPARTS(2012, 3, 10) AS RESULT;    
SELECT TIMEFROMPARTS(12, 10, 32, 0, 0) AS RESULT;    
SELECT DATETIME2FROMPARTS (2012, 3, 10, 12, 10, 32, 0, 0) AS RESULT;    










SELECT BusinessEntityID, FirstName + ' ' + MiddleName +        
	' ' + LastName AS "Full Name"    
FROM Person.Person;  
  
--Use ISNULL or COALESCE 
SELECT BusinessEntityID, FirstName + ' ' + ISNULL(MiddleName,'') +        
	' ' + LastName AS "Full Name"    
FROM Person.Person;       
   
--remove space if not needed
SELECT BusinessEntityID, FirstName + ISNULL(' ' + MiddleName,'') +        
	' ' + LastName AS "Full Name"    
FROM Person.Person;       

SELECT BusinessEntityID, FirstName + COALESCE(' ' + MiddleName,'') +        
	' ' + LastName AS "Full Name"    
FROM Person.Person;  




  
-- Listing 4-3. CONCAT Examples 
--1   Simple CONCAT function    
SELECT CONCAT ('I ', 'love', ' writing', ' T-SQL') AS RESULT;      