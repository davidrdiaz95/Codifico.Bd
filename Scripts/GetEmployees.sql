CREATE PROCEDURE sp_get_employees
AS
BEGIN
    SELECT
        empid 'EmpId',
        CONCAT(lastname,' ',firstname) 'Name'
    FROM hr.Employees
END