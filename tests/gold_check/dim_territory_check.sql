-- Check Duplicates
SELECT territory_id, COUNT(*)
FROM gold.dim_territory
GROUP BY territory_id
HAVING COUNT(*) > 1;

-- Check Nulls
SELECT *
FROM gold.dim_territory
WHERE territory_key IS NULL;
