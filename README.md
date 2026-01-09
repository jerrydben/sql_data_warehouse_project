**🚀 Sales Data Warehouse Project (SQL Server)**

Welcome to the Sales Data Warehouse Project.
I’m Jeremiah Ogochukwu Ngiri, a Lead Business Intelligence Analyst, and this repository demonstrates an end-to-end data engineering and analytics workflow—from raw source data to business-ready analytical views.

This project highlights my ability to design, build, and document a modern data warehouse using SQL Server, with a strong focus on data quality, dimensional modeling, and analytical usability.

Whether you’re a recruiter, data engineer, or analytics professional, this repository is intended to clearly show how I translate complex, multi-source data into actionable business insight.

**📌 Project Objective**

The primary goal of this project was to design and implement a centralized Sales Data Warehouse that consolidates data from two core operational systems:

CRM (Customer Relationship Management)

ERP (Enterprise Resource Planning)

By integrating these systems into a single analytical environment, the warehouse provides a single source of truth for sales, customers, and products—enabling reliable reporting and strategic decision-making.

**🛠️ Technical Stack**

**Data Sources**

High-volume CSV extracts from CRM and ERP systems

**Technologies & Tools**

**Database: SQL Server**

**Data Engineering: Advanced SQL (CTEs, Window Functions, Joins)**
**ETL / Data Preparation: Power Query**

**Modeling Approach: Star Schema (Kimball-style)**

**🏗️ Data Engineering Workflow**

1️⃣ Data Quality & Cleansing

Before integration, extensive data preparation was performed to ensure analytical reliability:

Resolved data quality issues across CRM and ERP sources

Standardized attributes (e.g., gender, country)

Handled NULL values, duplicates, and inconsistent identifiers

Validated financial and sales transaction accuracy

2️⃣ Integration & Modeling

Cleaned datasets were integrated into a high-performance analytical model:

Architecture: Star Schema optimized for BI queries

Fact Table: Centralized sales transactions

Dimensions: Customer and product attributes

Analytics: SQL Window Functions used to support trend and performance analysis

Scope: Focused on current and relevant records for actionable insights

🏗️ Data Architecture (Medallion Pattern)

The warehouse follows a three-layer architecture to ensure data reliability, scalability, and clarity:

**🥉 Bronze Layer (Raw)**

-Stores raw data as-is from source systems

-Preserves historical records for traceability

**🥈 Silver Layer (Cleaned)**

-Performs cleansing, standardization, and deduplication

-Handles data quality issues (NULLs, inconsistent codes)

-Prepares data for analytical modeling

**🥇 Gold Layer (Presentation)**

-Implemented as SQL Views

-Applies business logic and generates surrogate keys

-Models data into a Star Schema for reporting and BI tools

**🚀 Key Features & Transformations**

🔹 Data Integration (Customer 360)

Unified customer profiles by joining:

crm_cust_info

erp_cust_az12

erp_loc_a101

**Implemented prioritized logic to standardize gender values across systems**

**🔹 Data Modeling (Star Schema)**

Fact Table

gold.fact_sales — centralized sales transactions

**Dimension Tables**

gold.dim_customers

gold.dim_products

**Surrogate Keys**

-Generated using ROW_NUMBER() within Gold views

-Ensures stable analytical relationships across dimensions

**🔹 Data Quality & Validation**

Robust validation rules were applied at the Gold layer to ensure trust in analytics:

Uniqueness: No duplicate customers or products

Referential Integrity: All sales records map to valid customers and products

Business Rules: Shipping dates cannot precede order dates

**📂 Documentation & Deliverables**

Data Catalogue: Column-level documentation for all Gold views

SQL Scripts: Optimized transformation logic

Architecture Documentation: Clear explanation of layers and modeling decisions

Validation Notes: Summary of data quality checks and resolutions

**📊 Business Impact**

Consolidated Reporting: Eliminated data silos between CRM and ERP systems

Performance Tracking: Enabled revenue, product, and customer performance analysis

Automation: Reduced manual data preparation through structured ETL workflows

Decision Support: Delivered a reliable foundation for executive-level reporting



linkedin: https://www.linkedin.com/in/jeremiah-ngiri-7a279619a?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_view_base_contact_details%3BfHfXhsbtQrSIlFZZ0I1NqQ%3D%3D


<img width="1429" height="790" alt="image" src="https://github.com/user-attachments/assets/15db3e20-db29-4ca1-9e63-5ff3ee392a7b" />


**🛠️ How to Run**
Follow these steps to replicate the environment and set up the Data Warehouse on your local machine.

**1. Prerequisites**
SQL Server Management Studio (SSMS) or Azure Data Studio.

SQL Server Instance (Express or Developer edition).

2. Setup Instructions
    1. Clone the Repository:

Bash

https://github.com/jerrydben/sql_data_warehouse_project.git

    2. Create the Database: Open the Scripts/init_database.sql 
script in SSMS and execute it to create the DataWarehouse database and the bronze, silver, and gold schemas.

    3. Run the Pipeline: Execute the scripts in the following order:

-Bronze: Run bronze_load.sql to import raw data.

-Silver: Run silver_transformation.sql to clean and standardize the data.

-Gold: Run gold_views.sql to create the final analytical Star Schema.

    4. Verify Data Quality: Run Tests/gold_dq_checks.sql to confirm that all quality gates pass and the data is consistent.

**3. Usage**
Once the scripts have finished running, you can connect your preferred BI tool (Power BI, Tableau, or Excel) to the Gold Views for reporting.

**📫 Connect With Me**

If you’d like to discuss this project or explore collaboration opportunities in Data Engineering or Business Intelligence, feel free to reach out:

Email: jerrydben24@gmail.com

Location: Onitsha, Anambra State, Nigeria

phone: +2347033485535
