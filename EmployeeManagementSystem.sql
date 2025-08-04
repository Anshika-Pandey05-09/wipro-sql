create database CustomerDB;
Use CustomerDB;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    CustomerPhone VARCHAR(15)
);

INSERT INTO Customers VALUES 
(1, 'Amit', '9087654321'),
(2, 'Arshdeep', '9876543210'),
(3, 'Akhil', '9807654321');

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);

INSERT INTO Categories VALUES 
(1, 'Electronics'),
(2, 'Clothing');

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    ProductPrice DECIMAL(10,2),
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

INSERT INTO Products VALUES 
(1, 'Laptop', 60000, 1),
(2, 'Sports Shoes', 2500, 2),
(3, 'Wireless Keyboard', 1000, 1);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders VALUES 
(101, 1, 1),
(102, 2, 2),
(103, 3, 3);

select * from Orders;
select * from Products;
select * from Categories;
select * from Customers;


--> 3rd Question

-- it is already in 1NF

--2NF

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50),
    DeptLocation VARCHAR(50)
);

INSERT INTO Departments VALUES
(1, 'HR', 'Mumbai'),
(2, 'IT', 'Pune');


CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    Role VARCHAR(50),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);


INSERT INTO Employees VALUES
(201, 'Alice Brown', 'HR Executive', 1),
(202, 'Bob Smith', 'IT Analyst', 2),
(203, 'John Davis', 'HR Executive', 1),
(204, 'Riya Shah', 'HR Manager', 1),
(205, 'Priya Mehta', 'HR Manager', 1);


CREATE TABLE EmployeeManagers (
    EmpID INT,
    ManagerID INT,
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmpID)
);


INSERT INTO EmployeeManagers VALUES
(201, 205),  -- Alice reports to Priya
(202, 206),  -- Bob reports to Karan (Karan needs to be added)
(203, 205),  -- John reports to Priya
(204, 207),  -- Riya reports to Arjun (Arjun needs to be added)
(205, 207);  -- Priya reports to Arjun



INSERT INTO Employees VALUES
(206, 'Karan Kapoor', 'IT Head', 2),
(207, 'Arjun Sharma', 'HR Director', 1);


-- 3NF

CREATE TABLE Roles (
    RoleID INT PRIMARY KEY,
    RoleName VARCHAR(50)
);


INSERT INTO Roles VALUES
(1, 'HR Executive'),
(2, 'IT Analyst'),
(3, 'HR Manager'),
(4, 'IT Head'),
(5, 'HR Director');


DROP TABLE Employees;
DROP TABLE EmployeeManagers;



CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    RoleID INT,
    DeptID INT,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);


INSERT INTO Employees VALUES
(201, 'Alice Brown', 1, 1),
(202, 'Bob Smith', 2, 2),
(203, 'John Davis', 1, 1),
(204, 'Riya Shah', 3, 1),
(205, 'Priya Mehta', 3, 1),
(206, 'Karan Kapoor', 4, 2),
(207, 'Arjun Sharma', 5, 1);

select * from EmployeeManagers;
select * from Employees;
select * from Roles;
select * from Departments;
