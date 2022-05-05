--CREATE PROCEDURE sp_ListAllProducts
--AS
--SELECT * FROM Products
--GO;

Exec sp_ListAllProducts --Tüm ürünleri listeleyen SP

-------------------------------------------------------------------

--CREATE PROCEDURE sp_FilterProducts @search nvarchar(30)
--as
--select * from Products where name like '%'+@search+'%'

exec sp_FilterProducts @search='me' --Girilen deðeri içeren ürünleri getiren SP

-------------------------------------------------------------------

--CREATE PROCEDURE sp_InsertProduct @supplierId int, @categoryId int, @quantityPerUnit nvarchar(30), @unitPrice decimal(18, 2), @unitsInStock int, @unitsOnOrder int, @reorderLevel int, @discontinued bit, @name nvarchar(MAX)
--AS
--BEGIN
--	INSERT INTO Products(supplierId, categoryId, quantityPerUnit, unitPrice, unitsInStock, unitsOnOrder, reorderLevel, discontinued, name)
--	VALUES (@supplierId, @categoryId, @quantityPerUnit, @unitPrice , @unitsInStock , @unitsOnOrder , @reorderLevel , @discontinued , @name)
--END

EXEC sp_InsertProduct @supplierId=2, @categoryId=4, @quantityPerUnit='15', @unitPrice =20, @unitsInStock =21, @unitsOnOrder =22, @reorderLevel =23, @discontinued =1, @name ='deneme2' --Bilgileri girilen yeni ürünün kaydýný gerçekleþtiren SP

-------------------------------------------------------------------

--CREATE PROCEDURE sp_InsertOrder @userId int,@orderDate date=NULL
--AS
--BEGIN
--	SET @orderDate=ISNULL(@orderDate,GETDATE())
--	INSERT INTO Orders(userId,orderDate)
--	VALUES (@userId,@orderDate)
--END

exec sp_InsertOrder @userId=1
exec sp_InsertOrder @userId=1,@orderDate='2022-09-11' --Kullanýcý ile birlikte tarih girilirse girilen tarihe, girilmez ise o an ki tarihe order kayýtý yapan SP

-------------------------------------------------------------------

--CREATE PROCEDURE sp_InsertOrderDetail @orderId int, @productId int, @quantity int
--AS
--BEGIN
--	INSERT INTO OrderDetails(OrderId,ProductId,Quantity,UnitPrice)
--	VALUES(@orderId, @productId,@quantity,(select unitPrice from Products WHERE id=@productId))
--END

EXEC sp_InsertOrderDetail @orderId=6,@productId=8,@quantity=10
EXEC sp_InsertOrderDetail 5,6,3 --Ýlgili Order'a ait detay bilgisinin kaydýný yapan SP

-------------------------------------------------------------------

--Girilen OrderDetail'e göre önce stock durumunun yeterli olup olmadýðýný kontrol eden, yeterli ise 'Products' tablosunda ilgili 'unitsInStock' deðerini ve 'Orders' tablosunda 'TotalPrice' deðerini güncelleyen TRIGGER (stok yetersiz ise hiç bir þey yapmadan hata verir.)

CREATE TRIGGER trg_UpdateStock 
ON OrderDetails
INSTEAD OF INSERT 
AS
BEGIN
    declare @productId int
	declare @quantity int, @prevStock int
	SELECT @productId=ProductId, @quantity=Quantity from inserted -- !! buradaki insterted sql'de sabittir. select kýsmýnda da bu insert edilen tablonun ilgili column'larýna ulaþýlýr.
	Select @prevStock=unitsInStock from Products where id=@productId
	--Trigger UPDATE ifadesi
	if (@prevStock-@quantity>=0)
	BEGIN
		DECLARE @total decimal(18,2),@orderId int,@unitPrice decimal(18,2)
		SELECT @productId=ProductId,@total=Quantity*UnitPrice,@orderId=OrderId,@unitPrice=UnitPrice FROM inserted
		SELECT ProductId,Quantity*UnitPrice as total FROM inserted
		UPDATE Orders
		SET TotalPrice+=@total
		where Id=@orderId
		UPDATE Products
		SET unitsInStock=unitsInStock-@quantity
		WHERE id=@productId
		INSERT INTO OrderDetails(OrderId,ProductId,Quantity,UnitPrice)
		VALUES(@orderId, @productId,@quantity,@unitPrice)
	END
	else select 'Not enough STOCK.'

	--Güncelleme sonrasý yeni ve eski 'stock' deðeri
	SELECT id,[name],@prevStock as previousStock,unitsInStock as currentStock from Products where id=@productId
END;


-------------------------------------------------------------------


--CREATE VIEW vw_ProductVW AS --genel ürün bilgilerini listeleyen view
--Select p.name as ProductName, p.unitPrice as UnitPrice, p.unitsInStock as CurrentStock,c.name as CategoryName, s.companyName as SupplierCompany
--from Products p
--right join Categories c
--on p.categoryId=c.id
--left join Suppliers s
--on p.supplierId=s.id
--ürünü bulunmayan category'leri LÝSTELEMEK için right, 
--ürünü bulunmayan supplier'larý LÝSTELEMEMEK için left join kullanýldý.

--Stokta tükenmemiþ ürünlerin bilgilerini listeleyen view
--CREATE VIEW vw_ActiveProducts AS
--Select p.name as ProductName, p.unitPrice as UnitPrice, p.unitsInStock as CurrentStock,c.name as CategoryName, s.companyName as SupplierCompany
--from Products p
--right join Categories c
--on p.categoryId=c.id
--left join Suppliers s
--on p.supplierId=s.id
--where p.activeSelling='true'
--order by p.unitsInStock
--offset 0 rows

