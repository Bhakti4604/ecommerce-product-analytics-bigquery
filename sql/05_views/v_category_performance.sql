-- ============================================================
-- View: v_category_performance
-- Purpose: Category-level sales and revenue performance
-- ============================================================

CREATE OR REPLACE VIEW
`bhakti-510718.bhakti_analytics.v_category_performance`
AS

SELECT
    p.category,

    COUNT(DISTINCT f.product_id) AS unique_products,

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

GROUP BY p.category;


-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS total_categories,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue_usd), 2) AS total_revenue_usd
FROM `bhakti-510718.bhakti_analytics.v_category_performance`;