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



insert into sales values(
  1,
  1,
  102,
  '2016-03-02',
  5000
),(
  2,
  1,
  102,
  '2016-03-02',
  5000
),(
  3,
  1,
  102,
  '2016-03-02',
  5000
),(
  4,
  1,
  102,
  '2016-03-02',
  5000
),(
  5,
  1,
  102,
  '2016-03-02',
  5000
),(
  6,
  1,
  102,
  '2016-03-02',
  5000
),(
  7,
  1,
  102,
  '2016-03-02',
  5000
),(
  8,
  1,
  102,
  '2016-03-02',
  8000
),(
  9,
  1,
  102,
  '2016-03-02',
  7000
),(
  10,
  1,
  102,
  '2019-11-22',
  6000
),(
  11,
  1,
  102,
  '2016-03-02',
  5000
),(
  12,
  1,
  102,
  '2016-03-02',
  5000
),(
  13,
  1,
  102,
  '2016-03-02',
  5000
),(
  14,
  1,
  102,
  '2016-03-02',
  5000
),(
  15,
  1,
  102,
  '2016-03-02',
  5000
),(
  16,
  1,
  102,
  '2016-03-02',
  5000
),(
  17,
  1,
  102,
  '2016-03-02',
  5000
),(
  18,
  1,
  102,
  '2016-03-02',
  8000
),(
  19,
  1,
  102,
  '2016-03-02',
  7000
),(
  20,
  1,
  102,
  '2019-11-22',
  6000
);
