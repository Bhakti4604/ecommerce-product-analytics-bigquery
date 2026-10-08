-- ============================================================
-- Fact Table: fact_items
-- Purpose: Create the item-level analytical fact table
-- Source: stg_items
-- ============================================================

CREATE OR REPLACE TABLE
`bhakti-510718.bhakti_analytics.fact_items`
AS

SELECT
    event_key,
    event_date,
    event_timestamp,
    event_name,
    user_pseudo_id,

    item_id AS product_id,

    quantity,
    price_in_usd,
    item_revenue_in_usd,
    item_refund_in_usd,

    coupon,
    affiliation,
    location_id,

    item_list_id,
    item_list_name,

    promotion_id,
    promotion_name

FROM `bhakti-510718.bhakti_analytics.stg_items`;

-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS total_item_rows,
    COUNT(DISTINCT event_key) AS unique_events,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT user_pseudo_id) AS unique_users,
    COUNT(DISTINCT event_name) AS event_types,
    MIN(event_date) AS min_event_date,
    MAX(event_date) AS max_event_date
FROM `bhakti-510718.bhakti_analytics.fact_items`;