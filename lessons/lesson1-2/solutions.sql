-- Solutions
USE lessons;

-- Exercise 1
SELECT orderid, orderdate, custid, empid
FROM Orders
WHERE YEAR(orderdate) = 2015 AND MONTH(orderdate) = 6;

-- or

SELECT orderid, orderdate, custid, empid
FROM Orders
WHERE orderdate >= '20150601'
  AND orderdate < '20150701';

-- Exercise 2

-- with the LAST_DAY function
SELECT orderid, orderdate, custid, empid
FROM Orders
WHERE orderdate = LAST_DAY(orderdate);

-- without the LAST_DAY function
SELECT orderid, orderdate, custid, empid
FROM Orders WHERE MONTH(orderdate) != MONTH(DATE_ADD(orderdate, INTERVAL 1 DAY))
ORDER BY orderdate;

-- Exercise 3

-- Solution
SELECT empid, firstname, lastname
FROM Employees
WHERE lastname LIKE '%e%e%';

-- Exercise 4

SELECT orderid, SUM(qty*unitprice) AS totalvalue
FROM OrderDetails
GROUP BY orderid
HAVING SUM(qty*unitprice) > 10000
ORDER BY totalvalue DESC;

-- Exercise 5

SELECT lastname from Employees WHERE lastname REGEXP BINARY '^[a-z]{1}[A-z]*';

-- Exercise 7

-- Solution
SELECT shipcountry, AVG(freight) AS avgfreight
FROM Orders
WHERE orderdate >= '20150101' AND orderdate < '20160101'
GROUP BY shipcountry
ORDER BY avgfreight DESC LIMIT 3;

-- With OFFSET-FETCH (MariaDB version > 10.6)
SELECT shipcountry, AVG(freight) AS avgfreight
FROM Orders
WHERE orderdate >= '20150101' AND orderdate < '20160101'
GROUP BY shipcountry
ORDER BY avgfreight DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

-- Exercise 8

-- Solutions
SELECT empid, firstname, lastname, titleofcourtesy,
  CASE titleofcourtesy
    WHEN 'Ms.'  THEN 'Female'
    WHEN 'Mrs.' THEN 'Female'
    WHEN 'Mr.'  THEN 'Male'
    ELSE             'Unknown'
  END AS gender
FROM Employees;

SELECT empid, firstname, lastname, titleofcourtesy,
  CASE 
    WHEN titleofcourtesy IN('Ms.', 'Mrs.') THEN 'Female'
    WHEN titleofcourtesy = 'Mr.'           THEN 'Male'
    ELSE                                        'Unknown'
  END AS gender
FROM Employees;

-- Exercise 9
SELECT custid, region
FROM Customers
ORDER BY
  CASE WHEN region IS NULL THEN 1 ELSE 0 END, region;

SELECT custid, region
FROM Customers
ORDER BY
  ISNULL(region), region;

SELECT custid, region FROM Customers
ORDER BY IFNULL(region, 'z') ASC, custid


