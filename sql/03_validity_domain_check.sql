-- 03_validity_domain_check.sql
-- Purpose: Domain checks (what values exist)

SELECT source_system, COUNT(*) AS cnt
FROM loan_applications_raw
GROUP BY source_system
ORDER BY cnt DESC;

SELECT product_type, COUNT(*) AS cnt
FROM loan_applications_raw
GROUP BY product_type
ORDER BY cnt DESC;

SELECT employment_status, COUNT(*) AS cnt
FROM loan_applications_raw
GROUP BY employment_status
ORDER BY cnt DESC;

SELECT application_status, COUNT(*) AS cnt
FROM loan_applications_raw
GROUP BY application_status
ORDER BY cnt DESC;