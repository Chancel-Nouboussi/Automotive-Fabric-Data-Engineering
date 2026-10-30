
-- Automotive Fabric Data Engineering Portfolio
-- PASS / FAIL Consistency Validation
-- Compare Silver and Gold aggregations

WITH Silver_KPIs AS (
    SELECT
        COUNT_BIG(*) AS TotalTests,
        SUM(CASE WHEN TestResult = 'PASS'
            THEN 1 ELSE 0 END) AS PassedTests,
        SUM(CASE WHEN TestResult = 'FAIL'
            THEN 1 ELSE 0 END) AS FailedTests
    FROM silver.synthetic_vehicle_diagnostics_clean
),

Gold_KPIs AS (
    SELECT
        'Gold_ECU' AS DataLayer,
        SUM(TotalTests) AS TotalTests,
        SUM(PassedTests) AS PassedTests,
        SUM(FailedTests) AS FailedTests
    FROM gold.synthetic_ecu_quality_kpis

    UNION ALL

    SELECT
        'Gold_ErrorCategory',
        SUM(TotalTests),
        SUM(PassedTests),
        SUM(FailedTests)
    FROM gold.synthetic_error_category_kpis

    UNION ALL

    SELECT
        'Gold_Monthly',
        SUM(TotalTests),
        SUM(PassedTests),
        SUM(FailedTests)
    FROM gold.synthetic_monthly_quality_kpis
)

SELECT
    g.DataLayer,
    g.TotalTests,
    g.PassedTests,
    g.FailedTests,
    CASE
        WHEN g.TotalTests = s.TotalTests
         AND g.PassedTests = s.PassedTests
         AND g.FailedTests = s.FailedTests
         AND g.PassedTests + g.FailedTests =
             g.TotalTests
        THEN 'PASS'
        ELSE 'FAIL'
    END AS ValidationStatus
FROM Gold_KPIs g
CROSS JOIN Silver_KPIs s;
