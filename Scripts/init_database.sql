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
