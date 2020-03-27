# Question 1:
create database if not exists training;
use training;

# Question 2:
create table demography (
    CustID INTEGER AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50),
    Age INTEGER,
    Gender VARCHAR(1)
);

# Question 3:
insert into demography (Name, Age, Gender)
values ('John',25,'M');

# Question 4:
insert into demography (Name, Age, Gender)
values ('Pawan', 26, 'M'),
('Hema',31,'F');

# Question 5:
insert into demography (Name, Gender)
values ('Rekha', 'F');

# Question 6:
SET SQL_SAFE_UPDATES = 0;

# Question 7:
UPDATE demography 
SET Age = NULL
WHERE Name = 'John';

# Question 8:
SELECT * FROM demography
where Age is null;

# Question 9:
delete From demography;

# Question 10:
drop table demography;


# MODULE 2

# Question 1:
SELECT account.account_id, account.cust_id, account.avail_balance
FROM account
where account.pending_balance > 2500 AND account.status = 'ACTIVE';

# Question 2:
SELECT * FROM account
WHERE year(account.open_date) = 2002;

# Question 3:
SELECT account.avail_balance, account.pending_balance
FROM account WHERE account.avail_balance != pending_balance;

# Question 4:
SELECT account_id
FROM account
WHERE account.account_id IN (1,10,23,27);

# Question 5:
SELECT account_id, avail_balance
FROM account
WHERE avail_balance > 100 AND avail_balance < 200;

# MODULE 3

# Question 1:
SELECT COUNT(*) FROM account;

# Question 2:
SELECT * FROM account LIMIT 2;

# Question 3:
SELECT * FROM account LIMIT 2,2;

# Question 4:
SELECT YEAR(birth_date) year_bdate, MONTH(birth_date) month_bdate, DAY(birth_date) day_bdate, WEEKDAY(birth_date) weekday_bdate
FROM individual;

# Question 5:
SELECT SUBSTRING('Please find the substring in this string',17,25);

# Question 6:
select abs(round(-25.76823,2)), sign(-25.76823);

# Question 7:
SELECT ADDDATE(CURDATE(),30);

# Question 8:
SELECT  SUBSTRING(fname,3), SUBSTRING(lname,-3)
FROM individual;

# Question 9:
SELECT UPPER(fname)
FROM individual
WHERE LENGTH(fname) = 5;

# Question 10:
SELECT MAX(avail_balance) max_bal, AVG(avail_balance) min_bal FROM account;

# MODULE 4

# Question 1:
SELECT cust_id,COUNT(*)
FROM account
GROUP BY cust_id;

# Question 2:
SELECT cust_id, COUNT(*)
FROM account
GROUP BY cust_id
HAVING COUNT(*) > 2;

# Question 3:
SELECT fname, birth_date
FROM individual
ORDER BY birth_date;

# Question 4:
SELECT YEAR(open_date), avail_balance
FROM account
WHERE YEAR(open_date) > 2000
ORDER BY YEAR(open_date);

# Question 5:
SELECT product_cd, MAX(pending_balance)
FROM account
WHERE product_cd IN ('CHK', 'SAV', 'CD')
GROUP BY product_cd;

# MODULE 5
# Question 1:
SELECT 
    employee.fname, employee.title, department.name
FROM
    employee
        JOIN
    department ON employee.dept_id = department.dept_id;

# Question 2:
SELECT 
    product.name, product_type.name
FROM
    product
        LEFT JOIN
    product_type ON product_type.product_type_cd = product.product_type_cd;

# Question 3:
SELECT concat(employee.fname,' ', employee.lname), concat(parent.fname,' ', parent.lname)
FROM employee
INNER JOIN employee AS parent ON employee.superior_emp_id = parent.emp_id;

# Question 4:
SELECT fname,lname
FROM employee
WHERE superior_emp_id IN (SELECT emp_id
FROM employee 
WHERE fname= 'Susan' and lname = 'Hawthorne'
);

# Question 5:
SELECT fname,lname
FROM employee
WHERE dept_id= 1 AND emp_id IN (SELECT employee.emp_id
FROM employee
INNER JOIN employee AS parent ON parent.superior_emp_id = employee.emp_id
);

