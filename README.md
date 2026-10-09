# E-Commerce Product Analytics & Data Warehouse

An end-to-end e-commerce analytics project built using **Google BigQuery, SQL, Python, Streamlit, and Plotly**.

The project transforms raw Google Analytics 4 (GA4) e-commerce event data into a structured analytical data warehouse and an interactive business intelligence dashboard.

---

## 📌 Project Overview

This project analyzes:

- User engagement
- New vs. returning users
- Conversion funnel performance
- Revenue and transactions
- Product and category performance
- Customer lifetime value
- Cohort retention
- Revenue anomalies
- BigQuery optimization techniques

The project demonstrates an end-to-end analytics workflow, from raw event data to actionable business insights.

---

## 🏗️ Architecture

```text
Google Analytics 4 Public Dataset
              │
              ▼
        Google BigQuery
              │
              ▼
        Staging Tables
              │
              ▼
   Dimension + Fact Tables
              │
              ▼
       Analytical Views
              │
              ▼
     Streamlit Dashboard
              │
              ▼
       Business Insights
```

---

## 🛠️ Tech Stack

- **Cloud Data Warehouse:** Google BigQuery
- **Query Language:** SQL
- **Data Modeling:** Star Schema
- **Analytics:** CTEs, window functions, aggregations, cohort analysis
- **Dashboard:** Streamlit
- **Visualization:** Plotly
- **Data Processing:** Python, Pandas

---

## 📊 Dataset

- **Source:** `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
- **Period analyzed:** November 1, 2020 – January 31, 2021
- **Total events:** 4,295,584
- **Unique users:** 270,154
- **Products identified:** 1,394

The dataset is a public, obfuscated GA4 sample and represents historical sample data rather than current e-commerce activity.

---

## 📈 Key Findings

- Analyzed **$362,165 in purchase revenue** across the sample period.
- Identified a **7.21% product-view-to-purchase conversion rate**.
- Found that the product-view-to-cart stage is a major conversion bottleneck.
- Analyzed customer lifetime value segments, cohort retention, and product/category performance.
- Identified high-revenue days using statistical anomaly detection.

---

## 🚀 Live Dashboard

- **Dashboard:** https://bhakti-ecommerce-analytics.streamlit.app
- **GitHub Repository:** https://github.com/Bhakti4604/ecommerce-product-analytics-bigquery
