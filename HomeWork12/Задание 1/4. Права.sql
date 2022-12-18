/*1. Запретите пользователю с логином Марк получать информацию о продавцах*/
USE SportShop
GO;

CREATE LOGIN [Марк] WITH PASSWORD='12345678', 
				    DEFAULT_DATABASE=[SportShop],
					DEFAULT_LANGUAGE=[Russian],
					CHECK_EXPIRATION = OFF,
					CHECK_POLICY = OFF;
GO

CREATE USER [Марк]
FOR LOGIN [Марк]
WITH DEFAULT_SCHEMA=[dbo];
GO

DENY SELECT
ON Employees
TO Марк;
GO

/*2. Разрешите пользователю с логином Дэвид получать информацию только о продавцах*/
CREATE LOGIN [Дэвид] WITH PASSWORD='12345678',
					 DEFAULT_DATABASE=[SportShop],
					 DEFAULT_LANGUAGE=[Russian],
					 CHECK_EXPIRATION = OFF,
					 CHECK_POLICY = OFF;
GO

CREATE USER [Дэвид]
FOR LOGIN [Дэвид]
WITH DEFAULT_SCHEMA=[dbo];
GO

GRANT SELECT
ON Employees
TO Дэвид;
GO

/*3. Предоставьте полный доступ к базе данных пользователю с логином Ольга*/
CREATE LOGIN [Ольга] WITH PASSWORD='12345678',
					 DEFAULT_DATABASE=[SportShop],
					 DEFAULT_LANGUAGE=[Russian],
					 CHECK_EXPIRATION=OFF,
					 CHECK_POLICY=OFF;
GO

CREATE USER [Ольга]
FOR LOGIN [Ольга]
WITH DEFAULT_SCHEMA=[dbo];
GO

EXEC sp_addrolemember 'db_datareader', 'Ольга';
GO

EXEC sp_addrolemember 'db_datawriter', 'Ольга';
GO

/*4. Предоставьте доступ только на чтение таблиц с информацией о продавцах, товарах в наличии пользователю с логином Константин.*/
CREATE LOGIN Константин WITH PASSWORD='12345678',
						DEFAULT_DATABASE=[SportShop],
						DEFAULT_LANGUAGE=[Russian],
						CHECK_EXPIRATION=OFF,
						CHECK_POLICY=OFF;
GO

CREATE USER [Константин]
FOR LOGIN [Константин]
WITH DEFAULT_SCHEMA=[dbo];
GO

GRANT SELECT
ON Employees
TO [Константин];
GO

GRANT SELECT
ON Product
TO [Константин];
GO
