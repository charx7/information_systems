-- create the customers table
CREATE TABLE customers(
	custno int primary key not null,
	cust_name text not null,
	cust_addr text not null,
	cust_phone char(10) not null
);

-- create the suppliers table
CREATE TABLE suppliers(
  supplier_id int primary key not null,
	supplier_name text not null
);

-- create the sales table
CREATE TABLE sales(
	salesno int primary key not null,
  purchase_date DATE NOT NULL DEFAULT CURRENT_DATE,
	sales_price real not null,
	product_code int  not null,
	product_title text not null
);
