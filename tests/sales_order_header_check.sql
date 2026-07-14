

-- Check the Time
SELECT order_date
FROM bronze.aw_sales_order_header
WHERE CAST(order_date AS TIME) = '00:00:00.000';


-- Orphan Check : customer_id
SELECT 
    soh.customer_id,
    c.customer_id
FROM bronze.aw_sales_order_header AS soh
LEFT JOIN bronze.aw_customer AS c
ON soh.customer_id = c.customer_id
WHERE soh.customer_id IS NOT NULL
    AND c.customer_id IS NULL;


-- Orphan Check : sales_person_id
SELECT 
    soh.sales_person_id,
    sp.business_entity_id
FROM bronze.aw_sales_order_header AS soh
LEFT JOIN bronze.aw_sales_person AS sp
ON soh.sales_person_id = sp.business_entity_id
WHERE soh.sales_person_id IS NOT NULL
    AND sp.business_entity_id IS NULL;


-- Orphan Check : territory_id
SELECT 
    soh.territory_id,
    st.territory_id
FROM bronze.aw_sales_order_header AS soh
LEFT JOIN bronze.aw_sales_territory AS st
ON soh.territory_id = st.territory_id
WHERE soh.territory_id IS NOT NULL
    AND st.territory_id IS NULL;




