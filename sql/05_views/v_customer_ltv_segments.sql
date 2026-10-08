-- ============================================================
-- View: v_customer_ltv_segments
-- Purpose: Segment customers based on lifetime revenue
-- ============================================================

CREATE OR REPLACE VIEW
`bhakti-510718.bhakti_analytics.v_customer_ltv_segments`
AS

SELECT
    user_pseudo_id,
    purchase_events,
    lifetime_revenue_usd,
    average_order_value_usd,
    first_purchase_date,
    last_purchase_date,
    customer_lifetime_days,

    CASE
        WHEN lifetime_revenue_usd >= 500
            THEN 'High Value'

        WHEN lifetime_revenue_usd >= 200
            THEN 'Medium Value'

        ELSE 'Low Value'
    END AS clv_segment

FROM `bhakti-510718.bhakti_analytics.v_customer_ltv`;


-- ============================================================
-- Validation
-- ============================================================

SELECT
    clv_segment,

    COUNT(*) AS customers,

    ROUND(
        SUM(lifetime_revenue_usd),
        2
    ) AS segment_revenue,

    ROUND(
        AVG(lifetime_revenue_usd),
        2
    ) AS average_lifetime_revenue

FROM `bhakti-510718.bhakti_analytics.v_customer_ltv_segments`

GROUP BY clv_segment

ORDER BY segment_revenue DESC;