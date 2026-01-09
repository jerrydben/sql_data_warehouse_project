**📊 Data Catalogue – Gold Layer (SQL Views)
Project: Sales Data Warehouse (CRM & ERP Integration)**

Author: Jeremiah Ngiri
Layer Type: Gold (Business Presentation Layer)
Object Type: SQL Views
Schema: gold

**🏗 Gold Layer Overview**
The Gold layer consists of curated SQL views designed for analytics and reporting.
**These views:**
-Integrate CRM and ERP data

-Apply business rules and validation

-Generate surrogate keys

-Handle SCD logic where applicable

-Present clean, analysis-ready datasets

**📘 View: gold.dim_customers**

**🔹 View Purpose:**
Provides a consolidated and standardized customer dimension by combining CRM and ERP customer data.

**🔹 Grain:**
One row per unique customer

🔹 Surrogate Key
customer_key – generated using ROW_NUMBER()

🔹 Business Logic Highlights

-Gender prioritizes CRM, falls back to ERP, defaults to N/A

-Customer location and birthdate are enriched from ERP sources

-All attributes are standardized for reporting consistency

**🔹 Data Dictionary**
| Column Name     | Data Type     | Description                                                                 |
|-----------------|--------------|-----------------------------------------------------------------------------|
| customer_key    | INT          | Surrogate key uniquely identifying each customer (generated in view).      |
| customer_id     | INT          | Original customer ID from the CRM system (`cst_id`).                        |
| customer_number | NVARCHAR     | ERP customer identifier (`cid`) used for system integration.               |
| first_name      | NVARCHAR     | Customer first name from CRM.                                               |
| last_name       | NVARCHAR     | Customer last name from CRM.                                                |
| country         | NVARCHAR     | Customer country enriched from ERP location data.                          |
| marital_status  | NVARCHAR     | Customer marital status from CRM.                                          |
| gender          | NVARCHAR     | Standardized gender (CRM preferred, ERP fallback, default `N/A`).          |
| birthdate       | DATE         | Customer birth date sourced from ERP.                                      |
| create_date     | DATE         | Customer record creation date in CRM.                                     |


**📘 View: gold.dim_products**

**🔹 View Purpose:**
Provides the current, active version of products with standardized categorization.

**🔹 Grain:**
One row per active product

**🔹 Surrogate Key:**
product_key – generated using ROW_NUMBER()

**🔹 Business Logic Highlights:**

-Filters only active products (prd_end_dt IS NULL)

-Enriches products with ERP category and subcategory data

-Supports Slowly Changing Dimension (SCD Type 2 source logic)

**🔹 Data Dictionary**
| Column Name     | Data Type     | Description                                                                 |
|-----------------|--------------|-----------------------------------------------------------------------------|
| product_key     | INT          | Surrogate key uniquely identifying each product (generated in view).       |
| product_id      | INT          | Internal product ID from CRM.                                              |
| product_number  | NVARCHAR     | Business product key used across systems.                                 |
| product_name    | NVARCHAR     | Descriptive name of the product.                                          |
| category_id     | INT          | Category identifier from ERP.                                             |
| category        | NVARCHAR     | High-level product category.                                              |
| subcategory     | NVARCHAR     | Detailed product subcategory.                                             |
| maintenance     | NVARCHAR     | Maintenance classification from ERP.                                     |
| cost            | DECIMAL      | Standard cost of the product.                                             |
| product_line    | NVARCHAR     | Product line (e.g., Mountain, Road, Touring).                             |
| start_date      | DATE         | Product version start date (SCD tracking).                               |



**📙 View: gold.fact_sales**

**🔹 View Purpose:**
Stores transactional sales metrics enriched with surrogate keys from Gold dimensions.

**🔹 Grai:n**
One row per product, per customer, per sales order

**🔹 Join Logic:**

-Joins to gold.dim_products using product business key

-Joins to gold.dim_customers using CRM customer ID

-Ensures consistent surrogate key usage for analytics


**🔹 Data Dictionary**
| Column Name     | Data Type     | Description                                                                 |
|-----------------|--------------|-----------------------------------------------------------------------------|
| order_number    | NVARCHAR     | Unique identifier for the sales order.                                     |
| product_key     | INT          | Surrogate key linking to `gold.dim_products`.                              |
| customer_key    | INT          | Surrogate key linking to `gold.dim_customers`.                             |
| order_date      | DATE         | Date the sales transaction occurred.                                      |
| shipping_date   | DATE         | Date the product was shipped.                                             |
| due_date        | DATE         | Payment due date for the order.                                           |
| sales_amount    | DECIMAL      | Total sales value for the transaction.                                    |
| quantity        | INT          | Number of units sold.                                                     |
| price           | DECIMAL      | Unit price at time of sale.                                               |

**🧠 Architectural Notes:**
Gold layer objects are views, not physical tables

**Designed for:**

-BI tools (Power BI, Tableau, Looker)

-SQL analytics

-Business reporting

**Follows Kimball dimensional modeling principle**
**Surrogate keys generated dynamically for analytical consistency**

**📌 Intended Audience**

-Data Analysts

-BI Developers

-Data Engineers

-Recruiters & Technical Reviewers
