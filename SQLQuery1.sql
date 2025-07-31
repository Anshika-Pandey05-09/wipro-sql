CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,                  -- Unique employee ID
    FirstName VARCHAR(50) NOT NULL,         -- First name (required)
    LastName VARCHAR(50),                   -- Last name (optional)
    Age INT CHECK (Age > 18),               -- Must be older than 18
    Department VARCHAR(50),                 -- Department name
    Salary DECIMAL(10, 2),                  -- Salary with decimal
    JoiningDate DATE                        -- Date of joining
);

INSERT INTO Employee (EmpID, FirstName, LastName, Age, Department, Salary, JoiningDate)
VALUES (101, 'Anshika', 'Pandey', 25, 'HR', 50000.00, '2023-06-15');

SELECT * from employee;

CREATE database employee 

use employee

Create TABLE Students(
 StudentId int primary key,
 FullName varchar(100),
 Age int,
 Email varchar(100) unique
 );
 
 Create TABLE Courses(
 CourseID int primary key,
 Coursename varchar(50),
 Credits int
 );
 
 Create table Enrollments(
 EnrollmentID int primary key,
 StudentId int,
 CourseID int,
 EnrollmentDate date
 foreign key(StudentId) references Students(StudentId),  -- Defining foreign Key 
 foreign key(CourseID) references Courses (CourseID)
 );

-- Inserting values in above table
INsert INto Students(StudentId,FullName,Age,Email)
VALUES(1,'Raj',24,'Raj@gmail.com'),
      (2,'Aditi',25,'Aditi@gmail.com');

Select * from Students;-- We never prefer uing * during development 
INsert INto Courses (CourseID,Coursename,Credits)
 VALUES (101, 'C# with MSSQL', 5),
        (102,'ASP.NET COre with Angular ',6);
Select * FROM Courses;

INsert into Enrollments( EnrollmentID, StudentId, CourseID, EnrollmentDate)
VALUES(1,1,101,'2025-01-10'),
       (2,2,102,'2025-04-12');
Select * FROM Enrollments;



--updating Age = 22
update Students 
SET Age = 22
where StudentId = 1;

Select * from Students;
-- Performing airmatic/ Logical operators operations 
SELECT FullName, Age + 1 AS NextYearAge FROM Students
where Age> 22 and Email Like '%gmail.com'; -- pattern matching 


--Join
SELECT s.FullName, c.Coursename, e.EnrollmentDate
FROM Enrollments e
JOIN Students s on e.StudentId = s.StudentId
JOIN Courses c ON e.CourseID = c.CourseID

