DROP TABLE IF EXISTS Friends;

CREATE TABLE Friends
(
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    City NVARCHAR(50) NOT NULL
);

INSERT INTO Friends
(
    Name, City
)
VALUES
(
    'Matt', 'San Francisco'
),
(
    'Dave', 'Oakland'
),
(
    'Andrew', 'Blacksburg'
),
(
    'Todd', 'Chicago'
),
(
    'Blake', 'Atlanta'
),
(
    'Evan', 'Detroit'
),
(
    'Nick', 'New Yourk City'
),
(
    'Zack', 'Seattle'
);

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'Friends';

CREATE INDEX index1 ON Friends(Name);

DROP INDEX IF EXISTS index1 ON Friends;
