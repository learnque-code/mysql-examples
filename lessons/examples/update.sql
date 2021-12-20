UPDATE
	employees
SET
	first_name = 'Jadine'
WHERE
	id_employees = 3;
    
UPDATE 
	employees
INNER JOIN 
	departments ON employees.id_employees = 
    departments.id_departments
SET 
	employees.first_name = CONCAT(employees.first_name,
	' from the HR dept')
WHERE 
	departments.name = 'HR';
