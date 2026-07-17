
-- Check Duplicates
SELECT full_date, COUNT(*)
FROM gold.dim_dates
GROUP BY full_date
HAVING COUNT(*) > 1;


-- Check Nulls
SELECT *
FROM gold.dim_dates
WHERE date_key IS NULL
   OR full_date IS NULL;
