-- ============================================================
-- View: v_cohort_retention
-- Purpose: Track user retention by acquisition cohort
-- ============================================================

CREATE OR REPLACE VIEW
`bhakti-510718.bhakti_analytics.v_cohort_retention`
AS

WITH user_activity AS (

    SELECT DISTINCT
        user_pseudo_id,
        event_date,
        DATE_TRUNC(event_date, MONTH) AS activity_month

    FROM `bhakti-510718.bhakti_analytics.fact_events`

),

user_cohorts AS (

    SELECT
        user_pseudo_id,

        DATE_TRUNC(
            MIN(event_date),
            MONTH
        ) AS cohort_month

    FROM `bhakti-510718.bhakti_analytics.fact_events`

    GROUP BY user_pseudo_id

)

SELECT
    c.cohort_month,

    a.activity_month,

    DATE_DIFF(
        a.activity_month,
        c.cohort_month,
        MONTH
    ) AS month_number,

    COUNT(DISTINCT a.user_pseudo_id) AS active_users

FROM user_cohorts AS c

JOIN user_activity AS a
    ON c.user_pseudo_id = a.user_pseudo_id

GROUP BY
    c.cohort_month,
    a.activity_month,
    month_number

ORDER BY
    c.cohort_month,
    month_number;


-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS cohort_records,
    COUNT(DISTINCT cohort_month) AS cohorts,
    MIN(cohort_month) AS first_cohort,
    MAX(cohort_month) AS last_cohort
FROM `bhakti-510718.bhakti_analytics.v_cohort_retention`;