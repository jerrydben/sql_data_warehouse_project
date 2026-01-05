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
