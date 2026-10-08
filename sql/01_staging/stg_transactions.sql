-- ============================================================
-- Staging Table: stg_transactions
-- Purpose: Extract purchase-level transaction data
-- Source: BigQuery public GA4 ecommerce sample dataset
-- ============================================================

CREATE OR REPLACE TABLE
`bhakti-510718.bhakti_analytics.stg_transactions`
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
    user_pseudo_id,

    ecommerce.transaction_id AS transaction_id,
    ecommerce.total_item_quantity AS total_item_quantity,
    ecommerce.unique_items AS unique_items,

    ecommerce.purchase_revenue_in_usd AS purchase_revenue_usd,
    ecommerce.refund_value_in_usd AS refund_usd,
    ecommerce.shipping_value_in_usd AS shipping_usd,
    ecommerce.tax_value_in_usd AS tax_usd

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

WHERE event_name = 'purchase';



-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS purchase_events,
    COUNT(DISTINCT event_key) AS unique_purchase_events,
    COUNT(DISTINCT user_pseudo_id) AS purchasing_users,
    COUNT(DISTINCT transaction_id) AS unique_transaction_ids,
    COUNTIF(transaction_id IS NULL) AS null_transaction_ids,
    COUNTIF(transaction_id = '(not set)') AS not_set_transaction_ids,
    MIN(event_date) AS min_event_date,
    MAX(event_date) AS max_event_date
FROM `bhakti-510718.bhakti_analytics.stg_transactions`;