-- insert customers data
insert into customers values(
  1,
  'Betito',
  '1 fake street',
  '+316123457'
),(
  2,
  'Ankit',
  '2 fake street',
  '+316123458'
);

-- insert suppliers data
insert into suppliers values(
  1,
  'SupplierX'
),(
  2,
  'SupplierY'
);

-- insert into the products table
insert into products values(
  101,
  'Car',
  1
),(
  102,
  'Painting',
  2
),(
  103,
  'Wine',
  1
);

insert into sales values(
  1,
  '2016-03-02',
  5000,
  101,
  1
),(
  2,
  '2016-03-02',
  3000,
  102,
  1
),(
  3,
  '2016-04-02',
  500,
  103,
  2
);
