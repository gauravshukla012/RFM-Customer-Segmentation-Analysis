CREATE DATABASE online_retail_db;
USE online_retail_db;

-- Creating Table
CREATE TABLE retail_sales (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    Price DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(50)
);

-- Data Ingestion
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/online_retail_II.csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, @InvoiceDateVar, Price, @CustomerIDVar, Country)
SET 
    InvoiceDate = STR_TO_DATE(@InvoiceDateVar, '%Y-%m-%d %H:%i:%s'),
    CustomerID = NULLIF(@CustomerIDVar, '');


-- Creating view of cleaned data
CREATE VIEW cleaned_sales_view AS
SELECT
    *
FROM
    retail_sales
WHERE
    InvoiceNo NOT LIKE 'C%'
    AND Quantity > 0
    AND CustomerID IS NOT NULL;




