-- 找出和最貴的產品同類別的所有產品
--資料 12
--select CategoryID, ProductName
--from Products 
--where CategoryID in (
--select top 1 CategoryID
--from Products 
--order by UnitPrice desc
--)

-- 找出和最貴的產品同類別最便宜的產品
--24, 1, Guaraná Fantástica

--select top 1 ProductID, CategoryID, ProductName
--from Products 
--where CategoryID in (
--select top 1 CategoryID
--from Products 
--order by UnitPrice desc
--)
--order by UnitPrice asc

-- 計算出上面類別最貴和最便宜的兩個產品的價差
--65.8398

--select max(UnitPrice) - min(UnitPrice) Spread
--from Products 
--where CategoryID in (
--select top 1 CategoryID
--from Products 
--order by UnitPrice desc
--)

-- 找出沒有訂過任何商品的客戶所在的城市的所有客戶
--資料 5

--select City, CustomerID
--from Customers
--where City in(
--select c.City
--from Customers c
--left outer join Orders o on c.CustomerID = o.CustomerID
--where o.OrderID is null
--)

-- 找出第 5 貴跟第 8 便宜的產品的產品類別
--4, 59, RC
--select CategoryID, ProductID, ProductName
--from Products 
--order by UnitPrice desc
--offset 4 rows
--fetch next 1 rows only

--1, 1, chai
--select CategoryID, ProductID, ProductName
--from Products 
--order by UnitPrice asc
--offset 7 rows
--fetch next 1 rows only


--資料CID = 1,4


--select CategoryID, CategoryName
--from Categories
--where CategoryID in(
--(
--select CategoryID
--from Products 
--order by UnitPrice desc
--offset 4 rows
--fetch next 1 rows only)
--,
--(
--select CategoryID
--from Products
--order by UnitPrice asc
--offset 7 rows
--fetch next 1 rows only))



-- 找出誰買過第 5 貴跟第 8 便宜的產品
--with t1 as(
--select ProductID,
--	   DENSE_RANK()over(order by UnitPrice desc) as PriceDesc,
--	   DENSE_RANK()over(order by UnitPrice) as PriceAsc
--from Products)
--select ProductID
--from t1
--where PriceDesc = 5 or PriceAsc = 8

--買過第 5 貴'或'第 8 便宜的產品的顧客
--資料 74
--select distinct c.ContactName, od.ProductID
--from Products p
--inner join [Order Details] od on od.ProductID = p.ProductID
--inner join Orders o on o.OrderID = od.OrderID
--inner join Customers c on c.CustomerID = o.CustomerID
--where od.ProductID in (1, 59)


--select o.CustomerID, od.ProductID
--from [Order Details] od
--inner join Products p on p.ProductID = od.ProductID
--inner join Orders o on o.OrderID = od.OrderID
--where od.ProductID in(
--(
--select ProductID
--from Products 
--order by UnitPrice desc
--offset 4 rows
--fetch next 1 rows only)
--,
--(
--select ProductID
--from Products
--order by UnitPrice asc
--offset 7 rows
--fetch next 1 rows only))

--with t1 as
--(select ProductID, CategoryID,
--	   ROW_NUMBER()over(order by UnitPrice desc)as NoDESC,
--	   ROW_NUMBER()over(order by UnitPrice)as NoASC 
--from Products)
--t2 as
--(select 1 as ROWNUM, CategoryID
--from t1
--where NoDESC = 5 or NoASC = 8)
--select *
--from t2
--where CategoryID = 1

-- 找出誰賣過第 5 貴跟第 8 便宜的產品

--賣過第 5 貴'或'第 8 便宜的產品的員工
--資料 18
--select distinct e.LastName + e.FirstName Name, od.ProductID
--from Products p
--inner join [Order Details] od on od.ProductID = p.ProductID
--inner join Orders o on o.OrderID = od.OrderID
--inner join  Employees e on e.EmployeeID = o.EmployeeID
--where od.ProductID in (1, 59)


-- 找出 13 號星期五的訂單 (惡魔的訂單)
--資料 4

--select DATEPART(dd, OrderDate) as OrderDay,DATEPART(dw, OrderDate) as OrderWeek, *
--from Orders
--where DATEPART(dd, OrderDate) = 13
--and
--DATEPART(dw, OrderDate) = 5

-- 找出誰訂了惡魔的訂單
--資料 4

--select CustomerID
--from Orders
--where DATEPART(dd, OrderDate) = 13
--and
--DATEPART(dw, OrderDate) = 5

-- 找出惡魔的訂單裡有什麼產品
--資料12

