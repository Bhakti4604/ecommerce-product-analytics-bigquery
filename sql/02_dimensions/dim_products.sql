-- ============================================================
-- Dimension: dim_products
-- Purpose: Create a product master dimension
-- Source: stg_items
-- ============================================================

CREATE OR REPLACE TABLE
`bhakti-510718.bhakti_analytics.dim_products`
AS

SELECT
    item_id AS product_id,

    ANY_VALUE(item_name) AS product_name,
    ANY_VALUE(item_brand) AS brand,
    ANY_VALUE(item_variant) AS variant,

    ANY_VALUE(item_category) AS category,
    ANY_VALUE(item_category2) AS category2,
    ANY_VALUE(item_category3) AS category3,
    ANY_VALUE(item_category4) AS category4,
    ANY_VALUE(item_category5) AS category5

FROM `bhakti-510718.bhakti_analytics.stg_items`

GROUP BY item_id;



-- ============================================================
-- Validation
-- ============================================================

SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT product_id) AS unique_product_ids,
    COUNTIF(product_name IS NULL) AS null_product_names,
    COUNTIF(category IS NULL) AS null_categories
FROM `bhakti-510718.bhakti_analytics.dim_products`;