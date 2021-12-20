-- 1
-- Bad
SELECT Customers.custid, Customers.companyname, Orders.orderid, Orders.orderdate
FROM Customers
  INNER JOIN Orders
    ON Customers.custid = Orders.custid;

-- Good
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Customers AS C
  INNER JOIN Orders AS O
    ON C.custid = O.custid;

-- 2
SELECT C.custid, COUNT(DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM Customers AS C
  INNER JOIN Orders AS O
    ON O.custid = C.custid
  INNER JOIN OrderDetails AS OD
    ON OD.orderid = O.orderid
WHERE C.country = 'USA'
GROUP BY C.custid;

-- 3
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Customers AS C
  LEFT OUTER JOIN Orders AS O
    ON O.custid = C.custid;

-- 4
SELECT C.custid, C.companyname
FROM Customers AS C
  LEFT OUTER JOIN Orders AS O
    ON O.custid = C.custid
WHERE O.orderid IS NULL;

-- 5 
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Customers AS C
  INNER JOIN Orders AS O
    ON O.custid = C.custid
WHERE O.orderdate = '20160212';

-- 6
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Customers AS C
  LEFT OUTER JOIN Orders AS O
    ON O.custid = C.custid
    AND O.orderdate = '20160212';

-- 7

SELECT DISTINCT C.custid, C.companyname, 
  CASE WHEN O.orderid IS NOT NULL THEN 'Yes' ELSE 'No' END AS HasOrderOn20160212
FROM Customers AS C
  LEFT OUTER JOIN Orders AS O
    ON O.custid = C.custid
    AND O.orderdate = '20160212';

SELECT DISTINCT C.custid, C.companyname,
       IF(O.orderdate = '20160212' , 'YES', 'No') AS Have
FROM Customers AS C
  INNER JOIN Orders AS O
    ON O.custid = C.custid;