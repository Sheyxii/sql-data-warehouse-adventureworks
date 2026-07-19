# Data Catalog — Gold Layer

## Overview

The Gold Layer is the business-level data representation of the Sales Data Mart, structured as a **star schema** to support analytical and reporting use cases (Power BI, ad-hoc SQL analysis). It consists of five dimension tables/views and one fact view. Dimensions use `ROW_NUMBER()`-generated surrogate keys (except `dim_dates`, which uses a smart date key), decoupled from the natural/source system IDs.

**Source system:** AdventureWorks2025 (Sales, Production, Person, HumanResources schemas)
**Architecture:** Medallion (Bronze → Silver → Gold), Gold layer implemented as SQL views (except `dim_dates`, a physical table)

---

## 1. gold.dim_customers

**Type:** View   
**Purpose:** Stores customer identity information. A "customer" may be either an individual person or a reseller store, unified into a single dimension per AdventureWorks' business model.

| Column Name | Data Type | Description |
|---|---|---|
| `customer_key` | INT | Surrogate key uniquely identifying each customer record. Generated via `ROW_NUMBER()`, independent of the source system. |
| `customer_id` | INT | Natural key from the source system (`Sales.Customer.CustomerID`). Retained for traceability back to source. |
| `name` | NVARCHAR | The customer's display name. If the customer is a **Store**, this is the store's business name (`Sales.Store.Name`). If **Individual**, this is the concatenated full name (first + middle initial + last + suffix) from `Person.Person`. |
| `customer_type` | VARCHAR | Classifies the customer as `'Store'`, `'Individual'`, or `'Unknown'`. Determined by checking `store_id` first (since some records have both `person_id` and `store_id`, where `person_id` represents the store's contact person, not an individual buyer). |

**Data Quality Notes:**
- ~635 source rows have both `person_id` and `store_id` populated. These are Store customers where `person_id` refers to the store's primary contact, not a separate individual buyer. `store_id` takes classification priority over `person_id`.
- `middle_name` is inconsistently recorded in source data (some full names, some single initials) — normalized to a single initial + period (e.g., "E.") for consistency in the `name` field.

---

## 2. gold.dim_products

**Type:** View   
**Purpose:** Provides product attributes and category hierarchy for sellable products only.

| Column Name | Data Type | Description |
|---|---|---|
| `product_key` | INT | Surrogate key uniquely identifying each product record. Generated via `ROW_NUMBER()`. |
| `product_id` | INT | Natural key from source (`Production.Product.ProductID`). |
| `product_name` | NVARCHAR(50) | Descriptive name of the product (e.g., "Mountain-100 Silver, 38"). |
| `product_number` | NVARCHAR(25) | Structured alphanumeric SKU code (e.g., "BK-M82S-38"). |
| `color` | NVARCHAR(15) | Product color. NULL is valid — some products have no applicable color. |
| `size` | NVARCHAR(5) | Product size. Contains two different measurement conventions depending on product type: numeric frame sizes in cm (e.g., "58") for bikes/frames, and standard letter sizes (S, M, L, XL) for clothing. Not standardized, since the two conventions are not convertible. |
| `standard_cost` | MONEY | Manufacturing/acquisition cost of the product. |
| `list_price` | MONEY | Retail selling price of the product. |
| `subcategory` | NVARCHAR(50) | Product subcategory (e.g., "Road Frames", "Jerseys"). |
| `category` | NVARCHAR(50) | Top-level product category (e.g., "Bikes", "Components", "Clothing", "Accessories"). |

**Data Quality Notes:**
- Uses `INNER JOIN` to `dim_product_subcategory` and `dim_product_category`. This intentionally **excludes** ~209 raw materials/manufacturing components and sub-assemblies (e.g., "Bearing Ball", "Seat Assembly") that have `NULL` subcategory and were verified to have **zero** corresponding rows in `sales_order_detail` — i.e., items never sold directly to a customer.

---

## 3. gold.dim_sales_persons

**Type:** View   
**Purpose:** Stores sales representative identity and role information.

| Column Name | Data Type | Description |
|---|---|---|
| `sales_person_key` | INT | Surrogate key uniquely identifying each sales person record. Generated via `ROW_NUMBER()`. |
| `sales_person_id` | INT | Natural key from source (`Sales.SalesPerson.BusinessEntityID`). |
| `full_name` | NVARCHAR | Concatenated full name (first + middle initial + last + suffix), sourced from `Person.Person` via `HumanResources.Employee`. |
| `job_title` | NVARCHAR(50) | The employee's job title (e.g., "Sales Representative"). |

**Data Quality Notes:**
- Uses `LEFT JOIN` (not `INNER JOIN`) to `dim_employee`/`dim_person`, since orphan sales persons (missing employee/person records) have not been verified as safe to exclude. `full_name`/`job_title` may be NULL for such rows.

---

## 4. gold.dim_dates

**Type:** Physical Table (not a view — generated once via a recursive CTE date spine, not derived live from Silver)   
**Purpose:** Calendar reference table enabling time-based analysis (trends, period-over-period comparisons) — has no source table in AdventureWorks OLTP.

| Column Name | Data Type | Description |
|---|---|---|
| `date_key` | INT (PK) | Smart surrogate key in `YYYYMMDD` integer format (e.g., 20240615). Chosen over `ROW_NUMBER()` for human-readability and direct range filtering. |
| `full_date` | DATE | The actual calendar date. |
| `day` | TINYINT | Day of month (1–31). |
| `month` | TINYINT | Month number (1–12). |
| `month_name` | VARCHAR(20) | Full month name (e.g., "June"). |
| `quarter` | TINYINT | Calendar quarter (1–4). |
| `year` | SMALLINT | Calendar year. |
| `day_of_week` | VARCHAR(20) | Full weekday name (e.g., "Saturday"). |
| `week_of_year` | TINYINT | ISO week number within the year. |

**Data Quality Notes:**
- Date range spans the MIN/MAX `order_date` found in `silver.aw_sales_order_header` (2022-05-30 to 2025-06-29), not an arbitrarily wide range.
- Implemented as a physical table (not a view) since it does not change with each Silver reload and does not need recomputation via the recursive CTE on every query.

---

## 5. gold.dim_territory

**Type:** View   
**Purpose:** Stores sales territory/region attributes.

| Column Name | Data Type | Description |
|---|---|---|
| `territory_key` | INT | Surrogate key uniquely identifying each territory record. Generated via `ROW_NUMBER()`. |
| `territory_id` | INT | Natural key from source (`Sales.SalesTerritory.TerritoryID`). |
| `name` | NVARCHAR(50) | Territory name (e.g., "Northwest", "Canada", "Germany"). |
| `country_region_code` | NVARCHAR(3) | ISO 3166-1 alpha-2 country code (e.g., "US", "DE", "GB"). Codes are standard-compliant, not derived from English country names (e.g., "DE" = Deutschland, "GB" = Great Britain). |
| `group_name` | NVARCHAR(50) | Broader regional grouping (e.g., "North America", "Europe", "Pacific"). Source has only one grouping column — no separate "Region" tier exists. |

---

## 6. gold.fact_sales

**Type:** View   
**Grain:** One row per sales order line item (`sales_order_id` + `sales_order_detail_id`)
**Purpose:** Central transactional fact table for sales performance analysis.

| Column Name | Data Type | Description |
|---|---|---|
| `sales_order_id` | INT | Degenerate dimension — original order ID from source, retained for traceability/audit. Not a foreign key (no `dim_sales_order` exists). |
| `sales_order_detail_id` | INT | Degenerate dimension — original order line item ID from source. |
| `date_key` | INT | Foreign key → `gold.dim_dates.date_key`. Computed by converting `order_date` to `YYYYMMDD` integer format. |
| `customer_key` | INT | Foreign key → `gold.dim_customers.customer_key`. |
| `product_key` | INT | Foreign key → `gold.dim_products.product_key`. |
| `sales_person_key` | INT | Foreign key → `gold.dim_sales_persons.sales_person_key`. |
| `territory_key` | INT | Foreign key → `gold.dim_territory.territory_key`. |
| `order_quantity` | SMALLINT | Number of units ordered for the line item. |
| `unit_price` | MONEY | Price per unit at time of sale. |
| `unit_price_discount` | MONEY | Discount applied per unit. |
| `sales_amount` | MONEY | Total line item revenue (`line_total` from source). |
| `standard_cost` | MONEY | Unit manufacturing cost, sourced from `dim_products`. |
| `total_product_cost` | MONEY | **Calculated:** `order_quantity * standard_cost`. |
| `gross_profit` | MONEY | **Calculated:** `sales_amount - total_product_cost`. |

**Data Quality Notes:**
- Uses `LEFT JOIN` to all dimensions to avoid silently dropping fact rows if a dimension key is unmatched; any unmatched keys should be caught via orphan checks against each dimension before reporting.

---

## Relationship Summary

| Fact Column | Dimension | Dimension Key |
|---|---|---|
| `date_key` | `gold.dim_dates` | `date_key` |
| `customer_key` | `gold.dim_customers` | `customer_key` |
| `product_key` | `gold.dim_products` | `product_key` |
| `sales_person_key` | `gold.dim_sales_persons` | `sales_person_key` |
| `territory_key` | `gold.dim_territory` | `territory_key` |
