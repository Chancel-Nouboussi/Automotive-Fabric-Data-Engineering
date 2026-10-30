
-- Automotive Fabric Data Engineering Portfolio
-- Data Quality Monitoring
-- Source: dbo.synthetic_data_quality_log

-- 1. Overall quality monitoring
SELECT
    COUNT(*) AS TotalChecks,

    SUM(CASE WHEN QualityStatus = 'PASS'
        THEN 1 ELSE 0 END) AS PassedChecks,

    SUM(CASE WHEN QualityStatus = 'FAIL'
        THEN 1 ELSE 0 END) AS FailedChecks,

    CAST(
        100.0 * SUM(CASE
            WHEN QualityStatus = 'PASS'
            THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS QualityPassRate,

    SUM(TotalRows) AS TotalRowsChecked,

    SUM(
        COALESCE(MissingRows, 0) +
        COALESCE(DuplicateTestIDs, 0) +
        COALESCE(InvalidResults, 0) +
        COALESCE(InvalidDTCs, 0) +
        COALESCE(InvalidCategories, 0)
    ) AS TotalQualityIssues,

    MAX(CheckedAt) AS LastQualityCheck

FROM dbo.synthetic_data_quality_log;

-- 2. Daily quality monitoring
SELECT
    CAST(CheckedAt AS DATE) AS CheckDate,
    COUNT(*) AS TotalChecks,

    SUM(CASE WHEN QualityStatus = 'PASS'
        THEN 1 ELSE 0 END) AS PassedChecks,

    SUM(CASE WHEN QualityStatus = 'FAIL'
        THEN 1 ELSE 0 END) AS FailedChecks,

    CAST(
        100.0 * SUM(CASE
            WHEN QualityStatus = 'PASS'
            THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS QualityPassRate

FROM dbo.synthetic_data_quality_log

GROUP BY CAST(CheckedAt AS DATE)
ORDER BY CheckDate DESC;
