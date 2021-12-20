-- Solution 1
DROP TABLE IF EXISTS MyEmployees;

CREATE TABLE MyEmployees
(
    EmployeeId INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth Date NOT NULL,
    PostalAddress VARCHAR(50)
);

ALTER TABLE MyEmployees
    ADD PhoneNumber  VARCHAR(50);

ALTER TABLE MyEmployees
    ADD Email  NVARCHAR(50);

ALTER TABLE MyEmployees
    ADD Salary VARCHAR(50);

ALTER TABLE MyEmployees
    DROP COLUMN PostalAddress;


DROP TABLE IF EXISTS EmployeeAddresses;

CREATE TABLE EmployeeAddresses
(
    Country VARCHAR(50) NOT NULL
);

ALTER TABLE MyEmployees RENAME COLUMN EmployeeId TO Employee_id;
RENAME TABLE MyEmployees TO BITEmployees;

DROP TABLE IF EXISTS BITEmployees;

-- Solution 2
DROP TABLE BITEmployees;

CREATE TABLE BITEmployees
(
    Employee_Id INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth Date NOT NULL,
    PostalAddress VARCHAR(50)
);

ALTER TABLE BITEmployees
    ADD PhoneNumber VARCHAR(50);

ALTER TABLE BITEmployees
    ADD Email VARCHAR(50);

ALTER TABLE BITEmployees
    ADD Salary VARCHAR(50);

ALTER TABLE BITEmployees
    DROP COLUMN PostalAddress;

INSERT INTO BITEmployees
(
    Employee_Id, FirstName, LastName, DateOfBirth, PhoneNumber, Email, Salary
)
VALUES
(
    1, N'John', N'Johnson', '1975-01-01', '0-800-800-314', 'john@johnson.com', 1000
);

UPDATE BITEmployees
SET
    DateOfBirth = '1980-01-01'
WHERE Employee_Id = 1;

DELETE FROM BITEmployees;
-- Or
TRUNCATE TABLE BITEmployees;

INSERT INTO BITEmployees
(
    Employee_Id, FirstName, LastName, DateOfBirth, PhoneNumber, Email, Salary
)
VALUES
(
    1, N'John', N'Johnson', '1975-01-01', '0-800-800-314', 'john@johnson.com', 1000
),
(
    2, N'James', N'Jameson', '1985-02-02', '0-800-800-999', 'james@jameson.com', 2000
);

-- Solution 3
DROP TABLE IF EXISTS BITEmployees;

CREATE TABLE BITEmployees
(
    Employee_Id INT NOT NULL, -- Primary Key column
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth Date NOT NULL,
    PostalAddress VARCHAR(50)
);

ALTER TABLE BITEmployees
    ADD PhoneNumber VARCHAR(50);

-- Add a new column 'Email' to table 'MyEmployees' in schema 'dbo'
ALTER TABLE BITEmployees
    ADD Email VARCHAR(50);

ALTER TABLE BITEmployees
    ADD Salary VARCHAR(50);

ALTER TABLE BITEmployees
    DROP COLUMN PostalAddress;

INSERT INTO BITEmployees
(
    Employee_Id, FirstName, LastName, DateOfBirth, PhoneNumber, Email, Salary
)
VALUES
(
    1, N'John', N'Johnson', '1975-01-01', '0-800-800-314', 'john@johnson.com', 1000
);

UPDATE BITEmployees
SET
    DateOfBirth = '1980-01-01'
WHERE Employee_Id = 1;

DELETE FROM BITEmployees;
-- Or
TRUNCATE TABLE BITEmployees;


INSERT INTO BITEmployees
(
    Employee_Id, FirstName, LastName, DateOfBirth, PhoneNumber, Email, Salary
)
VALUES
(
    1, N'John', N'Johnson', '1975-01-01', '0-800-800-314', 'john@johnson.com', 1000
),
(
    2, N'James', N'Jameson', '1985-02-02', '0-800-800-999', 'james@jameson.com', 2000
);

ALTER TABLE BITEmployees
    DROP COLUMN Employee_Id;

ALTER TABLE BITEmployees
    ADD Employee_Id INT AUTO_INCREMENT NOT NULL;

ALTER TABLE BITEmployees
    ADD CONSTRAINT PK_Employee_Id PRIMARY KEY(Employee_Id);

INSERT INTO BITEmployees
(
    FirstName, LastName, DateOfBirth, PhoneNumber, Email, Salary
)
VALUES
(
    N'John', N'Johnson', '1975-01-01', '0-800-800-314', 'john@johnson.com', 1000
),
(
    N'James', N'Jameson', '1985-02-02', '0-800-800-999', 'james@jameson.com', 2000
);

DROP TABLE Departments;

CREATE TABLE Departments
(
    DepartmentId INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- Primary Key column
    Name NVARCHAR(50) NOT NULL
);

INSERT INTO Departments
(
    Name
)
VALUES
(
    N'HR'
),
(
    N'Finance'
);

ALTER TABLE BITEmployees
    ADD DepartmentId INT NULL;

UPDATE BITEmployees
SET
    DepartmentId = 1
WHERE Employee_Id = 1;

UPDATE BITEmployees
SET
    DepartmentId = 2
WHERE Employee_Id = 2;

DELETE FROM Departments
WHERE DepartmentId = 1;

UPDATE BITEmployees
SET
    DepartmentId = 2
WHERE EmployeeId = 1;

ALTER TABLE BITEmployees
ADD CONSTRAINT FK_BITEmployees_DepartmentId FOREIGN KEY(DepartmentId) REFERENCES Departments(DepartmentId);

-- Solution 4
ALTER TABLE BITEmployees
    ADD ManagerId INT REFERENCES BITEmployees(EmployeeId);

INSERT INTO BITEmployees
(
    FirstName, LastName, DateOfBirth, PhoneNumber, Email, Salary
)
VALUES
(
    N'Sophie', N'Shopie', '1975-01-01', '0-800-800-314', 'sophie@sophie.com', 1000
);

UPDATE BITEmployees
SET
    ManagerId = 3
WHERE EmployeeId IN (1, 2);

DROP TABLE IF EXISTS Projects;
CREATE TABLE Projects
(
    ProjectId INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Description NVARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS EmployeeProject;

CREATE TABLE EmployeeProject
(
    EmployeeProjectId     INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Employee_Id            INT REFERENCES BITEmployees(Employee_Id),
    ProjectId             INT  REFERENCES Projects(ProjectId)
);

INSERT INTO Projects
(
    Description
)
VALUES
(
    N'Python - Cinema Web App'
),
(
    N'Java - Fitness Web App'
);

-- Insert rows into table 'EmployeeProject' in schema 'dbo'
INSERT INTO EmployeeProject
(
    Employee_Id, ProjectId
)
VALUES
(
    1, 2 -- you can write a select for getting value.
),
(
    2, 1 -- you can write a select for getting value.
);
-- Something like that
/*
(
    (SELECT EmployeeId FROM BITEmployees WHERE LastName = 'Sophie'), 'Project manager'),
    (SELECT ProjectId FROM Projects WHERE Description = 'Python - Cinema Web App')
)
*/
