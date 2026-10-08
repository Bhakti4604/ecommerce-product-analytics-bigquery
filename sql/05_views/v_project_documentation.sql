-- ============================================================
-- View: v_project_documentation
-- Purpose: Document the analytical data warehouse objects
-- ============================================================

CREATE OR REPLACE VIEW
`bhakti-510718.bhakti_analytics.v_project_documentation`
AS

SELECT
    'staging' AS object_layer,
    'stg_events' AS object_name,
    'Standardized event-level source data' AS description

UNION ALL

SELECT
    'staging',
    'stg_items',
    'Flattened ecommerce item-level data'

UNION ALL

SELECT
    'staging',
    'stg_transactions',
    'Purchase-level transaction data'

UNION ALL

SELECT
    'dimension',
    'dim_users',
    'User-level behavioral summary'

UNION ALL

SELECT
    'dimension',
    'dim_date',
    'Calendar dimension'

UNION ALL

SELECT
    'dimension',
    'dim_products',
    'Product master dimension'

UNION ALL

SELECT
    'dimension',
    'dim_device',
    'Device and browser summary'

UNION ALL

SELECT
    'dimension',
    'dim_geo',
    'Geographic summary'

UNION ALL

SELECT
    'fact',
    'fact_events',
    'Core event-level fact table'

UNION ALL

SELECT
    'fact',
    'fact_items',
    'Item-level fact table'

UNION ALL

SELECT
    'fact',
    'fact_transactions',
    'Purchase-level transaction fact table'

UNION ALL

SELECT
    'optimization',
    'fact_events_clustered',
    'Clustered event fact table'

UNION ALL

SELECT
    'analysis',
    'v_product_performance',
    'Product performance analytics'

UNION ALL

SELECT
    'analysis',
    'v_category_performance',
    'Category performance analytics'

UNION ALL

SELECT
    'analysis',
    'v_cohort_retention',
    'Cohort retention analytics'

UNION ALL

SELECT
    'analysis',
    'v_customer_ltv',
    'Customer lifetime value'

UNION ALL

SELECT
    'analysis',
    'v_customer_ltv_segments',
    'Customer value segmentation'

UNION ALL

SELECT
    'analysis',
    'v_daily_revenue_anomalies',
    'Revenue anomaly detection'

UNION ALL

SELECT
    'dashboard',
    'v_executive_kpis',
    'Executive dashboard KPIs';


-- ============================================================
-- Validation
-- ============================================================

SELECT
    object_layer,
    COUNT(*) AS object_count
FROM `bhakti-510718.bhakti_analytics.v_project_documentation`
GROUP BY object_layer
ORDER BY object_layer;