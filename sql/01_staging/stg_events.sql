-- ============================================================
-- Staging Table: stg_events
-- Purpose: Standardize the raw GA4 event-level data
-- Source: BigQuery public GA4 ecommerce sample dataset
-- ============================================================

CREATE OR REPLACE TABLE
`bhakti-510718.bhakti_analytics.stg_events`
AS

SELECT
    CONCAT(
        user_pseudo_id,
        '_',
        CAST(event_timestamp AS STRING),
        '_',
        event_name
    ) AS event_key,

    PARSE_DATE('%Y%m%d', event_date) AS event_date,

    event_timestamp,
    event_name,
    user_pseudo_id,

    platform,

    device.category AS device_category,
    device.operating_system AS operating_system,
    device.web_info.browser AS browser,

    geo.country AS country,
    geo.region AS region,

    traffic_source.source AS traffic_source,
    traffic_source.medium AS traffic_medium,
    traffic_source.name AS traffic_campaign

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;



-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT event_key) AS unique_event_keys,
    COUNT(DISTINCT user_pseudo_id) AS unique_users,
    MIN(event_date) AS min_event_date,
    MAX(event_date) AS max_event_date
FROM `bhakti-510718.bhakti_analytics.stg_events`;