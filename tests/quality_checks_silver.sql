/*
===================================================================
crm_cust_info
===================================================================
*/

--Check for nulls and/or duplicates in the primary key
--Ideally we do not want nulls and/or duplicates
SELECT 
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 or cst_id IS NULL

--Check for unwanted spaces within the data
--Ideally we do not want any trailing or leading unwanted spaces
SELECT 
	cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

--Data standarization and consistency
SELECT DISTINCT 
	cst_gender
FROM silver.crm_cust_info

/*
===================================================================
crm_prd_info
===================================================================
*/

--Check for nulls and/or duplicates in the primary key
--Ideally we do not want nulls and/or duplicates
SELECT 
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 or prd_id IS NULL

--Check for unwanted spaces within the data
--Ideally we do not want any trailing or leading unwanted spaces
SELECT 
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--Check nulls or negative numbers
--Ideally there should be no nulls or negative numbers
SELECT 
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost is NULL

--Data standarization and consistency
SELECT DISTINCT 
	prd_line
FROM silver.crm_prd_info

--Check for invalid dates 
SELECT 
	*
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

/*
===================================================================
crm_sales_details
===================================================================
*/

--Check for invalid dates
SELECT
	sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 OR sls_order_dt > 20500101 OR sls_order_dt < 19000101

--Check for invalid date orders
SELECT 
	*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

--Check data consistensy between sales, quantinty and price 
--> Sales = quantity * price
--> Must not be NULL, zero or negative
SELECT DISTINCT 
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price
