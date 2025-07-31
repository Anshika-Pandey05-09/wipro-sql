Create database WiproLms;

--use WiproLms;
--Begin Try
--Begin transaction;
--Update Employe set Salaryy = salaryy + 5000 where DeptId =1;
--commit

--CREATE FUNCTION GetYearOfJoining (
  --  @emp_id INT        -- Input: Employee ID
--)
--RETURNS INT           -- Output: Year
--AS
--BEGIN
 --   DECLARE @year INT;

    -- Extract year from DateOfJoining column
   -- SELECT @year = YEAR(DateOfJoining)
    --FROM Employe
    --WHERE EmpID = @emp_id;

    --RETURN @year;
--END;

-- Declare input variable
--DECLARE @emp_id INT = 101;

-- Call the function and get the year of joining
CREATE FUNCTION GetYearOfJoining (@EmpID INT)RETURNS INTASBEGIN    DECLARE @Year INT;    SELECT @Year = YEAR(DateOfJoining) FROM Employe WHERE EmpID = @EmpID;    RETURN @Year;END-- Usage:SELECT EmpName, dbo.GetYearOfJoining(EmpID) AS JoiningYear FROM Employe;CREATE FUNCTION dbo.GetEmployeeDept (
    @emp_id INT   -- Input: Employee ID
)
RETURNS TABLE
AS
RETURN (
    -- Inline SELECT returning employee info with department name
    SELECT 
        EmpID,
        EmpName,
        Salary, from Employe
    WHERE DeptID = @DeptID
)

select * from dbo.GetEmployeeDept(1);

create procedure PrintEmployeeJoiningYear@EmpID intasbegindeclare @Year int;set @Year = dbo.GetYearOfJoining(@EmpID); print 'Joined' + cast (@Year as varchar);endexecute PrintEmployeeJoiningYear 101;
