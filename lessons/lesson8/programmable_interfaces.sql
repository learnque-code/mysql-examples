-- Block
BEGIN NOT ATOMIC
  SELECT 'Im inside of block' AS ``;
END;

-- Stored procedure

DELIMITER $$

CREATE OR REPLACE PROCEDURE getNumberOfCustomers (OUT number_of_customers INT)
 BEGIN
  SELECT COUNT(1) INTO number_of_customers FROM Customers;
 END;
$$

DELIMITER ;

CALL simpleproc(@a);

SELECT @a AS number_of_customers;

-- Calculator example
DELIMITER $$

CREATE OR REPLACE PROCEDURE calculateOutput(
    IN value1 float,
    IN Value2 float,
    IN operator char(10),
    OUT Result float
)
BEGIN
    IF operator = 'Add' THEN
        SET result = value1 + value2;
    ELSEIF operator = 'Subtract' THEN
        SET result = value1 - value2;
    ELSEIF operator = 'Multiply' THEN
        SET result = value1 * value2;
    ELSEIF operator = 'Divide' THEN
        SET result = value1 / value2;
    ELSE
        SET result = -1;
    END IF;
END;
$$

DELIMITER ;

CALL CalculateOutput(123, 456, 'Add',  @result);

SELECT @result;
-- Function

DELIMITER $$
CREATE FUNCTION last_customer_order_date (custid INT) RETURNS INT
BEGIN
    RETURN (SELECT MAX(orderdate) FROM Orders AS O WHERE O.custid = custid);
END;
$$

DELIMITER ;

SELECT last_customer_order_date(43);

--

-- Stack overflow: https://stackoverflow.com/questions/5773405/calculate-age-in-mysql-innodb

DROP FUNCTION IF EXISTS GetAge;

DELIMITER $$
CREATE FUNCTION GetAge
(
  birthdate DATE,
  eventdate DATE
) RETURNS INT

BEGIN
    RETURN (
        SELECT YEAR(eventdate) - YEAR(birthdate) - (
            CASE
                WHEN MONTH(birthdate) > MONTH(eventdate) OR
                    (MONTH(@birthday) = MONTH(@today) AND DAY(@birthday) > DAY(@today))
                THEN 1
                ELSE 0
            END
      )
      );
END;
$$

DELIMITER ;

SELECT GetAge('19860305', CURRENT_DATE);

-- If else

IF YEAR(NOW()) <> YEAR(DATE_ADD(NOW(), INTERVAL 1 DAY)) THEN
    SELECT 'Today is the last day of the year.' AS ``;
ELSE
    SELECT 'Today is not the last day of the year.' AS ``;
END IF;

IF YEAR(NOW()) <> YEAR(DATE_ADD(NOW(), INTERVAL 1 DAY)) THEN
BEGIN
    SELECT 'Today is the last day of the year.' AS ``;
END;
ELSE
BEGIN
    SELECT 'Today is not the last day of the year.' AS ``;
END;    
END IF;

IF YEAR(NOW()) <> YEAR(DATE_ADD(NOW(), INTERVAL 1 DAY)) THEN
    SELECT 'Today is the last day of the year.' AS ``;
ELSEIF MONTH(NOW()) <> MONTH(DATE_ADD(NOW(), INTERVAL 1 DAY)) THEN
    SELECT 'Today is the last day of the month but not the last day of the year.' AS ``;
ELSE
    SELECT 'Today is not the last day of the month.' AS ``;
END IF;

-- WHILE ... END WHILE

CREATE OR REPLACE PROCEDURE dowhile(OUT result INT)
BEGIN
  DECLARE v1 INT DEFAULT 5;
  WHILE v1 > 0 DO
    SET v1 = v1 - 1;
  END WHILE;
  SET result = v1;
END;
$$

CALL dowhile(@result);

SELECT @result AS v1;

-- ------

DELIMITER $$

CREATE OR REPLACE PROCEDURE dowhile(OUT result INT)
BEGIN
  DECLARE v1 INT DEFAULT 5;
  myloop: WHILE v1 > 0 DO
    IF v1 = 3 THEN
        LEAVE myloop; -- similar to BREAK
    END IF;
    SET v1 = v1 - 1;
  END WHILE;
  SET result = v1;
END;
$$

CALL dowhile(@result);

SELECT @result AS v1;

-- REPEAT

DELIMITER $$

CREATE OR REPLACE PROCEDURE dorepeat(IN p1 INT, OUT result INT)
  BEGIN
    DECLARE x INT;
    SET x = 0;
    REPEAT SET x = x + 1; UNTIL x >= p1 END REPEAT;
    SET result = x;
  END;
