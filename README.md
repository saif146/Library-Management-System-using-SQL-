# Library Management System using SQL 

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_project`

## Technologies Used
- PostgreSQL
- pgAdmin 4
- SQL

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/saif146/Library-Management-System-using-SQL-/blob/main/library.jpg.png)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Important Objectives
- Manage library books and their availability status
- Track book issue and return transactions
- Maintain member, employee, and branch information
- Generate business reports and operational insights
- Automate library processes using Stored Procedures

## Project Structure

### 1. Database Setup
![ERD](https://github.com/saif146/Library-Management-System-using-SQL-/blob/main/library_erd.png.jpg)

## Database Components
### Tables
- Books
- Members
- Employees
- Branch
- Issued Status
- Return Status
## SQL Concepts Used
- SELECT Statements
- WHERE Clauses
- GROUP BY
- ORDER BY
- Aggregate Functions
- JOINs
- CASE Statements
- Common Table Expressions (CTEs)
- Stored Procedures
- UPDATE Operations
- Subqueries

- **Database Creation**: Created a database named `library_project`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_project;

--proejct Name Library managemnet SYSTEM

--create table Branch
drop table if exists branch;
create table branch(
    branch_id varchar(10) PRIMARY KEY,
	manager_id varchar(10),
	branch_address varchar(30),
	contact_no varchar(15)
);

-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);

-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);


-- Create table "IssueStatus"
drop table if exists issued_status;
create table issued_status(
issued_id varchar(10) PRIMARY KEY,
issued_member_id varchar(30),
issued_book_name VARCHAR(80),
issued_date DATE,
issued_book_isbn VARCHAR(50),
issued_emp_id VARCHAR(10),
FOREIGN KEY(issued_member_id) REFERENCES members(member_id),
foreign key(issued_book_isbn) REFERENCES books(isbn),
foreign key(issued_emp_id) REFERENCES employees(emp_id)
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);


```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
```
**Task 2: Update an Existing Member's Address**

```sql
update members
SET member_address='125 Main St'
where member_id='C101';

select * from members;
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
select * from issued_status where issued_id = 'IS121';

delete from issued_status where issued_id = 'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
select 
     i.issued_emp_id,e.emp_name 
from issued_status as i 
join 
employees as e
on  i.issued_emp_id =e.emp_id
group by 1,2 
having count(i.issued_id)>1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
create table book_cnts as 
select b.isbn,b.book_title,count(i.issued_id) as no_of_issued 
from issued_status as i 
join books as b 
on i.issued_book_isbn = b.isbn 
group by 1,2;

select * from book_cnts;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books
WHERE category = 'Classic';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
select b.category,sum(b.rental_price),count(*)
from issued_status as i 
join 
books as b 
on b.isbn = i.issued_book_isbn 
group by 1;
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C120', 'sam', '145 Main St', '2026-06-01'),
('C121', 'john', '133 Main St', '2026-05-01');
select * from members where CURRENT_DATE-reg_date<180;
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
select e.*,b.manager_id,e2.emp_name as manager 
from employees as e 
join 
branch as b 
on b.branch_id = e.branch_id 
join employees as e2 
on b.manager_id=e2.emp_id;
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
CREATE TABLE books_price_greater_than_seven
AS    
SELECT * FROM Books
WHERE rental_price > 7

SELECT * FROM 
books_price_greater_than_seven
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
select distinct(i.issued_book_name) 
from issued_status as i 
left join 
return_status as r 
on i.issued_id=r.issued_id 
where r.return_id is null;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
select i.issued_member_id,
	   m.member_name,
	   b.book_title,
	   i.issued_date,
	   (CURRENT_DATE-i.issued_date) as over_due_date 
from issued_status as i 
join members as m 
on m.member_id = i.issued_member_id
join books as b 
on b.isbn = i.issued_book_isbn
LEFT join 
return_status as r 
on r.issued_id = i.issued_id 
where 
r.return_date is null 
and 
(CURRENT_DATE-i.issued_date) >30 
order by 1;
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql

