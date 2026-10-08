-- ============================================================
-- Analysis: Customer Lifetime Value (CLV)
-- Purpose: Measure customer revenue and segment customers
-- ============================================================


-- ============================================================
-- Customer-Level Lifetime Value
-- ============================================================

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

GROUP BY user_pseudo_id

ORDER BY lifetime_revenue_usd DESC;


-- ============================================================
-- CLV Segmentation
-- ============================================================

WITH customer_ltv AS (

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

    GROUP BY user_pseudo_id

)

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

FROM customer_ltv

ORDER BY lifetime_revenue_usd DESC;