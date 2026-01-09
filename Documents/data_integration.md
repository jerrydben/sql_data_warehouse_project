<img width="996" height="526" alt="image" src="https://github.com/user-attachments/assets/8d63cf81-5c9e-48ba-8d3b-94addffceecd" />

The Data Integration Model illustrates the logical mapping and consolidation of fragmented 

data from two distinct source systems, CRM and ERP, into unified business entitiesThis model 

serves as the blueprint for resolving entity fragmentation during the transition from the Silver to

the Gold layer.

**Key Integration Components**

Customer 360 View:

-The model integrates CRM customer information (crm_cust_info) with ERP 

demographic data (erp_cust_az12 for birthdays) and geographic data

(erp_loc_a101 for country location).

-This consolidation is achieved by mapping the CRM cst_key to the ERP cid (Customer ID) to create a single, 
enriched customer profile.


**Product Master Enrichment:**

-Current and historical product information from the CRM (crm_prd_info) is enriched with hierarchical ERP 

product categories (erp_px_cat_g1v2).

-The link is established by joining the CRM cat_id with the ERP category id.

**Sales Transaction Mapping:**

-Transactional records from the CRM sales details (crm_sales_details) are linked to the unified Product

and Customer entities using their respective keys (prd_key and cst_id).

-This establishes the foundational Fact-Dimension relationships required for the final Star Schema.

**Technical Rationale**
By mapping these disparate sources, the architecture resolves inconsistencies between systems, 
such as varying country formats or disjointed customer attributes. This integration ensures that 
the final Gold Layer provides a "Single Source of Truth" where all sales transactions are fully 
contextualized by comprehensive customer and product metadata.