--select DATEPART(dd, OrderDate) as OrderDay,DATEPART(dw, OrderDate) as OrderWeek,p.ProductName
--from Orders o
--inner join [Order Details] od on o.OrderID = od.OrderID
--inner join Products p on od.ProductID = p.ProductID
--where DATEPART(dd, o.OrderDate) = 13
--and
--DATEPART(dw, o.OrderDate) = 5

-- 列出從來沒有打折 (Discount) 出售的產品 
--應該是正確的  資料0

--select od.OrderID, od.ProductID, p.ProductName
--from [Order Details] od
--inner join Products p on p.ProductID = od.ProductID
--where od.Discount = 0
--and od.Discount <> 0

---
--select ProductID, Discount
--from [Order Details]
--order by ProductID

-- 列出購買非本國的產品的客戶
--應該是正確的  資料89

--select distinct o.CustomerID
--from Orders o
--inner join Customers c on c.CustomerID = o.CustomerID
--inner join [Order Details] od on od.OrderID = o.OrderID
--inner join Products p on p.ProductID = od.ProductID
--inner join Suppliers s on s.SupplierID = p.SupplierID
--where c.Country <> s.Country




--
--產品的原產地
--select od.ProductID, p.ProductName, s.Country 
--from [Order Details] od
--inner join Products p on p.ProductID = od.ProductID
--inner join Suppliers s on s.SupplierID = p.SupplierID


--顧客的國家
--select o.OrderID, o.CustomerID, c.Country 
--from Orders o 
--inner join Customers c on c.CustomerID = o.CustomerID


-- 列出在同個城市中有公司員工可以服務的客戶
--資料 17

--select e.EmployeeID, e.LastName + ' ' + e.FirstName as FullName, c.CustomerID, e.City EC, c.City CC
--from Orders o
--inner join Customers c on c.CustomerID = o.CustomerID
--inner join Employees e on e.EmployeeID = o.EmployeeID
--where e.City = c.City
--order by e.City desc

-- 列出那些產品沒有人買過
--應該是正確的  資料 0

--select p.ProductName
--from [Order Details] od
--inner join Products p on p.ProductID = od.ProductID
--where p.ProductID not in(
--select od.ProductID
--from [Order Details] od
--inner join Products p on p.ProductID = od.ProductID)

----------------------------------------------------------------------------------------

-- 列出所有在每個月月底的訂單
--資料 43

--select OrderID, OrderDate
--from Orders
--where OrderDate in(
--select max(OrderDate) LastDate
--from Orders o
--group by DATEPART(yy, OrderDate), DATEPART(mm, OrderDate))

-- 列出每個月月底售出的產品
--資料 135

--select o.OrderID, o.OrderDate, p.ProductName 
--from Orders o
--inner join [Order Details] od on od.OrderID = o.OrderID
--inner join Products p on p.ProductID = od.ProductID
--where OrderDate in(
--select max(OrderDate) LastDate
--from Orders 
--group by DATEPART(yy, OrderDate), DATEPART(mm, OrderDate))

-- 找出有敗過最貴的三個產品中的任何一個的前三個大客戶
--資料61

--select od.ProductID, c.CustomerID
--from Customers c
--inner join Orders o on o.CustomerID = c.CustomerID
--inner join [Order Details] od on od.OrderID = o.OrderID
--where od.ProductID in(
--select top 3 ProductID
--from Products
--order by UnitPrice desc)

-- 找出有敗過銷售金額前三高個產品的前三個大客戶
 
--資料 QUICK, HUNGO, RATTC

--select top 3 o.CustomerID
--from Customers c
--inner join Orders o on o.CustomerID = c.CustomerID
--inner join [Order Details] od on od.OrderID = o.OrderID
--where od.ProductID in (
--select top 3 od.ProductID
--from [Order Details] od
--group by od.ProductID
--order by sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) desc
--)
--group by o.CustomerID
--order by sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) desc

-- 找出有敗過銷售金額前三高個產品所屬類別的前三個大客戶

--資料 BONAP, MEREP, QUICK

--select top 3 o.CustomerID
--from Customers c
--inner join Orders o on o.CustomerID = c.CustomerID
--inner join [Order Details] od on od.OrderID = o.OrderID
--where od.ProductID in (
--select CategoryID
--from Products
--where ProductID in (
--select top 3 od.ProductID
--from [Order Details] od
--group by od.ProductID
--order by sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) desc)
--)
--group by o.CustomerID
--order by sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) desc

-- 列出消費總金額高於所有客戶平均消費總金額的客戶的名字，以及客戶的消費總金額

--平均586

--資料 30

--with t1 
--as
--(select c.ContactName, (UnitPrice * Quantity * (1 - Discount)) SalesTotal
--from [Order Details] od
--inner join Orders o on o.OrderID = od.OrderID
--inner join Customers c on c.CustomerID = o.CustomerID),
--t2 as
--(select ContactName, sum(SalesTotal) Total
--from t1
--group by ContactName)
--select *
--from t2
--where Total > (
--select avg(Total) 
--from t2
--)

