/*  ___________________________----------------------Project---------------------___________________________________*/

USE mintclassics;
SHOW TABLES;
SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM offices;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM payments;
SELECT * FROM productlines;
SELECT * FROM products;
SELECT * FROM warehouses;

SELECT P.productName , SUM(OD.quantityOrdered) AS TotalQuantityOrdered, P.warehouseCode
FROM orderDetails OD
LEFT JOIN products P 
ON OD.productCode = P.productCode
WHERE P.warehouseCode = "b"
GROUP BY P.productName
ORDER BY TotalQuantityOrdered DESC;


-- 1. Count of Orders by Customers.
SELECT C.customerNumber , C.customerName , C.phone , C.postalCode , C.creditLimit ,
count(O.orderNumber) AS orderCount FROM
customers C INNER JOIN orders O 
on C.customerNumber = O.customerNumber
GROUP BY customerNumber
ORDER BY orderCount DESC, creditLimit DESC;

-- 2. Count of Orders by Customers creditLimit.
SELECT C.customerNumber , C.customerName , C.phone , C.postalCode , C.creditLimit ,
count(O.orderNumber) AS orderCount FROM
customers C INNER JOIN orders O 
on C.customerNumber = O.customerNumber
GROUP BY customerNumber
ORDER BY creditLimit DESC;

SELECT ROUND(AVG(creditLimit),0)
as avgCreditLimit 
FROM customers;

-- The Highest Ordered done by "Euro+ Shopping Channel" and the order count is 26 also they have highest Credit Limit amongs all the customers
-- The Lowest Ordered done by "Bavarian Collectables Imports, Co." and the order count is only 1. 
-- Some of the customers have High credit limit but count of orders is less as compare to Low credit limit customers.  
-- Avg credit limit is around 68000. So, we should take survay about there experiance and requirement from those customers who have more than 68000 credit limit but count is low. 


-- 3. Which Product have highest demand.
SELECT sum(OD.quantityOrdered) AS totalOrder, count(OD.orderNumber) AS orderCount, P.productName,
P.productCode
FROM orderdetails OD 
LEFT JOIN products P 
ON OD.productCode = P.productCode
GROUP BY P.productCode
ORDER BY orderCount DESC;
-- The Product Name  "1992 Ferrari 360 Spider red" have highest demand and 56 ordered done by the customers.


-- 4. Which office have most customers?

SELECT COUNT(C.customerNumber) as custCount, E.jobTitle, OFFI.officeCode, OFFI.city
FROM customers C LEFT JOIN employees E
ON C.salesRepEmployeeNumber = E.employeeNumber
LEFT JOIN offices OFFI
ON E.officeCode = OFFI.officeCode
GROUP BY OFFI.officeCode,E.jobTitle,OFFI.city
HAVING E.jobTitle IS NOT NULL
ORDER BY custCount DESC ;

-- The highest customers are from paris city and least from tokyo city
-- We should focus on the customers demand and requirments.


-- 5. is every product is sold to customer?
SELECT * FROM orderdetails;
SELECT * FROM products;

SELECT P.productName, COUNT(OD.productCode) AS productCount
FROM products P 
LEFT JOIN orderDetails OD
ON P.productCode = OD.productCode
GROUP BY productName 
ORDER BY productCount DESC;

-- No, there is one product which is '1985 Toyota Supra' not ordered by any customers.
-- We can reduce the storage of this product.

SELECT P.productName , SUM(P.quantityInStock) AS TotalQuantityInStock, P.warehouseCode
FROM products P 
WHERE P.warehouseCode = "b"
GROUP BY P.productName
ORDER BY TotalQuantityInStock DESC ;
-- Total quantity in stock in warehouseCode b by Product Name.

SELECT P.productName , SUM(OD.quantityOrdered) AS TotalQuantityOrdered, P.warehouseCode
FROM orderDetails OD
LEFT JOIN products P 
ON OD.productCode = P.productCode
WHERE P.warehouseCode = "b"
GROUP BY P.productName
ORDER BY TotalQuantityOrdered DESC;
-- Total Quantity Ordered in warehouseCode b by Product Name. 


