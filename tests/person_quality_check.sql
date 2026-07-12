
-- Check NUll
-- Expectation: No Result
SELECT 
	business_entity_id
FROM bronze.aw_person
WHERE business_entity_id IS NULL;


-- Check Duplicates
-- Expectation: No Result

SELECT 
	business_entity_id,
	COUNT(*)
FROM bronze.aw_person
GROUP BY business_entity_id
HAVING COUNT(*) > 1;




-- Check for Unwanted Spaces

SELECT
    business_entity_id,
    first_name,
    middle_name,
    last_name,
    suffix
FROM bronze.aw_person
WHERE first_name != TRIM(first_name)
    OR middle_name != TRIM(middle_name)
    OR last_name != TRIM(last_name)
    OR suffix != TRIM(suffix);


-- Check Empty
SELECT first_name
FROM bronze.aw_person
WHERE TRIM(first_name) = ''
   OR TRIM(middle_name) = ''
   OR TRIM(last_name) = ''
   OR TRIM(suffix) = '';


-- Check for Standardzation
-- Expectation: No Result
SELECT middle_name
FROM bronze.aw_person
WHERE SUBSTRING(middle_name, 2, 1) != '.'
    AND LEN(middle_name) != 1;


SELECT middle_name
FROM bronze.aw_person
WHERE SUBSTRING(middle_name, 2, 1) != '.'
    AND LEN(middle_name) = 1;
