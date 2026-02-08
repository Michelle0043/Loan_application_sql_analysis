-- 06_timeliness_ingestion_delay.sql
-- Purpose: Ingestion delay distribution + delayed rate

-- A) Per record delay days
SELECT
  application_id,
  application_ts,
  ingestion_ts,
  CAST(julianday(ingestion_ts) - julianday(application_ts) AS INTEGER) AS ingestion_delay_days
FROM loan_applications_raw
ORDER BY ingestion_delay_days DESC;

-- B) Delay distribution
SELECT
  CAST(julianday(ingestion_ts) - julianday(application_ts) AS INTEGER) AS delay_days,
  COUNT(*) AS cnt
FROM loan_applications_raw
GROUP BY delay_days
ORDER BY delay_days;

-- C) % delayed over 1 day / 2 days
SELECT
  COUNT(*) AS total_rows,

  SUM(CASE WHEN (julianday(ingestion_ts) - julianday(application_ts)) > 1 THEN 1 ELSE 0 END) AS delayed_over_1d,
  ROUND(
    SUM(CASE WHEN (julianday(ingestion_ts) - julianday(application_ts)) > 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*),
    4
  ) AS delayed_over_1d_rate,

  SUM(CASE WHEN (julianday(ingestion_ts) - julianday(application_ts)) > 2 THEN 1 ELSE 0 END) AS delayed_over_2d,
  ROUND(
    SUM(CASE WHEN (julianday(ingestion_ts) - julianday(application_ts)) > 2 THEN 1 ELSE 0 END) * 1.0 / COUNT(*),
    4
  ) AS delayed_over_2d_rate
FROM loan_applications_raw;