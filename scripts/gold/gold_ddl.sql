/*
===============================================================================
DDL Script: Create Gold Views and Tables
===============================================================================
Script Purpose:
    This script creates the Gold layer objects in the 'gold' schema.
    Existing views and tables are dropped before being recreated to ensure
    the latest dimensional model is applied.

    The Gold layer organizes cleaned Silver layer data into a Star Schema
    consisting of dimension tables and a fact table for analytics and reporting.

Objects Created:
    - gold.dim_customers
    - gold.dim_products
    - gold.dim_sales_persons
    - gold.dim_dates
    - gold.dim_territory
    - gold.fact_sales

Usage:
    Run this script after the Silver layer has been successfully loaded to
    create the analytical model for BI tools and reporting.
===============================================================================
*/



-- Create Dimension: gold.dim_customers
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS 
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,
    c.customer_id,
    CASE    
        WHEN c.store_id IS NOT NULL THEN st.name
        ELSE TRIM(CONCAT(
            p.first_name, ' ',
            ISNULL(p.middle_name + ' ', ''),
            p.last_name,
            ISNULL(' ' + p.suffix, '')
        ))
    END AS name,
    CASE
        WHEN store_id IS NOT NULL THEN 'Store'
        WHEN person_id IS NOT NULL THEN 'Individual'
        ELSE 'Unknown'
    END AS customer_type
FROM silver.aw_customer AS c
LEFT JOIN silver.aw_person AS p 
    ON c.person_id = p.business_entity_id
LEFT JOIN silver.aw_store AS st 
    ON c.store_id = st.business_entity_id
GO



-- Create Dimension: gold.dim_products
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY product_id) AS product_key,
    p.product_id ,
    p.name AS product_name,
    p.product_number,
    p.color,
    p.size,
    p.standard_cost,
    p.list_price,
    psc.name AS subcategory,
    pc.name AS category
FROM silver.aw_product AS p
INNER JOIN silver.aw_product_subcategory AS psc
    ON p.product_subcategory_id = psc.product_subcategory_id
INNER JOIN silver.aw_product_category AS pc
    ON psc.product_category_id = pc.product_category_id;
GO



    
-- Create Dimension: gold.dim_products
IF OBJECT_ID('gold.dim_sales_persons', 'V') IS NOT NULL
    DROP VIEW gold.dim_sales_persons;
GO
CREATE VIEW gold.dim_sales_persons AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY sp.business_entity_id) AS sales_person_key,
    sp.business_entity_id AS sales_person_id,
    TRIM(CONCAT(p.first_name, ' ', 
        ISNULL(p.middle_name + ' ', ''),
        p.last_name, ' ', 
        ISNULL(p.suffix, '')
    )) AS full_name,
    e.job_title
FROM silver.aw_sales_person AS sp
LEFT JOIN silver.aw_employee AS e
    ON sp.business_entity_id = e.business_entity_id
LEFT JOIN silver.aw_person AS p
    ON sp.business_entity_id = p.business_entity_id;
GO


    

-- Create Dimension: gold.dim_dates
IF OBJECT_ID('gold.dim_dates', 'U') IS NOT NULL
    DROP TABLE gold.dim_dates;
GO

CREATE TABLE gold.dim_dates (
    date_key INT PRIMARY KEY,
    full_date DATE,
    day TINYINT,
    month TINYINT,
    month_name VARCHAR(20),
    quarter TINYINT,
    year SMALLINT,
    day_of_week VARCHAR(20),
    week_of_year TINYINT
);
GO
WITH date_spine AS (
    SELECT CAST('2022-05-30' AS DATE) AS full_date
    UNION ALL
    SELECT DATEADD(DAY, 1, full_date)
    FROM date_spine
    WHERE full_date < '2025-06-29'
)
INSERT INTO gold.dim_dates (
    date_key,
    full_date,
    day,
    month,
    month_name,
    quarter,
    year,
    day_of_week,
    week_of_year
)
SELECT
    CONVERT(INT, FORMAT(full_date, 'yyyyMMdd')),
    full_date,
    DAY(full_date),
    MONTH(full_date),
    DATENAME(MONTH, full_date),
    DATEPART(QUARTER, full_date),
    YEAR(full_date),
    DATENAME(WEEKDAY, full_date),
    DATEPART(WEEK, full_date)
FROM date_spine
OPTION (MAXRECURSION 0);
GO



    
-- Create Dimension: gold.dim_territory
IF OBJECT_ID('gold.dim_territory', 'V') IS NOT NULL
    DROP VIEW gold.dim_territory;
GO
CREATE VIEW gold.dim_territory AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY territory_id) AS territory_key,
    territory_id,
    name,
    country_region_code,
    group_name
FROM silver.aw_sales_territory;
GO




-- Create Facts: gold.fact_sales
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS 
SELECT
    soh.sales_order_id,
    sod.sales_order_detail_id,
    CONVERT(INT, FORMAT(soh.order_date, 'yyyyMMdd')) AS date_key,
    c.customer_key,
    p.product_key,
    sp.sales_person_key,
    t.territory_key,    
    sod.order_qty AS  order_quantity,
    sod.unit_price,
    sod.unit_price_discount,
    sod.line_total AS sales_amount,
    p.standard_cost,
    p.standard_cost * sod.order_qty AS total_product_cost,
    (sod.line_total - (p.standard_cost * sod.order_qty)) AS gross_profit
FROM silver.aw_sales_order_header AS soh
LEFT JOIN silver.aw_sales_order_detail AS sod
    ON  soh.sales_order_id = sod.sales_order_id
LEFT JOIN gold.dim_customers AS c
    ON soh.customer_id = c.customer_id
LEFT JOIN gold.dim_products AS p
    ON sod.product_id = p.product_id
LEFT JOIN gold.dim_sales_persons AS sp
    ON soh.sales_person_id = sp.sales_person_id
LEFT JOIN gold.dim_territory AS t
    ON soh.territory_id = t.territory_id
GO
