
-- Automotive Fabric Data Engineering Portfolio
-- Bronze / Silver / Gold Validation
-- Dataset: 1,000 synthetic diagnostic tests

WITH LayerCounts AS (

    SELECT
        'Bronze' AS DataLayer,
        COUNT_BIG(*) AS TotalTests
    FROM bronze.synthetic_vehicle_diagnostics

    UNION ALL

    SELECT
        'Silver',
        COUNT_BIG(*)
    FROM silver.synthetic_vehicle_diagnostics_clean

    UNION ALL

    SELECT
        'Gold_ECU',
        SUM(CAST(TotalTests AS BIGINT))
    FROM gold.synthetic_ecu_quality_kpis

    UNION ALL

    SELECT
        'Gold_ErrorCategory',
        SUM(CAST(TotalTests AS BIGINT))
    FROM gold.synthetic_error_category_kpis

    UNION ALL

    SELECT
        'Gold_Monthly',
        SUM(CAST(TotalTests AS BIGINT))
    FROM gold.synthetic_monthly_quality_kpis
)

SELECT
    DataLayer,
    TotalTests,

    CASE
        WHEN TotalTests = 1000 THEN 'PASS'
        ELSE 'FAIL'
    END AS ValidationStatus

FROM LayerCounts;
