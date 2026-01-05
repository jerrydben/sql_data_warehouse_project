/*
===============================================================================
Database Initialization Script
Project: Sales Data Warehouse (CRM & ERP Integration)
Author: Jeremiah Ogochukwu Ngiri
Description: 
    This script initializes the core database and sets up the Medallion 
    Architecture (Bronze, Silver, Gold) schemas to facilitate the ETL process 
    and Star Schema modeling.
===============================================================================
WARNING:
    This script will drop and recreate the [DataWareHouse] database if it 
    already exists, which will result in the PERMANENT LOSS of all data 
    within the schemas. Use with extreme caution in non-development environments.
===============================================================================
*/

USE master;
GO

-- 1. Create the Database with an existence check
-- Professional practice: Adding a 'DROP' option for clean development resets
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DataWareHouse')
BEGIN
    PRINT 'Warning: [DataWareHouse] already exists. Dropping existing database for a fresh build...';
    ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWareHouse;
END
GO

CREATE DATABASE DataWareHouse;
GO

PRINT 'Database [DataWareHouse] created successfully.';
GO

USE DataWareHouse;
GO

-- 2. Define the Medallion Architecture Schemas
-- BRONZE: Raw data ingestion from ERP and CRM CSV files
CREATE SCHEMA bronze;
GO
PRINT 'Schema [bronze] created.';

-- SILVER: Cleansed and validated data (Data Quality layer)
CREATE SCHEMA silver;
GO
PRINT 'Schema [silver] created.';

-- GOLD: Finalized Star Schema for analytical reporting and DAX visualization
CREATE SCHEMA gold;
GO
PRINT 'Schema [gold] created.';

/* ===============================================================================
SUCCESS: Environment Setup Complete
Next Step: Execute the ETL scripts to populate the [bronze] layer.
===============================================================================
*/

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


/*
===============================================================================
Stored Procedure: Load Bronze Layer (ERP)
Author: Jeremiah Ogochukwu Ngiri
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_erp AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        PRINT '>> Ingesting ERP Data...';

        PRINT '   -> Loading: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\USER\Desktop\MySQL with Baraa\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        PRINT '   -> Loading: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\USER\Desktop\MySQL with Baraa\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        PRINT '   -> Loading: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\USER\Desktop\MySQL with Baraa\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        PRINT '>> ERP Ingestion Completed.';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR: ERP Ingestion failed.';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

/*
===============================================================================
Stored Procedure: Load Bronze Layer (CRM)
Author: Jeremiah Ogochukwu Ngiri
Description: 
    Bulk loads CRM data into Bronze tables. Truncates existing data to ensure 
    a clean ingestion for the Sales Data Warehouse.
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_crm AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        PRINT '>> Ingesting CRM Data...';

        PRINT '   -> Loading: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\USER\Desktop\MySQL with Baraa\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        PRINT '   -> Loading: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\USER\Desktop\MySQL with Baraa\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        PRINT '   -> Loading: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\USER\Desktop\MySQL with Baraa\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        PRINT '>> CRM Ingestion Completed.';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR: CRM Ingestion failed.';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO
