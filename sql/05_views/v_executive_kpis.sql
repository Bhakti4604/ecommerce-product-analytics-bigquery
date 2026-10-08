-- ============================================================
-- View: v_executive_kpis
-- Purpose: Provide high-level KPIs for dashboard reporting
-- ============================================================

CREATE OR REPLACE VIEW
`bhakti-510718.bhakti_analytics.v_executive_kpis`
AS

SELECT

    (
        SELECT COUNT(*)
        FROM `bhakti-510718.bhakti_analytics.dim_users`
    ) AS total_users,

    (
        SELECT COUNT(DISTINCT user_pseudo_id)
        FROM `bhakti-510718.bhakti_analytics.fact_transactions`
    ) AS purchasing_users,

    (
        SELECT COUNT(*)
        FROM `bhakti-510718.bhakti_analytics.fact_events`
    ) AS total_events,

    (
        SELECT COUNT(*)
        FROM `bhakti-510718.bhakti_analytics.fact_transactions`
    ) AS purchase_events,

    (
        SELECT ROUND(
            SUM(purchase_revenue_usd),
            2
        )
        FROM `bhakti-510718.bhakti_analytics.fact_transactions`
    ) AS total_revenue_usd,

    (
        SELECT ROUND(
            SUM(purchase_revenue_usd)
            / NULLIF(COUNT(*), 0),
            2
        )
        FROM `bhakti-510718.bhakti_analytics.fact_transactions`
    ) AS average_order_value_usd,

    (
        SELECT COUNT(*)
        FROM `bhakti-510718.bhakti_analytics.dim_products`
    ) AS total_products,

    (
        SELECT MIN(event_date)
        FROM `bhakti-510718.bhakti_analytics.fact_events`
    ) AS data_start_date,

    (
        SELECT MAX(event_date)
        FROM `bhakti-510718.bhakti_analytics.fact_events`
    ) AS data_end_date;


-- ============================================================
-- Validation
-- ============================================================

SELECT *
FROM `bhakti-510718.bhakti_analytics.v_executive_kpis`;