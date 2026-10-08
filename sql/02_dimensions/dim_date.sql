-- ============================================================
-- Dimension: dim_date
-- Purpose: Create a calendar dimension for time-based analysis
-- Date range: 2020-11-01 to 2021-01-31
-- ============================================================

CREATE OR REPLACE TABLE
`bhakti-510718.bhakti_analytics.dim_date`
AS

SELECT
    date AS date_key,

    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(QUARTER FROM date) AS quarter,
    EXTRACT(MONTH FROM date) AS month,

    FORMAT_DATE('%B', date) AS month_name,

    EXTRACT(WEEK FROM date) AS week,
    EXTRACT(DAY FROM date) AS day,

    FORMAT_DATE('%A', date) AS day_name,

    CASE
        WHEN EXTRACT(DAYOFWEEK FROM date) IN (1, 7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type

FROM UNNEST(
    GENERATE_DATE_ARRAY(
        DATE '2020-11-01',
        DATE '2021-01-31'
    )
) AS date;




-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS total_dates,
    COUNT(DISTINCT date_key) AS unique_dates,
    MIN(date_key) AS min_date,
    MAX(date_key) AS max_date,
    COUNTIF(day_type = 'Weekend') AS weekend_days,
    COUNTIF(day_type = 'Weekday') AS weekday_days
FROM `bhakti-510718.bhakti_analytics.dim_date`;