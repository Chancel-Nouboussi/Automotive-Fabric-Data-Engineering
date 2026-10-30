
-- Automotive Fabric Data Engineering Portfolio
-- Data Quality Monitoring Views
-- Microsoft Fabric SQL Analytics Endpoint
--
-- Run each CREATE VIEW statement separately.
-- The views should not already exist.

-- View 1: Daily monitoring

CREATE VIEW dbo.vw_daily_data_quality_monitoring
AS
SELECT
    CAST(CheckedAt AS DATE) AS CheckDate,
    COUNT(*) AS TotalChecks,

    SUM(CASE WHEN QualityStatus = 'PASS'
        THEN 1 ELSE 0 END) AS PassedChecks,

    SUM(CASE WHEN QualityStatus = 'FAIL'
        THEN 1 ELSE 0 END) AS FailedChecks,

    CAST(
        100.0 * SUM(CASE WHEN QualityStatus = 'PASS'
            THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS QualityPassRate,

    SUM(
        COALESCE(MissingRows, 0) +
        COALESCE(DuplicateTestIDs, 0) +
        COALESCE(InvalidResults, 0) +
        COALESCE(InvalidDTCs, 0) +
        COALESCE(InvalidCategories, 0)
    ) AS TotalQualityIssues

FROM dbo.synthetic_data_quality_log
GROUP BY CAST(CheckedAt AS DATE);

GO

-- View 2: Overall monitoring KPIs

CREATE VIEW dbo.vw_data_quality_kpis
AS
SELECT
    COUNT(*) AS TotalChecks,

    SUM(CASE WHEN QualityStatus = 'PASS'
        THEN 1 ELSE 0 END) AS PassedChecks,

    SUM(CASE WHEN QualityStatus = 'FAIL'
        THEN 1 ELSE 0 END) AS FailedChecks,

    CAST(
        100.0 * SUM(CASE WHEN QualityStatus = 'PASS'
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
