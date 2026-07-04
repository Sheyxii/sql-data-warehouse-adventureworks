/*
--------------------------------------------
DML Scripts: Load Bronze Tables
--------------------------------------------
Script Purpose:
    This script loads data into the bronze
    schema tables from the AdventureWorks2025
    source database. Truncates each table
    before loading (full reload).
---------------------------------------------
*/

-- ===== bronze.aw_customer =====
TRUNCATE TABLE bronze.aw_customer;
GO
INSERT INTO bronze.aw_customer (
    customer_id, person_id, store_id, territory_id,
    account_number, rowguid, modified_date
)
SELECT
    CustomerID, PersonID, StoreID, TerritoryID,
    AccountNumber, rowguid, ModifiedDate
FROM AdventureWorks2025.Sales.Customer;
GO


-- ===== bronze.aw_person =====
TRUNCATE TABLE bronze.aw_person;
GO
INSERT INTO bronze.aw_person (
    business_entity_id, person_type, name_style, title,
    first_name, middle_name, last_name, suffix,
    email_promotion, additional_contact_info, demographics,
    rowguid, modified_date
)
SELECT
    BusinessEntityID, PersonType, NameStyle, Title,
    FirstName, MiddleName, LastName, Suffix,
    EmailPromotion, AdditionalContactInfo, Demographics,
    rowguid, ModifiedDate
FROM AdventureWorks2025.Person.Person;
GO


-- ===== bronze.aw_product =====
TRUNCATE TABLE bronze.aw_product;
GO
INSERT INTO bronze.aw_product (
    product_id, name, product_number, make_flag, finished_goods_flag,
    color, safety_stock_level, reorder_point, standard_cost, list_price,
    size, size_unit_measure_code, weight_unit_measure_code, weight,
    days_to_manufacture, product_line, class, style,
    product_subcategory_id, product_model_id,
    sell_start_date, sell_end_date, discontinued_date,
    rowguid, modified_date
)
SELECT
    ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag,
    Color, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice,
    Size, SizeUnitMeasureCode, WeightUnitMeasureCode, Weight,
    DaysToManufacture, ProductLine, Class, Style,
    ProductSubcategoryID, ProductModelID,
    SellStartDate, SellEndDate, DiscontinuedDate,
    rowguid, ModifiedDate
FROM AdventureWorks2025.Production.Product;
GO


-- ===== bronze.aw_product_subcategory =====
TRUNCATE TABLE bronze.aw_product_subcategory;
GO
INSERT INTO bronze.aw_product_subcategory (
    product_subcategory_id, product_category_id, name,
    rowguid, modified_date
)
SELECT
    ProductSubcategoryID, ProductCategoryID, Name,
    rowguid, ModifiedDate
FROM AdventureWorks2025.Production.ProductSubcategory;
GO


-- ===== bronze.aw_product_category =====
TRUNCATE TABLE bronze.aw_product_category;
GO
INSERT INTO bronze.aw_product_category (
    product_category_id, name, rowguid, modified_date
)
SELECT
    ProductCategoryID, Name, rowguid, ModifiedDate
FROM AdventureWorks2025.Production.ProductCategory;
GO


-- ===== bronze.aw_sales_territory =====
TRUNCATE TABLE bronze.aw_sales_territory;
GO
INSERT INTO bronze.aw_sales_territory (
    territory_id, name, country_region_code, group_name,
    sales_ytd, sales_last_year, cost_ytd, cost_last_year,
    rowguid, modified_date
)
SELECT
    TerritoryID, Name, CountryRegionCode, [Group],
    SalesYTD, SalesLastYear, CostYTD, CostLastYear,
    rowguid, ModifiedDate
FROM AdventureWorks2025.Sales.SalesTerritory;
GO


-- ===== bronze.aw_sales_person =====
TRUNCATE TABLE bronze.aw_sales_person;
GO
INSERT INTO bronze.aw_sales_person (
    business_entity_id, territory_id, sales_quota, bonus,
    commission_pct, sales_ytd, sales_last_year,
    rowguid, modified_date
)
SELECT
    BusinessEntityID, TerritoryID, SalesQuota, Bonus,
    CommissionPct, SalesYTD, SalesLastYear,
    rowguid, ModifiedDate
FROM AdventureWorks2025.Sales.SalesPerson;
GO


-- ===== bronze.aw_employee =====
TRUNCATE TABLE bronze.aw_employee;
GO
INSERT INTO bronze.aw_employee (
    business_entity_id, national_id_number, login_id,
    organization_node, organization_level, job_title,
    birth_date, marital_status, gender, hire_date,
    salaried_flag, vacation_hours, sick_leave_hours, current_flag,
    rowguid, modified_date
)
SELECT
    BusinessEntityID, NationalIDNumber, LoginID,
    OrganizationNode, OrganizationLevel, JobTitle,
    BirthDate, MaritalStatus, Gender, HireDate,
    SalariedFlag, VacationHours, SickLeaveHours, CurrentFlag,
    rowguid, ModifiedDate
FROM AdventureWorks2025.HumanResources.Employee;
GO


-- ===== bronze.aw_sales_order_header =====
TRUNCATE TABLE bronze.aw_sales_order_header;
GO
INSERT INTO bronze.aw_sales_order_header (
    sales_order_id, revision_number, order_date, due_date, ship_date,
    status, online_order_flag, sales_order_number, purchase_order_number,
    account_number, customer_id, sales_person_id, territory_id,
    bill_to_address_id, ship_to_address_id, ship_method_id,
    credit_card_id, credit_card_approv_code, currency_rate_id,
    sub_total, tax_amt, freight, total_due, comment, rowguid, modified_date
)
SELECT
    SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate,
    Status, OnlineOrderFlag, SalesOrderNumber, PurchaseOrderNumber,
    AccountNumber, CustomerID, SalesPersonID, TerritoryID,
    BillToAddressID, ShipToAddressID, ShipMethodID,
    CreditCardID, CreditCardApprovalCode, CurrencyRateID,
    SubTotal, TaxAmt, Freight, TotalDue, Comment, rowguid, ModifiedDate
FROM AdventureWorks2025.Sales.SalesOrderHeader;
GO
