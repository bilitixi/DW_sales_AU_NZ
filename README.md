📊 Data Warehouse Development – Models Sales Company
A complete ETL, DQ, and OLAP solution

📌 Project Overview
This repository contains the development artifacts, documentation, and implementation logic for a data warehouse designed for Models Sales Company.
The primary objective is to replace their OLTP‑only reporting setup with a centralised OLAP solution capable of supporting complex sales analytics.
🎯 Goals
Build a full data warehouse (DW): schema, dimensions, facts, relationships
Implement ETL pipelines using business rules for data quality
Provide clean, validated, analysis‑ready data
Enable advanced reporting (OLAP cubes, dashboards, and aggregated insights)


🏗️ System Architecture
Source System

Existing OLTP system running on MS SQL Server

Target System

Data Warehouse: DW_sales_AU_NZ
Constellation schema (multiple fact tables + shared dimensions)


🗂️ Data Warehouse Schema
Dimension Tables

dimCustomer – supports customer‑based analytics
dimEmployee – supports employee performance reporting
dimProduct – supports product, category & profit reporting
dimTime – essential for all monthly/period‑based reports

Fact Tables

factOrder

Grain: orderNumber + orderLineNumber


factPayment

Grain: customerKey + paymentDateKey + employeeKey + checkNumber




🔎 Data Quality (DQ) Framework
All data passes through a staged DQ process before being merged into the DW.
DQ Log System
Invalid or suspicious records are logged using physical row locators (%%physloc%%).
Only clean records proceed into the dimension and fact tables.
DQ Pipeline Steps


Run DQ Rules
Identify invalid or inconsistent records and insert them into DQLog.


Merge Clean Data
Only records not present in DQLog are imported into DW tables.


Fix Valid Records (Action = 'fix')
Apply corrections such as:

Converting negative values to positive
Filling missing dates
Standardising country formatting
Adjusting invalid relationships
Updating records via a second merge pass



Repeat for all dimensions and facts


This ensures only clean, validated data enters the DW.

📐 Business Data Quality Rules (R1–R10)
Rules 1–5: Product & Order Details Validations

Reject or fix negative buyPrice, priceEach, quantityOrdered
Validate MSRP ≥ buyPrice
Reject invalid quantityInStock

Rules 6–10: Key Relationships & Standardisation

Validate productCode existence
Reject missing customer address fields
Fix inconsistent date fields (requiredDate, shippedDate)
Reject negative payment amounts
Standardise country names (e.g., US, United States → USA)


🔄 ETL Overview
Extract

Pull data from OLTP tables
Capture operational entities: customers, orders, products, employees, payments

Transform

Apply all 10 DQ business rules
Standardise formatting (dates, country codes)
Fix or reject invalid records

Load

Insert only clean records into DW fact & dimension tables


📈 Reporting Requirements Supported

Monthly report: Most profitable employees
City‑based total sales summary
Top purchasing customers (monthly)
Monthly product-line performance report

Compare total profit vs total possible profit



These requirements guided the DW schema and ETL decisions.

📁 Data Warehouse Development
/src
  /etl_scripts.sql
  /dq_rules.sql
  /sql_schema.sql
  /sql_reports.sql
  /summary_DQlog_table.sql
  /createDQLog_Table.sql
/docs
  /constellation_Schema.pdf
  /Rule List.docx
  
/presentation
  DW - Presentation.pptx
  Report_PowerBI.pbix
/sales_AU_NZ(sampleData).sql
README.md


👥 Project Team

Brandon Nguyen
Natara Iata Pimoe


