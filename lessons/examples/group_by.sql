SELECT
	first_name,
COUNT(*) AS 'occurences count'
FROM
	persons
GROUP BY
	first_name;
    
SELECT
	first_name AS 'we have two or more people
	with such name!'
FROM
	persons
GROUP BY
	first_name
HAVING
COUNT(*) > 1;