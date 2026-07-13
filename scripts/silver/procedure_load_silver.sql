-- Customer
TRUNCATE TABLE silver.aw_customer;
GO
INSERT INTO silver.aw_customer (
    customer_id,
    person_id,
    store_id,
    territory_id
)
SELECT 
    customer_id,
    person_id,
    store_id,
    territory_id
FROM bronze.aw_customer
WHERE customer_id IS NOT NULL;
GO


-- Person
TRUNCATE TABLE silver.aw_person;
GO
INSERT INTO silver.aw_person (
    business_entity_id,
    first_name,
    middle_name,
    last_name,
    suffix
)
SELECT
    business_entity_id,
    NULLIF(TRIM(first_name), '') AS first_name,
    CASE
        WHEN NULLIF(TRIM(middle_name), '') IS NULL THEN NULL
        ELSE CONCAT(LEFT(TRIM(middle_name), 1), '.')
    END AS middle_name,    
    NULLIF(TRIM(last_name), '') AS last_name,
    NULLIF(TRIM(suffix), '') AS suffix
FROM bronze.aw_person;
GO


-- Product
TRUNCATE TABLE silver.aw_product;
GO
INSERT INTO silver.aw_product (
    product_id,
    name,
    product_number,
    color,
    standard_cost,
    list_price,
    size,
    product_subcategory_id
)
SELECT
    product_id,
    TRIM(name) AS name,
    TRIM(product_number) AS product_number,
    TRIM(color) AS color,
    standard_cost,
    list_price,
    TRIM(size) AS size,
    product_subcategory_id
FROM bronze.aw_product;
GO


-- Product Subcategory
TRUNCATE TABLE silver.aw_product_subcategory;
GO
INSERT INTO silver.aw_product_subcategory (
    product_subcategory_id,
    product_category_id,
    name
)
SELECT 
    product_subcategory_id,
    product_category_id,
    TRIM(name) AS name
FROM bronze.aw_product_subcategory;
GO


-- Product Category
TRUNCATE TABLE silver.aw_product_category;
GO
INSERT INTO silver.aw_product_category (
    product_category_id,
    name
)
SELECT 
    product_category_id,
    TRIM(name) AS name
FROM bronze.aw_product_category;
GO
