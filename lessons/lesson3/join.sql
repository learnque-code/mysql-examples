USE lessons;

-------------------------------------------------------------------------------
-- Cross join
-------------------------------------------------------------------------------

-- Self join
SELECT E1.address, E2.address FROM Employees AS E1
  CROSS JOIN Employees AS E2; 

SELECT C.custid, E.empid
FROM Customers AS C
  CROSS JOIN Employees AS E;

SELECT COUNT(*) 
FROM Customers AS C
  CROSS JOIN Employees AS E;

SELECT COUNT(*)
FROM Customers; -- 91 

SELECT COUNT(*)
FROM Employees; -- 8

SELECT * FROM Orders as orders 
    CROSS JOIN Employees as employees;

SELECT * FROM Orders, Employees; -- ISO/ANSI SQL-89 syntax

-- Generation of seq of numbers from 1 to 1000
DROP TABLE IF EXISTS dbo.Digits;

CREATE TABLE dbo.Digits(digit INT NOT NULL PRIMARY KEY);

INSERT INTO dbo.Digits(digit)
  VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

SELECT digit FROM dbo.Digits;

SELECT D3.digit * 100 + D2.digit * 10 + D1.digit + 1 AS n
FROM         dbo.Digits AS D1
  CROSS JOIN dbo.Digits AS D2
  CROSS JOIN dbo.Digits AS D3
ORDER BY n;

-------------------------------------------------------------------------------
-- inner join
-------------------------------------------------------------------------------

SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM Employees AS E
  INNER JOIN Orders AS O
    ON E.empid = O.empid;

SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM Employees AS E, Orders AS O
    WHERE E.empid = O.empid;

-- no equi join

SELECT
  E1.empid,
  E2.empid
FROM Employees AS E1
  CROSS JOIN Employees AS E2;

SELECT
  E1.empid,
  E2.empid
FROM Employees AS E1
  INNER JOIN Employees AS E2
    ON E1.empid < E2.empid;

-------------------------------------------------------------------------------
-- left join
-------------------------------------------------------------------------------
-- Check what orders do not exist for customer.

SELECT C.custid, C.companyname, O.orderid
FROM Customers AS C
  LEFT OUTER JOIN Orders AS O
    ON C.custid = O.custid;
-- WHERE orderid IS NULL; will return two records


-------------------------------------------------------------------------------
-- right join
-------------------------------------------------------------------------------

SELECT C.custid, C.companyname, O.orderid
FROM Customers AS C
  RIGHT OUTER JOIN Orders AS O
    ON C.custid = O.custid;
-- Order cannot be done for customer that do not exists :D
-- WHERE orderid IS NULL; will return empty

-------------------------------------------------------------------------------
-- composite join
-------------------------------------------------------------------------------

SELECT OD.orderid, OD.productid, OD.qty
FROM OrderDetails AS OD
  INNER JOIN OrderDetails AS ODA
    ON OD.orderid = ODA.orderid
    AND OD.productid = ODA.productid;

SELECT OD.orderid, P.productname, C.categoryname FROM Orders
    INNER JOIN OrderDetails OD ON Orders.orderid = OD.orderid
    INNER JOIN Products P ON OD.productid = P.productid
    INNER JOIN Categories C on P.categoryid = C.categoryid
    LIMIT 1;