SELECT P.productName, SUM(P.quantityInStock) AS TotalQuantity, W.warehouseCode, W.warehouseName
FROM products P 
LEFT JOIN warehouses W
ON P.warehouseCode = W.warehouseCode
WHERE productName = "1985 Toyota Supra"
GROUP BY W.warehouseCode; 

/* Huge quantity store in the warehouseCode B for this product.
 We should remove or replace the product from warehouseCode B which is "1985 Toyota Supra"(7733 QTY in Stock) as there is no demand for it. */ 


-- 6. customer count by Employees
SELECT * FROM orders;
SELECT * FROM customers;

SELECT C.customerName, C.salesRepEmployeeNumber, COUNT(O.orderNumber) AS orderCount
FROM customers C 
RIGHT JOIN orders O
ON C.customerNumber = O.customerNumber
GROUP BY C.salesRepEmployeeNumber,C.customerName
ORDER BY orderCount DESC;
-- The most customers handle by emoloyee number 1370 and job title is Salaes Rep who is from Paris.
-- Also Paris have the most active customers.

SELECT * FROM employees 
WHERE employeeNumber = "1370";

SELECT orderNumber, comments, `status`
FROM orders
GROUP BY comments, orderNumber, `status`
HAVING COMMENTS IS NOT NULL
ORDER BY comments DESC;

-- Above Query shows us all the comments.

-- 7. Check the shipping duration of the products.

select * from orders;
ALTER TABLE orders
ADD COLUMN ExpectedDaysForDelevery int AFTER shippedDate;

ALTER TABLE orders
DROP COLUMN ExpectedDaysForDelevery;

UPDATE orders
SET ExpectedDaysForDelevery = datediff(requiredDate ,orderDate);

ALTER TABLE orders
ADD COLUMN ActualDaysForDelivery INT AFTER ExpectedDaysForDelevery;

UPDATE orders
SET ActualDaysForDelivery = DATEDIFF(shippedDate,orderDate);

ALTER TABLE orders
ADD COLUMN DaysMargin INT AFTER ActualDaysForDelivery;

UPDATE orders
SET DaysMargin = ExpectedDaysForDelevery-ActualDaysForDelivery;

SELECT * FROM orders
WHERE DaysMargin < 1;

-- Above query shows that 1 order took addition 56 days for delivery because customer don't have much credit limits to pay the bill.
-- So, always make sure that customer have enough credit limit for trasaction of the product. 

-- 8. Check the cancel and on hold transaction
SELECT * FROM orders
WHERE status in ("On Hold","Cancelled","Resolved");

-- Always check the customer credit limit and Budget to avoid future  conflicts.
-- Also give update about the shipping chargers and policies.  
-- Some of Customer cancelled the order that time our shipping pocies comes into the picture.
-- Maintain Proper and Clean Documentation to avoid unneccessary transaction and ordered.
-- before placing any order Always confirm it with customers and give status of the ordered. 
-- Give discount on specific orders.
-- Always check the credit limit and purchasing power of customer before placing any order for them to avoid future dispute. 
-- Always maintain transperancy between customers about the product. Always Give clear and Genuine information about the product.

SELECT * FROM PAYMENTS;
SELECT * FROM orders;

-- 9. Count the products and see which warehouse have most count. 
SELECT * FROM products;
SELECT * FROM warehouses;
SELECT * FROM orderdetails;

SELECT warehouseCode , SUM(quantityInStock) AS TotalQuantity
FROM products
GROUP BY warehouseCode
ORDER BY warehouseCode;
/*  a	131688
	b	219183
	c	124880
	d	79380 */

SELECT P.warehouseCode , SUM(OD.quantityOrdered) AS TotalQuantity
FROM orderdetails OD
LEFT JOIN products P
ON OD.productCode = P.productCode
GROUP BY P.warehouseCode
ORDER BY P.warehouseCode;
/*  a	24650
	b	35582
	c	22933
	d	22351*/

-- We should reduce the quantity of the products from the warehouse.



	

