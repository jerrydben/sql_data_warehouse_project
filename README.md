**🚀 Sales Data Warehouse Project (SQL Server)**

Welcome to the Sales Data Warehouse Project.

I am Jeremiah Ogochukwu Ngiri, a Lead Business Intelligence Analyst. 

This repository demonstrates an end-to-end data engineering and analytics workflow—transforming raw, 

fragmented source data into business-ready analytical insights.


This project highlights my ability to design, build, and document a modern data warehouse using SQL Server,

with a rigorous focus on Data Quality, Dimensional Modeling, and Analytical Usability.

Whether you are a recruiter, data engineer, or analytics professional,

this repository is designed to showcase how I translate complex, multi-source data into actionable business intelligence.


<img width="1210" height="680" alt="Architecture Overview" src="https://github.com/user-attachments/assets/ebe3ee21-674c-43f5-9b39-3ecac3b94f45" />


________________________________________
**📌 Project Objective**


The primary goal of this project was to design and implement a centralized Sales Data Warehouse 

that consolidates data from two core operational systems:

•	CRM (Customer Relationship Management)

•	ERP (Enterprise Resource Planning)



By integrating these systems into a single analytical environment, 

the warehouse provides a Single Source of Truth for sales, customers, and products—enabling reliable reporting and strategic decision-making.

________________________________________
**🛠️ Technical Stack**

•	Data Sources: High-volume CSV extracts (CRM & ERP).

•	Database: SQL Server (T-SQL).

•	Data Engineering: Advanced SQL (CTEs, Window Functions, Complex Joins).

•	ETL / Data Preparation: SQL-based Medallion Pipeline.


________________________________________
**🔗 Data Integration Strategy**

To create a unified "Customer 360" view, I integrated data from two distinct source systems. 

This model illustrates the mapping logic used to resolve entity fragmentation.


<img width="1235" height="659" alt="Integration Model" src="https://github.com/user-attachments/assets/33943109-0cd9-4b38-aca5-86ef4f3733d5" />


•	Customer Integration: Combined CRM profiles with ERP demographic and location data using the cid / cst_key mapping.

•	Product Integration: Enriched CRM product records with ERP-managed categories and sub-categories.

•	Sales Mapping: Linked transactional sales details to core entities to establish fact-dimension relationships.


________________________________________
**🏛️ Modeling Approach: Star Schema (Kimball-style)**

To optimize the Gold Layer for analytical performance and ease of use, 

implemented a Star Schema following the Kimball dimensional modeling approach.


<img width="747" height="567" alt="ERD" src="https://github.com/user-attachments/assets/c0401ef4-6ff3-42b4-9b82-356e14c98bc7" />


•	Fact Table: gold.fact_sales — contains transactional metrics like sales amount and quantity, linked to dimensions via surrogate keys.

•	Dimension Tables: gold.dim_customers and gold.dim_products — provide descriptive attributes (SCD Type 1 logic) for granular slicing and dicing.


________________________________________
**🏗️ Data Architecture (Medallion Pattern)**

The warehouse follows a three-layer architecture to ensure data reliability and scalability:

•	🥉 Bronze Layer (Raw): Stores raw data as-is from source systems to preserve historical traceability.

•	🥈 Silver Layer (Cleaned): Performs cleansing, standardization, and deduplication. Handles NULL values and inconsistent formatting.

•	🥇 Gold Layer (Presentation): Implemented as SQL Views. Applies business logic, generates Surrogate Keys (using ROW_NUMBER()), and models data into the final Star Schema.


<img width="1373" height="710" alt="Medallion Architecture" src="https://github.com/user-attachments/assets/4cf60a3a-9960-443d-87b6-22dc6098d1d8" />


________________________________________

**🚀 Key Features & Transformations**

•	Customer 360: Unified fragmented profiles across crm_cust_info, erp_cust_az12, and erp_loc_a101.

•	Standardization: Implemented prioritized logic to normalize gender values and country codes across systems.

•	Surrogate Keys: Used ROW_NUMBER() within Gold views to ensure stable analytical relationships, independent of source system IDs.

•	Data Quality Gates: * Uniqueness: Zero duplicate records in dimensions.

o	Referential Integrity: 100% mapping between Fact and Dimension tables.

o	Business Rules: Validated logical flow (e.g., Shipping Date $\ge$ Order Date).

________________________________________
**📊 Business Impact**

•	Consolidated Reporting: Eliminated data silos between CRM and ERP systems.

•	Automated ETL: Reduced manual data preparation through a structured, repeatable SQL pipeline.

•	Decision Support: Delivered a reliable foundation for executive-level revenue, product, and customer performance analysis.

________________________________________
**🛠️ How to Run**

1. Prerequisites
    •	SQL Server Management Studio (SSMS) or Azure Data Studio.
    •	SQL Server Instance (Express or Developer edition).

2. Setup Instructions
        1.	Clone the Repository:
        Bash
        git clone https://github.com/jerrydben/sql_data_warehouse_project.git
        
        2.	Create the Database: Execute Scripts/init_database.sql to initialize the DataWarehouse database and schemas (bronze, silver, gold).
       
        3.	Run the Pipeline: Execute scripts in this order:
       
            o	bronze_load.sql
      	
            o	silver_transformation.sql
      	
            o	gold_views.sql

        4.	Verify Quality: Run Tests/gold_dq_checks.sql to confirm all quality gates pass.
________________________________________
**📫 Connect With Me**

•	LinkedIn: [Jeremiah Ngiri](https://www.google.com/search?q=https://www.linkedin.com/in/jeremiah-ngiri-7a279619a)

•	Email: jerrydben24@gmail.com

•	Location: Onitsha, Anambra State, Nigeria

