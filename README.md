# E-Commerce Product Analytics & Data Warehouse

An end-to-end e-commerce analytics project built using **Google BigQuery, SQL, Python, Streamlit, and Plotly**.

The project transforms raw Google Analytics 4 (GA4) e-commerce event data into a structured analytical data warehouse and an interactive business intelligence dashboard.

---

## 📌 Project Overview

This project analyzes user behavior, product performance, conversion funnels, revenue, customer lifetime value, cohort retention, and revenue anomalies using the public GA4 e-commerce sample dataset.

### Architecture

Raw GA4 Dataset
        ↓
BigQuery
        ↓
Staging Tables
        ↓
Dimensions + Fact Tables
        ↓
Analytical Views
        ↓
Streamlit Dashboard
        ↓
Interactive Business Insights

---

## 🛠️ Technology Stack

- **Google BigQuery** — Cloud data warehouse
- **SQL** — Data transformation and analytics
- **Python** — Data processing and application logic
- **Streamlit** — Interactive dashboard
- **Plotly** — Data visualization
- **GitHub** — Version control and project documentation

---

## 📊 Dataset

Source:

**Google Analytics 4 Obfuscated Sample E-commerce Dataset**

BigQuery public dataset:

`bigquery-public-data.ga4_obfuscated_sample_ecommerce`

### Dataset Coverage

- Events: **4,295,584**
- Unique Users: **270,154**
- Products: **1,394**
- Purchase Events: **5,692**
- Purchasing Users: **4,419**
- Total Revenue: **$362,165**
- Date Range: **2020-11-01 to 2021-01-31**

---

## 🏗️ Data Warehouse Design

The project uses separate staging, dimension, and fact tables to preserve analytical grains.

### Staging

- `stg_events`
- `stg_items`
- `stg_transactions`

### Dimensions

- `dim_users`
- `dim_date`
- `dim_products`
- `dim_device`
- `dim_geo`

### Fact Tables

- `fact_events`
- `fact_items`
- `fact_transactions`

### Optimization

- `fact_events_clustered`

Clustered by:

- `user_pseudo_id`
- `event_name`

---

## 📈 Analytics Performed

### 1. User Engagement

Calculated:

- Daily Active Users
- Total Events
- Events per Active User

Average DAU:

**3,468**

---

### 2. New vs Returning Users

Classified user activity based on each user's first observed event date.

Results:

- New user activity share: **84.67%**
- Returning user activity share: **15.33%**

These percentages represent **active-user days**, not the percentage of unique users.

---

### 3. Conversion Funnel

Analyzed the customer journey:

**Product View → Add to Cart → Checkout → Purchase**

Results:

| Funnel Stage | Users |
|---|---:|
| Product View | 61,252 |
| Add to Cart | 12,545 |
| Checkout | 9,715 |
| Purchase | 4,419 |

Key finding:

The largest funnel drop occurs between **Product View and Add to Cart**.

---

### 4. Revenue Analysis

Overall:

- Revenue: **$362,165**
- Purchase Events: **5,692**
- Purchasing Users: **4,419**
- Average Order Value: **$63.63**

December 2020 generated the highest monthly revenue:

**$160,555**

---

### 5. Product & Category Performance

Analyzed:

- Product revenue
- Units sold
- Category revenue
- Category volume
- Top-performing products

Top product by revenue:

**Google Canteen Bottle Black — $5,303**

---

### 6. Customer Lifetime Value

Customers were segmented into:

- Low Value
- Medium Value
- High Value

High-value customers:

- **55 customers**
- Approximately **1.24%** of purchasing customers
- Approximately **11.41%** of customer revenue

---

### 7. Cohort Retention

Users were grouped by their first activity month and tracked across subsequent months.

November 2020 cohort:

- Month 0: **100%**
- Month 1: **5.86%**
- Month 2: **1.52%**

The analysis indicates a substantial decline in user retention after acquisition.

---

### 8. Revenue Anomaly Detection

Daily revenue was analyzed using a statistical **Z-score** approach.

Classification:

- Z ≥ 2 → High Anomaly
- Z ≤ -2 → Low Anomaly
- Otherwise → Normal

The analysis identified **6 high-revenue anomaly days**.

No causal explanation was assigned without additional supporting evidence.

---

## ⚡ BigQuery Optimization

### Clustering

Created:

`fact_events_clustered`

Cluster keys:

```text
user_pseudo_id
event_name