**🏗️ Data Warehouse Architecture Overview**

**🌌 High-Level Architecture**

This project implements a modern Medallion Architecture on a SQL Server environment. 

The design prioritizes data integrity, reproducibility, and analytical performance. 

By separating the pipeline into three distinct layers, we ensure that raw data is preserved while end-users interact only with high-quality, modeled data.


**🌊 The Medallion Flow**

🥉 Bronze Layer (Raw Ingestion)

Purpose: Acts as the landing zone for raw extracts from CRM and ERP systems.

Strategy: Data is loaded "as-is" without any transformations to maintain a permanent historical record and allow for re-processing if business logic changes.

Loading Pattern: Truncate and Insert (Full Load) for current project scope.


🥈 Silver Layer (Cleansing & Integration)

Purpose: To transform raw data into a reliable, standardized format.

Key Transformations: * Data Standardizing: Normalizing gender codes and country names.

Deduplication: Removing redundant records to ensure a unique grain.

Null Handling: Applying default values to prevent calculation errors in downstream tools.


🥇 Gold Layer (Presentation & Modeling)

Purpose: To provide a business-ready interface for BI tools (Power BI/Tableau).

Design Choice (Views): The Gold layer is implemented using SQL Views rather than physical tables.

Why Views? They ensure that business logic is centralized and "live." Any update to the Silver layer is immediately reflected in the Gold layer without requiring an additional ETL step, reducing storage overhead and data latency.

**📐 Design Decisions**

1. Why the Star Schema?
   
I selected the Kimball Star Schema because it is the industry standard for analytical performance.

Simplicity: Reduces the number of JOINs required for BI tools, making queries faster and easier for non-technical users to understand.

Performance: SQL Server's optimizer is highly efficient at processing Star Schema structures, especially when filtering on dimensions and aggregating facts.

2. Why Surrogate Keys?
   
Instead of relying on natural keys from the source systems (like customer_id), I generated Surrogate Keys (e.g., customer_key) using ROW_NUMBER().

Source Independence: If the CRM system changes its ID format, our Data Warehouse remains stable.

Integration: It allows us to join data from CRM and ERP into a single row, even if they use different natural keys for the same customer.

**🛠️ Data Governance & Quality**

Architecture is nothing without trust. This pipeline includes:

Referential Integrity: Ensuring every sale in the fact_sales table maps to a valid record in dim_customers or dim_products.

Logic Validation: Automated checks to ensure that shipping_date never occurs before order_date.