-- 列出最熱銷的產品，以及被購買的總金額

--59,54

--select top 1 ProductID, count(*) hot
--from [Order Details]
--group by ProductID
--order by hot desc

--59, 71155

--select ProductID, sum((UnitPrice * Quantity * (1 - Discount))) SalesTotal
--from [Order Details]
--where ProductID in(
--select top 1 ProductID
--from [Order Details]
--group by ProductID
--order by count(*) desc
--)
--group by ProductID

-- 列出最少人買的產品
--資料 9

--select *
--from Products
--where ProductID in
--(select top 1 ProductID
--from [Order Details]
--group by ProductID
--order by count(*) asc)

-- 列出最沒人要買的產品類別 (Categories)

--資料 produce

--with t1 as (
--select od.ProductID, p.CategoryID
--from [Order Details] od
--inner join Products p on p.ProductID = od.ProductID),
--t2 as(
--select top 1 CategoryID
--from t1
--group by CategoryID
--order by count(*))
--select c.CategoryName
--from t2
--inner join Categories c on c.CategoryID = t2.CategoryID

-- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (含購買其它供應商的產品)



-- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (不含購買其它供應商的產品)

-- 列出那些產品沒有人買過

-- 列出沒有傳真 (Fax) 的客戶和它的消費總金額

--客戶資料 22

--with t1 as
--(
--select c.ContactName, o.OrderID, (UnitPrice * Quantity * (1 - Discount)) Total
--from Customers c
--inner join Orders o on o.CustomerID = c.CustomerID
--inner join [Order Details] od on od.OrderID = o.OrderID
--where c.Fax is null
--)
--select t1.ContactName, sum((UnitPrice * Quantity * (1 - Discount)))
--from t1
--inner join Orders o on o.CustomerID = o.CustomerID
--inner join [Order Details] od on od.OrderID = o.OrderID
--group by t1.ContactName

-- 列出每一個城市消費的產品種類數量



-- 列出目前沒有庫存的產品在過去總共被訂購的數量

--沒有庫存被訂購的數量：17_978, 29_746, 31_1397, 53_722

--with t1 as
--(select *
--from Products
--where UnitsInStock = 0)
--select od.ProductID, sum(od.Quantity)
--from t1
--inner join [Order Details] od on od.ProductID = t1.ProductID
--group by od.ProductID

-- 列出目前沒有庫存的產品在過去曾經被那些客戶訂購過

-- 資料 62

--with t1 as
--(select *
--from Products
--where UnitsInStock = 0),
--t2 as
--(select od.ProductID, o.CustomerID
--from t1
--inner join [Order Details] od on od.ProductID = t1.ProductID
--inner join Orders o on o.OrderID = od.OrderID)
--select distinct CustomerID 
--from t2

-- 列出每位員工的下屬的業績總金額

select o.EmployeeID Staff, sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) Total
from Orders o
right outer join [Order Details] od on od.OrderID = o.OrderID
group by o.EmployeeID

-- 列出每家貨運公司運送最多的那一種產品類別與總數量

--select o.ShipVia, p.CategoryID, count(p.CategoryID)
--from [Order Details] od
--inner join Products p on p.ProductID = od.ProductID
--inner join Orders o on o.OrderID = od.OrderID
--where o.ShipVia is not null
--group by o.ShipVia, p.CategoryID


--order by o.ShipVia, p.CategoryID

-- 列出每一個客戶買最多的產品類別與金額

-- 列出每一個客戶買最多的那一個產品與購買數量

--select o.CustomerID, od.ProductID, count(Quantity)
--from [Order Details] od
--right outer join Orders o on o.OrderID = od.OrderID
--group by o.CustomerID, od.ProductID
--order by o.CustomerID, od.ProductID desc

-- 按照城市分類，找出每一個城市最近一筆訂單的送貨時間
--資料 71

--select ShipCity, max(ShippedDate)
--from Orders 
--group by ShipCity

-- 列出購買金額第五名與第十名的客戶，以及兩個客戶的金額差距

--PICCO, RATTC, QUEEN
-- 2108

--with t1 as(
--select DENSE_RANK()over(order by(od.UnitPrice * od.Quantity *(1 - od.Discount)) desc ) No,
--	   o.CustomerID, 
--       od.UnitPrice * od.Quantity *(1 - od.Discount) SalesTotal	   
--from [Order Details] od
--inner join Orders o on o.OrderID = od.OrderID
--inner join Customers c on c.CustomerID = o.CustomerID)
--select max(SalesTotal) - min(SalesTotal) Subtract
--from t1
--where no in(5, 10)





