USE lessons;
-- Select example

SELECT * FROM Orders;

-- Where examples

SELECT * FROM Orders
  WHERE custid = 71;

SELECT orderid, custid, empid, orderdate, freight
  FROM Orders;

SELECT custid, orderdate FROM Orders
  WHERE custid > 40;

SELECT custid, orderdate FROM Orders
  WHERE custid > 40 AND custid < 45;

SELECT custid, orderdate FROM Orders
WHERE custid IN (41, 42);

SELECT custid, orderdate FROM Orders 
WHERE custid BETWEEN 41 AND 42;

SELECT shipaddress FROM Orders 
WHERE shipaddress LIKE '%tau%';

SELECT empid, YEAR(orderdate) FROM Orders
WHERE custid = 71;

-- Group by examples

SELECT empid, YEAR(orderdate) FROM Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

SELECT shipregion, YEAR(orderdate) AS `order year %`, shippeddate FROM Orders 
WHERE YEAR(orderdate) > 2015 AND NOT ISNULL(shippeddate);

SELECT empid, YEAR(orderdate) AS orderyear FROM Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

SELECT
  empid,
  YEAR(orderdate) AS orderyear,
  COUNT(*) AS numorders
FROM Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

SELECT
  empid,
  YEAR(orderdate) AS orderyear,
  SUM(freight) AS totalfreight,
  COUNT(*) AS numorders
FROM Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

SELECT
  empid,
  YEAR(orderdate) AS orderyear,
  COUNT(custid) AS numcusts
FROM Orders
GROUP BY empid, YEAR(orderdate);

SELECT * FROM Orders WHERE empid = 1 AND YEAR(orderdate) = '2014';

SELECT
  empid,
  YEAR(orderdate) AS orderyear,
  COUNT(DISTINCT custid) AS numcusts
FROM Orders
GROUP BY empid, YEAR(orderdate);

SELECT DISTINCT custid, empid, YEAR(orderdate) AS orderyear FROM Orders 
WHERE empid = 1 AND YEAR(orderdate) = '2014';

-- Having

SELECT empid, YEAR(orderdate) AS orderyear
FROM Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

SELECT empid, YEAR(orderdate) AS orderyear
FROM Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING empid in (6, 7);

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear;

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid DESC, orderyear ASC;

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY 1, 2;

-- Order by

SELECT DISTINCT country
FROM Employees
ORDER BY empid;

SELECT orderid, orderdate, custid, empid
FROM Orders
ORDER BY orderdate DESC LIMIT 5;

SELECT orderid, orderdate, custid, empid
FROM Orders
ORDER BY orderdate DESC;

SELECT orderid, orderdate, custid, empid
FROM Orders
ORDER BY orderdate, orderid
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;

SELECT orderid, productid, qty, unitprice, discount,
  FORMAT(ROUND(qty * unitprice * (1 - discount), 2), '##.##') AS val
FROM OrderDetails;

SELECT orderid, productid, qty, unitprice, discount,
  CAST(qty * unitprice * (1 - discount) AS DECIMAL(12, 2)) as val
FROM OrderDetails;

-- Case

SELECT productid, productname, categoryid,
  CASE categoryid
    WHEN 1 THEN 'Beverages'
    WHEN 2 THEN 'Condiments'
    WHEN 3 THEN 'Confections'
    WHEN 4 THEN 'Dairy Products'
    WHEN 5 THEN 'Grains/Cereals'
    WHEN 6 THEN 'Meat/Poultry'
    WHEN 7 THEN 'Produce'
    WHEN 8 THEN 'Seafood'
    ELSE 'Unknown Cate;ry'
  END AS categoryname
FROM Products;

SELECT orderid, custid, val,
  CASE
    WHEN val < 1000.00                   THEN 'Less than 1000'
    WHEN val BETWEEN 1000.00 AND 3000.00 THEN 'Between 1000 and 3000'
    WHEN val > 3000.00                   THEN 'More than 3000'
    ELSE 'Unknown'
  END AS valuecategory
FROM OrderValues;

SELECT custid, country, region, city
FROM Customers
WHERE region IS NULL; -- IS NOT NULL;

SELECT custid, country, region, city,
  COALESCE(region, '') AS location
FROM Customers;

SELECT custid, country, region, city,
  CONCAT(country, ', ', region, ', ', city) AS location
FROM Customers;

SELECT CONCAT('Test1', NULL, 'Test2') FROM DUAL;

-- String
SELECT empid, lastname
FROM Employees
WHERE lastname LIKE N'_e%';
