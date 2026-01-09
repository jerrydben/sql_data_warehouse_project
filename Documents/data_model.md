**🏛️ Data Model Documentation: Star Schema**

**📋 Overview**

This data warehouse utilizes a Star Schema design, the industry standard for analytical performance and ease of use.

By separating quantitative data (Facts) from descriptive attributes (Dimensions), we ensure that BI tools like

Power BI or Excel can perform high-speed aggregations while providing rich filtering capabilities.

**🗺️ Entity Relationship Diagram (ERD) **

The following Mermaid diagram represents the logical schema of the Gold Layer:
erDiagram
    dim_customers ||--o{ fact_sales : "places"
    dim_products ||--o{ fact_sales : "contains"

    dim_customers {
        int customer_key PK
        int customer_id
        string customer_number
        string first_name
        string last_name
        string country
    }

    dim_products {
        int product_key PK
        int product_id
        string product_name
        string category
        decimal cost
    }

    fact_sales {
        int order_number
        int product_key FK
        int customer_key FK
        date order_date
        decimal sales_amount
        int quantity
    }

**📊 Fact Table: gold.fact_sales**
The Fact table is the heart of the schema, containing the quantitative metrics used for business analysis.

Grain: The grain of this table is one row per line item per sales order.

Foreign Keys: It contains customer_key and product_key to link to dimensions.

Metrics: Stores additive measures such as sales_amount, quantity, and price.

Business Logic: Includes calculated fields and validated dates (e.g., ensuring shipping dates are after order dates).

**🗂️ Dimension Tables**

Dimensions provide the "who, what, and where" context for the facts.

1. gold.dim_customers
   
Role: Provides a unified "Customer 360" view.

Integration: Merges CRM profile data with ERP-sourced demographic information (e.g., birthdate and location).

Primary Key: customer_key (Surrogate Key generated via ROW_NUMBER()).

2. gold.dim_products
   
Role: Acts as the master catalog for all items sold.

Attributes: Includes hierarchical data such as category and sub_category for granular reporting.

Maintenance: Implemented using SCD Type 1 logic, ensuring that the most current product information is always available for analysis.

**🔗 Relationship Summary**

| Parent View           | Child View         | Relationship Type | Join Key (Parent → Child)                                  | Description                                                     |
|-----------------------|--------------------|-------------------|-------------------------------------------------------------|-----------------------------------------------------------------|
| gold.dim_customers    | gold.fact_sales    | 1 : N (One-to-Many) | customer_key → customer_key                                 | One customer can place multiple sales orders over time.         |
| gold.dim_products     | gold.fact_sales    | 1 : N (One-to-Many) | product_key → product_key                                   | One product can be sold in many different sales transactions.   |


**🔗 Fact–Dimension Relationships**

| Parent View           | Child View         | Relationship Type | Join Key (Parent → Child)                                  | Description                                                     |
|-----------------------|--------------------|-------------------|-------------------------------------------------------------|-----------------------------------------------------------------|
| gold.dim_customers    | gold.fact_sales    | 1 : N (One-to-Many) | customer_key → customer_key                                 | One customer can place multiple sales orders over time.         |
| gold.dim_products     | gold.fact_sales    | 1 : N (One-to-Many) | product_key → product_key                                   | One product can be sold in many different sales transactions.   |


**🔍 Join Logic Reference (Business Keys → Surrogate Keys)**

| Fact Column            | Source Column (Fact) | Dimension Column | Purpose                                                   |
|------------------------|---------------------|------------------|-----------------------------------------------------------|
| product_key            | sls_prd_key         | product_number   | Resolves product surrogate key from business key.         |
| customer_key           | sls_cust_id         | customer_id      | Resolves customer surrogate key from CRM identifier.      |


**📌 Modeling Notes**

This model follows a Kimball-style Star Schema

gold.fact_sales is the central fact table

Dimensions use surrogate keys generated via ROW_NUMBER()

Relationships are logical, as Gold objects are implemented as SQL views

Referential integrity is ensured through controlled join logic and data quality checks

**🧠 Fact Table Grain**

One row per product, per customer, per sales order

This grain enables:

Accurate revenue aggregation

Product performance analysis

Customer behavior tracking over time
