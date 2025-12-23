/*******************************************************************************
⚠️ WARNING: DESTRUCTIVE SCRIPT
Executing this script will DROP and RECREATE all tables in the [bronze] schema.
All existing data in these tables will be permanently deleted.
*******************************************************************************/

/*
Description:
    DDL script to initialize the Bronze layer tables. 
    The Bronze layer acts as a 'Landing Zone'—data is kept close to its 
    original source format to ensure full traceability.
*/

USE DataWareHouse;
GO

-- =============================================================================
-- CRM Tables
-- =============================================================================

-- 1. Customer Info
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE
);
GO

-- 2. Product Info
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     DECIMAL(18,2), -- Optimized: Changed from INT to DECIMAL for currency
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);
GO

-- 3. Sales Details
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT, -- Kept as INT to match common YYYYMMDD source formats
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    DECIMAL(18,2), -- Optimized: Changed from INT to DECIMAL
    sls_quantity      INT,           -- Renamed 'quantity' to 'qty' for brevity
    sls_price    DECIMAL(18,2)  -- Optimized: Changed from INT to DECIMAL
);
GO

-- =============================================================================
-- ERP Tables
-- =============================================================================

-- 4. ERP Customer (AZ12 System)
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
    cid   NVARCHAR(50),
    bdate DATE,
    gen   NVARCHAR(50)
);
GO

-- 5. ERP Location (A101 System)
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
    cid   NVARCHAR(50),
    cntry NVARCHAR(50)
);
GO

-- 6. ERP Product Category (G1V2 System)
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id          NVARCHAR(50),
    cat         NVARCHAR(50),
    subcat      NVARCHAR(50),
    maintenance NVARCHAR(50)
);
GO

PRINT '✅ All Bronze layer tables have been successfully recreated.';
