-- 04_accuracy_numeric_range_check.sql
-- Purpose: Identify impossible / suspicious numeric values

SELECT
  COUNT(*) AS total_rows,

  SUM(CASE WHEN loan_amount <= 0 THEN 1 ELSE 0 END) AS bad_loan_amount,
  SUM(CASE WHEN annual_income <= 0 THEN 1 ELSE 0 END) AS bad_annual_income,

  SUM(CASE WHEN credit_score < 300 OR credit_score > 850 THEN 1 ELSE 0 END) AS bad_credit_score,

  SUM(CASE WHEN dtiratio < 0 OR dtiratio > 1 THEN 1 ELSE 0 END) AS bad_dtiratio
FROM loan_applications_raw;
