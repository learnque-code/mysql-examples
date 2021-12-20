DELIMITER $$
CREATE FUNCTION add_two_ints(
	a INT, -- parametr a of type int
	b INT -- parametr b of type int
) RETURNS INT -- function returns an int
BEGIN -- body of the function
RETURN a + b;
END$$
-- example usage:
SELECT add_two_ints(3, 5);

DELIMITER $$
CREATE FUNCTION my_sign (a INT) 
	RETURNS INT
	BEGIN
		IF a > 0 THEN RETURN 1;
		ELSEIF a = 0 THEN RETURN 0;
		ELSE RETURN -1;
		END IF;
	END$$
SELECT my_sign(2);

DELIMITER $$
-- Power function (works if b is a positive number).
CREATE FUNCTION my_power (a INT, b INT) 
	RETURNS INT
	BEGIN
-- declaration of a variable named result of type INT with
-- initial value 1.
-- variables have to be declared at the start of the
-- BEGIN - END code block.
	DECLARE result INT DEFAULT 1;
	WHILE b > 0 DO -- while loop (with b > 0 condition)
		SET result = result * a; -- set variable's value
		SET b = b - 1;
	END WHILE;
	RETURN result;
END$$
SELECT my_power(2, 5);