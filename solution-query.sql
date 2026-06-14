select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from return_status;
select * from members;

--Project Task
--CRUD Operations
--Task 1. Create a New Book Record -- '978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
insert into books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

select * from books;

-- Task 2: Update an Existing Member's Address
update members
SET member_address='125 Main St'
where member_id='C101';

select * from members;

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
select * from issued_status where issued_id = 'IS121';

delete from issued_status where issued_id = 'IS121';


-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * from issued_status WHERE issued_emp_id = 'E101';

-- Task 5: List employee Who Have Issued More Than One Book -- Objective: Use GROUP BY to find employee who have issued more than one book.

select 
     i.issued_emp_id,e.emp_name 
from issued_status as i 
join 
employees as e
on  i.issued_emp_id =e.emp_id
group by 1,2 
having count(i.issued_id)>1;



-- CTAS
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

create table book_cnts as 
select b.isbn,b.book_title,count(i.issued_id) as no_of_issued 
from issued_status as i 
join books as b 
on i.issued_book_isbn = b.isbn 
group by 1,2;

select * from book_cnts;

-- Task 7. Retrieve All Books in a Specific Category:
select * from books  where category='Classic';


-- Task 8: Find Total Rental Income by Category:
select b.category,sum(b.rental_price),count(*)
from issued_status as i 
join 
books as b 
on b.isbn = i.issued_book_isbn 
group by 1;


INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C120', 'sam', '145 Main St', '2026-06-01'),
('C121', 'john', '133 Main St', '2026-05-01');

-- Task-9 List Members Who Registered in the Last 180 Days:

select * from members where CURRENT_DATE-reg_date<180;

-- task 10 :List Employees with Their Branch Manager's Name and their branch details:


select e.*,b.manager_id,e2.emp_name as manager 
from employees as e 
join 
branch as b 
on b.branch_id = e.branch_id 
join employees as e2 
on b.manager_id=e2.emp_id;



-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

CREATE TABLE books_price_greater_than_seven
AS    
SELECT * FROM Books
WHERE rental_price > 7

SELECT * FROM 
books_price_greater_than_seven



-- Task 12: Retrieve the List of Books Not Yet Returned
select distinct(i.issued_book_name) 
from issued_status as i 
left join 
return_status as r 
on i.issued_id=r.issued_id 
where r.return_id is null;
