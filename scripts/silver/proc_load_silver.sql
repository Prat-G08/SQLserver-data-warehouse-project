INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gender,
	cst_create_date)

SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE UPPER(TRIM(cst_marital_status))
		WHEN 'S' THEN 'Single'
		WHEN 'M' THEN 'Married'
		ELSE 'n/a'
	END AS cst_marital_status,
	CASE UPPER(TRIM(cst_gender))
		WHEN 'F' THEN 'Female'
		WHEN 'M' THEN 'Male'
		ELSE 'n/a'
	END AS cst_gender,
	cst_create_date
FROM(
	SELECT 
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS data_time_rank
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL) sub
WHERE data_time_rank = 1


INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt)
SELECT 
	prd_id,
	REPLACE(SUBSTRING(TRIM(prd_key), 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(TRIM(prd_key))) AS prd_key,
	prd_nm,
	COALESCE(prd_cost, 0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(DATEADD(day, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info
