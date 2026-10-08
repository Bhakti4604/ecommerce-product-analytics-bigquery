-- ============================================================
-- Analysis: Revenue & Transaction Analysis
-- Purpose: Measure revenue, orders, AOV and purchasing users
-- ============================================================

SELECT
    COUNT(*) AS purchase_events,

    COUNT(DISTINCT user_pseudo_id) AS purchasing_users,

    ROUND(
        SUM(purchase_revenue_usd),
        2
    ) AS total_revenue_usd,

    ROUND(
        SAFE_DIVIDE(
            SUM(purchase_revenue_usd),
            COUNT(*)
        ),
        2
    ) AS average_order_value_usd,

    SUM(total_item_quantity) AS total_items_purchased,

    ROUND(
        SUM(refund_usd),
        2
    ) AS total_refunds_usd,

    ROUND(
        SUM(shipping_usd),
        2
    ) AS total_shipping_usd,

    ROUND(
        SUM(tax_usd),
        2
    ) AS total_tax_usd

FROM `bhakti-510718.bhakti_analytics.fact_transactions`;


-- ============================================================
-- Monthly Revenue Analysis
-- ============================================================

SELECT
    DATE_TRUNC(event_date, MONTH) AS month,

    COUNT(*) AS purchase_events,

    COUNT(DISTINCT user_pseudo_id) AS purchasing_users,

    ROUND(
        SUM(purchase_revenue_usd),
        2
    ) AS revenue_usd,

    ROUND(
        SAFE_DIVIDE(
            SUM(purchase_revenue_usd),
            COUNT(*)
        ),
        2
    ) AS average_order_value_usd

FROM `bhakti-510718.bhakti_analytics.fact_transactions`

GROUP BY month

ORDER BY month;