INSERT INTO persons 
	(first_name, last_name, birth_date) 
VALUES
	('Michael', 'Harding', '1937-07-25'),
	('Ariana', 'Fox', '1992-09-30'),
	('Madelyn', 'Flynn', '1953-03-05'),
	('Fynley', 'Dodd', '1973-03-27'),
	('Aliza', 'Wyatt', '1969-02-14'),
    ('Michael', 'Doss', '1964-12-11');
    
INSERT INTO persons 
	(first_name, last_name) 
VALUES
	('John', 'Unknown');
    
INSERT INTO departments 
	(name) 
VALUES
	('Sales'),
	('IT'),
	('HR');

INSERT INTO employees 
	(first_name, last_name, id_departments) 
VALUES
	('John', 'Smith', 1),
	('John', 'Cage', 2),
	('Jadine', 'Mcclain', 3),
	('Ibraheem', 'Mcfadden', 1),
	('Kade', 'Christie', 2);

INSERT INTO employees
	(first_name, last_name, id_departments)
SELECT
	CONCAT(first_name, ' - duplicate'),
	CONCAT(last_name, ' - duplicate'),
	id_departments
FROM
	employees;
