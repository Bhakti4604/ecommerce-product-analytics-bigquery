-- ============================================================
-- Analysis: User Engagement
-- Purpose: Calculate daily active users and engagement
-- ============================================================

SELECT
    event_date,

    COUNT(DISTINCT user_pseudo_id) AS daily_active_users,

    COUNT(*) AS total_events,

    ROUND(
        COUNT(*) / COUNT(DISTINCT user_pseudo_id),
        2
    ) AS events_per_active_user

FROM `bhakti-510718.bhakti_analytics.fact_events`

GROUP BY event_date

ORDER BY event_date;