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

-- Sales Territory
TRUNCATE TABLE silver.aw_sales_territory;
GO

INSERT INTO silver.aw_sales_territory (
    territory_id,
    name,
    country_region_code,
    group_name
)
SELECT
    territory_id,
    TRIM(name) AS name,
    TRIM(country_region_code) AS country_region_code,
    TRIM(group_name) AS group_name
FROM bronze.aw_sales_territory
WHERE territory_id IS NOT NULL;
GO


-- Sales Person
TRUNCATE TABLE silver.aw_sales_person;
GO

INSERT INTO silver.aw_sales_person (
    business_entity_id,
    territory_id
)
SELECT
    business_entity_id,
    territory_id
FROM bronze.aw_sales_person
WHERE business_entity_id IS NOT NULL;
GO


-- Employee
TRUNCATE TABLE silver.aw_employee;
GO

INSERT INTO silver.aw_employee (
    business_entity_id,
    job_title
)
SELECT
    business_entity_id,
    TRIM(job_title) AS job_title
FROM bronze.aw_employee
WHERE business_entity_id IS NOT NULL;
GO


-- Sales Order Header
TRUNCATE TABLE silver.aw_sales_order_header;
GO

INSERT INTO silver.aw_sales_order_header (
    sales_order_id,
    order_date,
    customer_id,
    sales_person_id,
    territory_id
)
SELECT
    sales_order_id,
    CAST(order_date AS DATE) AS order_date,
    customer_id,
    sales_person_id,
    territory_id
FROM bronze.aw_sales_order_header
WHERE sales_order_id IS NOT NULL;
GO
