-- 05_consistency_logic_checks.sql
-- Purpose: Cross-field logic checks

SELECT
  COUNT(*) AS total_rows,

  -- APPROVED / DECLINED should have decision_ts
  SUM(
    CASE
      WHEN application_status IN ('APPROVED', 'DECLINED')
           AND decision_ts IS NULL
      THEN 1 ELSE 0
    END
  ) AS status_requires_decision_ts_missing,

  -- PENDING should not have decision_ts (usually)
  SUM(
    CASE
      WHEN application_status = 'PENDING'
           AND decision_ts IS NOT NULL
      THEN 1 ELSE 0
    END
  ) AS pending_has_decision_ts,

  -- decision_ts should not be earlier than application_ts
  SUM(
    CASE
      WHEN decision_ts IS NOT NULL
           AND application_ts IS NOT NULL
           AND julianday(decision_ts) < julianday(application_ts)
      THEN 1 ELSE 0
    END
  ) AS decision_before_application
FROM loan_applications_raw;