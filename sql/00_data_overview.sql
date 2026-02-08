-- 00_profile_overview.sql
-- Purpose: Basic table profiling + date range coverage

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT application_id) AS distinct_application_id,
  COUNT(DISTINCT customer_id) AS distinct_customer_id,
  MIN(application_ts) AS min_application_ts,
  MAX(application_ts) AS max_application_ts,
  MIN(ingestion_ts) AS min_ingestion_ts,
  MAX(ingestion_ts) AS max_ingestion_ts
FROM loan_applications_raw;