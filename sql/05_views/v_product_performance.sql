-- ============================================================
-- View: v_product_performance
-- Purpose: Product-level sales and revenue performance
-- ============================================================

CREATE OR REPLACE VIEW
`bhakti-510718.bhakti_analytics.v_product_performance`
AS

SELECT
    p.product_id,
    p.product_name,
    p.brand,
    p.category,

    COUNT(DISTINCT f.event_key) AS item_events,

    COUNT(DISTINCT CASE
        WHEN f.event_name = 'purchase'
        THEN f.event_key
    END) AS purchase_events,

    SUM(
        CASE
            WHEN f.event_name = 'purchase'
            THEN COALESCE(f.quantity, 0)
            ELSE 0
        END
    ) AS units_sold,

    ROUND(
        SUM(
            CASE
                WHEN f.event_name = 'purchase'
                THEN COALESCE(f.item_revenue_in_usd, 0)
                ELSE 0
            END
        ),
        2
    ) AS revenue_usd

FROM `bhakti-510718.bhakti_analytics.fact_items` AS f

JOIN `bhakti-510718.bhakti_analytics.dim_products` AS p
    ON f.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name,
    p.brand,
    p.category;


-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT product_id) AS unique_product_ids,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue_usd), 2) AS total_revenue_usd
FROM `bhakti-510718.bhakti_analytics.v_product_performance`;