-- trigger that call the discount func after an insert on
-- the sales table
 
CREATE TRIGGER checkout_discount
  AFTER INSERT ON sales
  FOR EACH STATEMENT
  EXECUTE PROCEDURE discount();

