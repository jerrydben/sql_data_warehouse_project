/*
===============================================================================
DDL Script: Bronze Layer Table Creation
Project: Sales Data Warehouse (CRM & ERP Integration)
Description: 
    This script defines the schema for the Bronze layer. These tables are 
    designed to store raw data exactly as it arrives from the CRM and ERP 
    source systems (CSV format).
===============================================================================
*/

USE DataWareHouse;
GO

-- =============================================================================
-- 1. CRM SOURCE SYSTEM TABLES
-- =============================================================================

PRINT '>>> Creating CRM Tables...';

-- Customer Information from CRM
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO
CREATE TABLE bronze.crm_cust_info (
    cst_id               INT,
    cst_key              NVARCHAR(50),
    cst_firstname        NVARCHAR(50),
    cst_lastname         NVARCHAR(50),
    cst_marital_status   NVARCHAR(50),
    cst_gndr             NVARCHAR(50),	
    cst_create_date      DATE
);
GO

-- Product Catalog from CRM
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO
CREATE TABLE bronze.crm_prd_info (
    prd_id               INT,	
    prd_key              NVARCHAR(50),
    prd_nm               NVARCHAR(50),
    prd_cost             INT,
    prd_line             NVARCHAR(50),
    prd_start_dt         DATETIME,
    prd_end_dt           DATETIME
);
GO

-- Transactional Sales Details from CRM
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num          NVARCHAR(50),
    sls_prd_key          NVARCHAR(50),
    sls_cust_id          INT,
    sls_order_dt         INT,
    sls_ship_dt          INT,
    sls_due_dt           INT,
    sls_sales            INT,
    sls_quantity         INT,
    sls_price            INT
);
GO

-- =============================================================================
-- 2. ERP SOURCE SYSTEM TABLES
-- =============================================================================

PRINT '>>> Creating ERP Tables...';

-- Supplemental Customer Data from ERP (Region AZ12)
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO
CREATE TABLE bronze.erp_cust_az12 (
    cid                  NVARCHAR(50),
    bdate                DATE,	
    gen                  NVARCHAR(50)
);
GO

-- Location and Country Mapping from ERP (Region A101)
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO
CREATE TABLE bronze.erp_loc_a101 (
    cid                  NVARCHAR(50),	
    cntry                NVARCHAR(50)
);
GO

-- Product Category and Sub-category Mapping from ERP
IF OBJECT_ID('bronze.erp_PX_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id                   NVARCHAR(50),
    cat                  NVARCHAR(50),
    subcat               NVARCHAR(50),
    maintenance          NVARCHAR(50)
);
GO

PRINT '---------------------------------------------------';
PRINT 'SUCCESS: All Bronze Layer tables created.';
PRINT 'Next Step: Bulk load CSV data into these tables.';
PRINT '---------------------------------------------------';


