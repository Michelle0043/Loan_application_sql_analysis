-- 02_uniqueness_duplicate_check.sql
-- Purpose: Duplicate application_id

SELECT
  application_id,
  COUNT(*) AS cnt
FROM loan_applications_raw
GROUP BY application_id
HAVING COUNT(*) > 1;