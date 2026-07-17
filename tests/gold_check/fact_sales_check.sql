
-- Check Duplicates
SELECT sales_order_detail_id, COUNT(*)
FROM gold.fact_sales
GROUP BY sales_order_detail_id
HAVING COUNT(*) > 1;

/*  Check Null foreign keys (excluding sales_person_key since 
                        there are orders that dont have assigned salesperson)
*/
SELECT *
FROM gold.fact_sales
WHERE customer_key IS NULL
   OR product_key IS NULL
   OR territory_key IS NULL
   OR date_key IS NULL;


-- Check Financial Calculations
SELECT *
FROM gold.fact_sales
WHERE gross_profit <>
      (sales_amount - total_product_cost);


-- Quantity Validation
SELECT *
FROM gold.fact_sales
WHERE order_quantity <= 0;


-- Orphan Check (dim_products)
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL;
