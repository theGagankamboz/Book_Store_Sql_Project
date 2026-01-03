--- CREATE TABLES
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
Book_ID SERIAL PRIMARY KEY,
Title varchar(100),
Author varchar(100),
Genre varchar (50),
Published_Year int,
Price NUMERIC(10,2),
Stock int
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
Customer_ID SERIAL PRIMARY KEY,
Name varchar(100),
Email Varchar(100),
Phone Varchar(15),
City varchar(50),
Country Varchar(150)
);
DROP TABLE IF EXISTS orders;
create table Orders(
Order_ID SERIAL PRIMARY KEY,
Customer_ID int REFERENCES  Customers(Customer_ID),
Book_id int REFERENCES Books(Book_id),
Order_Date DATE,
Quantity int,
Total_Amount NUMERIC(10,2)
);

select * from Books;
select * from Customers;
select * from Orders;

---import data into Books Table
COPY Books(
Book_ID,
Title,
Author,
Genre,
Published_Year,
Price,
Stock
)
from 'D:\SQL PRJ 13DEC\Books.csv'
CSV HEADER;

---IMPORT DATA INTO CUSTOMERS TABLE
COPY Customers(
Customer_ID,
Name,
Email,
Phone,
City,
Country
)
from 'D:\SQL PRJ 13DEC\Customers.csv'
CSV HEADER;

---IMPORT DATA INTO Orders Table
copy Orders(
Order_ID,
Customer_ID,
Book_id,
Order_Date,
Quantity,
Total_Amount)
from 'D:\SQL PRJ 13DEC\Orders.csv'
CSV HEADER;


***--1)Retrieve all books in the "fiction" genre;
select * from Books 
where Genre='Fiction';


***--2) find books published after the year 1950;
select * from Books 
where Published_year>1950;

***---3) list all the customers from canada 
select * from Customers
where country='canada';

***--4) show orders placed in november 2023;
select * from Orders
where order_date BETWEEN '2023-11-01' AND '2023-11-30';

***--5) Retriew the total stock of books avaible;
select sum(stock) as Total_Stock 
from Books;

---6) find the details of the most expensive book;
select * from Books ORDER BY price;
select * from Books ORDER BY price desc;--- descending order
select * from Books ORDER BY price desc limit 1; --- most expensive book

***---7)show all customers who ordered more than 1 quantity of a book;
select * from Orders 
where Quantity>1

---8) Retrieve all orders where the total amount exceeds $20;
select * from Orders 
where total_amount>20;


---9)List all genres available in the Books table;
select distinct genre FROM Books;

---10) find the book with the lowest stock;
select * from Books order by Stock limit 1;

--11) calculate the total revenue generated from all orders;
select sum(Total_amount) as Revenue  from Orders;


-------***
---Advance Questions;
--1)Retrieve the total number of books sold for each genre;
select * from Orders;

select B.Genre, O.Quantity 
from Orders O
JOIN Books b ON O.Book_ID = B.book_ID;

---Total sold
select b.Genre, sum(O.Quantity) as Toal_book_sold
from Orders O
JOIN Books b ON O.book_id = b.book_id
GROUP by b.Genre;

--2) find the average price of books in the "Fantasy genre";
select avg(Price) as Average_Price
From Books 
where genre = 'Fantasy';

--3) list customers who have placed at 2 orders;
select Customer_ID, COUNT(Order_ID) AS ORDER_COUNT
FROM Orders
Group by customer_id
having count(Order_ID) >=2;

--FOR SHOW VIA NAME 
select O.Customer_ID, c.name, COUNT(O.Order_ID) AS ORDER_COUNT
FROM Orders O
JOIN customers c on o.customer_id= c.customer_id
Group by o.customer_id, c.name
having count(Order_ID) >=2;

--4) Find the most frequently orderd book:
select Book_id, count(order_id) as order_count
From Orders 
group by Book_id
order by order_count desc;

--if you want book name then
select o.Book_id, b.title ,count(o.order_id) as order_count
From Orders o
join books b on o.book_id=b.book_id
group by o.Book_id, b.title 
order by order_count desc;

--5)show the top 3 most expensive books of 'fantasy' Genre :
select * from books 
where genre ='Fantasy'
ORDER BY price DESC LIMIT 3;

--6)Retrieve the total quantity of books sold by each author:
select b.author, sum(o.quantity) as Total_Books_sold
fROM orders O
JOIN books b on o.book_id=b.book_id
group by b.author; 


--7)List the cities where customers who spent over $30 are located:
select distinct c.city , total_amount
from orders o
join customers c on o.customer_id=c.customer_id
where o.total_amount > 30;

--8)Find the customer who spent the most on orders:
select c.customer_id, c.name, sum(o.total_amount) as total_spent
from orders o
join customers c on o.customer_id=c.customer_id
group by c.customer_id, c.name 
order by total_spent desc;

--9)calculate the stock remainning after fulfilling all orders;
select b.book_id, b.title, b,stock ,coalesce(sum(o.quantity),0)  as order_quantity ,
b.stock- coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join orders o on b.book_id=o.book_id
group by b.book_id order by b.book_id;





