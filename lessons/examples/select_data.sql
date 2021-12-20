SELECT
    *
FROM
    persons;

SELECT 
	first_name, last_name
FROM
	persons;
    
SELECT DISTINCT
	first_name
FROM
	persons;
    
SELECT
	first_name, last_name, birth_date
FROM
	persons
WHERE
    -- we want only Michaels to be selected
	first_name = 'Michael';
    
SELECT
    first_name AS name,
    last_name AS surname
FROM
    persons;
    
SELECT
	COUNT(birth_date) AS 'persons count,
	that have date of birthed filled'
FROM
	persons;

SELECT
	employees.first_name,
	employees.last_name,
	departments.name AS 'department name'
FROM
	employees
INNER JOIN
	departments USING(id_departments)