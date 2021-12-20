-- Solution 1
DROP TABLE IF EXISTS CustomersWithOrders;

CREATE TABLE CustomersWithOrders
(
  custid      INT         NOT NULL PRIMARY KEY,
  companyname VARCHAR(40) NOT NULL,
  country     VARCHAR(15) NOT NULL,
  region      VARCHAR(15) NULL,
  city        VARCHAR(15) NOT NULL
);

INSERT INTO CustomersWithOrders(custid, companyname, country, region, city)
  VALUES(100, 'Coho Winery', 'USA', 'WA', 'Redmond');

INSERT INTO CustomersWithOrders(custid, companyname, country, region, city)
  SELECT custid, companyname, country, region, city
  FROM Customers AS C
  WHERE EXISTS
    (SELECT * FROM Orders AS O
     WHERE O.custid = C.custid);

-- Solution 2
DROP TABLE IF EXISTS Orders2014_2016;

CREATE TABLE Orders2014_2016
(
    orderid        int                         not null,
    custid         int                         null,
    empid          int                         not null,
    orderdate      date                        not null,
    requireddate   date                        not null,
    shippeddate    date                        null,
    shipperid      int                         not null,
    freight        decimal(10, 2) default 0.00 not null,
    shipname       varchar(40) charset utf8mb3 not null,
    shipaddress    varchar(60) charset utf8mb3 not null,
    shipcity       varchar(15) charset utf8mb3 not null,
    shipregion     varchar(15) charset utf8mb3 null,
    shippostalcode varchar(10) charset utf8mb3 null,
    shipcountry    varchar(15) charset utf8mb3 not null
);

INSERT INTO Orders2014_2016 
SELECT * FROM Orders
WHERE orderdate >= '20140101'
    AND orderdate < '20170101';

-- Solution 3

CREATE TABLE OrdersForDeletion SELECT * FROM Orders;

DELETE FROM OrdersForDeletion
WHERE orderdate < '20140801';

-- Solution 4

CREATE OR REPLACE TABLE OrdersForDeletion SELECT * FROM Orders;

DELETE FROM OrdersForDeletion
WHERE EXISTS
  (SELECT 1
   FROM Customers AS C
   WHERE OrdersForDeletion.custid = C.custid
     AND C.country = 'Brazil');

DELETE
FROM OrdersForDeletion
WHERE custid IN (
    SELECT custid
    FROM Customers
    WHERE country = 'Brazil'
);

-- Solution 5

CREATE OR REPLACE TABLE CustomersForUpdate SELECT * FROM Customers;

UPDATE CustomersForUpdate
  SET region = '<None>'
WHERE region IS NULL;

-- Solution 6
CREATE OR REPLACE TABLE OrdersForUpdate SELECT * FROM Orders;

UPDATE OrdersForUpdate AS OU
INNER JOIN Customers AS C on OU.custid = C.custid
  SET OU.shipcountry = C.country,
      OU.shipregion = C.region,
      OU.shipcity = C.city
WHERE C.country = 'UK';