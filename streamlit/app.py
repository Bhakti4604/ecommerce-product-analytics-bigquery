import streamlit as st
from google.cloud import bigquery
import pandas as pd
import plotly.express as px

# ============================================================
# Page Configuration
# ============================================================

st.set_page_config(
    page_title="E-Commerce Analytics Dashboard",
    page_icon="📊",
    layout="wide"
)

# ============================================================
# BigQuery Connection
# ============================================================

@st.cache_resource
def get_bigquery_client():
    return bigquery.Client(project="bhakti-510718")


client = get_bigquery_client()

# ============================================================
# Sidebar
# ============================================================

with st.sidebar:

    st.title("📊 E-Commerce Analytics")

    st.markdown("---")

    st.subheader("Project")

    st.write(
        "End-to-end e-commerce analytics "
        "using BigQuery, SQL and Streamlit."
    )

    st.markdown("---")

    st.subheader("🛠️ Technology Stack")

    st.write("• Google BigQuery")
    st.write("• SQL")
    st.write("• Python")
    st.write("• Streamlit")
    st.write("• Plotly")

    st.markdown("---")

    st.subheader("📅 Data Coverage")

    st.write("November 2020 – January 2021")

    st.markdown("---")

    st.subheader("📌 Dashboard Sections")

    section = st.radio(
    "Navigate to",
    [
        "📊 Executive Overview",
        "📈 Revenue & Products",
        "🔄 Conversion Funnel",
        "👥 Customer Intelligence",
        "🚨 Anomaly Detection"
    ]
)



# ============================================================
# Page Title
# ============================================================
if section == "📊 Executive Overview":
    st.title("📊 E-Commerce Product Analytics Dashboard")
    st.caption("GA4 E-Commerce Analytics | BigQuery + SQL + Streamlit")

# ============================================================
# Executive KPIs
# ============================================================

    query = """
    SELECT *
    FROM `bhakti-510718.bhakti_analytics.v_executive_kpis`
    """

    kpi_df = client.query(query).to_dataframe()

# ============================================================
# KPI Cards
# ============================================================

    if not kpi_df.empty:

        data = kpi_df.iloc[0]

        col1, col2, col3, col4 = st.columns(4)

        with col1:
            st.metric(
                "Total Users",
                f"{int(data['total_users']):,}"
            )

        with col2:
            st.metric(
                "Purchasing Users",
                f"{int(data['purchasing_users']):,}"
            )

        with col3:
            st.metric(
                "Total Revenue",
                f"${data['total_revenue_usd']:,.2f}"
            )

        with col4:
            st.metric(
                "Average Order Value",
                f"${data['average_order_value_usd']:,.2f}"
            )

    # ============================================================
    # Additional Information
    # ============================================================

    st.divider()

    col1, col2, col3 = st.columns(3)

    with col1:
        st.metric(
            "Total Events",
            f"{int(data['total_events']):,}"
        )

    with col2:
        st.metric(
            "Purchase Events",
            f"{int(data['purchase_events']):,}"
        )

    with col3:
        st.metric(
            "Products",
            f"{int(data['total_products']):,}"
        )

    st.divider()

    st.subheader("📅 Data Coverage")

    st.write(
        f"Data available from **{data['data_start_date']}** "
        f"to **{data['data_end_date']}**"
    )

    # ============================================================
    # Key Insights
    # ============================================================

    st.divider()

    st.header("💡 Key Insights")

    insight_col1, insight_col2, insight_col3 = st.columns(3)

    with insight_col1:
        st.subheader("📈 Revenue")

        st.write(
            "December 2020 generated the highest monthly revenue "
            "at approximately **$160.6K**, before revenue declined "
            "sharply in January 2021."
        )

    with insight_col2:
        st.subheader("🔄 Conversion")

        st.write(
            "The largest funnel drop occurs between product views "
            "and add-to-cart actions, with approximately **20.48%** "
            "of product viewers adding an item to cart."
        )

    with insight_col3:
        st.subheader("💎 Customer Value")

        st.write(
            "The high-value customer segment represents only about "
            "**1.24% of purchasing customers** but contributes "
            "approximately **11.41% of customer revenue**."
        )

