CREATE DATABASE online_retail_db;
USE online_retail_db;

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
    
    
WITH cleaned_sales AS (
    SELECT
        *
    FROM
        retail_sales
    WHERE
        InvoiceNo NOT LIKE 'C%'
        AND Quantity > 0
        AND CustomerID IS NOT NULL
)
-- Now you can select from your clean data
SELECT * FROM cleaned_sales
ORDER BY
	InvoiceDate DESC
LIMIT 1;
    
CREATE VIEW cleaned_sales_view AS
SELECT
    *
FROM
    retail_sales
WHERE
    InvoiceNo NOT LIKE 'C%'
    AND Quantity > 0
    AND CustomerID IS NOT NULL;

-- Recency
SELECT
	CustomerID,
    DATEDIFF('2011-12-10', MAX(InvoiceDate)) AS Recency
FROM
	cleaned_sales_view
GROUP BY
	CustomerID;
    
-- Frequency
SELECT
	CustomerID,
    COUNT(DISTINCT InvoiceNo) AS TotalPurchase
FROM
	cleaned_sales_view
GROUP BY
	CustomerID;
    
-- Monetary
SELECT
	CustomerID,
    SUM(Price * Quantity) AS TotalSpend
FROM
	cleaned_sales_view
GROUP BY
	CustomerID;
    
-- RFM
SELECT
	CustomerID,
    DATEDIFF('2011-12-10', MAX(InvoiceDate)) AS Recency,
    COUNT(DISTINCT InvoiceNo) AS Frequency,
    SUM(Price * Quantity) AS Monetary
FROM
	cleaned_sales_view
GROUP BY
	CustomerID;
    
    
-- Final    
    
WITH rfm_values AS (
    -- Raw RFM values
    SELECT
        CustomerID,
        DATEDIFF('2011-12-10', MAX(InvoiceDate)) AS Recency,
        COUNT(DISTINCT InvoiceNo) AS Frequency,
        SUM(Price * Quantity) AS Monetary
    FROM
        cleaned_sales_view
    GROUP BY
        CustomerID
),
rfm_scores AS (
    -- RFM scores from 1-5
    SELECT
        CustomerID,
        NTILE(5) OVER (ORDER BY Recency ASC) AS r_score,
        NTILE(5) OVER (ORDER BY Frequency DESC) AS f_score,
        NTILE(5) OVER (ORDER BY Monetary DESC) AS m_score
    FROM
        rfm_values
)
SELECT
    r.CustomerID,
    s.r_score,
    s.f_score,
    s.m_score,
    CASE
        WHEN s.r_score = 5 AND s.f_score IN (4, 5) AND s.m_score IN (4, 5) THEN 'Champions'
        WHEN s.r_score IN (3, 4) AND s.f_score IN (4, 5) AND s.m_score IN (4, 5) THEN 'Loyal Customers'
        WHEN s.r_score = 5 AND s.f_score IN (2, 3) AND s.m_score IN (2, 3) THEN 'Recent Customers'
        WHEN s.r_score IN (1, 2) AND s.f_score IN (4, 5) AND s.m_score IN (4, 5) THEN 'At-Risk Champions'
        WHEN s.r_score IN (1, 2) AND s.f_score IN (1, 2) AND s.m_score IN (1, 2) THEN 'Lost Customers'
        ELSE 'Other'
    END AS CustomerSegment
FROM
    rfm_scores s
JOIN
    rfm_values r ON s.CustomerID = r.CustomerID;
    
-- View of segmentations

CREATE VIEW customer_segments_view AS
WITH rfm_values AS (
    SELECT
        CustomerID,
        DATEDIFF('2011-12-10', MAX(InvoiceDate)) AS Recency,
        COUNT(DISTINCT InvoiceNo) AS Frequency,
        SUM(Price * Quantity) AS Monetary
    FROM
        cleaned_sales_view
    GROUP BY
        CustomerID
),
rfm_scores AS (
    SELECT
        CustomerID,
        NTILE(5) OVER (ORDER BY Recency ASC) AS r_score,
        NTILE(5) OVER (ORDER BY Frequency DESC) AS f_score,
        NTILE(5) OVER (ORDER BY Monetary DESC) AS m_score
    FROM
        rfm_values
)
SELECT
    r.CustomerID,
    r.Recency,
    r.Frequency,
    r.Monetary,
    s.r_score,
    s.f_score,
    s.m_score,
    CASE
        WHEN s.r_score = 5 AND s.f_score IN (4, 5) AND s.m_score IN (4, 5) THEN 'Champions'
        WHEN s.r_score IN (3, 4) AND s.f_score IN (4, 5) AND s.m_score IN (4, 5) THEN 'Loyal Customers'
        WHEN s.r_score = 5 AND s.f_score IN (2, 3) AND s.m_score IN (2, 3) THEN 'Recent Customers'
        WHEN s.r_score IN (1, 2) AND s.f_score IN (4, 5) AND s.m_score IN (4, 5) THEN 'At-Risk Champions'
        WHEN s.r_score IN (1, 2) AND s.f_score IN (1, 2) AND s.m_score IN (1, 2) THEN 'Lost Customers'
        ELSE 'Other'
    END AS CustomerSegment
FROM
    rfm_scores s
JOIN
    rfm_values r ON s.CustomerID = r.CustomerID;

    -- Analysis
    
SELECT * FROM customer_segments_view;

-- What is the size and value of each segment?

SELECT
	CustomerSegment,
    COUNT(CustomerID) AS NumberofCustomers,
    SUM(Monetary) AS TotalRevenue,
    SUM(Monetary) / COUNT(CustomerID) AS RevenueperCustomer
From
	customer_segments_view
GROUP BY
	CustomerSegment
ORDER BY
	NumberofCustomers DESC;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    