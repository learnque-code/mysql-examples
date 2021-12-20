DELETE 
FROM
	employees
WHERE
	employees.id_employees = 4;
    
SELECT * FROM employees;
SELECT * FROM departments;

DROP TABLE employees;
    
DELETE
	employees
FROM
	employees
INNER JOIN
	departments USING(id_departments)
WHERE
	id_departments = 2;
