create database StudentDB;

use StudentDB;

-- Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    email VARCHAR(50),
    major VARCHAR(50),
    enrollment_year INT
);

-- Create Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    credit_hours INT,
    department VARCHAR(50)
);

-- Create StudentCourses table for enrollment
CREATE TABLE StudentCourses (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);


-- Insert sample data
INSERT INTO Students VALUES 
(1, 'John Doe', 'john@example.com', 'Computer Science', 2020),
(2, 'Jane Smith', 'jane@example.com', 'Mathematics', 2021),
(3, 'Mike Johnson', 'mike@example.com', 'Physics', 2020);

INSERT INTO Courses VALUES
(101, 'Database Systems', 3, 'CS'),
(102, 'Calculus II', 4, 'MATH'),
(103, 'Quantum Physics', 4, 'PHYSICS');

INSERT INTO StudentCourses VALUES
(1, 1, 101, 'Fall 2023', 'A'),
(2, 1, 102, 'Spring 2024', 'B'),
(3, 2, 102, 'Fall 2023', 'A'),
(4, 3, 103, 'Spring 2024', 'B+');

SELECT * FROM StudentCourses, Students, Courses;

-- Creating a simple view 
CREATE VIEW CS_Student AS
select student_id, student_name, email
FROM Students
WHERE major = 'Computer Science';

SELECT * FROM CS_Student;


-- Complex VIEW ( From multiple Table with Joins)
CREATE VIEW dbo.StudentEnrollments AS 
SELECT s.student_name, c.course_name, sc.semester, sc.grade
FROM dbo.Students s
INNER JOIN dbo.StudentCourses sc on s.student_id = sc.student_id
INNER JOIN dbo.Courses c ON sc.course_id = c.course_id;

SELECT * FROM dbo.StudentEnrollments;

-- View which can do operations on tables
-- Inserting new data in students
Create view dbo.InsertIntoStudents
AS
SELECT * FROM Students;

INSERT INTO dbo.InsertIntoStudents VALUES
(4, 'Priyanshu bhai', 'priyanshu@bhai.com', 'Driving', 2025);

SELECT * FROM InsertIntoStudents;

-- Query and modify VIEW
SELECT TOP 100 * FROM dbo.CS_Student;


SELECT * FROM dbo.StudentEnrollments WHERE grade = 'A';

-- Updating data through a view
CREATE VIEW dbo.UpdateStudent AS 
	UPDATE dbo.CS_Student
	SET email = 'John_doe_unversity.edu'
	WHERE student_id = 1;



BEGIN TRANSACTION ;
	UPDATE dbo.CS_Student
	SET email = 'John_doe_unversity.edu'
	WHERE student_id = 1;

-- VERIFYING THE UPDATE OPERATION
SELECT * FROM dbo.CS_Student WHERE student_id = 1;
ROLLBACK TRANSACTION -- Undoing the changes

-- IRCTC servers, Instead of doing every small changes in my main system, we have views that works as data
-- where we can make local changes and later on when they are permanent they are updated in main DB
-- Limitation with Views: (Very Imp.)

-- Attemting to update a complex view Using error handling (Will fail)

BEGIN TRY
	BEGIN TRANSACTION;
		UPDATE dbo.StudentEnrollments
		SET grade = 'A+'
		WHERE student_name = 'John Doe' AND course_name = 'Database Systems';
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH 
	ROLLBACK TRANSACTION;
	PRINT 'ERROR OCCURED ...!!' + ERROR_MESSAGE();
END CATCH;

