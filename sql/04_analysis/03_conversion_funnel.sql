-- ============================================================
-- Analysis: Conversion Funnel
-- Purpose: Measure user progression through the ecommerce funnel
-- ============================================================

WITH funnel_users AS (

    SELECT
        COUNT(DISTINCT CASE
            WHEN event_name = 'view_item'
            THEN user_pseudo_id
        END) AS product_viewers,

        COUNT(DISTINCT CASE
            WHEN event_name = 'add_to_cart'
            THEN user_pseudo_id
        END) AS cart_users,

        COUNT(DISTINCT CASE
            WHEN event_name = 'begin_checkout'
            THEN user_pseudo_id
        END) AS checkout_users,

        COUNT(DISTINCT CASE
            WHEN event_name = 'purchase'
            THEN user_pseudo_id
        END) AS purchasing_users

    FROM `bhakti-510718.bhakti_analytics.fact_events`

)

SELECT
    product_viewers,
    cart_users,
    checkout_users,
    purchasing_users,

    ROUND(
        SAFE_DIVIDE(cart_users, product_viewers) * 100,
        2
    ) AS view_to_cart_pct,

    ROUND(
        SAFE_DIVIDE(checkout_users, cart_users) * 100,
        2
    ) AS cart_to_checkout_pct,

    ROUND(
        SAFE_DIVIDE(purchasing_users, checkout_users) * 100,
        2
    ) AS checkout_to_purchase_pct,

    ROUND(
        SAFE_DIVIDE(purchasing_users, product_viewers) * 100,
        2
    ) AS view_to_purchase_pct

FROM funnel_users;