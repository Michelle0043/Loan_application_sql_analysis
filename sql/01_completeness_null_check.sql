-- 01_completeness_null_check.sql
-- Purpose: Null counts for each key field

SELECT
  COUNT(*) AS total_rows,

  SUM(CASE WHEN application_id IS NULL THEN 1 ELSE 0 END) AS application_id_nulls,
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
  SUM(CASE WHEN application_ts IS NULL THEN 1 ELSE 0 END) AS application_ts_nulls,
  SUM(CASE WHEN ingestion_ts IS NULL THEN 1 ELSE 0 END) AS ingestion_ts_nulls,
  SUM(CASE WHEN source_system IS NULL THEN 1 ELSE 0 END) AS source_system_nulls,
  SUM(CASE WHEN product_type IS NULL THEN 1 ELSE 0 END) AS product_type_nulls,
  SUM(CASE WHEN loan_amount IS NULL THEN 1 ELSE 0 END) AS loan_amount_nulls,
  SUM(CASE WHEN annual_income IS NULL THEN 1 ELSE 0 END) AS annual_income_nulls,
  SUM(CASE WHEN credit_score IS NULL THEN 1 ELSE 0 END) AS credit_score_nulls,
  SUM(CASE WHEN employment_status IS NULL THEN 1 ELSE 0 END) AS employment_status_nulls,
  SUM(CASE WHEN dtiratio IS NULL THEN 1 ELSE 0 END) AS dtiratio_nulls,
  SUM(CASE WHEN application_status IS NULL THEN 1 ELSE 0 END) AS application_status_nulls,
  SUM(CASE WHEN decision_ts IS NULL THEN 1 ELSE 0 END) AS decision_ts_nulls
FROM loan_applications_raw;