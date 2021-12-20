USE lessons;
-- ----------------------------------------------------------------------------
-- Self-contained subqueries
-- ----------------------------------------------------------------------------
SELECT orderid, orderdate, empid, custid
  FROM Orders
WHERE orderid = (SELECT MAX(O.orderid)
                  FROM Orders AS O);

-- Why not works

SELECT orderid
FROM Orders
WHERE empid =
  (SELECT E.empid
   FROM Employees AS E
   WHERE E.lastname LIKE 'D%');

-- Fixed

SELECT orderid
FROM Orders
WHERE empid =
  (SELECT E.empid
   FROM Employees AS E
   WHERE E.lastname LIKE 'C%');

-- NULL

SELECT orderid
FROM Sales.Orders
WHERE empid =
  (SELECT E.empid
   FROM HR.Employees AS E
   WHERE E.lastname LIKE 'A%');

-- Multi value
-- It is the same as inner join
SELECT orderid
FROM Orders
WHERE empid IN
  (SELECT E.empid
   FROM Employees AS E
   WHERE E.lastname LIKE N'D%');

-- Alternative

SELECT O.orderid
FROM Employees AS E
  INNER JOIN Orders AS O
    ON E.empid = O.empid
WHERE E.lastname LIKE N'D%';

/*
Write a query that returns orders placed by customers 
from the United States. You can write a query against 
the Orders table that returns orders where the customer ID is in the set of customer IDs of customers from the United States. 
You can implement the last part in a self-contained, 
multivalued subquery. 
*/

SELECT custid, orderid, orderdate, empid
FROM Orders
WHERE custid IN
  (SELECT C.custid
   FROM Customers AS C
   WHERE C.country = 'USA');

-- The same solution with INNER JOIN
SELECT C.custid, orderid, orderdate, empid FROM Orders AS O
    INNER JOIN Customers C on O.custid = C.custid
WHERE C.country = 'USA';

-- We can use NOT IN as well

SELECT custid, orderid, orderdate, empid
FROM Orders
WHERE custid NOT IN
  (SELECT C.custid
   FROM Customers AS C
   WHERE C.country = 'USA');

SELECT n
FROM Nums
WHERE n BETWEEN (SELECT MIN(O.orderid) FROM Orders AS O)
            AND (SELECT MAX(O.orderid) FROM Orders AS O)

SELECT *
FROM Customers AS C 
INNER JOIN (
    SELECT *
    FROM Orders
) AS OrderData ON OrderData.custid = C.custid
-- ----------------------------------------------------------------------------
-- Corelated subquery
-- ----------------------------------------------------------------------------

-- Will find latest max order id
SELECT custid, orderid, orderdate, empid
FROM Orders AS O1
WHERE orderid =
  (
    SELECT MAX(O2.orderid)
    FROM Orders AS O2
    WHERE O2.custid = O1.custid
  );

-- We can try to get a similiar results with group by
SELECT custid, MAX(orderid) AS orderid, MAX(orderdate) AS orderdate, empid FROM Orders
GROUP BY custid;

SELECT orderid, custid, val,
  CAST(100. * val / (SELECT SUM(O2.val)
    FROM OrderValues AS O2
  WHERE O2.custid = O1.custid) AS DECIMAL(5,2)) AS pct
FROM OrderValues AS O1
ORDER BY custid, orderid;

SELECT orderid, custid, val,
  CAST(100. * val / 10000
    AS DECIMAL(5,2)) AS pct
FROM OrderValues AS O1
ORDER BY custid, orderid;

-- The same solution with group by and JOIN
SELECT OV1.orderid,
       OV1.custid,
       OV1.val,
       CAST(100. * OV1.val / OV2.customer_values AS DECIMAL(5, 2)) AS pct
FROM OrderValues AS OV1
         INNER JOIN (
    SELECT custid, SUM(val) AS customer_values
    FROM OrderValues
    GROUP BY custid
) as OV2 USING (custid)
ORDER BY custid, orderid;

-- What order for customer exist or not exist
SELECT custid, companyname
FROM Customers AS C
WHERE country = 'Spain'
  AND NOT EXISTS
    (SELECT * FROM Orders AS O
     WHERE O.custid = C.custid);

-- Alternative way with LEFT OUTER JOIN
SELECT C.custid, C.companyname FROM Customers AS C
    LEFT JOIN Orders O on C.custid = O.custid
WHERE country = 'Spain' and orderid IS NULL;

-- Find previous orders?
-- Sub query
SELECT orderid, orderdate, empid, custid,
  (SELECT MAX(O2.orderid)
   FROM Orders AS O2
   WHERE O2.orderid < O1.orderid) AS prevorderid
FROM Orders AS O1;

-- Join
SELECT O1.orderid, O1.orderdate, O1.empid, O1.custid, O2.orderid AS prevorderid
FROM Orders O1
    LEFT JOIN Orders O2 ON O1.orderid > O2.orderid;