CREATE PROCEDURE sp_add_new_order
    @custid INT,
    @empid INT,
    @shipperid INT,
    @shipname NVARCHAR(40),
    @shipaddress NVARCHAR(60),
    @shipcity NVARCHAR(15),
    @orderdate DATETIME,
    @requireddate DATETIME,
    @shippeddate DATETIME,
    @freight MONEY,
    @shipcountry NVARCHAR(15),
    @productid INT,
    @unitprice MONEY,
    @qty SMALLINT,
    @discount NUMERIC(4,3)
AS
BEGIN TRY
    BEGIN TRANSACTION
        INSERT INTO Sales.Orders(custid,empid,shipperid,shipname,shipaddress,shipcity,orderdate,requireddate,shippeddate,freight,shipcountry)
        VALUES(@custid,@empid,@shipperid,@shipname, @shipaddress,@shipcity,@orderdate,@requireddate,@shippeddate,@freight,@shipcountry)

        INSERT INTO Sales.OrderDetails(orderid,productid,unitprice,qty,discount)
        VALUES( (SELECT @@IDENTITY),@productid,@unitprice,@qty,@discount)
    COMMIT TRANSACTION;
END TRY
BEGIN  CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage
    ROLLBACK TRANSACTION
END CATCH

