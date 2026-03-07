

--DimCustomer
-- Merge before fix
MERGE INTO dimCustomer dc
USING
(
    SELECT customerNumber, customerName, contactLastName, contactFirstName
    ,phone, addressLine1, addressLine2, city,
    [state],postalCode, country, creditLimit 
    FROM sales_AU_NZ.dbo.customer c1
    WHERE c1.%%physloc%% NOT IN(
        SELECT RowID
        FROM DQLog
        WHERE DBName = 'sales_AU_NZ'
        AND TableName = 'customer'
        AND RuleNo = 7 AND Action = 'reject'
        UNION
        SELECT RowID
        FROM DQLog
        WHERE DBName = 'sales_AU_NZ'
        AND TableName = 'customer'
        AND RuleNo = 5 AND Action = 'fix'
    )
	


) c ON (dc.customerNumber = c.customerNumber) -- Assume customerNumber is unique
WHEN MATCHED THEN
    -- if customerNumber matched, do nothing
    UPDATE SET dc.customerName = c.customerName -- Dummy update
WHEN NOT MATCHED THEN
    -- Otherwise, insert a new customer
    INSERT(customerNumber, customerName, contactLastName,contactFirstName,
    phone, addressLine1, addressLine2, city,
    [state],postalCode, country, creditLimit)
    VALUES(c.customerNumber, c.customerName, c.contactLastName,c.contactFirstName,
    c.phone, c.addressLine1, c.addressLine2, c.city,
    c.[state],c.postalCode, c.country, c.creditLimit);

-- fix after merge
MERGE INTO dimCustomer dc
USING
(
    SELECT customerNumber, customerName, contactLastName, contactFirstName
    ,phone, addressLine1, addressLine2, city,
    [state],postalCode, country, creditLimit 
    FROM sales_AU_NZ.dbo.customer c1
    WHERE c1.%%physloc%% IN(
        SELECT RowID
        FROM DQLog
        WHERE DBName = 'sales_AU_NZ'
        AND TableName = 'customer'
        AND RuleNo = 5 AND Action = 'fix'
    )
	


) c ON (dc.customerNumber = c.customerNumber) -- Assume customerNumber is unique
WHEN MATCHED THEN
    -- if customerNumber matched, do nothing
    UPDATE SET dc.customerName = c.customerName -- Dummy update
WHEN NOT MATCHED THEN
    -- Otherwise, insert a new customer
    INSERT(customerNumber, customerName, contactLastName,contactFirstName,
    phone, addressLine1, addressLine2, city,
    [state],postalCode, country, creditLimit)
    VALUES(c.customerNumber, c.customerName, c.contactLastName,c.contactFirstName,
    c.phone, c.addressLine1, c.addressLine2, c.city,
    c.[state],c.postalCode, 
     CASE 
        WHEN Lower(c.country) IN ('australia') THEN 'AU'
        WHEN Lower(c.country) IN ('new zealand') THEN 'NZ'
        ELSE 'NOT IN AU OR NZ'
    END,
     c.creditLimit);



--DimEmployee
--Merge before fix
MERGE INTO dimEmployee de
USING
(
    SELECT employeeNumber, lastName, firstName,
    extension, email, e.officeCode, reportsTo,
    jobTitle, city, phone, addressLine1,addressLine2,
    [state],country,postalCode,territory 
    FROM sales_AU_NZ.dbo.employee e, sales_AU_NZ.dbo.office o
    WHERE e.officeCode = o.officeCode
    AND o.%%physloc%% NOT IN(
        SELECT RowID
        FROM DQLog
        WHERE DBName = 'sales_AU_NZ'
        AND TableName = 'office'
        AND RuleNo = 5 AND Action = 'fix'
       
    )
) e ON (de.employeeNumber = e.employeeNumber) -- Assume employeeNumber is unique
WHEN MATCHED THEN
    -- if employeeNumber matched, do nothing
    UPDATE SET de.lastName = e.lastName -- Dummy update
