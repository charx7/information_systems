-- create the table for the company
create table company(
	-- create a primary key which cannot be empty
	id int primary key not null,
	name text not null,
	age int not null,
	address char(50),
	salary real
);

-- create the table for departments
create table department(
	id int primary key not null,
	dept char(50) not null,
	emp_id int not null
);

-- create the students table
create table student(
	id int not null,
	name text not null
);

-- create a table with the constraint that "price"
-- must be > 0
create table products(
	product_no integer,
	name text,
	price numeric check (price>0)
);