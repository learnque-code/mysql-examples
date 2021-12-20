SELECT
	COUNT(*) AS 'persons count'
FROM
	persons;
    
SELECT
	MAX(first_name) AS 'alphabetically max first name'
FROM
	persons;

SELECT
	AVG(birth_date) AS 'average birth date'
FROM
	persons;