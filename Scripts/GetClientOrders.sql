CREATE PROCEDURE sp_get_client_orders
    @id_customer INT,
    @page INT = 1,
    @size INT = 10
AS
BEGIN
    declare @count int =
    (SELECT
        COUNT(*)
    FROM Sales.Orders  o
    WHERE o.custid = @id_customer)
    SELECT
        o.orderid 'OrderId',
        o.requireddate 'RequiredDate',
        o.shippeddate 'ShippedDate',
        o.shipname 'ShipName',
        @count 'Count'
    FROM Sales.Orders  o
    WHERE o.custid = @id_customer
    ORDER BY o.orderid
    OFFSET (@page - 1) * @size  ROWS
    FETCH NEXT @size ROWS ONLY;
END