# sql_data_warehouse_project
Build a modern data warehouse with SQL Server including ETL process, data modelling and analytics
Welcome to the sql_data_warehouse_project 
Welcome to the central repository for the sql_data_warehouse_project data infrastructure! We are glad you're here.
This project is the "single source of truth" for our organization’s data. Our mission is to transform fragmented raw data into high-performance, actionable insights through a structured SQL Server environment. Whether you are a data analyst looking for schema definitions or a developer contributing to our ETL pipelines, this documentation is designed to get you up to speed quickly.
SQL Server Data Warehouse
A robust, scalable Data Warehouse solution built on SQL Server to provide centralized reporting and business intelligence for business
📌 Project Overview
This project implements a Star Schema architecture to consolidate data from [Source Systems, e.g., CRM, ERP, Flat Files]. It is designed to optimize query performance for analytical workloads and support historical data tracking through Slowly Changing Dimensions (SCD).

Key Features:
Architecture: Kimball Methodology (Star Schema).

Storage: SQL Server 2022 with Columnstore Indexing.

ETL Process: SSIS / T-SQL Stored Procedures / Azure Data Factory.

Data Quality: Automated validation checks for nulls and referential integrity.

🏗 Data Architecture
The warehouse follows a multi-layer staging approach to ensure data cleanlines:

Staging (STG): Raw data ingestion with minimal transformation.

Integration (INT): Data cleansing, de-duplication, and business rule application.

Presentation (DW): Final Fact and Dimension tables ready for BI tools (Power BI/Tableau).
