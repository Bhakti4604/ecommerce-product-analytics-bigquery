-- ============================================================
-- Fact Table: fact_transactions
-- Purpose: Create the purchase-level transaction fact table
-- Source: stg_transactions
-- ============================================================

CREATE OR REPLACE TABLE
`bhakti-510718.bhakti_analytics.fact_transactions`
AS

SELECT
    event_key,
    event_date,
    event_timestamp,
    user_pseudo_id,

    transaction_id,
    total_item_quantity,
    unique_items,

    purchase_revenue_usd,
    refund_usd,
    shipping_usd,
    tax_usd

FROM `bhakti-510718.bhakti_analytics.stg_transactions`;

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
FROM `bhakti-510718.bhakti_analytics.fact_transactions`;