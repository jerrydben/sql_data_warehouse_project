/*
===============================================================================
DDL Script: Silver Layer Table Creation
Project: Sales Data Warehouse (CRM & ERP Integration)
Author: Jeremiah Ngiri
Description:
    This script defines the schema for the Silver Layer (Cleansed/Standardized).
    It establishes the structure for both CRM and ERP source system data.
===============================================================================
*/

USE DataWareHouse;
GO

-- Create Schema if not exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
    EXEC('CREATE SCHEMA silver');
GO

-- =============================================================================
-- 1. CRM SOURCE SYSTEM TABLES
-- =============================================================================
PRINT '>>> Creating CRM Tables...';

-- Customer Information (Cleansed)
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO
CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

-- Product Catalog (Standardized with SCD Type 2 fields)
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO
CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        DECIMAL(18, 4), -- Optimized from INT to handle currency
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Transactional Sales Details
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO
CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       DECIMAL(18, 4), -- Optimized from INT
    sls_quantity    INT,
    sls_price       DECIMAL(18, 4), -- Optimized from INT
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
-- 2. ERP SOURCE SYSTEM TABLES
-- =============================================================================
PRINT '>>> Creating ERP Tables...';

-- Supplemental Customer Data (Region AZ12)
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO
CREATE TABLE silver.erp_cust_az12 (
    cid             NVARCHAR(50),
    bdate           DATE,
    gen             NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Location and Country Mapping (Region A101)
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO
CREATE TABLE silver.erp_loc_a101 (
    cid             NVARCHAR(50),
    cntry           NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Product Category and Sub-category Mapping
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO
CREATE TABLE silver.erp_px_cat_g1v2 (
    id              NVARCHAR(50),
    cat             NVARCHAR(50),
    subcat          NVARCHAR(50),
    maintenance     NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

PRINT '---------------------------------------------------';
PRINT 'SUCCESS: All Silver Layer tables defined.';
PRINT '---------------------------------------------------';
