-- --------------------------------------------------------------------
-- Example for a simple transaction with ROLLBACK and COMMIT;
-- --------------------------------------------------------------------

CREATE OR REPLACE TABLE `divisible_numbers` (
  `number` INT
);

START TRANSACTION;
INSERT INTO divisible_numbers VALUES (1000);
SELECT * FROM divisible_numbers;
-- COMMIT;
ROLLBACK;
SELECT * FROM divisible_numbers;

-- --------------------------------------------------------------------
-- REPEATABLE READ example
-- --------------------------------------------------------------------

-- T1 transaction
CREATE OR REPLACE TABLE persons
(
    id   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(55)
);

INSERT INTO persons(name)
VALUES ('Vinicius'),
       ('Sergey'),
       ('Iwo'),
       ('Peter');

START TRANSACTION;

SELECT * FROM persons;

-- Go to second console and execute SQL for T2 transaction

-- T2 transaction
START TRANSACTION;

UPDATE persons SET name = 'Kuzmichev' WHERE id = 2;

COMMIT;

SELECT * FROM persons;

-- Try execute again after other T2 transaction did modification.

SELECT * FROM persons;

COMMIT;

SELECT * FROM persons;

/*
With the REPEATABLE READ isolation level, there are thus no dirty reads 
and or non-repeatable reads. Each transaction reads the snapshot established 
by the first read.
*/

-- --------------------------------------------------------------------
-- READ COMMITTED example
-- --------------------------------------------------------------------

/*
The main difference between READ COMMITTED and REPEATABLE READ 
is that with READ COMMITTED each consistent read, even within the same transaction, 
creates and reads its own fresh snapshot. 
This behavior can lead to phantom reads when executing multiple queries inside a 
transaction.
*/

-- First session with T1 transaction
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT * FROM persons WHERE id = 1;
-- Execute T2 sql
-- Second session with T2 transaction
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
UPDATE persons SET name = 'Grippa' WHERE id = 1;
COMMIT;
-- Execute T1 sql again
SELECT * FROM persons WHERE id = 1;
COMMIT;
/* 
The significant advantage of READ COMMITTED is that 
there are no gap locks, allowing the free insertion of new 
records next to locked records.
*/

-- --------------------------------------------------------------------
-- READ UNCOMMITTED example
-- --------------------------------------------------------------------

/* 
With the READ UNCOMMITTED isolation level MySQL performs SELECT statements 
in a non-locking fashion, which means two SELECT statements within the same 
transaction might not read the same version of a row. As we saw earlier, 
this phenomenon is called a dirty read.
*/

-- First session with T1 transaction
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
SELECT * FROM persons WHERE id = 4;
-- Execute T2 sql
-- Second session with T2 transaction
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
UPDATE persons SET name = 'Altmann' WHERE id = 4;
-- Execute T1 sql again
SELECT * FROM persons WHERE id = 4;
COMMIT;
-- --------------------------------------------------------------------
-- SERIALIZABLE example
-- --------------------------------------------------------------------

/*
The most restricted isolation level available in MySQL is SERIALIZABLE. 
This is similar to REPEATABLE READ, but has an additional restriction 
of not allowing one transaction to interfere with another. So, with this 
locking mechanism, 
the inconsistent data scenario is no longer possible.
*/

-- First session with T1 transaction
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
-- Execute T2 sql
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
UPDATE persons SET name = 'Apa' WHERE id = 3;
COMMIT;
-- Second session with T2 transaction
-- Execute T1 sql again
SELECT * FROM persons WHERE id = 3;
COMMIT;
