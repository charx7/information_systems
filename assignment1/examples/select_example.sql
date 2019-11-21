-- Select just a few columns
select id, name from company;

-- Select with a where clause
select name from company where age = 20;

-- Now with logical operators
select * from company where age > 20 and salary > 10000;
select * from company where salary is null;
select * from company where name like 'A%';

-- Calculate the counts (*) will select disctinct
select count(*) from company;
select max(age) from company;
