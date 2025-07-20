CREATE DATABASE OnlineBookstore;
use onlineBookstore;
-- Create Tables
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Books;

-- Books table
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

-- Customers table
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

-- Orders table
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID BIGINT UNSIGNED,  -- Match SERIAL type from Customers
    Book_ID BIGINT UNSIGNED,      -- Match SERIAL type from Books
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Import Data into Books Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.3/Uploads/books.csv'
INTO TABLE Books
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Book_ID, Title, Author, Genre, Published_Year, Price, Stock);

-- MySQL doesn’t allow you to load or export files from anywhere on your computer (for security reasons).
SHOW VARIABLES LIKE 'secure_file_priv';
-- Import Data into Customers Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.3/Uploads/Customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Customer_ID, Name, Email, Phone, City, Country);

select * FROM customers;

-- Import Data into Orders Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.3/Uploads/Orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount);

select* from orders;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books;
select * from Books
where Genre='Fiction';
-- 2) Find books published after the year 1950:
select * from books
where Published_Year>'1950';
-- 3) List all customers from the Canada:
select * from customers 
where country ='Canada';
-- 4) Show orders placed in November 2023:
select * from orders
where Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:

select   Title,stock
from books;
select sum(stock) as toltal_stock
from books;
-- 6) Find the details of the most expensive book:
select title,price
from books order by price desc
limit 1;
-- 7) Show all customers who ordered more than 1 quantity of a book:
select c.name,o.quantity
from customers as c
join  orders o on
c.customer_ID=o.Customer_id
where quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where Total_Amount>20;
-- 9) List all genres available in the Books table:
select distinct(genre) from books;
-- 10) Find the book with the lowest stock:
select * from books
order by stock ;

-- 11) Calculate the total revenue generated from all orders:
select sum(Total_amount) as   generated_revenue
from orders;
-- Advance Questions : 

-- 1) Retrieve the total number of books stock for each genre:
select* from books;
select distinct (Genre) as type_genrs,count(Stock) as available_book
from books
group by Genre;
-- 2) Retrieve the total number of books stock for each genre:
select b.Genre ,sum(o.Quantity) as total_quantity
from orders o
join books b on
o.Book_ID=b.Book_ID
group by Genre
;
select * from orders;
-- 2) Find the average price of books in the "Fantasy" genre:
select b.Genre,avg(o.Total_amount)
from orders as o
join books as b on
o.Book_ID = b.Book_ID
where Genre='Fantasy';

-- 3) List customers who have placed at least 2 orders:

select*from customers;

SELECT c.Name, o.Customer_ID, COUNT(o.Order_ID) AS morethan_one_order
FROM Customers AS c
JOIN Orders AS o 
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2;
-- 4) Find the most frequently ordered book:
SELECT b.Book_ID, b.Title, COUNT(o.Order_ID) AS order_count
FROM Orders o
JOIN Books b
    ON o.Book_ID = b.Book_ID
GROUP BY b.Book_ID, b.Title
ORDER BY order_count DESC;

select * from books;
select * from orders;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from books
where Genre='Fantasy' order 
by Price 
limit 5;
-- 6) Retrieve the total quantity of books sold by each author:
select * from books;
select b.Author,sum(o.Quantity) as sold_book
from orders o
join  books b on
b.Book_ID=o.Book_ID
group by Author;

-- 7) List the cities where customers who spent over $30 are located:
select* from customers;
select distinct c.city ,o.Total_Amount
from orders o
join customers c
on c.customer_ID=o.order_id
where o.Total_Amount>30;


-- 8) Find the customer who spent the most on orders:
select * from orders;
select * from customers;
select c.name,sum(o.Total_amount) as total_spend
from customers c
join orders o on
c.customer_id=o.customer_id
group by c.name 
order by total_spend desc
limit 2;
-- 9) Calculate the stock remaining after fulfilling all orders:(stock-quantity)

select b.book_id,b.title,b.stock,coalesce(sum(o.quantity),0) as order_quantity,
b.stock-coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join orders o on b.book_id=o.book_id
group by b.book_id
order by b.book_id;




