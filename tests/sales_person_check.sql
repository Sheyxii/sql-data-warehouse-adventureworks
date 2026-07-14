
-- Orphan Check
SELECT 
    sp.territory_id,
    st.territory_id
FROM bronze.aw_sales_person AS sp
LEFT JOIN bronze.aw_sales_territory AS st
ON sp.territory_id = st.territory_id
WHERE sp.territory_id IS NOT NULL
    AND st.territory_id IS NULL;
