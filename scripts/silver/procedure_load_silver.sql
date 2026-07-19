/*
--------------------------------------------
DML Scripts: Load Silver Tables
--------------------------------------------
Script Purpose:
    This script loads data into the silver
    schema tables from the bronze schema tables.
    Performs cleansing/transformation (trim,
    null handling, type casting) during the
    load. Truncates each table before loading
    (full reload).
---------------------------------------------
*/


CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '===================================';
        PRINT 'LOADING SILVER LAYER';
        PRINT '===================================';

        -- ===== silver.aw_customer =====
        SET @start_time = GETDATE();
        PRINT '=>> TRUNCATING TABLE: silver.aw_customer';
        TRUNCATE TABLE silver.aw_customer;
        PRINT '=>> INSERTING DATA INTO: silver.aw_customer';
        INSERT INTO silver.aw_customer (
            customer_id, person_id, store_id, territory_id
        )
        SELECT
            customer_id, person_id, store_id, territory_id
        FROM bronze.aw_customer
        WHERE customer_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';


        -- ===== silver.aw_person =====
        SET @start_time = GETDATE();
        PRINT '=>> TRUNCATING TABLE: silver.aw_person';
        TRUNCATE TABLE silver.aw_person;
        PRINT '=>> INSERTING DATA INTO: silver.aw_person';
        INSERT INTO silver.aw_person (
            business_entity_id, first_name, middle_name, last_name, suffix
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
        SET @end_time = GETDATE();
        PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';


        -- ===== silver.aw_product =====
        SET @start_time = GETDATE();
        PRINT '=>> TRUNCATING TABLE: silver.aw_product';
        TRUNCATE TABLE silver.aw_product;
        PRINT '=>> INSERTING DATA INTO: silver.aw_product';
        INSERT INTO silver.aw_product (
            product_id, name, product_number, color, standard_cost,
            list_price, size, product_subcategory_id
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
        SET @end_time = GETDATE();
        PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';


        -- ===== silver.aw_product_subcategory =====
        SET @start_time = GETDATE();
        PRINT '=>> TRUNCATING TABLE: silver.aw_product_subcategory';
        TRUNCATE TABLE silver.aw_product_subcategory;
        PRINT '=>> INSERTING DATA INTO: silver.aw_product_subcategory';
        INSERT INTO silver.aw_product_subcategory (
            product_subcategory_id, product_category_id, name
        )
        SELECT
            product_subcategory_id, product_category_id, TRIM(name) AS name
        FROM bronze.aw_product_subcategory;
        SET @end_time = GETDATE();
        PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';


        -- ===== silver.aw_product_category =====
        SET @start_time = GETDATE();
        PRINT '=>> TRUNCATING TABLE: silver.aw_product_category';
        TRUNCATE TABLE silver.aw_product_category;
        PRINT '=>> INSERTING DATA INTO: silver.aw_product_category';
        INSERT INTO silver.aw_product_category (
            product_category_id, name
        )
        SELECT
            product_category_id, TRIM(name) AS name
        FROM bronze.aw_product_category;
        SET @end_time = GETDATE();
        PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';


        -- ===== silver.aw_sales_territory =====
        SET @start_time = GETDATE();
        PRINT '=>> TRUNCATING TABLE: silver.aw_sales_territory';
        TRUNCATE TABLE silver.aw_sales_territory;
        PRINT '=>> INSERTING DATA INTO: silver.aw_sales_territory';
        INSERT INTO silver.aw_sales_territory (
            territory_id, name, country_region_code, group_name
        )
        SELECT
            territory_id,
            TRIM(name) AS name,
            TRIM(country_region_code) AS country_region_code,
            TRIM(group_name) AS group_name
        FROM bronze.aw_sales_territory
        WHERE territory_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';


        -- ===== silver.aw_sales_person =====
        SET @start_time = GETDATE();
        PRINT '=>> TRUNCATING TABLE: silver.aw_sales_person';
        TRUNCATE TABLE silver.aw_sales_person;
        PRINT '=>> INSERTING DATA INTO: silver.aw_sales_person';
        INSERT INTO silver.aw_sales_person (
            business_entity_id, territory_id
        )
        SELECT
            business_entity_id, territory_id
        FROM bronze.aw_sales_person
        WHERE business_entity_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';


        -- ===== silver.aw_employee =====
        SET @start_time = GETDATE();
        PRINT '=>> TRUNCATING TABLE: silver.aw_employee';
        TRUNCATE TABLE silver.aw_employee;
        PRINT '=>> INSERTING DATA INTO: silver.aw_employee';
        INSERT INTO silver.aw_employee (
            business_entity_id, job_title
        )
        SELECT
            business_entity_id, TRIM(job_title) AS job_title
        FROM bronze.aw_employee
        WHERE business_entity_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';


        -- ===== silver.aw_sales_order_header =====
        SET @start_time = GETDATE();
        PRINT '=>> TRUNCATING TABLE: silver.aw_sales_order_header';
        TRUNCATE TABLE silver.aw_sales_order_header;
        PRINT '=>> INSERTING DATA INTO: silver.aw_sales_order_header';
        INSERT INTO silver.aw_sales_order_header (
            sales_order_id, order_date, customer_id, sales_person_id, territory_id
        )
        SELECT
            sales_order_id,
            CAST(order_date AS DATE) AS order_date,
            customer_id,
            sales_person_id,
            territory_id
        FROM bronze.aw_sales_order_header
        WHERE sales_order_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';


        -- ===== silver.aw_sales_order_detail =====
        SET @start_time = GETDATE();
        PRINT '=>> TRUNCATING TABLE: silver.aw_sales_order_detail';
        TRUNCATE TABLE silver.aw_sales_order_detail;
        PRINT '=>> INSERTING DATA INTO: silver.aw_sales_order_detail';
        INSERT INTO silver.aw_sales_order_detail (
            sales_order_id, sales_order_detail_id, order_qty, product_id,
            unit_price, unit_price_discount, line_total
        )
        SELECT
            sales_order_id,
            sales_order_detail_id,
            order_qty,
            product_id,
            unit_price,
            ISNULL(unit_price_discount, 0) AS unit_price_discount,
            line_total
        FROM bronze.aw_sales_order_detail
        WHERE sales_order_detail_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';
    
                -- ===== silver.aw_store =====
        SET @start_time = GETDATE();
        PRINT '=>> TRUNCATING TABLE: silver.aw_store';
        TRUNCATE TABLE silver.aw_store;
        PRINT '=>> INSERTING DATA INTO: silver.aw_store';
        INSERT INTO silver.aw_store (
            business_entity_id, name, sales_person_id
        )
        SELECT
            business_entity_id,
            TRIM(name) AS name,
            sales_person_id
        FROM bronze.aw_store
        WHERE business_entity_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';

        
        SET @batch_end_time = GETDATE();
        PRINT '';
        PRINT '';
        PRINT '===================================';
        PRINT '=>> BATCH LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';
    END TRY

    BEGIN CATCH
        PRINT '===================================';
        PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
        PRINT 'Error Message' + ERROR_MESSAGE();
        PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '===================================';
    END CATCH
END;
GO
