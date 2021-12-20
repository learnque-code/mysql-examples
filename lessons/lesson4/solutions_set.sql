-- Solution 5

SELECT custid, empid
FROM Orders
WHERE orderdate >= '20160101' AND orderdate < '20160201'
EXCEPT
SELECT custid, empid
FROM Orders
WHERE orderdate >= '20160201' AND orderdate < '20160301'
ORDER BY custid, empid;

-- Solution 6

SELECT custid, empid
FROM Orders
WHERE orderdate >= '20160101' AND orderdate < '20160201'
INTERSECT
SELECT custid, empid
FROM Orders
WHERE orderdate >= '20160201' AND orderdate < '20160301'
ORDER BY custid;

-- Solution 7

SELECT custid, empid
FROM Orders
WHERE orderdate >= '20160101' AND orderdate < '20160201'
INTERSECT
SELECT custid, empid
FROM Orders
WHERE orderdate >= '20160201' AND orderdate < '20160301'
EXCEPT
SELECT custid, empid
FROM Orders
WHERE orderdate >= '20150101' AND orderdate < '20160101';
