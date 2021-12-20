-- -----------------------------------------------------------------------------
-- Union, Union All
-- -----------------------------------------------------------------------------

SELECT country, region, city FROM Employees
UNION
SELECT country, region, city FROM Customers;

SELECT country, region, city FROM Employees
UNION ALL
SELECT country, region, city FROM Customers;

-- -----------------------------------------------------------------------------
-- Intersect
-- -----------------------------------------------------------------------------

SELECT country, region, city FROM Employees
INTERSECT
SELECT country, region, city FROM Customers;

SELECT DISTINCT E.country, E.region, E.city 
FROM Employees AS E
INNER JOIN Customers AS C
    ON E.region = C.region OR (E.region IS NULL AND C.region IS NULL)

SELECT
    @i := @i + 1 AS rownum,
    country, region, city
FROM Employees, (SELECT @i := 0) f
INTERSECT
SELECT
    @i := @i + 1 AS rownum,
    country, region, city
FROM Customers, (SELECT @i := 0) f;

SELECT country, region, city FROM Employees
EXCEPT
SELECT country, region, city FROM Customers;


-------------------------------------------------------------------------------
-- Precendence
-------------------------------------------------------------------------------
SELECT country, region, city FROM Suppliers
EXCEPT
SELECT country, region, city FROM Employees
INTERSECT
SELECT country, region, city FROM Customers;

/*
Because INTERSECT precedes EXCEPT, the INTERSECT operator is evaluated first, 
even though it appears second in the code. The meaning of this query is, 
“locations that are supplier locations, 
but not (locations that are both employee and customer locations).”
*/

-- Note

SELECT country, COUNT(*) AS numlocations
FROM (SELECT country, region, city FROM HR.Employees
      UNION
      SELECT country, region, city FROM Sales.Customers) AS U
GROUP BY country;

SELECT empid, orderid, orderdate
FROM (
    SELECT empid, orderid, orderdate
        FROM Orders
    WHERE empid = 3
    ORDER BY orderdate DESC, orderid DESC LIMIT 2
) AS D1
UNION ALL
SELECT empid, orderid, orderdate
FROM (
    SELECT empid, orderid, orderdate
        FROM Orders
    WHERE empid = 5
    ORDER BY orderdate DESC, orderid DESC LIMIT 2
) AS D2;
