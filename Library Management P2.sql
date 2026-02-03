--Library management system Project 2

create table branch (
			branch_id varchar PRIMARY KEY,
			manager_id  varchar,
			branch_address  varchar,
			contact_no  varchar
);

create table employee(
			emp_id varchar PRIMARY KEY,
			emp_name varchar,
			position varchar,
			salary int8,
			branch_id varchar --FK
);

create table books(
			isbn varchar PRIMARY KEY,
			book_title varchar,
			category varchar,	
			rental_price float,	
			status varchar,
			author varchar,
			publisher varchar
);

create table members(
			member_id varchar PRIMARY KEY, 
			member_name	varchar,
			member_address varchar,
			reg_date date
);
drop table issues;

create table issue_status (
			issued_id varchar PRIMARY KEY,
			issued_member_id varchar, --FK 
			issued_book_name varchar,
			issued_date date,
			issued_book_isbn varchar, --FK 
			issued_emp_id varchar --FK
);

create table return_status(
			return_id varchar PRIMARY KEY,
			issued_id varchar, --FK
			return_book_name varchar,
			return_date date,
			return_book_isbn varchar --FK
);

--FOREIGN KEY
ALTER TABLE issue_status
add constraint fk_member_id 
foreign key (issued_member_id)
references members(member_id);

alter table issue_status
add constraint fk_book_isbn
foreign key (issued_book_isbn)
references books(isbn);

alter table issue_status
add constraint fk_emp_id
foreign key (issued_emp_id)
references employee(emp_id);

alter table employee
add constraint fk_branch_id
foreign key (branch_id )
references branch(branch_id);

ALTER TABLE branch
ADD CONSTRAINT pk_branch
PRIMARY KEY (branch_id);

alter table return_status
add constraint fk_return_book_isbn
foreign key (return_book_isbn)
references books(isbn);

alter table return_status
add constraint fk_issued_id
foreign key (issued_id)
references issue_status(issued_id);

--Data Exploration
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employee;
SELECT * FROM members;
select * from issue_status;
select * from return_status;

select count(*) from books;
select count(*) from branch;
select count(*) from employee;
select count(*) from members;
select count(*) from issue_status;
select count(*) from return_status;

--Project Questions

--1) Create a New Book Record -- 
--"978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books (isbn,book_title,	category,	rental_price,	status,	author,	publisher)
values
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

--2) Update an C103 MEMEBER"S ADDRESS TO  125 Oak St
update members 
set member_name  = 'Sammy' 
where member_id = 'C118';

update members 
set member_address  ='125 Oak St'
where member_id = 'C103';

--3) Delete a Record from the Issued Status Table
--Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
delete from issue_status 
where issued_id = 'IS121';

--4) Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
select * 
from issue_status 
where issued_emp_id = 'E101';

--5) List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_member_id , count(issued_member_id)
from issue_status
group by issued_member_id
having count(*) > 1;

--6) Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
create table book_issued_cnt as
select isbn, book_title, count(issued_id)
from issue_status i
join books as b
on i.issued_book_isbn = b. isbn
group by isbn, book_title;

select * from book_issued_cnt;

--Data Analysis & Findings
--7) Retrieve number of Books in each Specific Category:
select distinct category, count(book_title) 
from books
group by category
order by count desc;

--8) Find rental inventory value by Category:
select category, sum(rental_price), count(book_title)
from books
group by category
order by sum desc;

--9)Find Total Rental Income by Category:
SELECT 
    category,
    SUM(rental_price),
    COUNT(*)
FROM 
issue_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1
order by sum desc;

--10)Create a Table of Books with Rental Price expensive(more than 7):

create table Expensive_books as
select * 
from books 
where rental_price > 7;

select * from expensive_books;

--11) Retrieve the List of Books Not Yet Returned

select * 
from issue_status as i
left join return_status as r
on r.issued_id = i.issued_id
where r.issued_id is null
order by i.issued_id;

--12) List Employees with Their Branch Manager's Name and their branch details:
SELECT *
FROM (
    SELECT
        e.emp_id,
        e.emp_name,
        e.branch_id,
        b.manager_id
    FROM employee e
    JOIN branch b
      ON e.branch_id = b.branch_id
) eb
JOIN employee m
  ON m.emp_id = eb.manager_id;







