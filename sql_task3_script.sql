
CREATE DATABASE EmployeeProjectDB;
GO

USE EmployeeProjectDB;
GO
CREATE TABLE DEPARTMENT (
    DeptID INT IDENTITY(1,1) PRIMARY KEY,
    DeptName VARCHAR(100) NOT NULL
);


CREATE TABLE EMPLOYEE (
    EmpID INT IDENTITY(1,1) PRIMARY KEY,
    EmpName VARCHAR(100) NOT NULL,
    JobTitle VARCHAR(50),
    Salary DECIMAL(10, 2),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES DEPARTMENT(DeptID)
);

CREATE TABLE PROJECT (
    ProjectID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName VARCHAR(100),
    StartDate DATE,
    EndDate DATE
);


CREATE TABLE EMPLOYEE_PROJECT (
    EmpID INT,
    ProjectID INT,
    WorkingHours INT,
    PRIMARY KEY (EmpID, ProjectID),
    FOREIGN KEY (EmpID) REFERENCES EMPLOYEE(EmpID),
    FOREIGN KEY (ProjectID) REFERENCES PROJECT(ProjectID)
);

INSERT INTO DEPARTMENT (DeptName) VALUES
('IT'),
('HR'),
('Finance');

INSERT INTO EMPLOYEE (EmpName, JobTitle, Salary, DeptID) VALUES
('Ali Ahmed', 'Developer', 8000.00, 1),
('Sara Adel', 'HR Manager', 9000.00, 2),
('Mona Said', 'Accountant', 7500.00, 3),
('Omar Nabil', 'Developer', 8200.00, 1),
('Laila Hesham', 'HR Assistant', 6000.00, 2);

INSERT INTO PROJECT (ProjectName, StartDate, EndDate) VALUES
('AI System', '2025-01-01', '2025-12-31'),
('HR Portal', '2025-03-01', '2025-08-30');

INSERT INTO EMPLOYEE_PROJECT (EmpID, ProjectID, WorkingHours) VALUES
(1, 1, 40),
(4, 1, 35),
(2, 2, 30),
(5, 2, 20);

UPDATE EMPLOYEE
SET DeptID = 1
WHERE EmpName = 'Laila Hesham';


DELETE FROM EMPLOYEE_PROJECT
WHERE EmpID = 5 AND ProjectID = 2;


SELECT *
FROM EMPLOYEE
WHERE DeptID = 1;


SELECT E.EmpName, P.ProjectName, EP.WorkingHours
FROM EMPLOYEE E
JOIN EMPLOYEE_PROJECT EP ON E.EmpID = EP.EmpID
JOIN PROJECT P ON EP.ProjectID = P.ProjectID;

