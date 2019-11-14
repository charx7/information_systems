-- function that upper cases the customer name
create or replace function upper_case_customer_on_insert() returns trigger as $$
	begin
		NEW.cust_name = UPPER(NEW.cust_name);
        RETURN NEW;
	end;
$$ LANGUAGE plpgsql;

-- function that upper cases the supplier name
create or replace function upper_case_supplier_on_insert() returns trigger as $$
	begin
		NEW.supplier_name = UPPER(NEW.supplier_name);
        RETURN NEW;
	end;
$$ LANGUAGE plpgsql;
