CREATE PROCEDURE sp_get_shippers
AS
BEGIN
    SELECT 
        shipperid 'ShipperId',
        companyname 'CompanyName'
    FROM Sales.Shippers
END