-- ============================================================
-- Analysis: Product & Category Performance
-- Purpose: Analyze product-level and category-level performance
-- ============================================================


-- ============================================================
-- Product Performance
-- ============================================================

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
    p.category

ORDER BY revenue_usd DESC;


-- ============================================================
-- Category Performance
-- ============================================================

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

GROUP BY p.category

ORDER BY revenue_usd DESC;