-------------------------------------------------------------------------------
-- INSERT INTO ... SELECT
-------------------------------------------------------------------------------
/*
    This example show how to combine data 
    with set operators
*/

USE lessons;

DROP TABLE IF EXISTS Locations;

CREATE TABLE Locations(
    country varchar(15),
    region varchar(15),
    city varchar(15)
);

INSERT INTO Locations(country, region, city)
SELECT country, region, city FROM Customers
EXCEPT
SELECT country, region, city
FROM Employees;

-- -----------------------------------------------------------------------------
-- CREATE TABLE LIKE
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS MyCustomers;

CREATE TABLE MyCustomers LIKE Customers;
-- -----------------------------------------------------------------------------
-- CREATE TABLE SELECT
-- -----------------------------------------------------------------------------

CREATE TABLE Locations AS SELECT country, region, city FROM Customers;

-- -----------------------------------------------------------------------------
-- export example
-- -----------------------------------------------------------------------------

SELECT @@secure_file_priv;

SELECT country, region, country
    FROM Customers
    INTO OUTFILE 'locations.csv'
    FIELDS TERMINATED BY ',' LINES TERMINATED BY ';';

-------------------------------------------------------------------------------
-- Merge
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS MyCustomers, MyCustomersStage;

CREATE TABLE MyCustomers
(
  custid      INT         NOT NULL PRIMARY KEY,
  companyname VARCHAR(25) NOT NULL,
  phone       VARCHAR(20) NOT NULL,
  address     VARCHAR(50) NOT NULL
);

INSERT INTO MyCustomers(custid, companyname, phone, address)
VALUES
  (1, 'cust 1', '(111) 111-1111', 'address 1'),
  (2, 'cust 2', '(222) 222-2222', 'address 2'),
  (3, 'cust 3', '(333) 333-3333', 'address 3'),
  (4, 'cust 4', '(444) 444-4444', 'address 4'),
  (5, 'cust 5', '(555) 555-5555', 'address 5');

CREATE TABLE MyCustomersStage
(
  custid      INT         NOT NULL PRIMARY KEY,
  companyname VARCHAR(25) NOT NULL,
  phone       VARCHAR(20) NOT NULL,
  address     VARCHAR(50) NOT NULL,
);

INSERT INTO MyCustomersStage(custid, companyname, phone, address)
VALUES
  (2, 'AAAAA', '(222) 222-2222', 'address 2'),
  (3, 'cust 3', '(333) 333-3333', 'address 3'),
  (5, 'BBBBB', 'CCCCC', 'DDDDD'),
  (6, 'cust 6 (new)', '(666) 666-6666', 'address 6'),
  (7, 'cust 7 (new)', '(777) 777-7777', 'address 7');

SELECT * FROM MyCustomers;
SELECT * FROM MyCustomersStage;

-- UPDATE REPLACE?

-------------------------------------------------------------------------------
-- Updating with LIMIT, OFFSET FETCH
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS MyOrders;

CREATE TABLE MyOrders
(
  orderid        INT          NOT NULL,
  custid          INT          NULL,
  empid          INT          NOT NULL,
  orderdate      DATE          NOT NULL,
  requireddate    DATE          NOT NULL,
  shippeddate    DATE          NULL,
  shipperid      INT          NOT NULL,
  freight         DECIMAL(10, 2) NOT NULL DEFAULT(0.00),
  shipname        NVARCHAR(40) NOT NULL,
  shipaddress    NVARCHAR(60) NOT NULL,
  shipcity        NVARCHAR(15) NOT NULL,
  shipregion      NVARCHAR(15) NULL,
  shippostalcode NVARCHAR(10) NULL,
  shipcountry    NVARCHAR(15) NOT NULL,
  CONSTRAINT PK_Orders PRIMARY KEY(orderid)
);

INSERT INTO MyOrders SELECT * FROM Orders;
DELETE FROM MyOrders LIMIT 5;
UPDATE MyOrders SET freight := freight + 10.00 LIMIT 50;

-------------------------------------------------------------------------------
-- Window function
-------------------------------------------------------------------------------
SELECT empid,
       ordermonth,
       val,
       SUM(val) OVER (PARTITION BY empid
           ORDER BY ordermonth) AS runval
FROM EmpOrders;

SELECT custid,
       empid,
       freight,
       SUM(freight) OVER (PARTITION BY custid) as sum_freight
FROM Orders
ORDER BY custid, empid;

-- The same approach with group by. Details are hidden
SELECT custid,
       SUM(freight) sum_freight
FROM Orders
GROUP BY custid;


-- The same approach with corellated subquery. Details are not hidden
SELECT
       O1.custid, O1.empid, O1.freight,
       (SELECT SUM(O2.freight) FROM Orders O2 WHERE O2.custid = O1.custid) AS sum_freight
FROM Orders O1
ORDER BY custid, empid;


-- Do not forget to explain how to do advanced delete and update!!!
UPDATE ... INNER JOIN ...