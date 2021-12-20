CREATE TABLE employees_history (
	id_employees INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    modification_date DATE,
    old_first_name VARCHAR(30) NOT NULL,
    old_last_name VARCHAR(30) NOT NULL,
    new_first_name VARCHAR(30) NOT NULL,
    new_last_name VARCHAR(30) NOT NULL
);

DELIMITER $$
CREATE TRIGGER store_history BEFORE UPDATE ON employees
	FOR EACH ROW
	BEGIN
		INSERT INTO employees_history
		VALUES(new.id_employees, NOW(),
		old.first_name, old.last_name,
		new.first_name, new.last_name);
	END$$
UPDATE employees SET first_name='Lucy' WHERE first_name='Kate';
