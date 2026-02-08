-- 07_dq_summary_table.sql
-- Purpose: Produce one DQ summary table for GitHub README

WITH base AS (
  SELECT
    COUNT(*) AS total_count
  FROM loan_applications_raw
),

issues AS (

  -- Completeness: Any NULL in critical fields
  SELECT
    'Completeness' AS dq_dimension,
    'Any NULL in critical fields' AS dq_metric,
    SUM(
      CASE
        WHEN application_id IS NULL
          OR customer_id IS NULL
          OR application_ts IS NULL
          OR ingestion_ts IS NULL
          OR source_system IS NULL
          OR product_type IS NULL
          OR loan_amount IS NULL
          OR annual_income IS NULL
          OR credit_score IS NULL
          OR employment_status IS NULL
          OR application_status IS NULL
        THEN 1 ELSE 0
      END
    ) AS issue_count
  FROM loan_applications_raw

  UNION ALL

  -- Uniqueness: Duplicate application_id
  SELECT
    'Uniqueness' AS dq_dimension,
    'Duplicate application_id' AS dq_metric,
    (
      SELECT COALESCE(SUM(cnt - 1), 0)
      FROM (
        SELECT application_id, COUNT(*) AS cnt
        FROM loan_applications_raw
        GROUP BY application_id
        HAVING COUNT(*) > 1
      )
    ) AS issue_count

  UNION ALL

  -- Validity: credit_score out of range
  SELECT
    'Validity' AS dq_dimension,
    'Credit score out of range (300-850)' AS dq_metric,
    SUM(CASE WHEN credit_score < 300 OR credit_score > 850 THEN 1 ELSE 0 END) AS issue_count
  FROM loan_applications_raw

  UNION ALL

  -- Accuracy: dtiratio out of range
  SELECT
    'Accuracy' AS dq_dimension,
    'DTI ratio out of range (0-1)' AS dq_metric,
    SUM(CASE WHEN dtiratio < 0 OR dtiratio > 1 THEN 1 ELSE 0 END) AS issue_count
  FROM loan_applications_raw

  UNION ALL

  -- Consistency: APPROVED/DECLINED missing decision_ts
  SELECT
    'Consistency' AS dq_dimension,
    'APPROVED/DECLINED missing decision_ts' AS dq_metric,
    SUM(
      CASE
        WHEN application_status IN ('APPROVED', 'DECLINED')
             AND decision_ts IS NULL
        THEN 1 ELSE 0
      END
    ) AS issue_count
  FROM loan_applications_raw

  UNION ALL

  -- Timeliness: ingestion delay > 2 days
  SELECT
    'Timeliness' AS dq_dimension,
    'Ingestion delay > 2 days' AS dq_metric,
    SUM(
      CASE
        WHEN (julianday(ingestion_ts) - julianday(application_ts)) > 2
        THEN 1 ELSE 0
      END
    ) AS issue_count
  FROM loan_applications_raw
)

SELECT
  i.dq_dimension,
  i.dq_metric,
  i.issue_count,
  b.total_count,
  ROUND(i.issue_count * 1.0 / b.total_count, 4) AS issue_rate
FROM issues i
CROSS JOIN base b
ORDER BY issue_rate DESC;