$$

DELIMITER $$

CALL dorepeat(1000, @r);

SELECT @r;

-- Leave example

DELIMITER $$
CREATE OR REPLACE PROCEDURE proc(IN p TINYINT)
whole_proc:
BEGIN
   SELECT 1 AS `info message`;
   IF p < 1 THEN
      LEAVE whole_proc;
   END IF;
   SELECT 2 AS `info message`;
END;
$$

DELIMITER ;

CALL proc(5);

-- SIGNAL

CREATE PROCEDURE test_error(x INT)
BEGIN
   DECLARE errno SMALLINT UNSIGNED DEFAULT 31001;
   SET @errmsg = 'Hello, world!';
   IF x = 1 THEN
      SIGNAL SQLSTATE '45000' SET
        MYSQL_ERRNO = errno,
        MESSAGE_TEXT = @errmsg;
   ELSE
      SIGNAL SQLSTATE '45000' SET
        MYSQL_ERRNO = errno,
        MESSAGE_TEXT = _utf8'Hello, world!';
   END IF;
END;

CREATE PROCEDURE test_error(n INT)
BEGIN
   DECLARE `too_big` CONDITION FOR SQLSTATE '45000';
   IF n > 10 THEN
      SIGNAL `too_big`;
   END IF;
END;

CREATE PROCEDURE test_error()
BEGIN
   DECLARE EXIT HANDLER FOR 1146
   BEGIN
      SIGNAL SQLSTATE '45000' SET
        MESSAGE_TEXT = 'Temporary tables not found; did you call init() procedure?';
   END;
   -- this will produce a 1146 error
   SELECT `c` FROM `temptab`;
END;

-- Cursors
CREATE OR REPLACE TABLE c1(i INT);

CREATE OR REPLACE TABLE c2(i INT);

CREATE OR REPLACE TABLE c3(i INT);

DELIMITER $$

CREATE OR REPLACE PROCEDURE p1()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE x, y INT;
  DECLARE cur1 CURSOR FOR SELECT i FROM lessons.c1;
  DECLARE cur2 CURSOR FOR SELECT i FROM lessons.c2;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;
  OPEN cur2;

  read_loop: LOOP
    FETCH cur1 INTO x;
    FETCH cur2 INTO y;
    IF done THEN
      LEAVE read_loop;
    END IF;
    IF x < y THEN
      INSERT INTO lessons.c3 VALUES (x);
    ELSE
      INSERT INTO lessons.c3 VALUES (y);
    END IF;
  END LOOP;

  CLOSE cur1;
  CLOSE cur2;
END; $$

DELIMITER ;

INSERT INTO c1 VALUES(5),(50),(500);

INSERT INTO c2 VALUES(10),(20),(30);

CALL p1;

SELECT * FROM c3;

-- ---------------------------------------------------------------

CREATE OR REPLACE TABLE CustOrderQtyGrow
(
        custid INT,
        ordermonth INT,
        qty INT,
        _runqry INT,
        PRIMARY KEY(custid, ordermonth)
);

DELIMITER $$
CREATE OR REPLACE PROCEDURE calculateQtyGrow()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE _custid INT;
    DECLARE _prvcustid INT;
    DECLARE _qty SMALLINT;
    DECLARE _ordermonth INT;
    DECLARE _runqry INT;
    -- Must be last declared
    DECLARE cur CURSOR FOR SELECT custid, qty, ordermonth FROM lessons.CustOrders;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    -- ----------------------------------------------------

    OPEN cur;
    FETCH cur INTO _custid, _qty, _ordermonth;
    SET _prvcustid = _custid;
    SET _runqry = 0;

    WHILE NOT done DO
        IF _prvcustid <> _custid THEN
            SET _prvcustid = _custid;
            SET _runqry = 0;
        END IF;

        SET _runqry = _runqry + _qty;
        INSERT INTO CustOrderQtyGrow VALUES(_custid, _ordermonth, _qty, _runqry);

        FETCH cur INTO _custid, _qty, _ordermonth;
    END WHILE;

    CLOSE cur;
END;
$$

DELIMITER ;
CALL calculateQtyGrow();
SELECT * FROM CustOrderQtyGrow;

-- Triggers

-- --------------------------------------------
-- Table creation part
-- --------------------------------------------

