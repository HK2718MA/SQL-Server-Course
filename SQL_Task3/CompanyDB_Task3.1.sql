CREATE DATABASE CompanyDB;
GO

USE CompanyDB;
GO

CREATE SCHEMA hr;
GO

CREATE TABLE hr.Departments (
    DeptID INT PRIMARY KEY,
    DeptName NVARCHAR(100) NOT NULL UNIQUE,
    Location NVARCHAR(100),
    ManagerID INT
);

CREATE TABLE hr.Employees (
    EmpID INT PRIMARY KEY IDENTITY(1,1),
    FName NVARCHAR(50) NOT NULL,
    LName NVARCHAR(50) NOT NULL,
    SSN CHAR(14) UNIQUE NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    BirthDate DATE,
    HireDate DATETIME DEFAULT GETDATE(),
    Email NVARCHAR(100) UNIQUE,
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES hr.Departments(DeptID)
);


ALTER TABLE hr.Departments
ADD CONSTRAINT FK_Departments_Manager
FOREIGN KEY (ManagerID) REFERENCES hr.Employees(EmpID);


CREATE TABLE hr.Projects (
    ProjID INT PRIMARY KEY,
    ProjName NVARCHAR(100) NOT NULL,
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES hr.Departments(DeptID)
);

CREATE TABLE hr.EmployeeProjects (
    EmpID INT,
    ProjID INT,
    PRIMARY KEY (EmpID, ProjID),
    FOREIGN KEY (EmpID) REFERENCES hr.Employees(EmpID),
    FOREIGN KEY (ProjID) REFERENCES hr.Projects(ProjID)
);

CREATE TABLE hr.Dependents (
    DepID INT PRIMARY KEY IDENTITY(1,1),
    DepName NVARCHAR(100) NOT NULL,
    Relationship NVARCHAR(50),
    EmpID INT,
    FOREIGN KEY (EmpID) REFERENCES hr.Employees(EmpID) ON DELETE CASCADE
);


ALTER TABLE hr.Employees
ADD Nationality NVARCHAR(50);

ALTER TABLE hr.Projects
ADD CONSTRAINT FK_Projects_Manager
FOREIGN KEY (DeptID) REFERENCES hr.Departments(DeptID);

ALTER TABLE hr.Employees
ALTER COLUMN FName NVARCHAR(100);


ALTER TABLE hr.Departments
DROP CONSTRAINT FK_Departments_Manager;

INSERT INTO hr.Departments (DeptID, DeptName, Location)
VALUES (1, 'IT', 'Cairo'), (2, 'HR', 'Alex'), (3, 'Finance', 'Giza');


INSERT INTO hr.Employees (FName, LName, SSN, Gender, BirthDate, Email, DeptID)
VALUES 
('Sara', 'Ahmed', '12345678901234', 'F', '1995-04-20', 'sara@company.com', 1),
('Omar', 'Hassan', '98765432109876', 'M', '1992-06-15', 'omar@company.com', 2);


INSERT INTO hr.Dependents (DepName, Relationship, EmpID)
VALUES 
('Laila', 'Daughter', 1),
('Mona', 'Wife', 2);


INSERT INTO hr.Projects (ProjID, ProjName, DeptID)
VALUES (101, 'ERP System', 1), (102, 'Recruitment Drive', 2);

INSERT INTO hr.EmployeeProjects (EmpID, ProjID)
VALUES (1, 101), (2, 102);



