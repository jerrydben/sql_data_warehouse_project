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
