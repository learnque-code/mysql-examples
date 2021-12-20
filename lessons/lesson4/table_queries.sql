USE lessons;

-------------------------------------------------------------------------------
-- Table subqueries (derived table expression)
-------------------------------------------------------------------------------

SELECT * FROM (
    SELECT custid, companyname 
        FROM Customers WHERE country = 'USA'
) AS USACustomers;

-- Will throw an error
SELECT
    YEAR(orderdate) AS orderyear,
    COUNT(DISTINCT custid) AS numcusts
FROM Sales.Orders
GROUP BY orderyear;
--

/*
    This code defines a derived table called D based on a query against the Orders 
    table that returns the order year and customer ID from all rows.
*/

/* Inline aliasing easier to debug analysing */
SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
FROM (
    SELECT YEAR(orderdate) AS orderyear, custid  -- inline aliasing
        FROM Orders -- ORDER BY orderyear we cannot use order in derived table
) AS D
GROUP BY orderyear;

-- Session variable
SET @empid = 3;

SELECT YEAR(orderdate) AS orderyear, custid
        FROM Orders
        WHERE empid = @empid;

SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
FROM (
    SELECT YEAR(orderdate) AS orderyear, custid
        FROM Orders
        WHERE empid = @empid
) AS D
GROUP BY orderyear;

-- Nested query

-- Approach with HAVING
SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
    FROM (SELECT YEAR(orderdate) AS orderyear, custid
        FROM Sales.Orders
    ) AS D1
    GROUP BY orderyear
    HAVING COUNT(DISTINCT custid) > 70;

SELECT orderyear, numcusts
FROM (SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
        FROM (SELECT YEAR(orderdate) AS orderyear, custid
                FROM Sales.Orders
            ) AS D1
            GROUP BY orderyear 
    ) AS D2
WHERE numcusts > 70;

-- We can use in joins as well

-- Lets calculate how customers grows :)

SELECT Cur.orderyear,
    Cur.numcusts AS curnumcusts, Prv.numcusts AS prvnumcusts,
    Cur.numcusts - Prv.numcusts AS growth
FROM (
        SELECT YEAR(orderdate) AS orderyear,
            COUNT(DISTINCT custid) AS numcusts
        FROM Orders
        GROUP BY YEAR(orderdate)
    ) AS Cur
LEFT OUTER JOIN
    (
        SELECT YEAR(orderdate) AS orderyear,
            COUNT(DISTINCT custid) AS numcusts
        FROM Orders
        GROUP BY YEAR(orderdate)
    ) AS Prv
ON Cur.orderyear = Prv.orderyear + 1;

-------------------------------------------------------------------------------
-- Common table expression (CTV)
-------------------------------------------------------------------------------
/*
    The WITH clause is used in SQL for several purposes. 
    For example, it’s used to define a table hint in a query to force a 
    certain optimization option or isolation level. To avoid ambiguity, 
    when the WITH clause is used to define a CTE, the preceding statement in 
    the same batch—if one exists—must be terminated with a semicolon. 
    And oddly enough, the semicolon for the entire CTE is not required
*/

WITH USACusts AS
(
  SELECT custid, companyname
  FROM Customers
  WHERE country = 'USA'
  -- We cannot use ORDER BY companyname in CTE
)
SELECT * FROM USACusts;

-- inline aliasing
WITH C AS
(
  SELECT YEAR(orderdate) AS orderyear, custid
  FROM Sales.Orders
)
SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
FROM C
GROUP BY orderyear;

-- external aliasing
WITH C(orderyear, custid) AS
(
  SELECT YEAR(orderdate), custid
  FROM Orders
)

SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
FROM C
GROUP BY orderyear;

-- Using arguments

SET @empid = 3;

WITH C AS
(
  SELECT YEAR(orderdate) AS orderyear, custid
  FROM Orders
  WHERE empid = @empid
)
SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
FROM C
GROUP BY orderyear;


WITH C1 AS
(
    SELECT YEAR(orderdate) AS orderyear, custid
    FROM Orders
),
C2 AS
(
    SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
    FROM C1
    GROUP BY orderyear
)
SELECT orderyear, numcusts
FROM C2
WHERE numcusts > 70;

-- Lets calculate how customers grows :)
WITH YearlyCount AS
(
  SELECT YEAR(orderdate) AS orderyear,
    COUNT(DISTINCT custid) AS numcusts
  FROM Orders
  GROUP BY YEAR(orderdate)
)
SELECT Cur.orderyear,
  Cur.numcusts AS curnumcusts, Prv.numcusts AS prvnumcusts,
  Cur.numcusts - Prv.numcusts AS growth
FROM YearlyCount AS Cur
  LEFT OUTER JOIN YearlyCount AS Prv
    ON Cur.orderyear = Prv.orderyear + 1;

-------------------------------------------------------------------------------
-- Views
-------------------------------------------------------------------------------
DROP VIEW IF EXISTS USACusts;

CREATE VIEW USACusts
AS
SELECT
  custid, companyname, contactname, contacttitle, address,
  city, region, postalcode, country, phone, fax
FROM Customers
WHERE country = 'USA';

SELECT * FROM USACusts;

-- It is important to specify order by not in view creation but in inner query.

SELECT custid, companyname, region
    FROM USACusts
ORDER BY region;
