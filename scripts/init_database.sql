/*
===================================================================
CREATING THE WAREHOUSE DATABASE
===================================================================
Script purpose:
This script creates a new database in SQL server called 
"DataWarehouse". The script also creates three schemas within the 
database: "bronze", "silver" and "gold"
*/

USE master;
GO 

--Create the 'DataWarehouse' database
CREATE DATABASE DateWarehouse;
GO

USE DataWarehouse;
GO

--Creating the schemas
CREATE SCHEMA bronze;
GO 

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
