SELECT * FROM bronze.aw_customer;

-- >>> Quality Check: customer_id

-- Check Duplicates
SELECT 
	customer_id,
	COUNT(*) AS total_duplicates
FROM  bronze.aw_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check NULL 
SELECT 
	COUNT(*) AS total_null
FROM  bronze.aw_customer
WHERE customer_id IS NULL;
	


-- >>> Quality Check: person_id

-- Orphan Check
SELECT 
	c.person_id,
	p.business_entity_id
FROM bronze.aw_customer AS c
LEFT JOIN bronze.aw_person AS p
ON c.person_id = p.business_entity_id
WHERE c.person_id IS NOT NULL
	AND p.business_entity_id IS NULL;




-- >>> Quality Check:territory_id

-- Orphan Check
SELECT 
	c.territory_id,
	st.territory_id AS sales_territory_id
FROM bronze.aw_customer AS c
LEFT JOIN bronze.aw_sales_territory AS st
ON c.territory_id = st.territory_id
WHERE c.territory_id IS NOT NULL
	AND st.territory_id IS NULL;
