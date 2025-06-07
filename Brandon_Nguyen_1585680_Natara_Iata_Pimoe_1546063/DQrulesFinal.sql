-- RULE 1: Reject if buyPrice is 0 or Null
INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_AU_NZ', 'product', 1, 'reject'
FROM sales_AU_NZ.dbo.product
WHERE buyPrice = 0 or buyPrice IS NULL;



INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_AU_NZ', 'product', 1, 'fix'
FROM sales_AU_NZ.dbo.product
WHERE buyPrice < 0;


--Rule 2
INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_AU_NZ', 'orderdetail', 2, 'reject'
FROM sales_AU_NZ.dbo.orderdetail
WHERE priceEach = 0 or  priceEach IS NULL;


INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_AU_NZ', 'orderdetail', 2, 'fix'
FROM sales_AU_NZ.dbo.orderdetail
WHERE priceEach < 0;


--Rule 3
INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_AU_NZ', 'orderdetail', 3, 'reject'
FROM sales_AU_NZ.dbo.orderdetail
WHERE QuantityOrdered = 0 or QuantityOrdered IS NULL;


INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_AU_NZ', 'orderdetail', 3, 'fix'
FROM sales_AU_NZ.dbo.orderdetail
WHERE QuantityOrdered < 0;


-- RULE 4: Reject if buyPrice >= MSRP
INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_AU_NZ', 'product', 4, 'reject'
FROM sales_AU_NZ.dbo.product
WHERE buyPrice >= MSRP;

-- Rule 5 
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%,'sales_AU_NZ','customer',5,'fix'
FROM sales_AU_NZ.dbo.customer
WHERE country NOT IN ('USA','NZ','AU');

INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%,'sales_AU_NZ','office',5,'fix'
FROM sales_AU_NZ.dbo.office
WHERE country NOT IN ('USA','NZ','AU');

-- Rule 6
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%,'sales_AU_NZ','orderdetail',6,'reject'
FROM sales_AU_NZ.dbo.orderdetail
WHERE productCode IS NULL;



-- Rule 7
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%,'sales_AU_NZ','customer',7,'reject'
FROM sales_AU_NZ.dbo.customer
WHERE customerNumber IS NULL 
OR addressLine1 IS NULL 
OR addressLine2 IS NULL
OR City IS NULL;
-- Rule 8

-- This rule checks for NULL values in the requiredDate and shippedDate columns of the productorder table.
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%,'sales_AU_NZ','productorder',8,'fix'
FROM sales_AU_NZ.dbo.productorder
WHERE requiredDate IS NULL OR shippedDate IS NULL;
-- this rule check if orderDate is Greater than requiredDate
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%,'sales_AU_NZ','productorder',8,'reject'
FROM sales_AU_NZ.dbo.productorder
WHERE orderDate > requiredDate;
-- this rule check if orderDate is Greater than shippedDate
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%,'sales_AU_NZ','productorder',8,'reject'
FROM sales_AU_NZ.dbo.productorder
WHERE orderDate > shippedDate;
-- Rule 9
-- This rule checks for NULL or negative values in the payment table
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%,'sales_AU_NZ','payment',9,'reject'
FROM sales_AU_NZ.dbo.payment
WHERE amount IS NULL OR amount < 0;

-- RULE 10: quantityInStock
-- Reject if null
INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_AU_NZ', 'product', 10, 'reject'
FROM sales_AU_NZ.dbo.product
WHERE quantityInStock IS NULL OR quantityInStock < 0;

