CREATE VIEW employees_with_dept_name AS
SELECT
	employees.*,
	departments.name AS department_name
FROM
	employees
LEFT JOIN
	departments USING(id_departments);
    
SELECT * FROM employees_with_dept_name;