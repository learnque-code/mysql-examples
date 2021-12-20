SELECT *
FROM employees
ORDER BY last_name, first_name;

SELECT *
FROM employees
ORDER BY last_name DESC;

SELECT *
FROM employees
LIMIT 3;

SELECT *
FROM employees
LIMIT 3, 2;

SELECT first_name
FROM employees
	UNION
SELECT last_name
FROM employees;

SELECT
	CASE
		WHEN first_name LIKE 'M%' THEN 'name starts with M'
		WHEN first_name LIKE 'J%' THEN 'name starts with J'
		ELSE 'name does not start with M or J'
	END AS some_column_name
FROM employees;

SELECT
	*
FROM
	employees
WHERE
	EXISTS (
		SELECT *
		FROM departments
		WHERE departments.id_departments = 
        employees.id_departments
	);
    
SELECT
	(SELECT ...) AS column_name,
	...
FROM
	(SELECT ...) AS alias
	...
WHERE
	(SELECT ...) > 123
	AND
	column_abc IN (SELECT ...)