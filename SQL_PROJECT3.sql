
# 1.Create DataBase BANK and Write SQL query to create above schema with constraints

-- DATABASE CREATION ---------------------------------------------------------------

CREATE DATABASE BANK_PROJECT3;
USE BANK_PROJECT3;

-- TABLE CREATION ---------------------------------------------------------------

# CUSTOMER TABLE
CREATE TABLE CUSTOMER(
CUSTID INT NOT NULL,
FNAME CHAR(30),
MNAME CHAR(30),
LNAME CHAR(30),
OCCUPATION CHAR(10),
DOB DATE,
PRIMARY KEY(CUSTID));

# BRANCH_MSTR TABLE
CREATE TABLE BRANCH_MSTR(
BRANCH_NO INT NOT NULL,
NAME CHAR(50) NOT NULL,
PRIMARY KEY(BRANCH_NO));

# EMPLOYEE TABLE
CREATE TABLE EMPLOYEE(
EMP_NO INT NOT NULL,
BRANCH_NO INT,
FNAME CHAR(30),
MNAME CHAR(30),
LNAME CHAR(30),
DEPT CHAR(20),
DESIG CHAR(10),
MNGR_NO INT NOT NULL,
PRIMARY KEY(EMP_NO),
FOREIGN KEY (EMP_NO) REFERENCES BRANCH_MSTR(BRANCH_NO));

# ACCOUNT TABLE
CREATE TABLE ACCOUNT(
ACNUMBER INT NOT NULL,
CUSTID INT NOT NULL,
BID INT NOT NULL,
CURBAL INT,
ATYPE CHAR(10),
OPNDT DATE,
ASTATUS CHAR(10),
PRIMARY KEY (ACNUMBER),
FOREIGN KEY (CUSTID) REFERENCES CUSTOMER(CUSTID),
FOREIGN KEY (BID) REFERENCES BRANCH_MSTR(BRANCH_NO));

-- ---------------------------------------------------------------

# 2.	Inserting Records into created tables

# BRANCH TABLE
INSERT INTO BRANCH_MSTR VALUES
(1,"DELHI"),
(2,"MUMBAI");

# CUSTOMER TABLE
INSERT INTO CUSTOMER VALUES
(1,"Ramesh","Chandra","Sharma","Service","1976-12-06"),
(2,"Avinash","Sunder","Minha","Business","1974-10-16");

# ACCOUNT TABLE
INSERT INTO ACCOUNT VALUES
(1,1,1,10000,"Saving","2012-12-15","Active"),
(2,2,2,5000,"Saving","2012-06-12","Active");

# EMPLOYEE TABLE
INSERT INTO EMPLOYEE VALUES
(1,1,"Mark","steve","Lara","Account","Accountant",2),
(2,2,"Bella","James","Ronald","Loan","Manager",1);

-- --------------------------------------------------------------------

# 3.Select unique occupation from customer table

SELECT DISTINCT OCCUPATION FROM CUSTOMER;

# 4.Sort accounts according to current balance 

SELECT * FROM ACCOUNT ORDER BY CURBAL;

# 5.Find the Date of Birth of customer name ‘Ramesh’

SELECT DOB FROM CUSTOMER WHERE FNAME='RAMESH';

# 6.Add column city to branch table 

ALTER TABLE BRANCH_MSTR
ADD COLUMN CITY VARCHAR(20);

# 7.Update the mname and lname of employee ‘Bella’ and set to ‘Karan’, ‘Singh’ 

SELECT * FROM EMPLOYEE;
UPDATE EMPLOYEE 
SET MNAME="KARAN",LNAME="SINGH"
WHERE FNAME="BELLA";

# 8.Select accounts opened between '2012-07-01' AND '2013-01-01'

SELECT * FROM ACCOUNT WHERE OPNDT BETWEEN '2012-07-01' AND '2013-01-01';

# 9.List the names of customers having ‘a’ as the second letter in their names 

