--Check for nulls and/or duplicates in the primary key
--Ideally we do not want nulls and/or duplicates
SELECT 
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 or cst_id IS NULL

--Check for unwanted spaces within the data(check each column seperately)
--Ideally we do not want any trailing or leading unwanted spaces
SELECT 
	cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

--Data standarization and consistency(check for gender and marital columns)
SELECT DISTINCT 
	cst_gender
FROM silver.crm_cust_info
