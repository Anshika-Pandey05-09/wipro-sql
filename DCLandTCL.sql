Create database CollegeDB;
Use CollegeDB;

--1. Students Table
Create TABLE Student (
StudentID INT Primary key,
FullNAME VARCHAR(100) NOT NULL,
Email VARCHAR(100) Unique NOT NULL,
Age INT CHECK(AGE >= 18)
);

-- 2. Instructors Table
CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY,
    InstructorName VARCHAR(100),
    Email VARCHAR(100) UNIQUE
);

-- 3. Courses Table
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    InstructorID INT,
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
);



-- 4. Enrollments Table
CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Insert Students
INSERT INTO Student VALUES (1, 'Rohit', 'Rohit@example.com', 19);
INSERT INTO Student VALUES (2, 'Rashi', 'Rashi@example.com',19);

-- Insert Instructors
INSERT INTO Instructor VALUES (1, 'Dr. Smith', 'smith@example.com');
INSERT INTO Instructor VALUES (2, 'Prof Mani', 'Mani@example.com');

-- Insert Courses
INSERT INTO Course VALUES (101, 'Data Science', 1);
INSERT INTO Course VALUES (102, '.NET FSD with Azure Cloud', 2);

-- Insert Enrollments
INSERT INTO Enrollment VALUES (1001, 1, 101, GETDATE());
INSERT INTO Enrollment VALUES (1002, 2, 102, GETDATE());

select * from Enrollment;
select * from Student;

-- Step 1: Create Login and User
CREATE LOGIN Auditor WITH PASSWORD = 'StrongPassword123';
CREATE USER Auditor FOR LOGIN Auditor;

-- Step 2: Grant SELECT permission only
GRANT SELECT ON Student TO Auditor;
--GRANT SELECT ON Instructor TO Auditor;
--GRANT SELECT ON Course TO Auditor;
GRANT SELECT ON Enrollment TO Auditor;

-- Optional: Revoke access after audit
   REVOKE SELECT ON Student FROM Auditor;


-- Implementing a transaction with commit and rollback
   BEGIN TRANSACTION;

INSERT INTO Student VALUES (3, 'Alex', 'Alex@example.com', 20);
INSERT INTO Enrollment VALUES (1003,3,101, GETDATE());
--SAVE TRANSACTION SavePoint1;

-- Now something goes wrong
-- Let's say you want to roll back only the last part
--DELETE FROM Course WHERE CourseID = 999;  -- Invalid ID

-- Roll back to savepoint
--ROLLBACK TRANSACTION SavePoint1;

-- Commit the valid insert
COMMIT;

--Roll back
BEGIN TRANSACTION;
INSERT INTO Student VALUES (4, 'Angel', 'Angel@example.com', 17);
Rollback;

-- 1. Which Students are enrolled in which courses?
SELECT s.FullNAME, c.CourseName
FROM Enrollment e
JOIN Student s ON e.StudentID = s.StudentID
JOIN Course c ON e.CourseID = c.CourseID;

-- 2. Who is teaching each course?
SELECT c.CourseName, i.InstructorName
FROM Course c
JOIN Instructor i ON c.InstructorID = i.InstructorID;

-- 4. Allow only authorized users to make changes or view specific data.
-- Creating a role for admin users who can view and modify data
--CREATE ROLE AdminRole;

-- Creating a role for auditors who can only view data
--CREATE ROLE AuditorRole;

-- Creating an admin login and user (admin has full access)
--CREATE LOGIN StudentAdmin WITH PASSWORD = 'Admin@123';
--CREATE USER StudentAdmin FOR LOGIN StudentAdmin;
--EXEC sp_addrolemember 'AdminRole', 'StudentAdmin';

-- Creating an auditor login and user (auditor has read-only access)
--CREATE LOGIN StudentAuditor WITH PASSWORD = 'Audit@123';
--CREATE USER StudentAuditor FOR LOGIN StudentAuditor;
--EXEC sp_addrolemember 'AuditorRole', 'StudentAuditor';

-- Granting SELECT, INSERT, UPDATE, DELETE permissions to AdminRole
--GRANT SELECT, INSERT, UPDATE, DELETE ON Students TO AdminRole;

-- Granting only SELECT (read-only) permission to AuditorRole
--GRANT SELECT ON Students TO AuditorRole;

-- 5. Procedure to get student info by ID
-- Creating a stored procedure to get student info by StudentID
CREATE PROCEDURE GetStudentByID
    @StudentID INT  -- Input parameter to search by Student ID
AS
BEGIN
    -- Selecting student details for the given ID
    SELECT StudentID, FullNAME, Age, Email
    FROM Student
    WHERE StudentID = @StudentID;
END;
-- Calling the procedure to get details of student with ID = 1
EXEC GetStudentByID @StudentID = 1;