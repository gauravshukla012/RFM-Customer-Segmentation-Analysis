# RFM Customer Segmentation Analysis

![Dashboard Screenshot](dashboard/rfm_dashboard.png)

## 🎯 Project Summary

This project performs an end-to-end RFM (Recency, Frequency, Monetary) analysis to segment customers of a UK-based online retailer. The goal was to identify key customer groups to enable targeted and effective marketing strategies. The analysis revealed a critical and unexpected insight: the company's historically highest-spending customer segment is now almost entirely inactive, representing a major revenue risk.

---

## 📊 Power BI Dashboard

An interactive dashboard was created to visualize the customer segments.

**[➡️ View the Interactive Dashboard Here](https://your-public-powerbi-link-here)** *(if you published it)*

---

## 💡 Key Insights & Recommendations

### Insights
* **Highest-Value Segment is Inactive**: The 'Lost Customers' segment, comprising 2,515 customers, has historically generated the most revenue at over **$12.1M**.
* **Major Churn Risk**: This indicates that the most valuable customer base has churned, posing a significant risk to future revenue.
* **High-Potential Segments**: The 'Champions' and 'Loyal Customers' segments, while smaller, are currently the most active high-value groups and represent the new core of the business.

### Recommendations
1.  **Urgent Reactivation Campaign**: Immediately launch a targeted win-back campaign for the 'Lost Customers' segment. Investigate the root causes of this churn.
2.  **Nurture and Reward Champions**: Implement a loyalty program for the 'Champions' and 'Loyal Customers' to retain and grow this new high-value base.
3.  **Onboard Recent Customers**: Develop an onboarding strategy for 'Recent Customers' to increase their frequency and monetary value, converting them into future loyal customers.

---

## 🛠️ Technical Workflow

1.  **Database & ETL**: Loaded a 1M+ row dataset into a **MySQL** database using the `LOAD DATA INFILE` command for efficiency.
2.  **Data Cleaning**: Created a reusable `VIEW` in SQL to filter out cancelled orders, invalid entries, and records without a `CustomerID`.
3.  **RFM Analysis**: Wrote SQL queries using aggregate functions and `DATEDIFF` to calculate Recency, Frequency, and Monetary values for each customer.
4.  **Segmentation**: Used `NTILE` to score customers and a `CASE` statement to assign them to meaningful segments (e.g., Champions, At-Risk, Lost).
5.  **Visualization**: Connected **Power BI** to the MySQL database and built a dashboard to visualize the size and value of each customer segment, leading to the key insights.

---

## 📁 Repository Structure
