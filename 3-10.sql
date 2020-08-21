CREATE DATABASE ToyzUnlimited 
GO
USE ToyzUnlimited
GO

CREATE TABLE Toys (
  ProductCode varchar(5) PRIMARY KEY,
  Name varchar(30),
  Category varchar(30),
  Manufacturer varchar(40),
  AgeRange varchar(15),
  UnitPrice money,
  Netweight int,
  QtyOnHand int
)
GO
--1. Tạo bảng Toys với cấu trúc giống như trên. Thêm dữ liệu (15 bản ghi) vào bảng với giá trị của
--trường QtyOnHand ít nhất là 20 cho mỗi sản phẩm đồ chơi. 
INSERT INTO Toys VALUES ('T1', 'JC Toys','Toys', 'Tennessee Williams', '3-5 Year Old', 35, 500, 125)
INSERT INTO Toys VALUES ('T2', 'Doll Riter' ,' Doll', 'Henderen', '3-7 Year Old', 25,400, 100),
                         ('T3', 'Teddy bear', 'Teddy', 'Hammer', '3-11 Year Old', 50,750, 1000),
						 ('T4', 'Football Ball', ' Ball', 'Removored', '5-15 year old', 30,400, 15000),
						 ('T5', 'Kite Bird',' Kite', 'Jiriu', '7-15 Year Old', 12,120, 1400),
						 ('T6', 'Titatic Boat','Boat', 'Jemruc', '5-15 year old', 47,1500, 234),
						 ('T7', 'Busan Train Toys', 'Toys', 'Yo na ka', '7-12 Year Old', 34,1250, 120),
						 ('T8', 'Yo-Yo Ryo','Yo-Yo','YoRic', '9-15 Year Old', 23,50, 1590),
						 ('T9', 'Slide Toys', 'Toys', 'HamHam', '6-12 Year Old', 45,400, 1230),
						 ('T10',' Balloon','Balloon', 'Balli', '5-15 Year Old', 12,25,120),
						 ('T11', 'Rocking Horse', 'Rocking', 'Jemrock',' 6-14 Year old', 60,2600,200),
						 ('T12', 'Whistle ','Whistle', 'Winner B', '5-15 Year old', 34,240, 120),
						 ('T13', 'Car Toys', 'Toys', 'LamaYa', '6-12 Year old', 90,250, 1200),
						 ('T14', 'Rubik cude', 'Rubik', 'Ruzana', '5-12 Year Old', 45,125, 1200),
						 ('T15', 'Block Tomokid', ' Block', 'Tomaya', '7-12 Year old', 34,124, 123)
--2. Viết câu lệnh tạo Thủ tục lưu trữ có tên là HeavyToys cho phép liệt kê tất cả các loại đồ chơi có
--trọng lượng lớn hơn 500g. 
CREATE  PROCEDURE  HeavyToys AS 
SELECT Name FROM Toys 
WHERE Netweight > 500
--3. Viết câu lệnh tạo Thủ tục lưu trữ có tên là PriceIncreasecho phép tăng giá của tất cả các loại đồ
--chơi lên thêm 10 đơn vị giá.
CREATE PROCEDURE  PriceIncrease as
SELECT ProductCode,Name, Category, ManuFacturer, UnitPrice+10 As price_increases, Netweight, QtyOnHand
FROM Toys
--4. Viết câu lệnh tạo Thủ tục lưu trữ có tên là QtyOnHand làm giảm số lượng đồ chơi còn trong của
--hàng mỗi thứ 5 đơn vị.  

CREATE PROCEDURE QtyOnHand AS
SELECT ProductCode,Name, Category, ManuFacturer, UnitPrice, QtyOnHand-5 as QtyONHand_decrease
From Toys

--
Exec  HeavyToys
EXECUTE PriceIncrease
EXEC QtyOnHand

--1. Ta đã có 3 thủ tục lưu trữ tên là HeavyToys,PriceIncrease, QtyOnHand. Viết các câu lệnh xem
--định nghĩa củacác thủ tục trên dùng 3 cách sau: 
Exec sp_helptext HeavyToys
sp_helptext PriceIncrease
sp_helptext QtyOnHand

SELECT definition FROM sys.sql_modules WHERE object_id=OBJECT_ID('HeavyToys')
SELECT definition FROM sys.sql_modules WHERE object_id=OBJECT_ID('PriceIncrease')
SELECT definition FROM sys.sql_modules WHERE object_id=OBJECT_ID('QtyOnHand')

SELECT OBJECT_DEFINITION(OBJECT_ID('HeavyToys'));
SELECT OBJECT_DEFINITION(OBJECT_ID('PriceIncrease'));
SELECT OBJECT_DEFINITION(OBJECT_ID('QtyOnHand'));

--2. Viết câu lệnh hiển thị các đối tượng phụ thuộc của mỗi thủ tục lưu trữ trên 
EXECUTE sp_depends HeavyToys
EXECUTE sp_depends PriceIncrease 
EXECUTE sp_depends QtyOnHand

--3. Chỉnh sửa thủ tục PriceIncreasevà QtyOnHandthêm câu lệnh cho phép hiển thị giá trị mới đã
--được cập nhật của các trường (UnitPrice,QtyOnHand). 
ALTER PROCEDURE PriceIncrease as
UPDATE Toys SET UnitPrice = UnitPrice+15 
GO
ALTER PROCEDURE QtyOnHand AS
UPDATE Toys SET QtyOnHand = QtyOnHand-10
GO

--4. Viết câu lệnh tạo thủ tục lưu trữ có tên là SpecificPriceIncrease thực hiện cộng thêm tổng số sản
--phẩm (giá trị trường QtyOnHand)vào giá của sản phẩm đồ chơi tương ứng. 

CREATE PROCEDURE SpecificPriceIncrease AS 
UPDATE toys SET UnitPrice = UnitPrice+ QtyOnHand
GO
exec SpecificPriceIncrease
select* from Toys
--5. Chỉnh sửa thủ tục lưu trữ SpecificPriceIncrease cho thêm tính năng trả lại tổng số các bản ghi
--được cập nhật. 
ALTER PROCEDURE SpecificPriceIncrease AS 
BEGIN 
UPDATE Toys SET UnitPrice = UnitPrice + QtyOnHand
SELECT ProductCode,Name, Category, ManuFacturer, UnitPrice AS Price, QtyOnHand 
FROM Toys
WHERE QtyOnHand > 0
SELECT @@ROWCOUNT
END

--6. Chỉnh sửa thủ tục lưu trữ SpecificPriceIncrease cho phép gọi thủ tục HeavyToysbên trong nó 
ALTER PROCEDURE SpecificPriceIncrease AS
BEGIN
UPDATE Toys SET UnitPrice = UnitPrice+QtyOnHand
SELECT ProductCode, Name, UnitPrice as Price, QtyOnHand 
FROM Toys
WHERE QtyOnHand > 0
SELECT @@ROWCOUNT
EXECUTE HeavyToys
END
EXEC SpecificPriceIncrease
 
--8. Xóa bỏ tất cả các thủ tục lưu trữ đã được tạo ra
DROP PROCEDURE HeavyToys
DROP PROCEDURE QtyOnHand
DROP PROCEDURE PriceIncrease