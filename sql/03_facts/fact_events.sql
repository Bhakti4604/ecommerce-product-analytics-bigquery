-- ============================================================
-- Fact Table: fact_events
-- Purpose: Create the core event-level analytical fact table
-- Source: stg_events
-- ============================================================

CREATE OR REPLACE TABLE
`bhakti-510718.bhakti_analytics.fact_events`
AS

SELECT
    event_key,
    event_date,
    event_timestamp,
    event_name,
    user_pseudo_id,
    platform,

    device_category,
    operating_system,
    browser,

    country,
    region,

    traffic_source,
    traffic_medium,
    traffic_campaign

FROM `bhakti-510718.bhakti_analytics.stg_events`;

-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT event_key) AS unique_event_keys,
    COUNT(DISTINCT user_pseudo_id) AS unique_users,
    COUNT(DISTINCT event_name) AS event_types,
    MIN(event_date) AS min_event_date,
    MAX(event_date) AS max_event_date
FROM `bhakti-510718.bhakti_analytics.fact_events`;