select * from books where status='no'


update books 
set status='Yes'
where isbn in(
  select i.issued_id 
  from issued_status as i 
  join 
  return_status as r 
  on i.issued_id=r.issued_id
);

--see which books is not issued 
select isbn from books  where isbn not in (select issued_book_isbn from issued_status);

-- see books which is issued but not returned 
select issued_id from issued_status where issued_id not in (select issued_id from return_status);


--Task 15: Store Procedures
-- return a book which is issued and update book status is yes where issued_id is IS135

create or replace  procedure add_return_records(

 p_issued_id varchar(10),
 p_return_id varchar(15)
)
LANGUAGE plpgsql
 as $$

 DECLARE 
 B_isbn VARCHAR(50);
 B_name varchar(100);

 BEGIN
 --get book information from issued status
 select issued_book_isbn,issued_book_name
 INTO
 B_isbn,B_name
 from issued_status 
 where issued_id=p_issued_id;

 --check issued_id is exist or not 
 if B_isbn is null then 
 raise exception
 'Issued id % not found',p_issued_id;
 end if;

 --insert return record
 insert into return_status(
  return_id,
  issued_id,
  return_book_name,
  return_date,
  return_book_isbn
 )
 values(p_return_id,p_issued_id,B_name,current_date,B_isbn);

 --update book availability
 update books
 set status='Yes'
 where isbn=B_isbn;

 --success Message
 raise notice
 'Book returned successfully: %',B_name;

 end;
 $$;

 call add_return_records('IS134','RS120');

```




**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
CREATE TABLE branch_reports
AS
select e.branch_id,count(i.issued_id) as total_issued_book,sum(b.rental_price) as revenue,count(r.return_id) as returned_book 
from issued_status as i 
join 
employees as e 
on e.emp_id = i.issued_emp_id
join books as b 
on b.isbn = i.issued_book_isbn 
left join return_status as r 
on i.issued_id = r.issued_id 
group by 1;

select * from branch_reports;
```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

create table active_members as 
select * from members where member_id in (select distinct issued_member_id from issued_status where issued_date >= current_date - interval '2 month');


select * from active_members;

```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
select e.emp_id,e.emp_name,count(i.issued_id) as total_issued,e.branch_id 
from issued_status as i 
join 
employees as e
on i.issued_emp_id = e.emp_id 
group by e.emp_id order by 3 desc limit 3;
```

  **Task 18: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

create or replace procedure issue_book(

   p_issued_id varchar(10),
   p_issued_member_id varchar(30),
   p_issued_book_isbn varchar(30),
   p_issued_emp_id varchar(10)
)
language plpgsql
as $$

declare 
b_status varchar(10);
b_name varchar(100);

BEGIN

select book_title,status into b_name,b_status from books where isbn=p_issued_book_isbn;

if b_status='Yes' then 
insert into issued_status(issued_id, issued_member_id,issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
        VALUES(p_issued_id,p_issued_member_id,b_name,current_date,p_issued_book_isbn,p_issued_emp_id);
		raise notice 'Books records added successfully for book: %',p_issued_book_isbn;
else 
raise notice 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;
end if;

end;
$$;


call issue_book('IS155', 'C108', '978-0-525-47535-5', 'E104');

```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Key Business Reports
- Books issued by branch
- Revenue generated from book rentals
- Returned vs non-returned books
- Most active library members
- Employee performance analysis
- Branch performance reporting
- Book availability tracking
## Features
- Book Issue Management
- Book Return Management
- Automatic Book Status Updates
- Revenue Analysis
- Branch-wise Reporting
- Member Activity Tracking
## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.



## Author - Saiful Islam

This project showcases SQL skills essential for database management and analysis. For more content on SQL and data analysis, connect with me through the following channels:
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/saiful-islam-7b7a64268/)


Thank you for your interest in this project!
