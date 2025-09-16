# RFM Customer Segmentation Analysis



## Project Overview

This project analyzes over one million transaction records from a UK-based online retailer to segment customers using the RFM (Recency, Frequency, Monetary) model. The analysis, conducted with SQL and visualized in Power BI, identified a critical business risk: the company's historically highest-spending customer segment is now largely inactive.

---

## Key Business Insights

* **Revenue Concentration Risk**: The 'Lost Customers' segment, while inactive, accounts for the highest historical revenue at over **$12.1M**. This indicates a significant churn of high-value customers.
* **Disproportionate Value**: The active 'Champions' segment, representing only 13% of the customer base, generates the second-highest revenue (**$4.9M**), highlighting their critical importance to current business health.
* **High-Value Churn**: The 'At-Risk Champions' segment represents a group of formerly high-frequency, high-spending customers who are now lapsing, signaling a clear opportunity for proactive retention efforts.

---

## Strategic Recommendations

1.  **Prioritize High-Value Customer Reactivation**: Launch a targeted marketing campaign to re-engage the 'Lost Customers' segment, focusing on understanding the causes of churn and providing compelling incentives to return.
2.  **Implement a Loyalty Program**: Nurture and retain the 'Champions' and 'Loyal Customers' segments with a premium loyalty program to solidify their value and encourage continued engagement.
3.  **Develop Customer Onboarding**: Create an automated onboarding process for 'Recent Customers' to increase their purchase frequency and guide them towards becoming long-term loyal customers.

---

## Technical Workflow

The project was executed using the following end-to-end process:

1.  **Data Ingestion & Storage**: A dataset of over 1 million rows was efficiently loaded into a **MySQL** database.
2.  **Data Cleaning & Preparation**: Data was cleaned and prepared in SQL, filtering for active sales and valid customer records. This cleaned data was stored in a reusable `VIEW` for analysis.
3.  **RFM Modeling**: The Recency, Frequency, and Monetary metrics were calculated for each customer using SQL aggregate functions and `DATEDIFF`. Customers were then scored and segmented using `NTILE` and `CASE` statements.
4.  **Visualization**: The final segmented data was connected to **Power BI** to build an interactive dashboard, enabling the visualization of segment size, value, and key characteristics.

---

## Repository Structure