WHEN NOT MATCHED THEN
    -- Otherwise, insert a new employee
    INSERT(employeeNumber, lastName, firstName,
    extension, email, officeCode, reportsTo,jobTitle,
    city, phone, addressLine1,addressLine2,[state],country,postalCode,territory)
    VALUES(e.employeeNumber, e.lastName, e.firstName,e.extension, e.email, e.officeCode, e.reportsTo,e.jobTitle,
    e.city, e.phone, e.addressLine1,e.addressLine2,e.[state],e.country,e.postalCode,e.territory);

-- fix after merge
MERGE INTO dimEmployee de
USING
(
    SELECT employeeNumber, lastName, firstName,
    extension, email, e.officeCode, reportsTo,
    jobTitle, city, phone, addressLine1,addressLine2,
    [state],country,postalCode,territory 
    FROM sales_AU_NZ.dbo.employee e, sales_AU_NZ.dbo.office o
    WHERE e.officeCode = o.officeCode
    AND o.%%physloc%%  IN(
        SELECT RowID
        FROM DQLog
        WHERE DBName = 'sales_AU_NZ'
        AND TableName = 'office'
        AND RuleNo = 5 AND Action = 'fix'
       
    )
) e ON (de.employeeNumber = e.employeeNumber) -- Assume employeeNumber is unique
WHEN MATCHED THEN
    -- if employeeNumber matched, do nothing
    UPDATE SET de.lastName = e.lastName -- Dummy update
WHEN NOT MATCHED THEN
    -- Otherwise, insert a new employee
    INSERT(employeeNumber, lastName, firstName,
    extension, email, officeCode, reportsTo,jobTitle,
    city, phone, addressLine1,addressLine2,[state],country,postalCode,territory)
    VALUES(e.employeeNumber, e.lastName, e.firstName,e.extension, e.email, e.officeCode, e.reportsTo,e.jobTitle,
    e.city, e.phone, e.addressLine1,e.addressLine2,e.[state],
    CASE 
        WHEN Lower(e.country) IN ('australia') THEN 'AU'
        WHEN Lower(e.country) IN ('new zealand') THEN 'NZ'
        ELSE 'NOT IN AU OR NZ'
    END,e.postalCode,e.territory);

--DimProduct
--merge before fix
MERGE INTO   	dimProduct dp 
USING  	 	 	 	 
( 
	SELECT 	productCode, productName,productScale,productVendor,
    productDescription, quantityInStock, buyPrice, MSRP,textDescription,htmlDescription,
    pimage 
 	     FROM        sales_AU_NZ.dbo.product p, sales_AU_NZ.dbo.productline pl
      WHERE p.productLine = pl.productLine
      AND p.%%physloc%% NOT IN(
        SELECT RowID
        FROM DQLog
        WHERE DBName = 'sales_AU_NZ'
        AND TableName = 'product'
        AND RuleNo = 1 AND Action = 'fix'
        UNION
        SELECT RowID
        FROM DQLog
        WHERE DBName = 'sales_AU_NZ'
        AND TableName = 'product'
        AND RuleNo = 4 AND Action = 'reject'
             ) 
) pc ON (dp.productCode = pc.ProductCode)  	-- Assume ProductCode is unique 
WHEN MATCHED THEN  	 	 	-- if ProductID matched, do nothing
UPDATE SET dp.productName = pc.productName 	-- Dummy update 
WHEN NOT MATCHED THEN  	 	-- Otherwise, insert a new product 
INSERT (productCode, productName, productScale, productVendor,
    productDescription, quantityInStock, buyPrice, MSRP,textDescription,htmlDescription,
    pimage)
VALUES(pc.productCode, pc.productName, pc.productScale, pc.productVendor,
    pc.productDescription, pc.quantityInStock, pc.buyPrice, pc.MSRP,pc.textDescription,pc.htmlDescription,
    pc.pimage);