# ============================================================
# Revenue & Product Analysis
# ============================================================
if section == "📈 Revenue & Products":
    st.divider()

    st.header("📈 Revenue & Product Analysis")

    # ============================================================
    # Monthly Revenue
    # ============================================================

    monthly_revenue_query = """
    SELECT
        DATE_TRUNC(event_date, MONTH) AS month,
        COUNT(*) AS purchase_events,
        COUNT(DISTINCT user_pseudo_id) AS purchasing_users,
        ROUND(SUM(purchase_revenue_usd), 2) AS revenue_usd
    FROM `bhakti-510718.bhakti_analytics.fact_transactions`
    GROUP BY month
    ORDER BY month
    """

    monthly_revenue = client.query(monthly_revenue_query).to_dataframe()

    st.subheader("💰 Monthly Revenue")

    fig = px.line(
        monthly_revenue,
        x="month",
        y="revenue_usd",
        markers=True,
        title="Monthly Revenue Trend"
    )

    fig.update_layout(
        xaxis_title="Month",
        yaxis_title="Revenue (USD)",
        hovermode="x unified"
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

    st.dataframe(
        monthly_revenue,
        use_container_width=True
    )




    # ============================================================
    # Top 10 Products by Revenue
    # ============================================================

    product_query = """
    SELECT
        product_name,
        brand,
        category,
        units_sold,
        revenue_usd
    FROM `bhakti-510718.bhakti_analytics.v_product_performance`
    WHERE revenue_usd > 0
    ORDER BY revenue_usd DESC
    LIMIT 10
    """

    top_products = client.query(product_query).to_dataframe()

    st.subheader("🏆 Top 10 Products by Revenue")

    fig_products = px.bar(
        top_products.sort_values("revenue_usd"),
        x="revenue_usd",
        y="product_name",
        orientation="h",
        hover_data=["brand", "category", "units_sold"],
        text="revenue_usd",
        title="Top 10 Products by Revenue"
    )

    fig_products.update_traces(
        texttemplate="$%{text:,.0f}",
        textposition="outside"
    )

    fig_products.update_layout(
        xaxis_title="Revenue (USD)",
        yaxis_title="Product",
        showlegend=False
    )

    st.plotly_chart(
        fig_products,
        use_container_width=True,
        key="top_products_chart"
    )





    # ============================================================
    # Category Performance
    # ============================================================

    st.divider()

    st.header("📦 Category Performance")

    category_query = """
    SELECT
        category,
        unique_products,
        units_sold,
        revenue_usd
    FROM `bhakti-510718.bhakti_analytics.v_category_performance`
    WHERE revenue_usd > 0
    ORDER BY revenue_usd DESC
    LIMIT 10
    """

    category_data = client.query(category_query).to_dataframe()

    # ============================================================
    # Top 10 Categories by Units Sold
    # ============================================================

    units_query = """
    SELECT
        category,
        unique_products,
        units_sold,
        revenue_usd
    FROM `bhakti-510718.bhakti_analytics.v_category_performance`
    WHERE units_sold > 0
    ORDER BY units_sold DESC
    LIMIT 10
    """

    top_unit_categories = client.query(units_query).to_dataframe()

    # ============================================================
    # Revenue by Category
    # ============================================================

    st.subheader("💰 Revenue by Category")

    fig_category_revenue = px.bar(
        category_data.sort_values("revenue_usd"),
        x="revenue_usd",
        y="category",
        orientation="h",
        text="revenue_usd",
        hover_data=["unique_products", "units_sold"],
        title="Revenue by Product Category"
    )

    fig_category_revenue.update_traces(
        texttemplate="$%{text:,.0f}",
        textposition="outside"
    )

    fig_category_revenue.update_layout(
        xaxis_title="Revenue (USD)",
        yaxis_title="Category",
        showlegend=False
    )

    st.plotly_chart(
        fig_category_revenue,
        use_container_width=True,
        key="category_revenue_chart"
    )

    # ============================================================
    # Units Sold by Category
    # ============================================================

    st.subheader("📦 Units Sold by Category")

    fig_category_units = px.bar(
        top_unit_categories.sort_values("units_sold"),
        x="units_sold",
        y="category",
        orientation="h",
        text="units_sold",
        hover_data=["unique_products", "revenue_usd"],
        title="Units Sold by Product Category"
    )

    fig_category_units.update_traces(
        texttemplate="%{text:,.0f}",
        textposition="outside"
    )

    fig_category_units.update_layout(
        xaxis_title="Units Sold",
        yaxis_title="Category",
        showlegend=False
    )

    st.plotly_chart(
        fig_category_units,
        use_container_width=True,
        key="category_units_chart"
    )



# ============================================================
# Conversion Funnel
# ============================================================
if section == "🔄 Conversion Funnel":
    st.divider()

    st.header("🔄 Conversion Funnel")

    funnel_query = """
    WITH funnel_users AS (

        SELECT
            COUNT(DISTINCT CASE
                WHEN event_name = 'view_item'
                THEN user_pseudo_id
            END) AS product_viewers,

            COUNT(DISTINCT CASE
                WHEN event_name = 'add_to_cart'
                THEN user_pseudo_id
            END) AS cart_users,

            COUNT(DISTINCT CASE
                WHEN event_name = 'begin_checkout'
                THEN user_pseudo_id
            END) AS checkout_users,

            COUNT(DISTINCT CASE
                WHEN event_name = 'purchase'
                THEN user_pseudo_id
            END) AS purchasing_users

        FROM `bhakti-510718.bhakti_analytics.fact_events`
    )

    SELECT
        'Product View' AS stage,
        product_viewers AS users
    FROM funnel_users

    UNION ALL

    SELECT
        'Add to Cart',
        cart_users
    FROM funnel_users

    UNION ALL

    SELECT
        'Checkout',
        checkout_users
    FROM funnel_users

    UNION ALL

    SELECT
        'Purchase',
        purchasing_users
    FROM funnel_users
    """

    funnel_data = client.query(funnel_query).to_dataframe()

    # ============================================================
    # Funnel Chart
    # ============================================================

    fig_funnel = px.funnel(
        funnel_data,
        x="users",
        y="stage",
        title="E-Commerce Conversion Funnel"
    )

    fig_funnel.update_layout(
        xaxis_title="Users",
        yaxis_title="Funnel Stage"
    )

    st.plotly_chart(
        fig_funnel,
        use_container_width=True,
        key="conversion_funnel_chart"
    )




# ============================================================
# New vs Returning Users
# ============================================================
if section == "👥 Customer Intelligence":
    st.divider()

    st.header("👥 New vs Returning Users")

    user_type_query = """
    WITH user_activity AS (

        SELECT DISTINCT
            user_pseudo_id,
            event_date
        FROM `bhakti-510718.bhakti_analytics.fact_events`
    ),

    user_first_activity AS (

        SELECT
            user_pseudo_id,
            MIN(event_date) AS first_event_date
        FROM `bhakti-510718.bhakti_analytics.fact_events`
        GROUP BY user_pseudo_id
    )

    SELECT
        CASE
            WHEN a.event_date = f.first_event_date
            THEN 'New User'
            ELSE 'Returning User'
        END AS user_type,

        COUNT(*) AS active_user_days

    FROM user_activity AS a

    JOIN user_first_activity AS f
        ON a.user_pseudo_id = f.user_pseudo_id

    GROUP BY user_type
    ORDER BY active_user_days DESC
    """

    user_type_data = client.query(user_type_query).to_dataframe()

    # ============================================================
    # User Type Chart
    # ============================================================

    fig_user_type = px.pie(
        user_type_data,
        names="user_type",
        values="active_user_days",
        hole=0.45,
        title="New vs Returning User Activity"
    )

    fig_user_type.update_traces(
        textinfo="label+percent",
        hovertemplate="%{label}<br>Active User Days: %{value:,}<extra></extra>"
    )

    st.plotly_chart(
        fig_user_type,
        use_container_width=True,
        key="new_returning_users_chart"
    )




    # ============================================================
    # Customer Lifetime Value
    # ============================================================

    st.divider()

    st.header("💎 Customer Lifetime Value")

    clv_query = """
    SELECT
        clv_segment,
        COUNT(*) AS customers,
        ROUND(SUM(lifetime_revenue_usd), 2) AS total_revenue_usd,
        ROUND(AVG(lifetime_revenue_usd), 2) AS avg_lifetime_revenue_usd,
        ROUND(AVG(average_order_value_usd), 2) AS avg_order_value_usd
    FROM `bhakti-510718.bhakti_analytics.v_customer_ltv_segments`
    GROUP BY clv_segment
    ORDER BY total_revenue_usd DESC
    """

    clv_data = client.query(clv_query).to_dataframe()

    # ============================================================
    # CLV Revenue by Segment
    # ============================================================

    st.subheader("💰 Revenue by Customer Value Segment")

    fig_clv = px.bar(
        clv_data.sort_values("total_revenue_usd"),
        x="total_revenue_usd",
        y="clv_segment",
        orientation="h",
        text="total_revenue_usd",
        hover_data=[
            "customers",
            "avg_lifetime_revenue_usd",
            "avg_order_value_usd"
        ],
        title="Customer Lifetime Revenue by Segment"
    )

    fig_clv.update_traces(
        texttemplate="$%{text:,.0f}",
        textposition="outside"
    )

    fig_clv.update_layout(
        xaxis_title="Lifetime Revenue (USD)",
        yaxis_title="Customer Segment",
        showlegend=False
    )

    st.plotly_chart(
        fig_clv,
        use_container_width=True,
        key="clv_segment_chart"
    )

    # ============================================================
    # CLV Data Table
    # ============================================================

    st.subheader("📋 Customer Value Segments")

    st.dataframe(
        clv_data,
        use_container_width=True
    )





    # ============================================================
    # Cohort Retention
    # ============================================================

    st.divider()

    st.header("📅 Cohort Retention")

    cohort_query = """
    SELECT
        cohort_month,
        month_number,
        active_users
    FROM `bhakti-510718.bhakti_analytics.v_cohort_retention`
    ORDER BY cohort_month, month_number
    """

    cohort_data = client.query(cohort_query).to_dataframe()

    # ============================================================
    # Calculate Cohort Retention %
    # ============================================================

    cohort_data["cohort_size"] = (
        cohort_data
        .groupby("cohort_month")["active_users"]
        .transform("first")
    )

    cohort_data["retention_pct"] = (
        cohort_data["active_users"]
        / cohort_data["cohort_size"]
        * 100
    )

    # ============================================================
    # Retention Table
    # ============================================================

    retention_table = cohort_data.pivot(
        index="cohort_month",
        columns="month_number",
        values="retention_pct"
    )

    retention_table.index = pd.to_datetime(
        retention_table.index
    ).strftime("%Y-%m")

    retention_table.columns = [
        f"Month {int(col)}"
        for col in retention_table.columns
    ]

    st.subheader("📊 Cohort Retention Matrix")

    st.dataframe(
        retention_table.style.format("{:.2f}%"),
        use_container_width=True
    )

    # ============================================================
    # Retention Heatmap
    # ============================================================

    fig_cohort = px.imshow(
        retention_table,
        text_auto=".2f",
        aspect="auto",
        title="Cohort Retention (%)"
    )

    fig_cohort.update_layout(
        xaxis_title="Months Since Acquisition",
        yaxis_title="Cohort Month"
    )

    st.plotly_chart(
        fig_cohort,
        use_container_width=True,
        key="cohort_retention_heatmap"
    )




# ============================================================
# Daily Revenue Anomaly Detection
# ============================================================
if section == "🚨 Anomaly Detection":
    st.divider()

    st.header("🚨 Revenue Anomaly Detection")

    anomaly_query = """
    WITH daily_revenue AS (

        SELECT
            event_date,
            COUNT(*) AS purchase_events,
            COUNT(DISTINCT user_pseudo_id) AS purchasing_users,
            ROUND(SUM(purchase_revenue_usd), 2) AS revenue_usd

        FROM `bhakti-510718.bhakti_analytics.fact_transactions`

        GROUP BY event_date
    ),

    revenue_stats AS (

        SELECT
            AVG(revenue_usd) AS avg_revenue,
            STDDEV(revenue_usd) AS revenue_stddev

        FROM daily_revenue
    )

    SELECT
        d.event_date,
        d.purchase_events,
        d.purchasing_users,
        d.revenue_usd,

        ROUND(
            (d.revenue_usd - s.avg_revenue)
            / NULLIF(s.revenue_stddev, 0),
            2
        ) AS z_score,

        CASE
            WHEN
                (d.revenue_usd - s.avg_revenue)
                / NULLIF(s.revenue_stddev, 0) >= 2
            THEN 'High Anomaly'

            WHEN
                (d.revenue_usd - s.avg_revenue)
                / NULLIF(s.revenue_stddev, 0) <= -2
            THEN 'Low Anomaly'

            ELSE 'Normal'
        END AS anomaly_status

    FROM daily_revenue AS d
    CROSS JOIN revenue_stats AS s

    ORDER BY d.event_date
    """

    anomaly_data = client.query(anomaly_query).to_dataframe()

    # ============================================================
    # Revenue Trend
    # ============================================================

    st.subheader("📈 Daily Revenue & Anomalies")

    fig_anomaly = px.scatter(
        anomaly_data,
        x="event_date",
        y="revenue_usd",
        color="anomaly_status",
        size="purchase_events",
        hover_data=[
            "purchasing_users",
            "purchase_events",
            "z_score"
        ],
        title="Daily Revenue with Anomaly Detection"
    )

    fig_anomaly.update_layout(
        xaxis_title="Date",
        yaxis_title="Revenue (USD)"
    )

    st.plotly_chart(
        fig_anomaly,
        use_container_width=True,
        key="revenue_anomaly_chart"
    )

    # ============================================================
    # Detected Anomalies
    # ============================================================

    st.subheader("🚨 Detected Revenue Anomalies")

    anomalies_only = anomaly_data[
        anomaly_data["anomaly_status"] != "Normal"
    ].copy()

    st.dataframe(
        anomalies_only,
        use_container_width=True
    )



# ============================================================
# Footer
# ============================================================

st.divider()

st.caption(
    "E-Commerce Product Analytics | "
    "BigQuery • SQL • Python • Streamlit • Plotly"
)

st.caption(
    "Built by Bhakti | Analytics Portfolio Project"
)