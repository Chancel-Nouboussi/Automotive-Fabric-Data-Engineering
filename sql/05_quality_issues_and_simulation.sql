
-- Automotive Fabric Data Engineering Portfolio
-- Data Quality Issues and Simulation Views
-- Microsoft Fabric SQL Analytics Endpoint
--
-- These views already exist in our Fabric project.
-- This script documents their definitions.
-- Execute only in a fresh environment, one
-- CREATE VIEW statement per batch.

-- ============================================
-- VIEW 1: Actual data quality issues
-- ============================================

CREATE VIEW dbo.vw_data_quality_issues_by_type
AS

SELECT
    'Missing Fields' AS IssueType,
    SUM(MissingRows) AS IssueCount
FROM dbo.synthetic_data_quality_log

UNION ALL

SELECT
    'Duplicate TestIDs',
    SUM(DuplicateTestIDs)
FROM dbo.synthetic_data_quality_log

UNION ALL

SELECT
    'Invalid Results',
    SUM(InvalidResults)
FROM dbo.synthetic_data_quality_log

UNION ALL

SELECT
    'Invalid DTCs',
    SUM(InvalidDTCs)
FROM dbo.synthetic_data_quality_log

UNION ALL

SELECT
    'Invalid Categories',
    SUM(InvalidCategories)
FROM dbo.synthetic_data_quality_log;

GO

-- ============================================
-- VIEW 2: Simulated data quality issues
-- DEMONSTRATION DATA ONLY
-- ============================================

CREATE VIEW dbo.vw_simulated_data_quality_issues
AS

SELECT
    CAST('2026-10-26' AS DATE) AS CheckDate,
    'Missing Fields' AS IssueType,
    3 AS IssueCount,
    'SIMULATED' AS DataOrigin

UNION ALL

SELECT
    CAST('2026-10-26' AS DATE),
    'Duplicate TestIDs',
    2,
    'SIMULATED'

UNION ALL

SELECT
    CAST('2026-10-27' AS DATE),
    'Invalid Results',
    4,
    'SIMULATED'

UNION ALL

SELECT
    CAST('2026-10-28' AS DATE),
    'Invalid DTCs',
    6,
    'SIMULATED'

UNION ALL

SELECT
    CAST('2026-10-29' AS DATE),
    'Invalid Categories',
    2,
    'SIMULATED';
