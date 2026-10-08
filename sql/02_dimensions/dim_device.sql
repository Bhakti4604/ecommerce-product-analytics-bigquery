-- ============================================================
-- Dimension: dim_device
-- Purpose: Summarize device, operating system and browser usage
-- Source: stg_events
-- ============================================================

CREATE OR REPLACE TABLE
`bhakti-510718.bhakti_analytics.dim_device`
AS

SELECT
    device_category,
    operating_system,
    browser,

    COUNT(DISTINCT user_pseudo_id) AS users,
    COUNT(*) AS total_events

FROM `bhakti-510718.bhakti_analytics.stg_events`

GROUP BY
    device_category,
    operating_system,
    browser;



-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS device_combinations,
    COUNTIF(device_category IS NULL) AS null_device_categories,
    COUNTIF(operating_system IS NULL) AS null_operating_systems,
    COUNTIF(browser IS NULL) AS null_browsers,
    SUM(total_events) AS total_events
FROM `bhakti-510718.bhakti_analytics.dim_device`;