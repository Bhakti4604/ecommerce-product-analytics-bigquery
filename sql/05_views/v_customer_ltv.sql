-- ============================================================
-- View: v_customer_ltv
-- Purpose: Calculate customer lifetime value
-- ============================================================

CREATE OR REPLACE VIEW
`bhakti-510718.bhakti_analytics.v_customer_ltv`
AS

SELECT
    user_pseudo_id,

    COUNT(*) AS purchase_events,

    ROUND(
        SUM(purchase_revenue_usd),
        2
    ) AS lifetime_revenue_usd,

    ROUND(
        SAFE_DIVIDE(
            SUM(purchase_revenue_usd),
            COUNT(*)
        ),
        2
    ) AS average_order_value_usd,

    MIN(event_date) AS first_purchase_date,

    MAX(event_date) AS last_purchase_date,

    DATE_DIFF(
        MAX(event_date),
        MIN(event_date),
        DAY
    ) AS customer_lifetime_days

FROM `bhakti-510718.bhakti_analytics.fact_transactions`

GROUP BY user_pseudo_id;


-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS customers,
    ROUND(SUM(lifetime_revenue_usd), 2) AS total_customer_revenue,
    ROUND(AVG(lifetime_revenue_usd), 2) AS avg_customer_lifetime_value,
    MAX(lifetime_revenue_usd) AS highest_customer_ltv
FROM `bhakti-510718.bhakti_analytics.v_customer_ltv`;