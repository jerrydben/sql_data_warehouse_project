/*******************************************************************************
⚠️ WARNING: DESTRUCTIVE ACTION
This procedure TRUNCATES all tables in the Bronze layer before loading.
Ensure backups exist if historical raw data is not preserved elsewhere.
*******************************************************************************/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    -- Declare variables for performance tracking
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME;
    
    SET @start_time = GETDATE();
    PRINT '==================================================================';
    PRINT 'LOADING THE BRONZE LAYER';
    PRINT '==================================================================';

    BEGIN TRY
        -- ==========================================================================
        -- CRM TABLES LOADING
        -- ==========================================================================
        PRINT '------------------------------------------------------------------';
        PRINT 'LOADING THE CRM TABLES';
        PRINT '------------------------------------------------------------------';

        -- Load crm_cust_info
        SET @batch_start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\USER\Desktop\MySQL with Baraa\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        PRINT '>> crm_cust_info loaded in ' + CAST(DATEDIFF(second, @batch_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -- Load crm_prd_info
        SET @batch_start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_prd_info;
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\USER\Desktop\MySQL with Baraa\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        PRINT '>> crm_prd_info loaded in ' + CAST(DATEDIFF(second, @batch_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -- Load crm_sales_details
        SET @batch_start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\USER\Desktop\MySQL with Baraa\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        PRINT '>> crm_sales_details loaded in ' + CAST(DATEDIFF(second, @batch_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -- ==========================================================================
        -- ERP TABLES LOADING
        -- ==========================================================================
        PRINT '------------------------------------------------------------------';
        PRINT 'LOADING THE ERP TABLES';
        PRINT '------------------------------------------------------------------';

        -- Load erp_cust_az12
        SET @batch_start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_cust_az12;
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\USER\Desktop\MySQL with Baraa\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        PRINT '>> erp_cust_az12 loaded in ' + CAST(DATEDIFF(second, @batch_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -- Load erp_loc_a101
        SET @batch_start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_loc_a101;
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\USER\Desktop\MySQL with Baraa\sql-data-warehouse-project\datasets\source_erp\LOC_A101.CSV'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        PRINT '>> erp_loc_a101 loaded in ' + CAST(DATEDIFF(second, @batch_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -- Load erp_px_cat_g1v2
        SET @batch_start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\USER\Desktop\MySQL with Baraa\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.CSV'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        PRINT '>> erp_px_cat_g1v2 loaded in ' + CAST(DATEDIFF(second, @batch_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        SET @end_time = GETDATE();
        PRINT '==================================================================';
        PRINT 'SUCCESS: BRONZE LAYER LOADED IN ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' SECONDS';
        PRINT '==================================================================';

    END TRY
    BEGIN CATCH
        PRINT '##################################################################';
        PRINT 'ERROR OCCURRED DURING BRONZE LAYER LOAD';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR);
        PRINT '##################################################################';
    END CATCH
END;
GO
