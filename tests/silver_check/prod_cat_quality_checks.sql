
-- Check Duplicates
SELECT 
    product_category_id,
    COUNT(*)
FROM bronze.aw_product_category
GROUP BY product_category_id
HAVING COUNT(*) > 1;

-- Check Nulls
SELECT 
    COUNT(product_category_id) AS total_null
FROM bronze.aw_product_category
WHERE product_category_id IS NULL;


-- Check Unwanted Spaces
SELECT 
    name
FROM bronze.aw_product_category
WHERE name != TRIM(name)


