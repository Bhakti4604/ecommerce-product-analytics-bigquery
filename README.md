# E-Commerce Product Analytics & Data Warehouse

An end-to-end e-commerce analytics project built using **Google BigQuery, SQL, Python, Streamlit, and Plotly**.

The project transforms raw Google Analytics 4 (GA4) e-commerce event data into a structured analytical data warehouse and an interactive business intelligence dashboard.

---

## 📌 Project Overview

This project analyzes:

- User engagement
- New vs returning users
- Conversion funnel performance
- Revenue and transactions
- Product and category performance
- Customer lifetime value
- Cohort retention
- Revenue anomalies
- BigQuery optimization techniques

The project demonstrates an end-to-end analytics workflow from raw event data to business insights.

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
   Dimensions + Fact Tables
              │
              ▼
      Analytical Views
              │
              ▼
     Streamlit Dashboard
              │
              ▼
      Business Insights