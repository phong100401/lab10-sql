  
USE AdventureWorks2012

CREATE PROCEDURE Display_Customers
AS
SELECT CustomerID,AccountNumber,CustomerType,rowguid,ModifiedDate
from Sales.Customer

--ket qua: Command(s) completed successfully.

EXECUTE Display_Customers

--ket qua: hien thi du lieu cua bang Customer

EXECUTE xp_fileexist 'c:\myTest.txt'

EXECUTE sys.sp_who