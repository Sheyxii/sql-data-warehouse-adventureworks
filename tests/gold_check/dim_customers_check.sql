-- Check Consistency 
SELECT customer_key, customer_id, name, customer_type
FROM gold.dim_customers
WHERE (customer_type = 'Store' AND name IS NULL)
   OR (customer_type = 'Individual' AND name IS NULL);

-- Check Duplicates
SELECT customer_id, COUNT(*) 
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check breakdown of Number of Customer type 
SELECT customer_type, COUNT(*) AS total
FROM gold.dim_customers
GROUP BY customer_type;


