-- Exercise 1
DELIMITER $$
CREATE OR REPLACE FUNCTION GetSumOfTwoNumbers(l INT, r INT) RETURNS INT
BEGIN
    RETURN l + r;
END;$$

DELIMITER ;

SELECT GetSumOfTwoNumbers(5, 7);

-- Exercise 2

CREATE OR REPLACE TABLE `divisible_numbers` (
  `number` INT
);

DELIMITER $$
CREATE OR REPLACE PROCEDURE FillDivisibleNumbers(IN n INT)
BEGIN
    DECLARE a INT DEFAULT 0;
    SET a = 1;
    TRUNCATE divisible_numbers;
    WHILE (a <= 100) DO
        IF (SELECT MOD(a, n) = 0) THEN
            INSERT INTO `divisible_numbers` VALUE(a);
        END IF;
        SET a = a + 1;
    END WHILE;
END;
$$

DELIMITER ;

CALL FillDivisibleNumbers(4);

SELECT `number` FROM divisible_numbers;

-- Exercise 3

DELIMITER $$

CREATE OR REPLACE PROCEDURE GetFib(n INT,OUT out_fib INT)
BEGIN
  DECLARE n_1 INT;
  DECLARE n_2 INT;

  IF (n = 0) THEN
    SET out_fib = 0;
  ELSEIF (n = 1) then
    SET out_fib = 1;
  ELSE
    CALL GetFib(n-1, n_1);
    CALL GetFib(n-2, n_2);
    SET out_fib=(n_1 + n_2);
  END IF;
END; $$

DELIMITER ;

SET SESSION max_sp_recursion_depth = 100;

SET @result = 0;

CALL GetFib(10, @result);

SELECT @result; -- 55

DELIMITER ;

-- Or

DELIMITER $$

CREATE OR REPLACE PROCEDURE GetFib(n INT, OUT out_fib INT)
BEGIN
    DECLARE m INT DEFAULT 0;
    DECLARE k INT DEFAULT 1;
    DECLARE i INT;
    DECLARE tmp INT;

    SET m = 0;
    SET k = 1;
    SET i = 1;

    WHILE (i <= n)
        DO
            SET tmp = m + k;
            SET m = k;
            SET k = tmp;
            SET i = i + 1;
        END WHILE;
    SET out_fib = m;
END;
$$

DELIMITER ;

CALL GetFib(10, @result);

SELECT @result; -- 55

-- Exercise 4

DROP PROCEDURE IF EXISTS GetNums;
DELIMITER $$
CREATE PROCEDURE GetNums(IN low BIGINT, IN high BIGINT)
BEGIN
    PREPARE STMT FROM 'WITH L0 AS (SELECT c FROM (SELECT 1 as c UNION ALL SELECT 1) AS D),
         L1 AS (SELECT 1 AS c
                FROM L0 AS A
                         CROSS JOIN L0 AS B),
         L2 AS (SELECT 1 AS c
                FROM L1 AS A
                         CROSS JOIN L1 AS B),
         L3 AS (SELECT 1 AS c
                FROM L2 AS A
                         CROSS JOIN L2 AS B),
         L4 AS (SELECT 1 AS c
                FROM L3 AS A
                         CROSS JOIN L3 AS B),
         Nums AS (SELECT @i := @i+1 AS rownum FROM L4 AS O, (SELECT @i := 0) AS f)
    SELECT ? + rownum - 1 AS n
    FROM Nums
    ORDER BY rownum LIMIT ?';

    SET @low = low;
    SET @high = high - low + 1;
    EXECUTE STMT USING @low, @high;
END;
$$

DELIMITER ;