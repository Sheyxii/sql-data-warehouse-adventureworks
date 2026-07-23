

-- Check for Duplicates
-- Expectation: No Result

SELECT
    product_id,
    COUNT(*)
FROM bronze.aw_product
GROUP BY product_id
HAVING COUNT(*) > 1;


-- Check for Nulls
-- Expectation: No Result
SELECT
    COUNT(product_id) AS total_null
FROM bronze.aw_product
WHERE product_id IS NULL;

SELECT
	color
FROM silver.aw_product
WHERE color IS NULL

SELECT
	size
FROM silver.aw_product
WHERE size IS NULL

    
-- Guardrail Check
SELECT
    color
FROM bronze.aw_product
WHERE TRIM(color) = ''
    OR color IS NULL;


-- Check Unwanted Spaces
SELECT
    color
FROM bronze.aw_product
WHERE color != TRIM(color);


-- Check Negative Value

SELECT product_id, standard_cost, list_price
FROM bronze.aw_product
WHERE standard_cost < 0 OR list_price < 0;

-- Check Business Logic
SELECT product_id, standard_cost, list_price
FROM bronze.aw_product
WHERE list_price < standard_cost;



-- Orphan Check
SELECT 
    p.product_subcategory_id,
    psc.product_subcategory_id
FROM bronze.aw_product AS p
LEFT JOIN bronze.aw_product_subcategory AS psc
ON p.product_subcategory_id = psc.product_subcategory_id
WHERE p.product_subcategory_id IS NOT NULL
    AND psc.product_subcategory_id IS NULL;


SELECT * FROM bronze.aw_product
