SELECT
	*
FROM
	employees
INNER JOIN
	departments ON
	employees.id_departments = 
    departments.id_departments;
    
SELECT
	employees.first_name,
	employees.last_name,
	departments.name AS 'department name'
FROM
	employees
INNER JOIN
	departments ON
	employees.id_departments = 
    departments.id_departments;
    
SELECT
	e.first_name,
	e.last_name,
	d.name AS 'department name'
FROM
	employees AS e
INNER JOIN
	departments AS d ON e.id_departments =
    d.id_departments;
    
SELECT
    employees.first_name,
    employees.last_name,
    departments.name AS 'department name'
FROM
    employees
INNER JOIN
    departments USING(id_departments);
    
SELECT
	*
FROM
	employees,
	departments
WHERE
	employees.id_departments = 
    departments.id_departments;
    
SELECT
	employees.first_name,
	employees.last_name,
	departments.name AS 'department name'
FROM
	employees
LEFT JOIN
	departments USING(id_departments)
    
SELECT
	*
FROM
	employees
CROSS JOIN
	departments
    
SELECT
	*
FROM
	employees,
	departments