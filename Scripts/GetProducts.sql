CREATE PROCEDURE sp_get_products
AS
BEGIN
    SELECT 
        productid 'ProductId',
        productname 'ProductName'
    FROM Production.Products
    ORDER BY productid
END

exec sp_get_products