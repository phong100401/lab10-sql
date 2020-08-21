﻿USE AdventureWorks2012
GO
/*** MODULE 7 ***/
--tạo một thủ tục lưu trữ lấy r toàn bộ nhân viên vào làm theo năm có tham số đầu vào là một năm
CREATE PROCEDURE sp_DisplayEmployeesHireYear
	@HireYear int
AS
SELECT * FROM HumanResources.Employee
WHERE DATEPART(YY,HireDate)=@HireYear
GO
--để chạy thủ tục này cần phải truyền tham số vào là năm mà nhân viên vào làm
EXECUTE sp_DisplayEmployeesHireYear 1999
GO
--tạo thủ tục lưu trữ đếm số ng vào làm trog một năm xác định có tham số đầu vào là 1nam,tham số đầu ra là số ng vào làm trong năm
CREATE PROCEDURE sp_EmployeesHireYearCount
	@HireYear int,
	@Count int OUTPUT
AS
SELECT @Count=COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY,HireDate)=@HireYear
GO
--Chạy thủ tục lưu trữ cần phải truyền vào 1tham số đầu vào và 1tham số đầu ra

DECLARE @Number int
EXECUTE sp_EmployeesHireYearCount 1999,@Number OUTPUT
PRINT @Number
GO

--tạo thủ tục lưu trữ đếm số ng vào làm trog 1nam xác định có tham số đầu vào là 1nam,hàm trả về số ng vào làm năm đó
CREATE PROCEDURE sp_EmployeesHireYearCount2 
	@HireYear int
AS
DECLARE @Count int
SELECT @Count=COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY,HireDate)=@HireYear
RETURN @Count
GO
--chạy thủ tục lưu trữ cần pải truyền vào 1tham số đầu và lấy về số ng làm trog năm đó
DECLARE @Number int
EXECUTE @Number = sp_EmployeesHireYearCount2 1999
PRINT @Number
GO
--tạo bảng tạm#Students
CREATE TABLE #Students
(
   RollNo varchar(6) CONSTRAINT PK_Students PRIMARY KEY,
   FullName varchar(100),
   Birthday datetime constraint DF_StudentsBirthday DEFAULT DATEADD(yy,-18,GETDATE())
)
GO
--
CREATE PROCEDURE #spInsertStudents
	@rollNo varchar(6),
	@fullName nvarchar(100),
	@birthday datetime
AS BEGIN
	IF(@birthday IS NULL)
		SET @birthday=DATEADD(YY,-18,GETDATE())
	INSERT INTO #Students(RollNo,FullName,Birthday)
		VALUES(@rollNo,@fullName,@birthday)
END
GO
--
EXEC #spStudents 'A12345','abc',NULL
EXEC #spStudents 'A54321','abc','12/24/2011'
SELECT * FROM #Students
--
CREATE PROCEDURE #spDeleteStudents
	@rollNo varchar(6)
AS BEGIN
	DELETE FROM #Students WHERE RollNo=@rollNo
END
--
EXECUTE #spDeleteStudents 'A12345'
GO
--
CREATE PROCEDURE Cal_Square @num int=0 AS
BEGIN
	RETURN (@num * @num);
END
GO
--
DECLARE @square int;
EXEC @square = Cal_Square 10;
PRINT @square;
GO

--xem định nghĩa thủ tục lưu trữ bảng hàm OBJECT_DEFINITION
SELECT OBJECT_DEFINITION(OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')) AS DEFINITION

--XEM định nghĩa thủ tuc lưu trữ bảng
SELECT definition FROM sys.sql_modules
WHERE object_id=OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')
GO
--thủ tục lưu trữ hệ thống xem các thành phần mà thủ tục lưu trữ phụ thuộc
sp_depends 'HumanResources,uspUpdateEmployeePersonalInfo'
GO

USE AdventureWorks2012
GO
--tạo thủ tục lưu trữ sp_DisplayEmployees
CREATE PROCEDURE sp_DisplayEmployees AS
SELECT * FROM HumanResources.Employee
GO
--thay đổi thủ tục lưu trữ sp_DisplayEmployees
ALTER PROCEDURE sp_DisplayEmployees AS
SELECT * FROM HumanResources.Employee
WHERE Gender='F'
GO
--chạy thủ tục lưu trữ sp_DisplayEmployees
EXEC sp_DisplayEmployees
GO
--xóa một thủ tục lưu trữ
DROP PROCEDURE sp_DisplayEmployees
GO

CREATE PROCEDURE sp_EmployeeHire
AS
BEGIN
--hiển thị
	EXECUTE sp_DisplayEmployeesHireYear 1999
	DECLARE @Number int
	EXECUTE sp_EmployeesHireYearCount 1999,@Number OUTPUT
	PRINT N'số nhân viên vào làm năm 1999 là:' + CONVERT(varchar(3),@Number)
END
GO
--chạy thủ tục lưu trữ
EXEC sp_EmployeeHire
GO
--Thay đổi thủ tục lưu trữ sp_EmployeeHire có khối TRY...CATCH
ALTER PROCEDURE sp_EmployeeHire
	@HireYear int

AS
BEGIN
	BEGIN TRY
	EXECUTE sp_DisplayEmployeesHireYear @HireYear
	DECLARE @Number int
	--lỗi xảy ra ở thủ tục sp_EmployeeHireYearCount chỉ truyền 2 tham số mà ta truyền 3
	EXECUTE sp_EmployeesHireYearCount @HireYear,@Number OUTPUT,'123'
	PRINT N'số nhân viên vào làm năm là :'+CONVERT(varchar(3),@Number)
	END TRY
BEGIN CATCH
	PRINT N'có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
END CATCH
PRINT N'kết thúc thủ tục lưu trữ'
END
GO
--CHẠY THỦ TỤC SP_EMPLOYEEHIRE
EXEC sp_EmployeeHire 1999
GO
--thay đổi thủ tục lưu trữ sp_EmployeeHire sử dụng hàm @@ERROR
ALTER PROCEDURE sp_EmployeeHire
	@HireYear int
AS
BEGIN
	EXECUTE sp_DisplayEmployeesHireYear @HireYear
	DECLARE @Number int
	EXECUTE sp_EmployeesHireYearCount @HireYear,@Number OUTPUT,'123'
	IF @@ERROR<> 0
		PRINT N'có lỗi xả ra trong khi thực hiện thủ tục lưu trữ'
	PRINT N'số nhân viên vào làm năm là:'+CONVERT(varchar(3),@Number)
END
GO
--CHẠY THỦ TỤC SP_EMPLOYEEHIRE
EXEC sp_EmployeeHire 1999
GO