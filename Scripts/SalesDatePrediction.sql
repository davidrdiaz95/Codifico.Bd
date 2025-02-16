CREATE PROCEDURE sp_sales_date_prediction
    @page INT = 1,
    @size INT = 10,
    @search NVARCHAR(40) =''
AS
BEGIN
    DECLARE @Days_between_orders TABLE(
        custid INT,
        days_between_orders INT
    )

    DECLARE @Days_difference TABLE(
        custid INT,
        days_between_orders INT
    )

    INSERT INTO @Days_between_orders
    SELECT 
        custid,
        DATEDIFF(DAY, LAG(orderdate) OVER (PARTITION BY custid ORDER BY orderdate), orderdate)
    FROM Sales.Orders

    INSERT INTO @Days_difference
    SELECT 
        custid,
        SUM(days_between_orders) /COUNT(custid)
    FROM @Days_between_orders
    GROUP BY custid

    DECLARE @countOrder INT= (SELECT COUNT(*) FROM @Days_difference);
    SELECT 
        c.custid 'CustomerId',
        c.companyname 'CustomerName',
        MAX(o.orderdate)  'LastOrderDate',
        DATEADD(DAY, CAST(dp.days_between_orders AS INT), MAX(o.orderdate)) 'NextPredictedOrder',
        @countOrder 'Count'
    FROM Sales.Orders AS o
    INNER JOIN Sales.Customers AS c ON o.custid = c.custid
    INNER JOIN @Days_difference AS  dp ON o.custid = dp.custid
    WHERE c.companyname LIKE '%'+@search+'%'
    GROUP BY c.companyname, o.custid, dp.days_between_orders
    ORDER BY c.companyname
    OFFSET (@page - 1) * @size  ROWS
    FETCH NEXT @size ROWS ONLY; 
END