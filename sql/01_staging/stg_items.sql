-- ============================================================
-- Staging Table: stg_items
-- Purpose: Flatten nested ecommerce item data
-- Source: BigQuery public GA4 ecommerce sample dataset
-- ============================================================

CREATE OR REPLACE TABLE
`bhakti-510718.bhakti_analytics.stg_items`
AS

SELECT
    CONCAT(
        e.user_pseudo_id,
        '_',
        CAST(e.event_timestamp AS STRING),
        '_',
        e.event_name
    ) AS event_key,

    PARSE_DATE('%Y%m%d', e.event_date) AS event_date,

    e.event_timestamp,
    e.event_name,
    e.user_pseudo_id,

    item.item_id,
    item.item_name,
    item.item_brand,
    item.item_variant,

    item.item_category,
    item.item_category2,
    item.item_category3,
    item.item_category4,
    item.item_category5,

    item.price_in_usd,
    item.quantity,
    item.item_revenue_in_usd,
    item.item_refund_in_usd,

    item.coupon,
    item.affiliation,
    item.location_id,

    item.item_list_id,
    item.item_list_name,

    item.promotion_id,
    item.promotion_name

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS e

CROSS JOIN UNNEST(e.items) AS item;



-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT event_key) AS unique_events,
    COUNT(DISTINCT item_id) AS unique_items,
    COUNT(DISTINCT user_pseudo_id) AS unique_users,
    COUNT(DISTINCT event_name) AS event_types,
    MIN(event_date) AS min_event_date,
    MAX(event_date) AS max_event_date
FROM `bhakti-510718.bhakti_analytics.stg_items`;