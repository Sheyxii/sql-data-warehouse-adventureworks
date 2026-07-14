
-- Check Unwanter spaces
SELECT group_name
FROM bronze.aw_sales_territory
WHERE group_name != TRIM(group_name);


-- Check Consistency
SELECT DISTINCT group_name
FROM bronze.aw_sales_territory
ORDER BY group_name;
