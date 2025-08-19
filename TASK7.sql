-- 1. Create Database
CREATE DATABASE ECommerceDB

-- 2. Use Database
USE ECommerceDB

-- 3. Create Tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100),
    city VARCHAR(50),
    email VARCHAR(100)
)

CREATE TABLE Products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
)

CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    order_date DATE,
    total_amount MONEY,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
)

CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,
    product_id INT,
    quantity INT,
    price MONEY,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
)

-- 4. Insert Sample Data
INSERT INTO Customers (name, city, email) VALUES
('Alice', 'Bangalore', 'alice@example.com'),
('Bob', 'Mumbai', 'bob@example.com'),
('Charlie', 'Delhi', 'charlie@example.com');

INSERT INTO Products (product_name, category, price) VALUES
('Laptop', 'Electronics', 55000),
('Headphones', 'Electronics', 2000),
('T-Shirt', 'Clothing', 500),
('Shoes', 'Clothing', 1500);

INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2025-08-01', 57000),
(2, '2025-08-02', 2000),
(3, '2025-08-03', 2000);

INSERT INTO OrderDetails (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 55000), 
(1, 2, 1, 2000),  
(2, 2, 1, 2000),  
(3, 3, 2, 1000);  

--CREATING A VIEW FOR RETRIVING A report of total spent by each customer on each product category.
CREATE VIEW CustomerCategorySpending AS
SELECT 
    c.customer_id,
    c.name AS customer_name,
    p.category,
    SUM(od.quantity * od.price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY c.customer_id, c.name, p.category;

SELECT *FROM CustomerCategorySpending

--Views for Abstraction and Security (INSTEAD IF EXPOSING ALL TABLES CREATE SALES REPORT)

CREATE VIEW SalesSummary AS
SELECT order_date, SUM(total_amount) AS daily_sales
FROM Orders
GROUP BY order_date;

SELECT * FROM SalesSummary