-- ALTERING A VIEW (Ms SQL uses CREATE or ALTER in newer version
-- For older version, we need to DROP and CREATE

IF EXISTS ( SELECT * FROM sys.views WHERE name = 'CS_Student' AND schema_id = SCHEMA_ID('dbo'))
		DROP VIEW dbo.CS_Student;

--Simple View

CREATE VIEW CS_Student_New AS
select student_id, student_name, email
FROM Students
WHERE major = 'Computer Science';

SELECT * FROM CS_Student_New;

-- View MwetaData in MS SQL 
-- Get view definition
SELECT OBJECT_DEFINITION(OBJECT_ID('DBO.CS_Student_New')) AS ViewDefinition;

-- List all view in the database

SELECT NAME AS ViewName, create_date, modify_date
FROM sys.views
WHERE is_ms_shipped = 0
ORDER BY create_date;

CREATE NONCLUSTERED INDEX IX_STUDENT_EMAIL ON Students(email); -- Student Email

CREATE NONCLUSTERED INDEX IX_StudentMajor_Year ON Students(major, enrollment_year);  -- cOMPOSITE ON CLUSTURED Based on student major and year

-- Creating a Unique Index on email to prevent duplicates
CREATE unique INDEX UQ_Students_Email ON Students(email) WHERE email IS NOT NULL;


-- Create a non clustured Index on StudentCourses for common query patterns
CREATE NONCLUSTERED INDEX IX_StudentCourses_Grade ON StudentCourses(semester, grade)

-- Ananlyzing index usage
-- Check existing Indexes

SELECT 
	t.name AS TableName,
	i.name AS IndexName,
	i.type_desc AS IndexType,
	i.is_unique AS IsUnique

FROM sys.indexes i
INNER JOIN sys.tables t ON i.object_id = t.object_id
where i.name IS NOT NULL;


-- Sample Queries based on indexing
SELECT * FROM Students WHere email = 'john@example.com';

-- Using composite index
SELECT * FROM Students WHERE major = 'Computer Science' AND enrollment_year = 2020;


--This tells you:

--How often each index is used (seeks/scans).

--If your index is being ignored, consider dropping or modifying it.
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks, s.user_scans, s.user_lookups, s.user_updates
FROM sys.dm_db_index_usage_stats s
JOIN sys.indexes i ON i.index_id = s.index_id AND i.object_id = s.object_id
WHERE OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1
ORDER BY s.user_seeks DESC;

-- List of all tables in the database
SELECT * FROM sys.tables

-- Most views in MsSQL  Server are read only by design? justify How?

-- Only simple views meeting strict criteria can be updated directly ? How?

-- View with DISTINCT
--CREATE VIEW ToAddStudentDetails
--INSERT INTO Students VALUES(1, 'Aman', 'aman@gmail.com', 'Physics', 2022);

Select * FROM CS_Student_New; -- simple updatable view ( Meets all criteria)
SELECT * FROM StudentEnrollments; --View with Join( Not directly Updatable)
SELECT OBJECT_DEFINITION(OBJECT_ID('DBO.StudentEnrollments')) AS ViewDefinition;

-- View with DISTINCT(not updatable)
CREATE VIEW UniqueMajors AS
SELECT DISTINCT major FROM Students;
SELECT * FROM UniqueMajors;

-- Below operatioj is failing because 
-- DISTINCT create a derived result set
-- SQL SERVER can't map updates back to the base table 
BEGIN TRY 
	PRINT 'Attempting to update DISTINCT view..'
	UPDATE UniqueMajors
	SET major = 'Computer Sciences'
	Where Major = 'Computer Science'
END TRY

BEGIN CATCH
	PRINT 'update failed(as Expected)';
	PRINT 'ERROR: ' +ERROR_MESSAGE();
END CATCH;


-- View with computed column ( non updatable)
Create VIEW StudentNameLengths1 AS
SELECT student_id,student_name, LEN(student_name) AS name_length
FROM Students;

SELECT * FROM StudentNameLengths1;


-- Thi will fail because :
-- Contain a derived column( name_length)
-- SQL Server can't update calculated values 

BEGIN TRY
	PRINT'Attempting to updated computed column';
	UPDATE StudentNameLengths1
	SET student_name = 'John Travolta'
	Where name_length = 6;
END TRY

BEGIN CATCH
	PRINT 'Update Failed( a expected)';
	PRINT 'Error' + Error_Message();
END CATCH;