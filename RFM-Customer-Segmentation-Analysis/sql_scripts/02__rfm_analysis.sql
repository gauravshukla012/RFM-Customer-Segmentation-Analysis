-- Creating view of segmentations

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
	RevenueperCustomer DESC;
    
-- Who are our 'At-Risk Champions'?

SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary
FROM
    customer_segments_view
WHERE
    CustomerSegment = 'At-Risk Champions'
ORDER BY
    Monetary DESC
LIMIT 100;
    
-- What are the characteristics of our 'Champions'?

SELECT
    CustomerSegment,
    AVG(Recency) AS AvgRecency,
    AVG(Frequency) AS AvgFrequency,
    AVG(Monetary) AS AvgMonetaryValue
FROM
    customer_segments_view
WHERE
    CustomerSegment = 'Champions'
GROUP BY
    CustomerSegment;