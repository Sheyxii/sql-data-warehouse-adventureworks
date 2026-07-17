/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema. Existing tables are
    dropped before being recreated to ensure the latest table definitions
    are applied.

Usage:
    Run this script to re-create the structure of the Silver layer tables.
===============================================================================
*/


IF OBJECT_ID('silver.aw_customer', 'U') IS NOT NULL
    DROP TABLE silver.aw_customer;
GO
CREATE TABLE silver.aw_customer (
    customer_id     INT,
    person_id       INT,
    store_id        INT,
    territory_id    INT,
    dw_create_date  DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.aw_person', 'U') IS NOT NULL
    DROP TABLE silver.aw_person
GO
CREATE TABLE silver.aw_person (
    business_entity_id          INT,
    first_name                  NVARCHAR(50),
    middle_name                 NVARCHAR(50),
    last_name                   NVARCHAR(50),
    suffix                      NVARCHAR(10),
    dw_create_date              DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.aw_product', 'U') IS NOT NULL
    DROP TABLE silver.aw_product
GO

CREATE TABLE silver.aw_product (
    product_id                 INT,
    name                       NVARCHAR(50),
    product_number             NVARCHAR(25),
    color                      NVARCHAR(15),
    standard_cost              MONEY,
    list_price                 MONEY,
    size                       NVARCHAR(5),
    product_subcategory_id     INT,
    dw_create_date             DATETIME2 DEFAULT GETDATE()
);
GO



IF OBJECT_ID('silver.aw_product_subcategory', 'U') IS NOT NULL
    DROP TABLE silver.aw_product_subcategory
GO

CREATE TABLE silver.aw_product_subcategory (
    product_subcategory_id     INT,
    product_category_id        INT,
    name                       NVARCHAR(50),
    dw_create_date             DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.aw_product_category', 'U') IS NOT NULL
    DROP TABLE silver.aw_product_category
GO

CREATE TABLE silver.aw_product_category (
    product_category_id        INT,
    name                       NVARCHAR(50),
    dw_create_date             DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.aw_sales_territory', 'U') IS NOT NULL
    DROP TABLE silver.aw_sales_territory
GO

CREATE TABLE silver.aw_sales_territory (
    territory_id               INT,
    name                       NVARCHAR(50),
    country_region_code        NVARCHAR(3),
    group_name                 NVARCHAR(50),
    dw_create_date             DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.aw_sales_person', 'U') IS NOT NULL
    DROP TABLE silver.aw_sales_person
GO

CREATE TABLE silver.aw_sales_person (
    business_entity_id         INT,
    territory_id               INT,
    dw_create_date             DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.aw_employee', 'U') IS NOT NULL
    DROP TABLE silver.aw_employee
GO

CREATE TABLE silver.aw_employee (
    business_entity_id         INT,
    job_title                  NVARCHAR(50),
    dw_create_date             DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.aw_sales_order_header', 'U') IS NOT NULL
    DROP TABLE silver.aw_sales_order_header
GO

CREATE TABLE silver.aw_sales_order_header (
    sales_order_id           INT,
    order_date               DATE,
    customer_id              INT,
    sales_person_id          INT,
    territory_id             INT,
    dw_create_date           DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.aw_sales_order_detail', 'U') IS NOT NULL
    DROP TABLE silver.aw_sales_order_detail;
GO

CREATE TABLE silver.aw_sales_order_detail (
    sales_order_id            INT,
    sales_order_detail_id     INT,
    order_qty                 SMALLINT,
    product_id                INT,
    unit_price                MONEY,
    unit_price_discount       MONEY,
    line_total                MONEY,
    dw_create_date            DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.aw_store', 'U') IS NOT NULL
    DROP TABLE silver.aw_store;
GO

CREATE TABLE silver.aw_store (
    business_entity_id     INT,
    name                   NVARCHAR(50),
    sales_person_id        INT,
    dw_create_date         DATETIME2 DEFAULT GETDATE()
);
GO
