-- Steps for implementing a function 
-- Step 1: CEATING A TABLE , INSERTING VALUES 
-- Step 2: IMPLEMENTING BUILTIN SCALAR FUNCTION 
use WiproLms;

-- Creating Department table 
create TABLE Department(
DeptID int primary KEY,
DeptName varchar(50)
);

-- creating a Employee table 
create TABLE Employe(
EmpID INT primary KEY,
EmpName  varchar(100),
Salary decimal(10,2),
DeptID INT,
ManagerID INT,
DateOfJoining date
);

INSERT INTO Department VALUES(1,'HR'),(2,'Finance'),(3,'IT'),(4,'Customer Support');

INSERT INTO Employe VALUES
(101,'Raj', 70000.45,3,null,'2024-01-15'),
(102,'Rajiv', 35000,2,101,'2025-01-15'),
(103,'Rajesh', 40000.75,3,101,'2021-01-15'),
(104,'Rajni', 50000,3,102,'2022-01-15'),
(105,'Rani', 70000,1,null,'2020-01-15'),
(106,'Kishor', 80000,5,null,'2018-01-15');


Select * FROM Department;
Select * from Employe;

-- implementing built-in Scalar function

SELECT EmpName,Len(EmpName) As NameLength FROM Employe;

select EmpName, round(Salary,-3) AS RoundedSalary FROM Employe;
--positive value rounds  to decimal place (Round(123.456,2) -> 123.46)
--negative Vlaue rounds to power of 10 o the left( Round(12345,-2)-> 12300)

select GETDATE() AS CurrentDate;

-- Aggregate Functions 

select Count(*) AS TotalEmployees FROM Employe;
SELECT round(avg(Salary),-2) AS AverageSalary FROM Employe;
Select max(Salary) AS MaxSalary FROM Employe;

-- Joins 
--Inner Joins : Returns only matching rows from both table 

Select E.EmpName, D.DeptName
FROM Employe E
INNER JOIN Department D ON E.DeptID = D.DeptID;
-- Left Joins : returns all rows from the left table and matched rows from the right table 

Select E.EmpName, D.DeptName
FROM Employe E 
LEFT JOIN  Department D ON E.DeptID = D.DeptID; 
-- Right Joins: returns alll rows from the right table  and matched rows from the left

Select E.EmpName , D.DeptName
FROM Employe E
right JOIN Department D ON E.DeptID = D.DeptID;


-- Full Joins : Returns all rows where there is a match in one of the table 

Select E.EmpName , D.DeptName
FROM Employe E
FUll OUTER JOIN Department D ON E.DeptID = D.DeptID;

-- Self join : a table is joined with itself, ofthe using aliases.
-- Here we are returning Emp- > Manager mapping 
Select E1.EmpName AS Employee, E2.EmpName AS Manager
FROM Employe E1
LEFT JOIN  Employe E2  ON E1.ManagerID = E2.EmpID;
-- cross join : returns the cartesian product of two table(All possible combination)
SELECT EmpName, DeptName FROM Employe cross join Department;

--Set operators : 
-- union

SELECT DeptID FROM Employe
UNION
SELECT DeptID FROM Department;



-- INTERSECT

SELECT DeptID FROM Employe
INTERSECT
SELECT DeptID FROM Department;



-- MINUS( not directly suported in SQL SERVER use Except)

SELECT DeptID FROM Department
EXCEPT
SELECT DeptID FROM Employe;

--SELECT DeptID FROM Department
--MINUS
--SELECT DeptID FROM Employe;

create procedure DisplayDepartmentsasBeginselect * from Department;end;execute DisplayDepartments;---- lets create a stored procedure for getting employee detailscreate procedure GetEmployeeDetails@EmpID int, @EmpName varchar(100) outputasbeginselect @EmpName = EmpName from Employe where EmpID = @EmpID;End;declare @Name varchar(100);execute GetEmployeeDetails 103, @EmpName = @Name output;print @Name;--- update employee detailsalter procedure UpdateEmployeeDetails@EmpID int, @NewSalary decimal(10,2) outputasbeginupdate Employeset salary = @NewSalary where EmpID= @EmpID;select * from Employeend;execute UpdateEmployeeDetails @EmpID = 103, @NewSalary = 90000;--- check salarycreate procedure CheckSalaryy@EmpID int asbegindeclare @Salary decimal(10,2)select @Salary = Salary from Employe where EmpID = @EmpID;if @Salary> 55000print 'High Earner'elseprint 'Low Earner';end

EXEC CheckSalaryy 103;








