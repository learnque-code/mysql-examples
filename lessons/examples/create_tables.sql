USE dockerDB;

CREATE TABLE departments (
    id_departments INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE employees (
    id_employees INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    id_departments INT(6) UNSIGNED,
    FOREIGN KEY (id_departments) REFERENCES departments(id_departments)
);

CREATE TABLE persons (
    id_persons INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
	birth_date DATE
);
