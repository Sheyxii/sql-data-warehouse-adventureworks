
-- Check Duplicate
SELECT business_entity_id, COUNT(*) AS duplicate_count
FROM bronze.aw_employee
GROUP BY business_entity_id
HAVING COUNT(*) > 1;

-- Check Unwanted Spaces
SELECT job_title
FROM bronze.aw_employee
WHERE job_title != TRIM(job_title);

-- Check Null/blank
SELECT COUNT(*) AS null_or_blank_count
FROM bronze.aw_employee
WHERE job_title IS NULL OR TRIM(job_title) = '';
