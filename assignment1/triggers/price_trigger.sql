-- trigger that call the check price func before an insert or update on
-- the sales table
create trigger check_price_trigger before insert or update on sales
	for each row execute procedure check_price();
