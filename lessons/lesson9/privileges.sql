SELECT * FROM mysql.user WHERE user = 'root';
SELECT * FROM mysql.global_priv WHERE user = 'root';
SELECT * FROM mysql.tables_priv WHERE user = 'root';
SELECT * FROM mysql.columns_priv WHERE user = 'root';

-- Create user, database, table, grant privileges

-- As root user
CREATE USER 'bob'@'%' IDENTIFIED BY 'test';
CREATE DATABASE bob_database;
CREATE TABLE bob_database.persons(
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(55) NOT NULL
);
INSERT INTO bob_database.persons(Name)
VALUES ('test1'),
       ('test2'),
       ('test3');

GRANT SELECT ON bob_database.* TO 'bob'@'%';

-- As bob user in other connection
SELECT * FROM persons;
UPDATE persons SET Name = 'bob1' WHERE Id=1; --  will throw exception


