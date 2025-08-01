create database Inventory;
use Inventory;

-- Table: Categories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100)
);

-- Table: Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    CategoryID INT,
    Price DECIMAL(10, 2),
    StockQuantity INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Table: Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15)
);
drop table Customers;

-- Table: Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
drop table Orders;

-- Table: OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
drop table OrderDetails;

-- Function to calculate discount based on quantity
CREATE FUNCTION dbo.GetDiscountedPrice (@price DECIMAL(10,2), @qty INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @discountedPrice DECIMAL(10,2)

    IF @qty >= 10
        SET @discountedPrice = @price * 0.90 -- 10% discount
    ELSE IF @qty >= 5
        SET @discountedPrice = @price * 0.95 -- 5% discount
    ELSE
        SET @discountedPrice = @price

    RETURN @discountedPrice
END;

-- View for Sales Manager to analyze total sales per category
--CREATE VIEW vw_TotalSalesPerCategory AS
--SELECT 
  --  C.CategoryName,
    --SUM(OD.Quantity * OD.UnitPrice) AS TotalSales
--FROM 
  --  OrderDetails OD
    --INNER JOIN Products P ON OD.ProductID = P.ProductID
    --INNER JOIN Categories C ON P.CategoryID = C.CategoryID
--GROUP BY 
   -- C.CategoryName;

	-- Procedure for Warehouse Supervisor to view low stock products
CREATE PROCEDURE GetLowStockItems (@threshold INT = 10)
AS
BEGIN
    SELECT 
        ProductID, ProductName, StockQuantity
    FROM 
        Products
    WHERE 
        StockQuantity < @threshold;
END;

-- Procedure for Customer Support Agent
CREATE PROCEDURE GetOrderDetailsWithCustomerInfo (@OrderID INT)
AS
BEGIN
    SELECT 
        O.OrderID,
        O.OrderDate,
        C.CustomerName,
        C.Email,
        OD.ProductID,
        P.ProductName,
        OD.Quantity,
        OD.UnitPrice
    FROM Orders O
    JOIN Customers C ON O.CustomerID = C.CustomerID
    JOIN OrderDetails OD ON O.OrderID = OD.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    WHERE O.OrderID = @OrderID;
END;

-- Procedure for atomic bulk update of stock levels
CREATE PROCEDURE UpdateStockAfterOrder (
    @ProductID INT,
    @OrderQty INT
)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check current stock
        DECLARE @currentStock INT;
        SELECT @currentStock = StockQuantity FROM Products WHERE ProductID = @ProductID;

        IF @currentStock < @OrderQty
        BEGIN
            RAISERROR('Insufficient stock.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Update stock
        UPDATE Products
        SET StockQuantity = StockQuantity - @OrderQty
        WHERE ProductID = @ProductID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END;

-- Sample data for Categories
INSERT INTO Categories VALUES (1, 'Laptops'), (2, 'Smartphones'), (3, 'Accessories');

-- Sample Products
INSERT INTO Products VALUES 
(101, 'Laptop A', 1, 75000.00, 20),
(102, 'Phone B', 2, 25000.00, 50),
(103, 'Charger', 3, 500.00, 100);

-- Sample Customers
INSERT INTO Customers VALUES 
(1, 'Anshika', 'Anshika@example.com', '9990008887'),
(2, 'Raj', 'Raj@example.com', '7766655544');
select * from Customers;

drop table Customers;

-- Sample Orders
INSERT INTO Orders VALUES 
(1, 1, GETDATE(), 80000.00),
(2, 2, GETDATE(), 26000.00);
select * from Orders;

-- Sample OrderDetails
INSERT INTO OrderDetails VALUES 
(1, 1, 101, 1, 75000.00),
(2, 1, 103, 2, 500.00),
(3, 2, 102, 1, 25000.00),
(4, 2, 103, 2, 500.00);

select * from OrderDetails;