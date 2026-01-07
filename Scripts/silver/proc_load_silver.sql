CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME = GETDATE();
    DECLARE @end_time DATETIME;

    BEGIN TRY
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

        -- 1. LOAD: silver.crm_cust_info
        PRINT '>>> Loading silver.crm_cust_info...';
        TRUNCATE TABLE silver.crm_cust_info;
        INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
        SELECT cst_id, cst_key, TRIM(cst_firstname), TRIM(cst_lastname),
            CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                 ELSE 'N/A' END,
            CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                 ELSE 'N/A' END,
            cst_create_date
        FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
            FROM bronze.crm_cust_info WHERE cst_id IS NOT NULL
        ) t WHERE flag_last = 1;

        -- 2. LOAD: silver.crm_prd_info
        PRINT '>>> Loading silver.crm_prd_info...';
        TRUNCATE TABLE silver.crm_prd_info;
        INSERT INTO silver.crm_prd_info (prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
        SELECT prd_id, 
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
            SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, 
            prd_nm, ISNULL(prd_cost, 0),
            CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                 WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                 WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                 ELSE 'N/A' END,
            CAST(prd_start_dt AS DATE),
            CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE)
        FROM bronze.crm_prd_info;

        -- 3. LOAD: silver.crm_sales_details
        PRINT '>>> Loading silver.crm_sales_details...';
        TRUNCATE TABLE silver.crm_sales_details;
        INSERT INTO silver.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
        SELECT sls_ord_num, sls_prd_key, sls_cust_id,
            CASE WHEN sls_order_dt <= 0 OR LEN(CAST(sls_order_dt AS VARCHAR)) != 8 THEN NULL ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) END,
            CASE WHEN sls_ship_dt <= 0 OR LEN(CAST(sls_ship_dt AS VARCHAR)) != 8 THEN NULL ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) END,
            CASE WHEN sls_due_dt <= 0 OR LEN(CAST(sls_due_dt AS VARCHAR)) != 8 THEN NULL ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) END,
            CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != (sls_quantity * sls_price) THEN ABS(sls_quantity * sls_price) ELSE sls_sales END,
            sls_quantity,
            CASE WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0) ELSE sls_price END
        FROM bronze.crm_sales_details;

        -- 4. LOAD: silver.erp_cust_az12
        PRINT '>>> Loading silver.erp_cust_az12...';
        TRUNCATE TABLE silver.erp_cust_az12;
        INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
        SELECT 
            CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) ELSE cid END,
            CASE WHEN bdate > GETDATE() THEN NULL ELSE bdate END,
            CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                 ELSE 'N/A' END
        FROM bronze.erp_cust_az12;

        -- 5. LOAD: silver.erp_loc_a101
        PRINT '>>> Loading silver.erp_loc_a101...';
        TRUNCATE TABLE silver.erp_loc_a101;
        INSERT INTO silver.erp_loc_a101 (cid, cntry)
        SELECT REPLACE(cid, '-', '') AS cid,
            CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
                 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
                 WHEN TRIM(cntry) IN ('NULL', '') OR cntry IS NULL THEN 'N/A'
                 ELSE TRIM(cntry) END
        FROM bronze.erp_loc_a101;

        -- 6. LOAD: silver.erp_px_cat_g1v2
        PRINT '>>> Loading silver.erp_px_cat_g1v2...';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;
        INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
        SELECT id, TRIM(cat), TRIM(subcat), TRIM(maintenance)
        FROM bronze.erp_px_cat_g1v2;

        SET @end_time = GETDATE();
        PRINT '------------------------------------------------';
        PRINT 'SUCCESS: Silver Layer loaded in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds.';
        PRINT '------------------------------------------------';

    END TRY
    BEGIN CATCH
        PRINT '================================================';
        PRINT 'ERROR OCCURRED DURING SILVER LOAD';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR);
        PRINT '================================================';
    END CATCH
END;