CREATE TABLE animals
(
    id   mediumint(9) NOT NULL AUTO_INCREMENT,
    name char(30) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE animal_count
(
    animals int
);

INSERT INTO animal_count (animals)
VALUES (0);

-- --------------------------------------------

-- Create and Populate table Nums
DROP TABLE IF EXISTS `Nums`;
CREATE TABLE `Nums`
(
    `n` INT NOT NULL,
    CONSTRAINT PK_Nums PRIMARY KEY (`n`)
);

INSERT INTO `Nums` VALUES (1);

DELIMITER $$
CREATE PROCEDURE PopulateNumbers()
BEGIN
    DECLARE max, rc INT;
    SET max = 100000;
    SET rc = 1;
    WHILE rc * 2 <= max
        DO
            INSERT INTO Nums SELECT n + rc FROM Nums;
            SET rc = rc * 2;
        END WHILE;
END $$

DELIMITER ;

CALL PopulateNumbers();

-- --------------------------------------------
-- Triggers creation part
-- --------------------------------------------

DELIMITER $$
CREATE TRIGGER increment_animal
    AFTER INSERT
    ON animals
    FOR EACH ROW
BEGIN
    UPDATE animal_count SET animal_count.animals = animal_count.animals + 1;
END;
$$

DELIMITER ;

INSERT INTO animals(name) VALUES ('Spygle'), ('Gyle');

SELECT * FROM animal_count;

-- Validation data before insert and update

DELIMITER $$
CREATE TRIGGER `Check_employee_birthday_insert`
    BEFORE INSERT
    ON `Employees`
    FOR EACH ROW
BEGIN
    IF (NEW.`birthdate` > SYSDATE()) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Birth day must be less than current date';
    END IF;
END;
$$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER `Check_employee_birthday_update`
    BEFORE UPDATE
    ON `Employees`
    FOR EACH ROW
BEGIN
    IF (NEW.`birthdate` > SYSDATE()) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Birth day must be less than current date';
    END IF;
END;
$$

-- We can improve it for checking is user have more than 18 years

SELECT DATE_ADD('2015-03-10', INTERVAL -18 YEAR);

-- Trigger used to autid

CREATE OR REPLACE TABLE `persons`
(
    `id`         int         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `first_name` varchar(50) NOT NULL,
    `last_name`  varchar(50) NOT NULL,
    `birthday`   date        NOT NULL
);

CREATE OR REPLACE TABLE `persons_audit`
(
    `person_id`  int         NOT NULL,
    `first_name` varchar(50) NOT NULL,
    `last_name`  varchar(50) NOT NULL,
    `action`     varchar(50) CHECK (`action` IN ('UPDATED', 'INSERTED', 'DELETED')),
    `timestamp`  datetime    NOT NULL
);

DELIMITER $$
CREATE OR REPLACE TRIGGER trg_persons_audit_update
    AFTER UPDATE
    ON persons
    FOR EACH ROW
BEGIN
    INSERT persons_audit
    SET persons_audit.person_id  = NEW.id,
        persons_audit.first_name = NEW.first_name,
        persons_audit.last_name  = NEW.last_name,
        persons_audit.timestamp  = NOW(),
        persons_audit.action     = 'UPDATED';
END;
$$

CREATE OR REPLACE TRIGGER trg_persons_audit_insert
    AFTER INSERT
    ON persons
    FOR EACH ROW
BEGIN
    INSERT persons_audit
    SET persons_audit.person_id  = NEW.id,
        persons_audit.first_name = NEW.first_name,
        persons_audit.last_name  = NEW.last_name,
        persons_audit.timestamp  = NOW(),
        persons_audit.action     = 'INSERTED';
END;
$$

CREATE OR REPLACE TRIGGER trg_persons_audit_delete
    AFTER DELETE
    ON persons
    FOR EACH ROW
BEGIN
    INSERT persons_audit
    SET persons_audit.person_id  = OLD.id,
        persons_audit.first_name = OLD.first_name,
        persons_audit.last_name  = OLD.last_name,
        persons_audit.timestamp  = NOW(),
        persons_audit.action     = 'DELETED';
END;
$$

DELIMITER ;

-- --------------------------------------------
-- Prepared statements
-- --------------------------------------------

PREPARE stm FROM 'SELECT * FROM lessons.Orders WHERE orderid BETWEEN ? AND ?';
SET @a = 10248;
SET @b = 10250;
EXECUTE stm USING @a, @b;
DEALLOCATE PREPARE stm;

-- ---

SET @s = 'SELECT SQRT(POW(?,2) + POW(?,2)) AS result';
PREPARE stmt2 FROM @s;
SET @a = 6;
SET @b = 8;
EXECUTE stmt2 USING @a, @b;