
-- Check Null
SELECT COUNT(*) AS null_count
FROM bronze.aw_sales_order_detail
WHERE sales_order_id IS NULL;


-- Orphan Check
SELECT sod.sales_order_id,
    soh.sales_order_id
FROM bronze.aw_sales_order_detail AS sod
LEFT JOIN bronze.aw_sales_order_header AS soh
    ON sod.sales_order_id = soh.sales_order_id
WHERE sod.sales_order_id IS NOT NULL
    AND sod.sales_order_id IS NULL;

-- Check Duplicates
SELECT sales_order_detail_id, COUNT(*) AS duplicate_count
FROM bronze.aw_sales_order_detail
GROUP BY sales_order_detail_id
HAVING COUNT(*) > 1;

-- Check Zero/Negative 
SELECT order_qty
FROM bronze.aw_sales_order_detail
WHERE order_qty <= 0;

-- Check for consistency
SELECT 
    sales_order_detail_id,
    order_qty,
    unit_price,
    unit_price_discount,
    line_total,
    ROUND(order_qty * unit_price * (1 - unit_price_discount), 2) AS calculated_total
FROM bronze.aw_sales_order_detail
WHERE ROUND(line_total, 2) != ROUND(order_qty * unit_price * (1 - unit_price_discount), 2);


