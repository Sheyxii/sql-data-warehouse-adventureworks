-- Check Duplicates
SELECT product_id, COUNT(*) 
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Check NULL
SELECT product_key, product_id, product_name, subcategory, category
FROM gold.dim_products
WHERE product_name IS NULL 
   OR subcategory IS NULL 
   OR category IS NULL;

-- Check Total products (Excluded Raw materials)
SELECT COUNT(*) AS total_products
FROM gold.dim_products;

-- Check Price consistency (list_price >= standard_cost)
SELECT product_id, product_name, standard_cost, list_price
FROM gold.dim_products
WHERE list_price < standard_cost;
