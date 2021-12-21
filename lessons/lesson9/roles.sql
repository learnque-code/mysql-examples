CREATE ROLE 'application_rw';
CREATE ROLE 'application_ro';

CREATE USER 'bob'@'%' IDENTIFIED BY 'test';
CREATE USER 'kitty'@'%' IDENTIFIED BY 'test';
CREATE DATABASE bob_database;
CREATE TABLE bob_database.persons(
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(55) NOT NULL
);
INSERT INTO bob_database.persons(Name)
VALUES ('test1'),
       ('test2'),
       ('test3');

-- Roles
CREATE ROLE 'application_rw', 'application_ro';

GRANT ALL ON bob_database.* TO 'application_rw';
GRANT SELECT ON bob_database.* TO 'application_ro';

GRANT 'application_rw' TO 'bob'@'localhost';
GRANT 'application_ro' TO 'kitty'@'localhost';

-- Connect to database and set role for concrete user.

-- If you connected as bob you can set this role
SET ROLE 'application_rw';
-- If you connected as kitty you can set this role
SET ROLE 'application_ro';

ALTER USER 'bob'@'%' DEFAULT ROLE 'application_rw';

REVOKE 'application_rw' FROM 'bob'@'%' 