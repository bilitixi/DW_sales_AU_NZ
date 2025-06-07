-- create dimTime table
drop table Numbers_Small;
drop table Numbers_Big;
if exists (select * from sys.tables where name='dimTime')
	drop table dimTime;
go

CREATE TABLE Numbers_Small (Number INT);
INSERT INTO Numbers_Small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

CREATE TABLE Numbers_Big (Number_Big BIGINT);
INSERT INTO Numbers_Big ( Number_Big )
SELECT thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number as number_big
FROM numbers_small thousands, numbers_small hundreds, numbers_small tens, numbers_small ones;

CREATE TABLE dimTime(
[TimeKey] [int] NOT NULL PRIMARY KEY,
[Date] [datetime] NULL,
[Day] [char](10) NULL,
[DayOfWeek] [smallint] NULL,
[DayOfMonth] [smallint] NULL,
[DayOfYear] [smallint] NULL,
[WeekOfYear] [smallint] NULL,
[Month] [char](10) NULL,
[MonthOfYear] [smallint] NULL,
[QuarterOfYear] [smallint] NULL,
[Year] [int] NULL
);
INSERT INTO dimTime(TimeKey, Date) values(-1,'9999-12-31'); -- Create dummy for a "null" date/time
INSERT INTO dimTime (TimeKey, Date)
SELECT number_big, DATEADD(day, number_big,  '2013-01-01') as Date
FROM numbers_big
WHERE DATEADD(day, number_big,  '2013-01-01') BETWEEN '2013-01-01' AND '2016-12-31'
ORDER BY number_big;

/*
INSERT INTO dimTime (TimeKey, Date)
SELECT CONVERT(INT, CONVERT(CHAR(10),DATEADD(day, number_big,  '1996-01-01'), 112)) as DateKey,
CONVERT(DATE,DATEADD(day, number_big,  '1996-01-01')) as Date
FROM numbers_big
WHERE DATEADD(day, number_big,  '1996-01-01') BETWEEN '1996-01-01' AND '1998-12-31'
ORDER BY 1;
*/

UPDATE dimTime
SET Day = DATENAME(DW, Date),
DayOfWeek = DATEPART(WEEKDAY, Date),
DayOfMonth = DAY(Date),
DayOfYear = DATEPART(DY,Date),
WeekOfYear = DATEPART(WK,Date),
Month = DATENAME(MONTH,Date),
MonthOfYear = MONTH(Date),
QuarterOfYear = DATEPART(Q, Date),
Year = YEAR(Date);
drop table Numbers_Small;
drop table Numbers_Big;

Go

-- create dimProduct table
CREATE TABLE dimProduct (
  productKey int  IDENTITY(1,1) PRIMARY KEY,
  productCode varchar(15) NOT NULL,
  productName varchar(70) NOT NULL,
  productScale varchar(10) NOT NULL,
  productVendor varchar(50) NOT NULL,
  productDescription text NOT NULL,
  quantityInStock smallint NOT NULL,
  buyPrice decimal(10,2) NOT NULL,
  MSRP decimal(10,2) NOT NULL,
  textDescription varchar(4000) DEFAULT NULL,
  htmlDescription text,
  pimage image
)
-- create dimCustomer table
CREATE TABLE dimCustomer(
  customerKey int  IDENTITY(1,1) PRIMARY KEY,
  customerNumber int NOT NULL,
  customerName varchar(50) NOT NULL,
  contactLastName varchar(50) NOT NULL,
  contactFirstName varchar(50) NOT NULL,
  phone varchar(50) NOT NULL,
  addressLine1 varchar(50) NOT NULL,
  addressLine2 varchar(50) DEFAULT NULL,
  city varchar(50) NOT NULL,
  [state] varchar(50) DEFAULT NULL,
  postalCode varchar(15) DEFAULT NULL,
  country varchar(50) NOT NULL,
  creditLimit decimal(10,2) DEFAULT NULL
)

-- create dimEmployee table

create table dimEmployee(
  employeeKey int IDENTITY(1,1) PRIMARY KEY,
  employeeNumber int NOT NULL,
  lastName varchar(50) NOT NULL,
  firstName varchar(50) NOT NULL,
  extension varchar(10) NOT NULL,
  email varchar(100) NOT NULL,
  officeCode varchar(10) NOT NULL,
  reportsTo int DEFAULT NULL,
  jobTitle varchar(50) NOT NULL,
  city varchar(50) NOT NULL,
  phone varchar(50) NOT NULL, 
  addressLine1 varchar(50) NOT NULL,
  addressLine2 varchar(50) DEFAULT NULL,
  [state] varchar(50) DEFAULT NULL,
  country varchar(50) NOT NULL,
  postalCode varchar(15) NOT NULL,
  territory varchar(10) NOT NULL
)
--create factOrder table
CREATE TABLE factOrder(
    productKey int FOREIGN KEY REFERENCES dimProduct(productKey),
    customerKey int FOREIGN KEY REFERENCES dimCustomer(customerKey),
    orderDateKey int FOREIGN KEY REFERENCES dimTime(TimeKey),
    requiredDateKey int FOREIGN KEY REFERENCES dimTime(TimeKey),
    shippedDateKey int FOREIGN KEY REFERENCES dimTime(TimeKey),
    orderNumber int NOT NULL,
    [status] varchar(15) NOT NULL,
    comments text,
    quantityOrdered int NOT NULL,
    priceEach decimal(10,2) NOT NULL,
    orderLineNumber smallint NOT NULL,
    totalPrice		money		NOT NULL,
    totalProfit        money		NOT NULL,
    totalPossibleProfit money		NOT NULL,
    PRIMARY KEY (orderNumber,orderLineNumber))


-- create factPayment table
CREATE TABLE factPayment(
    customerKey int FOREIGN KEY REFERENCES dimCustomer(customerKey),
    employeeKey int FOREIGN KEY REFERENCES dimEmployee(employeeKey),
    paymentDateKey int FOREIGN KEY REFERENCES dimTime(TimeKey),
    amount decimal(10,2) NOT NULL,
    checkNumber varchar(50) NOT NULL,
    PRIMARY KEY (customerKey,employeeKey,paymentDateKey,checkNumber)
)