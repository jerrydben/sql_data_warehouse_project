
<img width="951" height="521" alt="image" src="https://github.com/user-attachments/assets/16ad7a74-2571-40a9-8114-201c16728313" />


This **Data Flow Diagram** illustrates the end-to-end lineage of the data as it moves from source 

extraction to final analytical modeling. 

It tracks how raw datasets from fragmented systems are transformed and unified through the 

**Medallion Architecture**.

 **Lineage & Transformation Stages**

 **Sources (Raw Data):** The pipeline begins with flat-file extracts (CSVs)
 
from two primary operational systems: **CRM** and **ERP**.

 **Bronze Layer (Raw Tables):** Data is loaded into SQL Server "as-is" to preserve
 
 the original state of the records.
 This layer contains six primary tables, including sales details, customer info, and product metadata.
 
 **Silver Layer (Cleaned & Standardized):** In this stage, data undergoes cleansing and standardization.
 
  Note that while the data structure remains similar to Bronze,
  
  this is where inconsistent identifiers are resolved and data quality is enforced.
  
 **Gold Layer (Analytical Modeling):** The final stage consolidates the cleaned tables into a high-performance

  **Star Schema**.
`crm_sales_details` feeds directly into the `fact_sales` table.

 `crm_cust_info`, `erp_cust_az12`, and `erp_loc_a101` are integrated to form the unified `dim_customers` dimension.
 
 `crm_prd_info` and `erp_px_cat_giv2` are merged to create the enriched `dim_products` dimension.



### **Architectural Significance**

This flow ensures a clear separation of concerns. By mapping multiple Silver tables into single Gold dimensions,

the architecture hides the complexity of the underlying source systems from the end-user, 
providing a simplified and reliable interface for business intelligence.
