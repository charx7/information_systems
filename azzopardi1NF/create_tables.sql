-- Create the customers table
CREATE TABLE firstNormalForm(
	custno int not null,
	cust_name text not null,
	cust_addr text not null,
	cust_phone char(10) not null,
	supplier_id int not null,
	supplier_name text not null,
	product_code int not null,
	product_title text not null,
	purchase_date DATE NOT NULL DEFAULT CURRENT_DATE,
	sales_price real not null
);
