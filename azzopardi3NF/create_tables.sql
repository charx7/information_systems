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

-- create the products table
CREATE TABLE products(
  product_code int primary key not null,
  product_title text not null,
  -- foreign key to the suppliers table
  supplier_id int references suppliers(supplier_id) not null
)

-- create the sales table
CREATE TABLE sales(
	salesno int primary key not null,
  purchase_date DATE NOT NULL DEFAULT CURRENT_DATE,
	sales_price real not null,
  -- foreign key to the products table
	product_code int references products(product_code) not null,
	-- foreign key to the customers table
	custno int references customers(custno) not null
);
