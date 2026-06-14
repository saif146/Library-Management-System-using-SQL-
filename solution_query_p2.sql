-- SQL Project - Library Management System part-2

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;
/*
Task 13: 
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

-- issued_status == members == books == return_status
-- filter books which is return
-- overdue > 30 

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

/*    
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/
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



/*
Task 16: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/
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

-- Task 17: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
create table active_members as 
select * from members where member_id in (select distinct issued_member_id from issued_status where issued_date >= current_date - interval '2 month');


select * from active_members;


-- Task 18: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.


select e.emp_id,e.emp_name,count(i.issued_id) as total_issued,e.branch_id 
from issued_status as i 
join 
employees as e
on i.issued_emp_id = e.emp_id 
group by e.emp_id order by 3 desc limit 3;



/*
Task 19: Stored Procedure Objective: 

Create a stored procedure to manage the status of books in a library system. 

Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 

The procedure should function as follows: 

The stored procedure should take the book_id as an input parameter. 

The procedure should first check if the book is available (status = 'yes'). 

If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 

If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/


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







