# SQL Data Warehouse Project with AdventureWorks 🚀

Welcome to the **SQL Data Warehouse Project with AdventureWorks** repository!

This project demonstrates a comprehensive data warehousing solution built on the AdventureWorks dataset — from raw data ingestion to business-ready analytics. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

---

## Data Architecture

The data architecture follows the **Medallion Architecture** with Bronze, Silver, and Gold layers:
![Data Architecture](docs/data_architecture.png)
- **Bronze Layer:** Stores raw data as-is from the AdventureWorks source system. Data is ingested directly from the AdventureWorks database tables into SQL Server.
- **Silver Layer:** Includes data cleansing, standardization, and normalization processes to prepare data for analysis.
- **Gold Layer:** Contains a Sales Data Mart modeled using a Star Schema. The data mart consists of a central fact_sales table surrounded by dimension tables such as customers, products, dates, salespersons, and territories, providing a business-ready model optimized for sales reporting and analytical queries.

---

## Project Overview

This project involves:

- **Data Architecture:** Designing a Modern Data Warehouse using Medallion Architecture (Bronze, Silver, and Gold layers).
- **ETL Pipelines:** Extracting, transforming, and loading data from AdventureWorks source tables into the warehouse.
- **Data Modeling:** Developing fact and dimension tables optimized for analytical queries.
- **Analytics & Reporting:** Creating SQL-based reports and dashboards for actionable business insights.
---

## Important Links & Tools

Everything is Free!

- **Dataset:** [AdventureWorks Sample Database](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure) — Official Microsoft sample database.
- **SQL Server Express:** Lightweight server for hosting your SQL database.
- **SQL Server Management Studio (SSMS):** GUI for managing and interacting with databases.
- **Git Repository:** Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- **DrawIO:** Design data architecture, models, flows, and diagrams.
- **Notion:** For Project Planning

---

## Project Requirements

### Building the Data Warehouse (Data Engineering)

**Objective**

Develop a modern data warehouse using SQL Server to consolidate AdventureWorks sales data, enabling analytical reporting and informed decision-making.

**Specifications**

- **Data Source:** AdventureWorks database (Sales, Customer, Product, and Territory domains).
- **Data Quality:** Cleanse and resolve data quality issues prior to analysis.
- **Integration:** Consolidate all relevant source tables into a single, user-friendly data model designed for analytical queries.
- **Scope:** Focus on the latest dataset only; historization of data is not required.
- **Documentation:** Provide clear documentation of the data model to support both business stakeholders and analytics teams.

### BI: Analytics & Reporting (Data Analysis)

**Objective**

Develop SQL-based analytics to deliver detailed insights into:

- Customer Behavior
- Product Performance
- Sales Trends

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

---

## Repository Structure

```
sql-datawarehouse-project-with-adventureworks/
│
├── datasets/                        # Raw AdventureWorks source data (if applicable)
│
├── docs/                            # Project documentation and architecture details
│   ├── data_architecture.png        # Draw.io file showing the project's architecture
│   ├── data_catalog.md              # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.png                # Draw.io file for the data flow diagram
│   ├── data_models.png              # Draw.io file for data models (star schema)
│   ├── naming_conventions.md        # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                         # SQL scripts for ETL and transformations
│   ├── bronze/                      # Scripts for extracting and loading raw data
│   ├── silver/                      # Scripts for cleaning and transforming data
│   ├── gold/                        # Scripts for creating analytical models (star schema)
│
├── tests/                           # Test scripts and data quality checks
│   ├── silver_check/                # Scripts for validation and data quality checks
│   ├── gold_check/                  # Scripts for validation and data quality checks
│
├── README.md                        # Project overview and instructions
├── LICENSE                          # License information for the repository
├── .gitignore                       # Files and directories to be ignored by Git
└── requirements.txt                 # Dependencies and requirements for the project
```
