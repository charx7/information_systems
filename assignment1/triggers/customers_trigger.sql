-- trigger that call the uppercase func before an insert or update on
-- the customers table
create trigger cust_name_trigger before insert or update on customers
	for each row execute procedure upper_case_customer_on_insert();

-- trigger that call the uppercase func before an insert or update on
-- the suppliers table
create trigger supplier_name_trigger before insert or update on suppliers
  for each row execute procedure upper_case_supplier_on_insert();