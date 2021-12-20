-- Solution 1

WITH C AS
(
  SELECT orderid, orderdate, custid, empid,
    DATE_FORMAT(orderdate, '%Y-12-31') AS endofyear
  FROM Orders
)
SELECT orderid, orderdate, custid, empid, endofyear
FROM C
WHERE orderdate <> endofyear;

SELECT orderid, orderdate, custid, empid, endofyear
FROM (
  SELECT orderid, orderdate, custid, empid,
    DATE_FORMAT(orderdate, '%Y-12-31') AS endofyear
  FROM Orders
) AS C
WHERE orderdate <> endofyear;

-- Solution 2

SELECT empid, MAX(orderdate) AS maxorderdate
FROM Orders
GROUP BY empid;

--

SELECT O.empid, O.orderdate, O.orderid, O.custid
FROM Orders AS O
  INNER JOIN (SELECT empid, MAX(orderdate) AS maxorderdate
              FROM Orders
              GROUP BY empid) AS D
    ON O.empid = D.empid
    AND O.orderdate = D.maxorderdate
ORDER BY O.empid DESC;

-- Solution 3

WITH OrdersRowNumber AS
(
  SELECT orderid, orderdate, custid, empid, @i := @i+1 AS rownum
  FROM Orders, (SELECT @i := 0) AS f
)
SELECT * FROM OrdersRowNumber WHERE rownum BETWEEN 11 AND 20;

-- Solution 4

CREATE OR REPLACE VIEW ViewEmployeeOrders
AS
SELECT
  empid,
  YEAR(orderdate) AS orderyear,
  SUM(qty) AS qty
FROM Orders AS O
  INNER JOIN OrderDetails AS OD
    ON O.orderid = OD.orderid
GROUP BY
  empid,
  YEAR(orderdate);

