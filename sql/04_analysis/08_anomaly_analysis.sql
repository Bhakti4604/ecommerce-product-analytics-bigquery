-- ============================================================
-- Analysis: Revenue Anomaly Detection
-- Purpose: Identify unusually high or low revenue days
-- Method: Z-score based anomaly detection
-- ============================================================

WITH daily_revenue AS (

    SELECT
        event_date,

        COUNT(*) AS purchase_events,

        COUNT(DISTINCT user_pseudo_id) AS purchasing_users,

        ROUND(
            SUM(purchase_revenue_usd),
            2
        ) AS daily_revenue_usd

    FROM `bhakti-510718.bhakti_analytics.fact_transactions`

    GROUP BY event_date

),

revenue_statistics AS (

    SELECT
        AVG(daily_revenue_usd) AS average_daily_revenue,

        STDDEV(daily_revenue_usd) AS revenue_stddev

    FROM daily_revenue

)

SELECT
    d.event_date,
    d.purchase_events,
    d.purchasing_users,
    d.daily_revenue_usd,

    ROUND(
        SAFE_DIVIDE(
            d.daily_revenue_usd - s.average_daily_revenue,
            s.revenue_stddev
        ),
        2
    ) AS revenue_z_score,

    CASE
        WHEN SAFE_DIVIDE(
            d.daily_revenue_usd - s.average_daily_revenue,
            s.revenue_stddev
        ) >= 2
            THEN 'High Anomaly'

        WHEN SAFE_DIVIDE(
            d.daily_revenue_usd - s.average_daily_revenue,
            s.revenue_stddev
        ) <= -2
            THEN 'Low Anomaly'

        ELSE 'Normal'
    END AS anomaly_status

FROM daily_revenue AS d

CROSS JOIN revenue_statistics AS s

ORDER BY d.event_date;