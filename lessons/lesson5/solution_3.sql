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