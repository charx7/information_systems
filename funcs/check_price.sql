-- function that checks if the sale price is >0
create or replace function check_price() 
returns trigger as $$
  begin
    -- check if the sales price is negative
    IF NEW.sales_price <= 0 THEN
      RAISE EXCEPTION 'Cannot register a sale <0';
    END IF;
    return NEW;
  end;
$$ language plpgsql;
