-- ============================================================
-- Analysis: New vs Returning Users
-- Purpose: Classify active users as new or returning by day
-- ============================================================

WITH user_daily_activity AS (

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
    a.event_date,

    COUNTIF(
        a.event_date = f.first_event_date
    ) AS new_users,

    COUNTIF(
        a.event_date > f.first_event_date
    ) AS returning_users,

    COUNT(*) AS total_active_users

FROM user_daily_activity AS a

JOIN user_first_activity AS f
    ON a.user_pseudo_id = f.user_pseudo_id

GROUP BY a.event_date

ORDER BY a.event_date;