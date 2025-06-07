-- Report 1
-- Monthly report on the most profitable employees. 
--For each employee, display its name, city, country, the total number of customers he/she supported, 
--the total number of payments from his/her customers processed. Rank the employees based on the number of
-- profits generated in descending order.
SELECT 
    e.firstName + ' ' + e.lastName AS employeeName,
    e.city,
    e.country,
	COUNT(DISTINCT p.customerKey) AS [total number of customers],
	COUNT(p.checkNumber) AS [total number of payments],
	SUM(o.totalProfit) AS totalProfitGenerated,
	FORMAT(t.[Date], 'yyyy-MM') AS reportMonth,
	RANK() OVER (PARTITION BY FORMAT(t.[Date], 'yyyy-MM') ORDER BY SUM(o.totalProfit) DESC) AS profitRank  --highlight
   
FROM factPayment p
JOIN dimEmployee e ON p.employeeKey = e.employeeKey
JOIN dimTime t ON p.paymentDateKey = t.TimeKey
JOIN dimCustomer c ON p.customerKey = c.customerKey
JOIN factOrder o ON o.customerKey = c.customerKey
   
GROUP BY 
    e.firstName, e.lastName, e.city, e.country, FORMAT(t.[Date], 'yyyy-MM') 
ORDER BY reportMonth;




-- Report 2
SELECT 
    c.city,
    c.country,
    COUNT(o.productKey) AS totalProductsSold,
    COUNT(DISTINCT p.productVendor) AS totalProductVendorsSold,
    COUNT(DISTINCT c.customerKey) AS totalCustomersInCity,
    SUM(o.totalPrice) AS totalSales,
    RANK() OVER (ORDER BY SUM(o.totalPrice) DESC) AS salesRank
FROM factOrder o
JOIN dimCustomer c ON o.customerKey = c.customerKey
JOIN dimProduct p ON o.productKey = p.productKey
GROUP BY c.city, c.country
ORDER BY salesRank;

--Report 3
SELECT 
    dt.[Month] + ' ' + CAST(dt.[Year] AS varchar) AS [MonthYear],
    dc.customerName,
    COUNT(fo.productKey) AS totalProductsBought,
    COUNT(DISTINCT dp.productVendor) AS totalCategoriesBought,
    SUM(fo.totalPrice) AS totalSales,
    SUM(fo.totalProfit) AS totalProfitOrLoss,
    RANK() OVER (PARTITION BY dt.[Year], dt.[MonthOfYear] 
                 ORDER BY SUM(fo.totalProfit) DESC) AS profitRank
FROM 
    factOrder fo
    INNER JOIN dimCustomer dc ON fo.customerKey = dc.customerKey
    INNER JOIN dimProduct dp ON fo.productKey = dp.productKey
    INNER JOIN dimTime dt ON fo.orderDateKey = dt.TimeKey
GROUP BY 
    dt.[Month], dt.[Year], dt.[MonthOfYear], dc.customerName
ORDER BY 
    dt.[Year], dt.[MonthOfYear], profitRank;


--Report 4
SELECT 
    dt.[Month] + ' ' + CAST(dt.[Year] AS varchar) AS [MonthYear],
    dp.productVendor AS productLine,
    
    COUNT(*) AS totalSalesCount,

    SUM(fo.totalProfit) AS totalProfit,


    SUM(fo.totalPrice) AS totalPossibleProfit,

    --Calculate profit gap: possible - actual
    SUM(fo.totalPrice) - SUM(fo.totalProfit) AS profitGap,

    -- Rank product lines by actual profit descending
    RANK() OVER (
        PARTITION BY dt.[Year], dt.[MonthOfYear]
        ORDER BY SUM(fo.totalProfit) DESC
    ) AS profitRank

FROM 
    factOrder fo
    INNER JOIN dimProduct dp ON fo.productKey = dp.productKey
    INNER JOIN dimTime dt ON fo.orderDateKey = dt.TimeKey

GROUP BY 
    dt.[Year], dt.[MonthOfYear], dt.[Month], dp.productVendor

ORDER BY 
    dt.[Year], dt.[MonthOfYear], profitRank;