-- fix after merge
MERGE INTO   	dimProduct dp 
USING  	 	 	 	 
( 
	SELECT 	productCode, productName,productScale,productVendor,
    productDescription, quantityInStock, buyPrice, MSRP,textDescription,htmlDescription,
    pimage 
 	     FROM        sales_AU_NZ.dbo.product p, sales_AU_NZ.dbo.productline pl
      WHERE p.productLine = pl.productLine
      AND p.%%physloc%%  IN(
        SELECT RowID
        FROM DQLog
        WHERE DBName = 'sales_AU_NZ'
        AND TableName = 'product'
        AND RuleNo = 1 AND Action = 'fix'
        
             ) 
) pc ON (dp.productCode = pc.ProductCode)  	-- Assume ProductCode is unique 
WHEN MATCHED THEN  	 	 	-- if ProductID matched, do nothing
UPDATE SET dp.productName = pc.productName 	-- Dummy update 
WHEN NOT MATCHED THEN  	 	-- Otherwise, insert a new product 
INSERT (productCode, productName, productScale, productVendor,
    productDescription, quantityInStock, buyPrice, MSRP,textDescription,htmlDescription,
    pimage)
VALUES(pc.productCode, pc.productName, pc.productScale, pc.productVendor,
    pc.productDescription, pc.quantityInStock, 
    CASE 
    WHEN pc.buyPrice < 0 THEN ABS(pc.buyPrice)
    END, pc.MSRP,pc.textDescription,pc.htmlDescription,
    pc.pimage);


--DimFactOrder
-- merge before fix
MERGE INTO factOrder fo
USING(
    SELECT productKey, customerKey,
    dt1.TimeKey AS [OrderDateKey], -- from dimTime
    dt2.TimeKey AS [RequiredDateKey], -- from dimTime
    dt3.TimeKey AS [ShippedDateKey], -- from dimTime
    po.orderNumber AS [OrderNumber],
    po.status AS [Status],
    po.comments AS [Comments],
    od.quantityOrdered AS [QuantityOrdered],
    od.priceEach AS [PriceEach],
    od.orderLineNumber AS [OrderLineNumber],
    od.quantityOrdered * od.priceEach AS [TotalPrice], -- Calculation!
    od.quantityOrdered * (od.priceEach - dp.buyPrice) AS [TotalProfit], -- Calculation!
    od.quantityOrdered * (dp.MSRP - dp.buyPrice) AS [TotalPossibleProfit] -- Calculation!
    FROM sales_AU_NZ.dbo.productorder po,
    sales_AU_NZ.dbo.orderdetail od,
    dimTime dt1,
    dimTime dt2,    
    dimTime dt3,
    dimProduct dp,
    dimCustomer dc
    WHERE po.orderNumber = od.orderNumber
    AND po.customerNumber = dc.customerNumber
    AND od.productCode = dp.productCode
    AND dt1.date = po.orderDate
    AND dt2.date = po.requiredDate  
    AND dt3.date = po.shippedDate
    AND po.%%physloc%% NOT IN(
        SELECT RowID
        FROM DQLog
        WHERE DBName = 'sales_AU_NZ'
        AND TableName = 'productorder'
        AND RuleNo = 8 AND Action = 'reject'
        UNION 
        SELECT RowID
        FROM DQLog
        WHERE DBName = 'sales_AU_NZ'
        AND TableName = 'productorder'
        AND RuleNo = 8 AND Action = 'fix'
    )
) o ON (
    o.orderLineNumber = fo.orderLineNumber AND
    o.orderNumber = fo.orderNumber
)
WHEN MATCHED THEN -- if they matched, do nothing
UPDATE SET fo.orderNumber = o.orderNumber -- Dummy update
WHEN NOT MATCHED THEN -- Otherwise, insert a new row
INSERT(productKey, customerKey, orderDateKey, requiredDateKey,
shippedDateKey, orderNumber, status, comments, quantityOrdered, priceEach, orderLineNumber, totalPrice, totalProfit, totalPossibleProfit)
VALUES(o.productKey, o.customerKey, o.orderDateKey, o.requiredDateKey,
o.shippedDateKey, o.orderNumber, o.status, o.comments, o.quantityOrdered, o.priceEach, o.orderLineNumber, o.totalPrice, o.totalProfit, o.totalPossibleProfit);