SELECT * FROM CUSTOMER WHERE FNAME LIKE "_A%";


# 10.Find the lowest balance from customer and account table

SELECT *
FROM CUSTOMER C JOIN ACCOUNT A
ON C.CUSTID=A.CUSTID
ORDER BY A.CURBAL ASC
LIMIT 1;

# 11.Give the count of customer for each occupation

SELECT OCCUPATION,COUNT(CUSTID) FROM CUSTOMER GROUP BY OCCUPATION;

# 12.Write a query to find the name (first_name, last_name) of the employees who are managers.

SELECT FNAME,LNAME FROM EMPLOYEE WHERE DESIG="MANAGER";

# 13.List name of all employees whose name ends with a

SELECT FNAME FROM EMPLOYEE WHERE FNAME LIKE "%A";

# 14.Select the details of the employee who work either for department ‘loan’ or ‘credit’

SELECT * FROM EMPLOYEE WHERE DEPT IN ("LOAN","CREDIT");

# 15.Write a query to display the customer number, customer firstname, account number for the 

SELECT C.CUSTID,C.FNAME,A.ACNUMBER
FROM customer C JOIN account A
ON C.CUSTID=A.CUSTID;

# 16.Write a query to display the customer’s number, customer’s firstname, branch id and balance amount for people using JOIN.

SELECT C.CUSTID,C.FNAME,B.BRANCH_NO,A.CURBAL
FROM CUSTOMER C JOIN ACCOUNT A
ON C.CUSTID=A.CUSTID
JOIN BRANCH_MSTR B
ON B.BRANCH_NO=A.BID;

# 17.Create a virtual table to store the customers who are having the accounts in the same city as they live


/*
18.	A. Create a transaction table with following details 
TID – transaction ID – Primary key with autoincrement 
Custid – customer id (reference from customer table
account no – acoount number (references account table)
bid – Branch id – references branch table
amount – amount in numbers
type – type of transaction (Withdraw or deposit)
DOT -  date of transaction

a. Write trigger to update balance in account table on Deposit or Withdraw in transaction table
b. Insert values in transaction table to show trigger success

*/

CREATE TABLE TRANSACTION(
TID INT NOT NULL AUTO_INCREMENT,
CUSTID INT,
ACCOUNT_NO INT,
BID INT,
AMOUNT FLOAT,
TYPE varchar(20) CHECK(TYPE IN ("WITHDRAW","DEPOSIT")),
DOT DATE,
PRIMARY KEY(TID),
foreign key (CUSTID) references CUSTOMER(CUSTID),
foreign key (ACCOUNT_NO) references ACCOUNT(ACNUMBER),
foreign key (BID) references BRANCH_MSTR(BRANCH_NO)
);

# 19.Write a query to display the details of customer with second highest balance 

SELECT * 
FROM CUSTOMER C JOIN ACCOUNT A
ON C.CUSTID=A.CUSTID
ORDER BY A.CURBAL DESC
LIMIT 1,1;


-- PART B --------------------------------------------------------------------------

/*
1. Display the product details as per the following criteria and sort them in descending order of category:
   #a.  If the category is 2050, increase the price by 2000
   #b.  If the category is 2051, increase the price by 500
   #c.  If the category is 2052, increase the price by 600

*/

SELECT *,IF(PRODUCT_CLASS_CODE=2050,PRODUCT_PRICE+2000,IF(PRODUCT_CLASS_CODE=2051,PRODUCT_PRICE+500,IF(PRODUCT_CLASS_CODE=2052,PRODUCT_PRICE+600,PRODUCT_PRICE))) REVISED_PRICE
FROM product
ORDER BY PRODUCT_CLASS_CODE DESC;

# 2.List the product description, class description and price of all products which are shipped. 

