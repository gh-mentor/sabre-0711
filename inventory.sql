/*
This file contains a script of Transact SQL (T-SQL) command to interact with a database named 'Inventory'.
Requirements:
- SQL Server 2022 is installed and running
- database 'Inventory' already exists.
Details:
- Check that the database 'Inventory' exists, if not print an error message and terminate the script.
- Sets the default database to 'Inventory'.
- Creates a 'categories' table and related 'products' table if they do not already exist.
- Remove all rows from the tables.
- Populates the 'Categories' table with sample data.
- Populates the 'Products' table with sample data.
- Creates stored procedures to get all categories.
- Creates a stored procedure to get all products in a specific category.
- Creates a stored procudure to get all products in a specific price range sorted by price in ascending order.
*/

-- Check if the database 'Inventory' exists
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Inventory')
BEGIN
    PRINT 'Error: The database Inventory does not exist.'
    RETURN
END

-- Set the default database to 'Inventory'
USE Inventory
Go

-- Create the 'Categories' table if it does not already exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Categories')
BEGIN
    CREATE TABLE Categories (
        CategoryID INT PRIMARY KEY,
        CategoryName NVARCHAR(50) NOT NULL
    )
END

-- Create the 'Products' table if it does not already exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Products')
BEGIN
    CREATE TABLE Products (
        ProductID INT PRIMARY KEY,
        ProductName NVARCHAR(50) NOT NULL,
        CategoryID INT NOT NULL,
        Price DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
        -- Add a unique constraint on the ProductName column
        CONSTRAINT UQ_ProductName UNIQUE (ProductName),
        -- Add a created date column
        CreatedDate DATETIME DEFAULT GETDATE(),
        -- Add a modified date column
        ModifiedDate DATETIME DEFAULT GETDATE()
    )
END

-- Remove all rows from the 'products' and 'categories' tables
TRUNCATE TABLE Products
TRUNCATE TABLE Categories

-- Populate the 'Categories' table with sample data
INSERT INTO Categories (CategoryID, CategoryName)
VALUES (1, 'Electronics'),
       (2, 'Clothing'),
       (3, 'Books'),
       (4, 'Home Goods')

-- Populate the 'Products' table with sample data
INSERT INTO Products (ProductID, ProductName, CategoryID, Price)
VALUES (1, 'Laptop', 1, 999.99),
       (2, 'Smartphone', 1, 699.99),
       (3, 'T-shirt', 2, 19.99),
       (4, 'Jeans', 2, 39.99),
       (5, 'Novel', 3, 14.99),
       (6, 'Cookbook', 3, 24.99),
       (7, 'Bedding Set', 4, 49.99),
       (8, 'Kitchenware Set', 4, 29.99)

-- Create a stored procedure to get all categories
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'GetAllCategories')
BEGIN
    EXEC('CREATE PROCEDURE GetAllCategories AS SELECT * FROM Categories')
END

-- Create a stored procedure to get all products in a specific category
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'GetProductsByCategory')
BEGIN
    EXEC('CREATE PROCEDURE GetProductsByCategory @CategoryID INT AS SELECT * FROM Products WHERE CategoryID = @Category






