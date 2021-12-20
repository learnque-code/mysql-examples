-- 8
SELECT orderid, orderdate, custid, empid
FROM Orders
WHERE orderdate =
  (SELECT MAX(O.orderdate) FROM Orders AS O)
ORDER BY orderid DESC;

-- 9
SELECT empid, FirstName, lastname
FROM Employees
WHERE empid NOT IN
  (SELECT O.empid
   FROM Orders AS O
   WHERE O.orderdate >= '20160501');

-- with join
SELECT E.empid, E.firstname, E.lastname FROM Employees AS E
    LEFT JOIN Orders AS O ON E.empid = O.empid AND O.orderdate >= '20160501'
WHERE orderid IS NULL;

-- 10
SELECT DISTINCT country
FROM Customers
WHERE country NOT IN
  (SELECT E.country FROM Employees AS E) ORDER BY country;

SELECT DISTINCT C.country FROM Customers AS C
    LEFT JOIN Employees E on C.country = E.country
WHERE empid IS NULL ORDER BY country;

-- 11
SELECT custid, orderid, orderdate, empid
FROM Orders AS O1
WHERE orderdate =
  (SELECT MAX(O2.orderdate)
   FROM Orders AS O2
   WHERE O2.custid = O1.custid)
ORDER BY custid;

-- Alternative approach with join and group by
SELECT O1.custid, O1.orderid, O1.orderdate, O1.empid FROM Orders AS O1
    INNER JOIN (
        SELECT INO.custid, MAX(INO.orderdate) AS orderdate FROM Orders AS INO
        GROUP BY custid
    ) AS O2 USING(custid, orderdate)
ORDER BY custid;

-- 12

SELECT C.custid, C.companyname
FROM Customers AS C
WHERE C.custid IN (
    SELECT O1.custid
    FROM Orders AS O1
    WHERE YEAR(O1.orderdate) = '2015')
  AND C.custid NOT IN (
    SELECT O2.custid
    FROM Orders AS O2
    WHERE YEAR(O2.orderdate) = '2016')
ORDER BY C.custid;

SELECT custid, companyname
FROM Customers AS C
WHERE EXISTS
    (SELECT 1
     FROM Orders AS O
     WHERE O.custid = C.custid
       AND O.orderdate >= '20150101'
       AND O.orderdate < '20160101')
  AND NOT EXISTS
    (SELECT 1
     FROM Orders AS O
     WHERE O.custid = C.custid
       AND O.orderdate >= '20160101'
       AND O.orderdate < '20170101')
ORDER BY custid;