DROP TABLE IF EXISTS Owners;

CREATE TABLE Owners(
   firstName VARCHAR(25) NOT NULL,
   lastName VARCHAR(25) NOT NULL
);

CREATE OR REPLACE TABLE Owners(
    firstname NVARCHAR(25) NOT NULL,
    lastname NVARCHAR(25) NOT NULL
);

ALTER TABLE Owners ADD Email NVARCHAR(10);
ALTER TABLE Owners MODIFY Email NVARCHAR(55);
ALTER TABLE Owners ADD Something INT;
ALTER TABLE Owners MODIFY Something INT;
ALTER TABLE Owners DROP COLUMN Something;

ALTER TABLE Owners MODIFY Email NVARCHAR(55) AFTER lastname;

-- ---------------------------------------------------

DROP TABLE IF EXISTS HelloWorld;

CREATE TABLE HelloWorld (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Description VARCHAR(1000)
);

-- DML
INSERT INTO HelloWorld (`Description`) VALUES ('Hello World');
INSERT INTO HelloWorld (`Description`) VALUES ('Hello World 2');
INSERT INTO HelloWorld SET `Description` = 'Hello world 3';

-- -----------------------------------------------------------------------------

ALTER TABLE HelloWorld 
    ADD Email varchar(255);

ALTER TABLE HelloWorld 
    DROP COLUMN Email;

ALTER TABLE HelloWorld 
    ADD Email varchar(255);

ALTER TABLE HelloWorld 
    MODIFY COLUMN Email varchar(300);

ALTER TABLE HelloWorld 
    MODIFY COLUMN Description VARCHAR(100);

ALTER TABLE HelloWorld 
    MODIFY COLUMN Description INT;

-------------------------------------------------------------------

DROP TABLE IF EXISTS HelloWorld2; 
-- Only for MySQL
CREATE TABLE HelloWorld2
(
    ID int AUTO_INCREMENT NOT NULL,
    CONSTRAINT PK_ID PRIMARY KEY(ID)
);

ALTER TABLE HelloWorld2
    ADD CONSTRAINT PK_ID PRIMARY KEY(ID);

-- Delete the primary key constraint.  
ALTER TABLE HelloWorld2
    DROP PRIMARY KEY;

-- Add ptimary key later

CREATE OR REPLACE TABLE test3 (
    id INT NOT NULL,
    col2 NVARCHAR(50),
    col3 NVARCHAR(50)
);

alter table test3
    add constraint
        primary key (id);

alter table test3
    modify id int auto_increment;

alter table test3 drop primary key;

-- Foreign key

DROP TABLE IF EXISTS Cars;

CREATE TABLE Cars (
    Id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Type VARCHAR(50) NOT NULL,
    Number VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS Trailers;

CREATE TABLE Trailers (
    Id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Number VARCHAR(50) NOT NULL,
    CarId INT,
    FOREIGN KEY (CarId) REFERENCES Cars(Id) ON DELETE CASCADE
);

alter table Trailers
    add constraint Trailers_Cars_id_fk
        foreign key (CarId) references Cars (id)
            on delete cascade;

ALTER TABLE Trailers ADD
    CONSTRAINT fk_trailers_carid FOREIGN KEY(CarId) REFERENCES Cars(Id);

ALTER TABLE Trailers DROP FOREIGN KEY fk_trailers_carid;

SELECT CONSTRAINT_NAME,
   TABLE_SCHEMA ,
   TABLE_NAME,
   CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA='lessons';

-- ----------------------------------------------------------------------------

CREATE TABLE pet_owners (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(100),
    PRIMARY KEY(`Id`)
);

CREATE TABLE pets (
  petId INT NOT NULL AUTO_INCREMENT,
  race VARCHAR(45) NOT NULL,
  dateOfBirth DATE NOT NULL,
  ownerId INT NOT NULL,
  PRIMARY KEY (petId),
  CONSTRAINT fk_pets_owners
    FOREIGN KEY (ownerId)
    REFERENCES pet_owners (Id));

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'pets';

DROP TABLE IF EXISTS Parent;
CREATE TABLE Parent (
    Id INT AUTO_INCREMENT NOT NULL,
    Name VARCHAR(250),
    CONSTRAINT PK_Parent_Id PRIMARY KEY(Id)
);

-- -----------------------------------------------------------------------------
-- On delete cascade
-- -----------------------------------------------------------------------------

DROP TABLE IF EXISTS Childs;
DROP TABLE IF EXISTS Parents;

CREATE TABLE Parents (
    Id INT AUTO_INCREMENT NOT NULL,
    Name VARCHAR(250),
    CONSTRAINT PK_Parent_Id PRIMARY KEY(Id)
);

CREATE TABLE Childs (
    Id INT AUTO_INCREMENT NOT NULL,
    Name VARCHAR(250),
    ParentId INT,
    CONSTRAINT PK_Childs_Id PRIMARY KEY(Id),
    CONSTRAINT FK_Parents_Id FOREIGN KEY(ParentId) REFERENCES Parents(Id) ON DELETE CASCADE
);

-------------------------------------------------------------------------------
-- Unique constraint
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS GrandChild;
CREATE TABLE GrandChild
(
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, -- Primary Key column
    ColumnName2 VARCHAR(50) NOT NULL,
    ColumnName3 VARCHAR(50) NOT NULL,
    CONSTRAINT AK_ColumnName2 UNIQUE(ColumnName2)
);

-- Create the table in the specified database
DROP TABLE IF EXISTS Person;
CREATE TABLE Person
(
    Id INT NOT NULL PRIMARY KEY, -- Primary Key column
    PasswordHash VARCHAR(50) NOT NULL,
    PasswordSalt VARCHAR(50) NOT NULL
);

ALTER TABLE Person
    ADD CONSTRAINT AK_Password UNIQUE (PasswordHash, PasswordSalt);

-------------------------------------------------------------------------------
-- Check constraint
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS Drinks;
CREATE TABLE Drinks
(
    Id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Name NVARCHAR(125) NOT NULL
);

ALTER TABLE Drinks
    ADD CONSTRAINT check_name_in_interval CHECK (`Name` IN ('Pepsi', 'Cola', 'Fanta'));


ALTER TABLE Drinks
    ADD CONSTRAINT check_not_empty_name CHECK (TRIM(`Name`) <> '');

-------------------------------------------------------------------------------
-- One to one
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS MySalaries;
DROP TABLE IF EXISTS MyEmployees;

CREATE TABLE MyEmployees (
    ID    INT PRIMARY KEY,
    Name  VARCHAR(50)
);

CREATE TABLE MySalaries (
    EmployeeID    INT UNIQUE NOT NULL,
    SalaryAmount  INT
);

ALTER TABLE MySalaries
ADD CONSTRAINT FK_Salary_Employee FOREIGN KEY(EmployeeID)
    REFERENCES Employee(ID);

INSERT INTO MyEmployees (
    ID,
    Name
)
VALUES
    (1, 'Ram'),
    (2, 'Rahim'),
    (3, 'Pankaj'),
    (4, 'Mohan');

INSERT INTO MySalaries (
    EmployeeID,
    SalaryAmount
)
VALUES
    (1, 2000),
    (2, 3000),
    (3, 2500),
    (4, 3000);


SELECT E.ID, E.Name, S.SalaryAmount FROM  Employee AS E
LEFT OUTER JOIN Salary AS S
    ON E.ID = S.EmployeeID;