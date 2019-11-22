-- function to gives 10% discounts for the customer's every 10th purchase
CREATE OR REPLACE FUNCTION discount()
RETURNS trigger AS $discount$
DECLARE
    rec_sales   RECORD;
    cur_sales CURSOR IS
       SELECT t.salesno,t.sales_price
           FROM (
                 SELECT *, row_number() OVER(ORDER BY salesno ASC) AS row
                 FROM sales) t
           WHERE t.row % 10 = 0 and t.purchase_date = CURRENT_DATE;
BEGIN
   -- Open the cursor
   OPEN cur_sales;
   
   LOOP
    -- fetch row into the film
      FETCH cur_sales INTO rec_sales;
    -- exit when no more row to fetch
      EXIT WHEN NOT FOUND;
 
    -- build the output
      UPDATE sales SET sales_price = rec_sales.sales_price * 0.9 WHERE sales.salesno = rec_sales.salesno;
      
   END LOOP;
  
   -- Close the cursor
   CLOSE cur_sales;
 
   RETURN NULL;
END;
$discount$ LANGUAGE plpgsql;
