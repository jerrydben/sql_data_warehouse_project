/*******************************************************************************
Description:
    Initializes the 'DataWareHouse' environment. This script implements a 
    Medallion Architecture (Bronze/Silver/Gold) to separate data by 
    refinement level.


/*******************************************************************************
⚠️ WARNING: DESTRUCTIVE POTENTIAL
This script initializes the DataWareHouse environment. While it uses 
'IF NOT EXISTS' logic, always ensure you are connected to the correct 
Server/Instance before execution. Do not run this on Production without 
a verified backup.
*******************************************************************************/
Layers:
    - Bronze: Raw data ingestion, exactly as it appears in source.
    - Silver: Cleansed, standardized, and deduplicated data.
    - Gold:   Business-ready Dimensional Model (Fact & Dimension tables).
*******************************************************************************/

USE master;
GO

-- Create database if it does not already exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DataWareHouse')
BEGIN
    CREATE DATABASE DataWareHouse;
    PRINT 'Database [DataWareHouse] created successfully.';
END
ELSE
BEGIN
    PRINT 'Database [DataWareHouse] already exists.';
END
GO

USE DataWareHouse;
GO

-- 1. Bronze Schema: Landing zone for raw, unedited source data.
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
    PRINT 'Schema [bronze] created.';
END
GO

-- 2. Silver Schema: Transformed, validated, and enriched data.
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
    PRINT 'Schema [silver] created.';
END
GO

-- 3. Gold Schema: Final Star/Snowflake schema optimized for BI and Reporting.
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
    PRINT 'Schema [gold] created.';
END
GO
