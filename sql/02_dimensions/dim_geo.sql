-- ============================================================
-- Dimension: dim_geo
-- Purpose: Summarize users and events by country and region
-- Source: Raw GA4 public ecommerce dataset
-- ============================================================

CREATE OR REPLACE TABLE
`bhakti-510718.bhakti_analytics.dim_geo`
AS

SELECT
    geo.country AS country,
    geo.region AS region,

    COUNT(DISTINCT user_pseudo_id) AS users,
    COUNT(*) AS total_events

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

GROUP BY
    geo.country,
    geo.region;




-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS geo_combinations,
    COUNTIF(country IS NULL) AS null_countries,
    COUNTIF(region IS NULL) AS null_regions,
    SUM(total_events) AS total_events
FROM `bhakti-510718.bhakti_analytics.dim_geo`;