SELECT distinct PRODUCT_DESC,PRODUCT_CLASS_DESC,PRODUCT_PRICE
FROM product P JOIN product_class PC
ON P.PRODUCT_CLASS_CODE=PC.PRODUCT_CLASS_CODE
JOIN order_items OI
ON OI.PRODUCT_ID=P.PRODUCT_ID
JOIN order_header OH
ON OH.ORDER_ID=OI.ORDER_ID
WHERE ORDER_STATUS="SHIPPED";

/*

3. Show inventory status of products as below as per their available quantity:
#a. For Electronics and Computer categories, if available quantity is < 10, show 'Low stock', 11 < qty < 30, show 'In stock', > 31, show 'Enough stock'
#b. For Stationery and Clothes categories, if qty < 20, show 'Low stock', 21 < qty < 80, show 'In stock', > 81, show 'Enough stock'
#c. Rest of the categories, if qty < 15 – 'Low Stock', 16 < qty < 50 – 'In Stock', > 51 – 'Enough stock'
#For all categories, if available quantity is 0, show 'Out of stock'.

*/

SELECT PRODUCT_ID,PRODUCT_DESC,PC.PRODUCT_CLASS_CODE,P.PRODUCT_QUANTITY_AVAIL,
CASE PC.PRODUCT_CLASS_CODE

WHEN PC.PRODUCT_CLASS_CODE IN ("Electronics","Computer") THEN
	IF(PRODUCT_QUANTITY_AVAIL=0,"OUT OF STOCK", IF(PRODUCT_QUANTITY_AVAIL<10,"LOW STOCK",IF(PRODUCT_QUANTITY_AVAIL BETWEEN 11 AND 30,"IN STOCK","ENOUGH STOCK")))
WHEN PC.PRODUCT_CLASS_CODE IN ("Stationery","Clothes") THEN
	IF(PRODUCT_QUANTITY_AVAIL=0,"OUT OF STOCK", IF(PRODUCT_QUANTITY_AVAIL<20,"LOW STOCK",IF(PRODUCT_QUANTITY_AVAIL BETWEEN 21 AND 80,"IN STOCK","ENOUGH STOCK")))
ELSE
	IF(PRODUCT_QUANTITY_AVAIL=0,"OUT OF STOCK", IF(PRODUCT_QUANTITY_AVAIL<15,"LOW STOCK",IF(PRODUCT_QUANTITY_AVAIL BETWEEN 16 AND 50,"IN STOCK","ENOUGH STOCK")))
    
END STOCK

FROM product P JOIN product_class PC
ON P.PRODUCT_CLASS_CODE=PC.PRODUCT_CLASS_CODE;

# 4.List customers from outside Karnataka who haven’t bought any toys or books

SELECT DISTINCT OC.CUSTOMER_ID,OC.CUSTOMER_FNAME,OC.CUSTOMER_LNAME,A.STATE
FROM online_customer OC JOIN address A
ON OC.ADDRESS_ID=A.ADDRESS_ID
JOIN order_header OH
ON OC.CUSTOMER_ID=OH.CUSTOMER_ID
JOIN order_items OI
ON OH.ORDER_ID=OI.ORDER_ID
JOIN product P
ON OI.PRODUCT_ID=P.PRODUCT_ID
JOIN product_class PC
ON PC.PRODUCT_CLASS_CODE=P.PRODUCT_CLASS_CODE
WHERE A.STATE!="Karnataka" 
AND OC.CUSTOMER_ID NOT IN 
	(SELECT OC.CUSTOMER_ID
		FROM online_customer OC JOIN address A
		ON OC.ADDRESS_ID=A.ADDRESS_ID
		JOIN order_header OH
		ON OC.CUSTOMER_ID=OH.CUSTOMER_ID
		JOIN order_items OI
		ON OH.ORDER_ID=OI.ORDER_ID
		JOIN product P
		ON OI.PRODUCT_ID=P.PRODUCT_ID
		JOIN product_class PC
		ON PC.PRODUCT_CLASS_CODE=P.PRODUCT_CLASS_CODE
        WHERE PRODUCT_CLASS_DESC IN ("TOYS","BOOKS"));
        
	