-- fix then merge
MERGE INTO factOrder fo
USING(
    SELECT productKey, customerKey,
    dt1.TimeKey AS [OrderDateKey], -- from dimTime
    dt2.TimeKey AS [RequiredDateKey], -- from dimTime
    dt3.TimeKey AS [ShippedDateKey], -- from dimTime
    po.orderNumber AS [OrderNumber],
    po.status AS [Status],
    po.comments AS [Comments],
    od.quantityOrdered AS [QuantityOrdered],
    od.priceEach AS [PriceEach],
    od.orderLineNumber AS [OrderLineNumber],
    od.quantityOrdered * od.priceEach AS [TotalPrice], -- Calculation!
    od.quantityOrdered * (od.priceEach - dp.buyPrice) AS [TotalProfit], -- Calculation!
    od.quantityOrdered * (dp.MSRP - dp.buyPrice) AS [TotalPossibleProfit] -- Calculation!
    FROM sales_AU_NZ.dbo.productorder po,
    sales_AU_NZ.dbo.orderdetail od,
    dimTime dt1,
    dimTime dt2,    
    dimTime dt3,
    dimProduct dp,
    dimCustomer dc
    WHERE po.orderNumber = od.orderNumber
    AND po.customerNumber = dc.customerNumber
    AND od.productCode = dp.productCode
    AND dt1.date = po.orderDate
    AND dt2.date = po.requiredDate  
    AND dt3.date = po.shippedDate
    AND po.%%physloc%% IN(
        SELECT RowID
        FROM DQLog
        WHERE DBName = 'sales_AU_NZ'
        AND TableName = 'productorder'
        AND RuleNo = 8 AND Action = 'fix'
    )
) o ON (
    o.orderLineNumber = fo.orderLineNumber AND
    o.orderNumber = fo.orderNumber
)
WHEN MATCHED THEN -- if they matched, do nothing
UPDATE SET fo.orderNumber = o.orderNumber -- Dummy update
WHEN NOT MATCHED THEN -- Otherwise, insert a new row
INSERT(productKey, customerKey, orderDateKey, requiredDateKey,
shippedDateKey, orderNumber, status, comments, quantityOrdered, priceEach, orderLineNumber, totalPrice, totalProfit, totalPossibleProfit)
VALUES(o.productKey, o.customerKey, o.orderDateKey,
CASE 
WHEN o.requiredDateKey IS NULL THEN o.orderDateKey + 7 END,
CASE
WHEN o.shippedDateKey IS NULL THEN o.orderDateKey + 2 END
, o.orderNumber, o.status, o.comments, o.quantityOrdered, o.priceEach, o.orderLineNumber, o.totalPrice, o.totalProfit, o.totalPossibleProfit);


--DimFactPayment
MERGE INTO factPayment AS fp
USING (
    SELECT
        dc.customerKey,
        de.employeeKey,
        dt.TimeKey AS paymentDateKey,
        py.amount,
        py.checkNumber
    FROM sales_AU_NZ.dbo.payment py, sales_AU_NZ.dbo.customer c, dimCustomer dc, sales_AU_NZ.dbo.employee e, dimEmployee de, dimTime dt
    WHERE py.customerNumber = c.customerNumber
    AND c.salesRepEmployeeNumber = e.employeeNumber
    AND dt.date = py.paymentDate
    AND dc.customerNumber = c.customerNumber
    AND de.employeeNumber = e.employeeNumber
    
) AS src
ON (
    fp.customerKey = src.customerKey AND
    fp.employeeKey = src.employeeKey AND
    fp.paymentDateKey = src.paymentDateKey
    AND fp.checkNumber = src.checkNumber
)
WHEN MATCHED THEN
    UPDATE SET 
    fp.amount = src.amount
WHEN NOT MATCHED THEN
    INSERT (customerKey, employeeKey, paymentDateKey, amount, checkNumber)
    VALUES (src.customerKey, src.employeeKey, src.paymentDateKey, src.amount, src.checkNumber);
