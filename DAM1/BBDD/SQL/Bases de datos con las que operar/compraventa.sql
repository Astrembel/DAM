USE [master]
GO
/****** Object:  Database [compraventa]    Script Date: 05/06/2018 19:45:39 ******/
CREATE DATABASE [compraventa]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'COMPRAVENTA_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\compraventa_Data.mdf' , SIZE = 4608KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'COMPRAVENTA_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\compraventa_Log.ldf' , SIZE = 3840KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
GO
ALTER DATABASE [compraventa] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [compraventa].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [compraventa] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [compraventa] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [compraventa] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [compraventa] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [compraventa] SET ARITHABORT OFF 
GO
ALTER DATABASE [compraventa] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [compraventa] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [compraventa] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [compraventa] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [compraventa] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [compraventa] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [compraventa] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [compraventa] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [compraventa] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [compraventa] SET  DISABLE_BROKER 
GO
ALTER DATABASE [compraventa] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [compraventa] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [compraventa] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [compraventa] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [compraventa] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [compraventa] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [compraventa] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [compraventa] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [compraventa] SET  MULTI_USER 
GO
ALTER DATABASE [compraventa] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [compraventa] SET DB_CHAINING OFF 
GO
ALTER DATABASE [compraventa] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [compraventa] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [compraventa] SET DELAYED_DURABILITY = DISABLED 
GO
USE [compraventa]
GO
/****** Object:  User [laly_casillas\laly]    Script Date: 05/06/2018 19:45:39 ******/
CREATE USER [laly_casillas\laly] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [laly_casillas\laly]
GO
/****** Object:  UserDefinedFunction [dbo].[AADOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[AADOS]
	(@REGIÓN nchar(50),
	 @AÑO	 int)
	 RETURNS @TABLA TABLE
			  (APELLIDOS 	nvarchar(20),
			   VALORPEDIDOS	numeric(12,2))
AS
BEGIN
INSERT @TABLA
SELECT APELLIDOS,SUM(VALORPEDIDO) 
	FROM VALORPEDIDOS VP INNER JOIN PEDIDOS P
							INNER JOIN EMPLEADOS E
							ON P.IDEMPLEADO = E.IDEMPLEADO
						 ON VP.IDPEDIDO = P.IDPEDIDO 
	WHERE E.IDEMPLEADO IN 
			(SELECT DISTINCT IDEMPLEADO
				FROM EMPLEADOSTERRITORIOS
				WHERE IDTERRITORIO IN
					(SELECT IDTERRITORIO
						FROM TERRITORIOS
						WHERE IDREGIÓN = 
							(SELECT IDREGIÓN
								FROM REGIONES
								WHERE DESCRIPCIÓN = @REGIÓN)))
						AND YEAR(FECHAPEDIDO)=@AÑO
	GROUP BY APELLIDOS
	ORDER BY SUM(VALORPEDIDO) DESC
RETURN
END


GO
/****** Object:  UserDefinedFunction [dbo].[AAUNO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[AAUNO]
(@nombreproducto nvarchar(40))
returns datetime
as
begin
declare @fechapedido datetime
select top 1 @fechapedido=fechapedido
  from productos pr inner join (
	   [detalles de pedidos] dp inner join 
		  pedidos p on dp.idpedido=p.idpedido)
		on pr.idproducto=dp.idproducto
  where nombreproducto=@nombreproducto
order by fechapedido desc
return @fechapedido
end

GO
/****** Object:  UserDefinedFunction [dbo].[ADOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ADOS]
  (@nombre nvarchar(40),
   @demora int)
  returns int
as
begin
declare @numpedidos int
select @numpedidos=count(*)
from pedidos inner join [compañías de envíos] 
		on idcompañíaenvíos=formaenvío
where datediff(day,fechaenvío,fechaentrega)>=@demora and 
      nombrecompañía=@nombre
group by nombrecompañía
return @numpedidos
end

GO
/****** Object:  UserDefinedFunction [dbo].[Aformato_fecha]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  function [dbo].[Aformato_fecha]
(@fecha datetime)
returns nvarchar(10)
as
begin
return convert(nvarchar(2),day(@fecha))+'/'+
       convert(nvarchar(2),month(@fecha))+'/'+
       convert(nvarchar(4),year(@fecha))
end

GO
/****** Object:  UserDefinedFunction [dbo].[ATRES]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ATRES]
	(@REGIÓN nchar(50))
	 RETURNS numeric (12,2)
AS
BEGIN
	DECLARE @NUMEMPLEADOS int
	SELECT @NUMEMPLEADOS = COUNT(DISTINCT IDEMPLEADO)
		FROM EMPLEADOSTERRITORIOS
		WHERE IDTERRITORIO IN
			(SELECT IDTERRITORIO
				FROM TERRITORIOS
				WHERE IDREGIÓN =
					(SELECT IDREGIÓN
						FROM REGIONES
						WHERE DESCRIPCIÓN = @REGIÓN))
		DECLARE @VALORPEDIDOS numeric(12,2)
	SELECT @VALORPEDIDOS = SUM(VALORPEDIDO)
		FROM VALORPEDIDOS VP INNER JOIN PEDIDOS P
						  ON VP.IDPEDIDO =P.IDPEDIDO
		WHERE IDEMPLEADO IN
			(SELECT DISTINCT IDEMPLEADO
				FROM EMPLEADOSTERRITORIOS
				WHERE IDTERRITORIO IN
					(SELECT IDTERRITORIO
						FROM TERRITORIOS
						WHERE IDREGIÓN =
							(SELECT IDREGIÓN
								FROM REGIONES
								WHERE DESCRIPCIÓN = @REGIÓN)))
		RETURN @VALORPEDIDOS/@NUMEMPLEADOS
END


GO
/****** Object:  UserDefinedFunction [dbo].[AUNO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[AUNO]
  (@nombrecategoría nvarchar(15))
  returns @tabla table
	(nombreproducto nvarchar(40),
	 preciounidad      money,
	 nombreproveedor nvarchar(40))
as
begin
  declare @idcategoría int
  select @idcategoría=idcategoría
    from categorías
    where nombrecategoría=@nombrecategoría
  insert @tabla
    select nombreproducto,preciounidad,nombrecompañía
      from productos pr inner join proveedores p
			on pr.idproveedor=p.idproveedor
      where idcategoría=@idcategoría
  return
end

GO
/****** Object:  UserDefinedFunction [dbo].[CONTAR]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CONTAR]
()
RETURNS INT
AS
BEGIN
DECLARE @NUM INT

SELECT @NUM=COUNT(*)
FROM PEDIDOS
RETURN @NUM
END

GO
/****** Object:  UserDefinedFunction [dbo].[DATOS_PEDIDOS_CLIENTE]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DATOS_PEDIDOS_CLIENTE]
	(@NOMBRECLIENTE nvarchar(40))
	 RETURNS datetime
AS
BEGIN
	DECLARE @IDCLIENTE nvarchar(5)
	SELECT @IDCLIENTE = IDCLIENTE
		FROM CLIENTES
		WHERE NOMBRECOMPAÑÍA = @NOMBRECLIENTE
	DECLARE @FECHA datetime
	SELECT @FECHA = MAX(FECHAPEDIDO)
	FROM PEDIDOS
	WHERE IDCLIENTE = @IDCLIENTE
	RETURN @FECHA
END

GO
/****** Object:  UserDefinedFunction [dbo].[DOS2]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DOS2]
(@DATO int)
RETURNS INT
AS
BEGIN
DECLARE @VDATO INT
SET @VDATO =2*@DATO
RETURN 2*DBO.UNO1(@DATO)
--RETURN CONVERT(@VDATO,VARCHAR(2))+'  '+CONVERT(DBO.UNO1(@DATO))
END

GO
/****** Object:  UserDefinedFunction [dbo].[FDOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[FDOS]
  (@año smallint)
   RETURNS @TABLA TABLE
			(nomcat	nvarchar(15),
			 ventas numeric(10,2))
AS
BEGIN
  INSERT @TABLA
  SELECT NOMBRECATEGORÍA,VENTASPORCATEGORÍA
FROM (
SELECT IDCATEGORÍA,SUM(VALORVENTAS) VENTASPORCATEGORÍA
FROM (SELECT IDPRODUCTO,SUM(PRECIOUNIDAD*CANTIDAD) 
				VALORVENTAS
	 FROM PEDIDOS P INNER JOIN [DETALLES DE PEDIDOS] DDP
	                                ON P.IDPEDIDO =DDP.IDPEDIDO
	WHERE YEAR(FECHAPEDIDO)= @año
	GROUP BY IDPRODUCTO)A
					   INNER JOIN
	PRODUCTOS PR
					   ON A.IDPRODUCTO = PR.IDPRODUCTO
	GROUP BY IDCATEGORÍA) B
					INNER JOIN
	CATEGORÍAS C
					   ON B.IDCATEGORÍA=C.IDCATEGORÍA
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[FMejorClienteAño]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*create view VMejorClienteAño as
 select IdCliente,YEAR(FechaPedido) Año, SUM(dbo.ValorPedidosin(IdPedido)) Valor
 from PEDIDOS
 group by IdCliente,YEAR(fechapedido)*/

 create function [dbo].[FMejorClienteAño] (@año int) returns varchar(40) as
 begin
 declare @mensaje varchar(40)
 set @mensaje=(select NombreCompañía
           from CLIENTES
           where IdCliente in (select IdCliente
                               from VMejorClienteAño
                               where Año=@año and VALOR in (select MAX(valor)
                                                            from VMejorClienteAño
                                                            where Año=@año)))
 if @mensaje is null set @mensaje='no hay pedidos'
 return @mensaje
 end
 
 --select dbo.




GO
/****** Object:  UserDefinedFunction [dbo].[fmejorclienteaño1]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*create view VMejorClienteAño as
select idcliente,YEAR(fechapedido) año,SUM(dbo.valorpedidosin(idpedido)) valor
from PEDIDOS
group by IdCliente,YEAR(fechapedido)*/

create function [dbo].[fmejorclienteaño1](@año int) returns varchar(40) as
begin
return (select nombrecompañía
        from CLIENTES
        where IdCliente=(select idcliente
                         from vmejorclienteaño
                         where año=@año
                         and valor=(select MAX(valor)
                                    from vmejorclienteaño
                                    where año=@año)))
                         end

GO
/****** Object:  UserDefinedFunction [dbo].[Fn_FechaEspañol]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[Fn_FechaEspañol] (@fecha date, @separador char(1))
	returns char(10)
as
	begin
		return replicate(0,2 - len(datename(dd,@fecha))) + datename(dd,@fecha) + @separador + 
				replicate(0,2 - len(cast(month(@fecha) as varchar))) + cast(month(@fecha) as varchar) + @separador + datename(yy, @fecha)
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_idPedido_cliente_envio]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[fn_idPedido_cliente_envio](@idpedido int)
	returns nvarchar(50)
as
	begin
		declare @retorno nvarchar(50)

		if(dbo.fn_validar_idPedido(@idPedido) = 0)
			set @retorno = 'No existe el pedido'
		else
			select @retorno = nombrecompañía + ' '  + dbo.Fn_FechaEspañol(FechaEnvío, '/')
							from pedidos p inner join clientes c on p.IdCliente = c.IdCliente
							where IdPedido = @idPedido
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_idPedido_compañiaenvio]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_idPedido_compañiaenvio](@idpedido int)
	returns nvarchar(50)
as
	begin
		declare @retorno nvarchar(50)

		if(dbo.fn_validar_idPedido(@idPedido) = 0)
			set @retorno = 'No existe el pedido'
		else
			set @retorno = (select NombreCompañía
							from [COMPAÑÍAS DE ENVÍOS]
							where IdCompañíaEnvíos in (select IdCompañíaEnvíos
														from pedidos
														where IdPedido = @idpedido))
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_media_pedidos]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_media_pedidos](@compañia nvarchar(40))
	returns nvarchar(35)
as
	begin
		declare @retorno nvarchar(35)

		if (@compañia not in (select NombreCompañía
								from [COMPAÑÍAS DE ENVÍOS]
								where NombreCompañía = @compañia))
			set @retorno = 'No existe esa compañía de envíos'
		else
			set @retorno = (select avg(datediff(dd, FechaEnvío, FechaEntrega))
							from pedidos where IdCompañíaEnvíos = (select IdCompañíaEnvíos
																	from [COMPAÑÍAS DE ENVÍOS]
																	where NombreCompañía = @compañia))
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_pedido_concargo]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[fn_pedido_concargo](@pedido int)
	returns nvarchar(50)
as
	begin
		declare @retorno nvarchar(50)
		if(dbo.fn_validar_idPedido(@pedido) = 0)
			set @retorno = 'No existe el pedido ' + cast(@pedido as nvarchar)
		else
			set @retorno = dbo.fn_pedido_sincargo(@pedido) + (select cargo
																from PEDIDOS
																where IdPedido = @pedido)
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_pedido_sincargo]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[fn_pedido_sincargo](@pedido int)
	returns nvarchar(50)
as
	begin
		declare @retorno nvarchar(50)
		if(dbo.fn_validar_idPedido(@pedido) = 0)
			set @retorno = 'No existe el pedido ' + cast(@pedido as nvarchar)
		else
			set @retorno = (select sum(preciounidad * cantidad * (1 - descuento))
							from [DETALLES DE PEDIDOS]
							where idpedido = @pedido)
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_pedidos_pais]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_pedidos_pais](@pais nvarchar(15))
	returns nvarchar(35)
as
	begin
		declare @retorno nvarchar(35)
		if(@pais not in (select país from clientes where País = @pais))
			set @retorno = 'El país no está en la base de datos'
		else if((select count(IdPedido)
							from pedidos
							where PaísDestinatario = @pais) = 0)
			set @retorno = 'No hay ningún pedido a ' + @pais
		else
			set @retorno = (select count(IdPedido)
							from pedidos
							where PaísDestinatario = @pais)
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_producto_proveedor]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_producto_proveedor](@producto nvarchar(40))
	returns nvarchar(40)
as
	begin
		declare @retorno nvarchar(40)

		if(@producto not in (select NombreProducto from productos where NombreProducto like @producto))
			set @retorno = 'No existe el producto' + @producto
		else
			set @retorno = (select NombreCompañía
							from proveedores
							where IdProveedor in (select IdProveedor
													from PRODUCTOS
													where NombreProducto like @producto))
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_productos_suspendidos]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_productos_suspendidos](@categoria nvarchar(15))
	returns nvarchar(50)
as
	begin
		declare @retorno nvarchar(50)

		if(@categoria not in (select NombreCategoría
								from CATEGORÍAS
								where NombreCategoría = @categoria))
			set @retorno = 'No existe la categoría ' + @categoria
		else
			set @retorno = 'La categoría ' + @categoria + ' tiene ' + cast((select count(suspendido)
																		from PRODUCTOS
																		where suspendido = 1 and IdCategoría = (select IdCategoría
																												from CATEGORÍAS
																												where NombreCategoría = @categoria)) as varchar) + ' productos suspendidos'
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_region_empleado]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_region_empleado](@empleado int)
	returns nvarchar(50)
as
	begin
		declare @retorno nvarchar(50)

		if(@empleado not in (select IdEmpleado
								from empleados
								where IdEmpleado = @empleado))
			set @retorno = 'No existe ese empleado'
		else
			set @retorno = (select descripción
							from REGIONES
							where IdRegión in (select IdRegión
												from TERRITORIOS
												where IdTerritorio in (select idterritorio
																		from EMPLEADOSTERRITORIOS
																		where Idempleado = @empleado)))
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_region2_empleado2]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_region2_empleado2](@empleado int)
	returns nvarchar(50)
as
	begin
		declare @retorno nvarchar(50)

		if(@empleado not in (select IdEmpleado
								from empleados
								where IdEmpleado = @empleado))
			set @retorno = 'No existe ese empleado'
		else
			set @retorno = 'El empleado ' + cast(@empleado as nvarchar(1)) + ' tiene asignada la región ' + (select Descripción
																												from vregiones
																												where IdEmpleado = @empleado)
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_validar_idPedido]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_validar_idPedido] (@idPedido int)
	returns int
as
	begin
		declare @retorno int

		if(@idpedido not in (select idpedido from PEDIDOS where IdPedido = @idPedido))
			set @retorno = 0
		else
			set @retorno = 1
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[Formato_fecha]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Formato_fecha]
    (@fecha datetime,
     @separador char(1))
    RETURNS nchar(20)
  AS
  BEGIN
    RETURN
	convert(nvarchar(2),day(@fecha)) + @separador
	+ convert(nvarchar(2),month(@fecha)) + @separador
	+ convert(nvarchar(4),year(@fecha))
  END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FUNO]
(@mes smallint,@año smallint)
  RETURNS nvarchar(30)
BEGIN
  DECLARE @idempleado	int
 
  SELECT @idempleado =idempleado
    FROM (
      SELECT top 1 idempleado,sum(preciounidad*cantidad)as valorventas
        FROM pedidos p INNER JOIN [detalles de pedidos] dp
                       ON p.idpedido=dp.idpedido
     WHERE month(fechapedido)=@mes AND year(fechapedido)=@año
        GROUP BY idempleado
        ORDER BY valorventas desc) a
  DECLARE @nombre 		nvarchar(10)
  DECLARE @apellidos 	nvarchar(20)
	SELECT @nombre=nombre,@apellidos=apellidos
	FROM EMPLEADOS
	WHERE idempleado=@idempleado
  RETURN @nombre+' '+@apellidos
END



GO
/****** Object:  UserDefinedFunction [dbo].[identificador_empleado]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* función que obtine el identificador del empleado, si este existe, en otro caso devolverá el valor -1, que no puede
ser un identificador de ningún empleado*/
create function [dbo].[identificador_empleado](@apellidoEmpleado varchar(40)) returns int
begin
 declare @idempleado int
 select @idempleado=idEmpleado
 from EMPLEADOS
 where Apellidos=@apellidoEmpleado
 
 if @idempleado is null set @idempleado=-1
 return @idempleado
 
 end
GO
/****** Object:  UserDefinedFunction [dbo].[MEJOR_CLIENTE_AÑO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[MEJOR_CLIENTE_AÑO]
(@AÑO	int )
  RETURNS nvarchar(40)
AS
BEGIN
	DECLARE @CLIENTE nvarchar(40)
	SELECT TOP 1 @CLIENTE = CLIENTE
		FROM PEDIDOS_CLIENTES_AÑO
		WHERE AÑO=@AÑO
		ORDER BY  VALORPEDIDOS DESC
	RETURN @CLIENTE
END

GO
/****** Object:  UserDefinedFunction [dbo].[MEJOR_EMPLEADO_POR_REGIÓN_Y_AÑO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[MEJOR_EMPLEADO_POR_REGIÓN_Y_AÑO]
	(@REGIÓN nchar(50),
	 @año	  int)
	RETURNS nvarchar(20)
AS
BEGIN
	DECLARE @APELLIDO nvarchar(20)
	SET @APELLIDO = (SELECT TOP 1 APELLIDOS
					FROM VENTAS_POR_REGIÓN_EMPLEADO_Y_AÑO
					WHERE REGIÓN=@REGIÓN AND AÑO=@AÑO
					ORDER BY VALORPEDIDOSAÑO DESC)
	RETURN @APELLIDO
END
				 			
							
											    

					
					
				  		
											
		
			
		

GO
/****** Object:  UserDefinedFunction [dbo].[MEJOR_VENDEDOR_MES]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[MEJOR_VENDEDOR_MES]
(@AÑO	int,
 @MES	int)
  RETURNS nvarchar(40)
AS
BEGIN
	DECLARE @EMPLEADO nvarchar(40)
	SELECT TOP 1 @EMPLEADO = EMPLEADO
		FROM PEDIDOS_VENDEDORES_MES
		WHERE AÑO=@AÑO AND MES=@MES
		ORDER BY  VALORPEDIDOS DESC
	RETURN @EMPLEADO
END


GO
/****** Object:  UserDefinedFunction [dbo].[MejorClienteAño]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*create view VMejorClienteAño as
 select IdCliente,YEAR(FechaPedido) Año, SUM(dbo.ValorPedidosin(IdPedido)) Valor
 from PEDIDOS
 group by IdCliente,YEAR(fechapedido)*/
 
 create function [dbo].[MejorClienteAño] (@año int) returns varchar(40) as
 begin
 declare @mensaje varchar(40)
 set @mensaje=(select NombreCompañía
           from CLIENTES
           where IdCliente in (select IdCliente
                               from VMejorClienteAño
                               where Año=@año and VALOR in (select MAX(valor)
                                                            from VMejorClienteAño
                                                            where Año=@año)))
 if @mensaje is null set @mensaje='no hay pedidos'
 return @mensaje
 end




GO
/****** Object:  UserDefinedFunction [dbo].[MEJORES_VENTAS_CON_REPETICIÓN]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[MEJORES_VENTAS_CON_REPETICIÓN]
	(@VENDEDOR nvarchar(20))
	 RETURNS @MEJORVENTA TABLE
			(FECHA	DATETIME)
AS
	BEGIN
		DECLARE @IDEMPLEADO INT
		SELECT @IDEMPLEADO = IDEMPLEADO
			FROM EMPLEADOS
			WHERE APELLIDOS = @VENDEDOR
		DECLARE @MAYORVALOR numeric(8,2)
		SELECT @MAYORVALOR = MAX(VALORVENTAS)
			FROM VALOR_VENTAS_POR_EMPLEADO_Y_FECHA
			WHERE IDEMPLEADO = @IDEMPLEADO
		INSERT @MEJORVENTA
			SELECT FECHA = FECHAPEDIDO
				FROM VALOR_VENTAS_POR_EMPLEADO_Y_FECHA
				WHERE IDEMPLEADO=@IDEMPLEADO AND VALORVENTAS=@MAYORVALOR
			
		RETURN
	END

GO
/****** Object:  UserDefinedFunction [dbo].[MEJORES_VENTAS_SIN_REPETICIÓN]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[MEJORES_VENTAS_SIN_REPETICIÓN]
	(@VENDEDOR nvarchar(20))
	 RETURNS DATETIME
AS
	BEGIN
		DECLARE @IDEMPLEADO INT
		SELECT @IDEMPLEADO = IDEMPLEADO
			FROM EMPLEADOS
			WHERE APELLIDOS = @VENDEDOR
		DECLARE @FECHA DATETIME
		SELECT TOP 1 @FECHA=FECHAPEDIDO
			FROM VALOR_VENTAS_POR_EMPLEADO_Y_FECHA
			WHERE IDEMPLEADO = @IDEMPLEADO
			ORDER BY VALORVENTAS DESC
		RETURN @FECHA
	END



GO
/****** Object:  UserDefinedFunction [dbo].[NomEmpleados]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[NomEmpleados]
 	(@long nvarchar(5))
	RETURNS @Empleados TABLE
		(idempleado int PRIMARY KEY NOT NULL,
		 nombre nvarchar(61) NOT NULL)
AS
BEGIN
	IF @long='corto'
		INSERT @Empleados
			SELECT idempleado,apellidos
			FROM empleados
	ELSE
		IF @long='largo'
			INSERT @Empleados
				SELECT idempleado, nombre+' '+apellidos
				FROM empleados
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[Sin_Región]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Sin_Región]
	(@valorregión nvarchar(30))
  	RETURNS nvarchar(30)
BEGIN
	IF @valorregión IS NULL
		SET @valorregión ='No Identificada'
	RETURN @valorregión
END

GO
/****** Object:  UserDefinedFunction [dbo].[TABLA_DATOS_PEDIDOS_CLIENTE]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TABLA_DATOS_PEDIDOS_CLIENTE]
	(@NOMBRECLIENTE nvarchar(40))
	 RETURNS @TABLA table
			(FECHA datetime)
AS
BEGIN
	DECLARE @IDCLIENTE nvarchar(5)
	SELECT @IDCLIENTE = IDCLIENTE
		FROM CLIENTES
		WHERE NOMBRECOMPAÑÍA = @NOMBRECLIENTE
	INSERT @TABLA	
		SELECT FECHA = MAX(FECHAPEDIDO)
		FROM PEDIDOS
		WHERE IDCLIENTE = @IDCLIENTE
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[TRES]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TRES]
	(@REGIÓN nchar(50))
	 RETURNS numeric (12,2)
AS
BEGIN
	DECLARE @NUMEMPLEADOS int
	SELECT @NUMEMPLEADOS = COUNT(DISTINCT IDEMPLEADO)
		FROM EMPLEADOSTERRITORIOS
		WHERE IDTERRITORIO IN
			(SELECT IDTERRITORIO
				FROM TERRITORIOS
				WHERE IDREGIÓN =
					(SELECT IDREGIÓN
						FROM REGIONES
						WHERE DESCRIPCIÓN = @REGIÓN))
		DECLARE @VALORPEDIDOS numeric(12,2)
	SELECT @VALORPEDIDOS = SUM(VALORPEDIDO)
		FROM VALORPEDIDOS VP INNER JOIN PEDIDOS P
						  ON VP.IDPEDIDO =P.IDPEDIDO
		WHERE IDEMPLEADO IN
			(SELECT DISTINCT IDEMPLEADO
				FROM EMPLEADOSTERRITORIOS
				WHERE IDTERRITORIO IN
					(SELECT IDTERRITORIO
						FROM TERRITORIOS
						WHERE IDREGIÓN =
							(SELECT IDREGIÓN
								FROM REGIONES
								WHERE DESCRIPCIÓN = @REGIÓN)))
		RETURN @VALORPEDIDOS/@NUMEMPLEADOS
END

GO
/****** Object:  UserDefinedFunction [dbo].[UNO1]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UNO1]
(@DATO int)
RETURNS INT
AS
BEGIN
RETURN 2*@DATO
END

GO
/****** Object:  UserDefinedFunction [dbo].[ValorPedidoCon]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*alter function ValorPedidoSin (@idpedido int) returns numeric(10,2) as
begin
	return (select SUM(PrecioUnidad*cantidad*(1-Descuento))
	        from [detalles de pedidos]
	        where IdPedido=@idpedido
	        group by Idpedido)
end
go*/

CREATE function [dbo].[ValorPedidoCon] (@idpedido int) returns numeric(10,2) as
begin
	return dbo.ValorPedidoSin (@IdPedido) + (select cargo
	                                        from PEDIDOS
	                                        where IdPedido=@idpedido)
end


GO
/****** Object:  UserDefinedFunction [dbo].[ValorPedidosin]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ValorPedidosin] (@idpedido int) returns numeric(10,2) as
begin
	return (select SUM(PrecioUnidad*cantidad*(1-Descuento))
	        from [detalles de pedidos]
	        where IdPedido=@idpedido
	        group by Idpedido)
end

GO
/****** Object:  UserDefinedFunction [dbo].[VENDEDOR_CLIENTE_AÑO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[VENDEDOR_CLIENTE_AÑO]
	(@VENDEDOR	nvarchar(20),
	 @CLIENTE		nvarchar(40),
	 @AÑO		int)
	 RETURNS numeric(18,2)
AS
	BEGIN
	DECLARE @IDEMPLEADO int
	SELECT @IDEMPLEADO = IDEMPLEADO
		FROM EMPLEADOS
		WHERE APELLIDOS = @VENDEDOR
	DECLARE @IDCLIENTE	nvarchar(5)
	SELECT @IDCLIENTE = IDCLIENTE
		FROM CLIENTES
		WHERE NOMBRECOMPAÑÍA = @CLIENTE
	DECLARE @VALORPEDIDOS numeric(18,2)
	SELECT @VALORPEDIDOS = SUM(VALORTOTAL)
		FROM VENTAS_ANUALES_POR_CLIENTE_Y_VENDEDOR
		WHERE IDCLIENTE = @IDCLIENTE AND IDEMPLEADO = @IDEMPLEADO AND AÑO =@AÑO
		GROUP BY AÑO,IDCLIENTE,IDEMPLEADO
	RETURN @VALORPEDIDOS
	END

GO
/****** Object:  Table [dbo].[CATEGORÍAS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CATEGORÍAS](
	[IdCategoría] [int] NOT NULL,
	[NombreCategoría] [nvarchar](15) NOT NULL,
	[Descripción] [ntext] NULL,
	[Imagen] [image] NULL,
 CONSTRAINT [PK_CATEGORÍAS] PRIMARY KEY CLUSTERED 
(
	[IdCategoría] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CLIENTES]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLIENTES](
	[IdCliente] [nvarchar](5) NOT NULL,
	[NombreCompañía] [nvarchar](40) NULL,
	[NombreContacto] [nvarchar](30) NULL,
	[CargoContacto] [nvarchar](30) NULL,
	[Dirección] [nvarchar](60) NULL,
	[Ciudad] [nvarchar](15) NULL,
	[Región] [nvarchar](15) NULL,
	[CódPostal] [nvarchar](10) NULL,
	[País] [nvarchar](15) NULL,
	[Teléfono] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
 CONSTRAINT [PK_CLIENTES] PRIMARY KEY CLUSTERED 
(
	[IdCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[COMPAÑÍAS DE ENVÍOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COMPAÑÍAS DE ENVÍOS](
	[IdCompañíaEnvíos] [int] NOT NULL,
	[NombreCompañía] [nvarchar](40) NULL,
	[Teléfono] [nvarchar](24) NULL,
 CONSTRAINT [PK_COMPAÑÍAS DE ENVÍOS] PRIMARY KEY CLUSTERED 
(
	[IdCompañíaEnvíos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DETALLES DE PEDIDOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DETALLES DE PEDIDOS](
	[IdPedido] [int] NOT NULL,
	[IdProducto] [int] NOT NULL,
	[PrecioUnidad] [money] NULL,
	[Cantidad] [smallint] NULL,
	[Descuento] [real] NULL,
 CONSTRAINT [PK_DETALLES DE PEDIDOS] PRIMARY KEY CLUSTERED 
(
	[IdPedido] ASC,
	[IdProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EMPLEADOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPLEADOS](
	[IdEmpleado] [int] NOT NULL,
	[Apellidos] [nvarchar](20) NULL,
	[Nombre] [nvarchar](10) NULL,
	[Cargo] [nvarchar](30) NULL,
	[Tratamiento] [nvarchar](25) NULL,
	[FechaNacimiento] [datetime] NULL,
	[FechaContratación] [datetime] NULL,
	[Dirección] [nvarchar](60) NULL,
	[Ciudad] [nvarchar](15) NULL,
	[Región] [nvarchar](15) NULL,
	[CódPostal] [nvarchar](10) NULL,
	[País] [nvarchar](15) NULL,
	[TelDomicilio] [nvarchar](24) NULL,
	[Extensión] [nvarchar](4) NULL,
	[Foto] [nvarchar](255) NULL,
	[Notas] [ntext] NULL,
	[Jefe] [int] NULL,
 CONSTRAINT [PK_EMPLEADOS] PRIMARY KEY CLUSTERED 
(
	[IdEmpleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EMPLEADOSTERRITORIOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPLEADOSTERRITORIOS](
	[Idempleado] [int] NOT NULL,
	[IdTerritorio] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_EMPLEADOSTERRITORIOS] PRIMARY KEY CLUSTERED 
(
	[Idempleado] ASC,
	[IdTerritorio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PEDIDOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PEDIDOS](
	[IdPedido] [int] NOT NULL,
	[IdCliente] [nvarchar](5) NULL,
	[IdEmpleado] [int] NULL,
	[FechaPedido] [datetime] NULL,
	[FechaEntrega] [datetime] NULL,
	[FechaEnvío] [datetime] NULL,
	[IdCompañíaEnvíos] [int] NULL,
	[Cargo] [money] NULL,
	[Destinatario] [nvarchar](40) NULL,
	[DirecciónDestinatario] [nvarchar](60) NULL,
	[CiudadDestinatario] [nvarchar](15) NULL,
	[RegiónDestinatario] [nvarchar](15) NULL,
	[CódPostalDestinatario] [nvarchar](10) NULL,
	[PaísDestinatario] [nvarchar](15) NULL,
 CONSTRAINT [PK_PEDIDOS] PRIMARY KEY CLUSTERED 
(
	[IdPedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRODUCTOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRODUCTOS](
	[IdProducto] [int] NOT NULL,
	[NombreProducto] [nvarchar](40) NULL,
	[IdProveedor] [int] NULL,
	[IdCategoría] [int] NULL,
	[CantidadPorUnidad] [nvarchar](20) NULL,
	[PrecioUnidad] [money] NULL,
	[UnidadesEnExistencia] [smallint] NULL,
	[UnidadesEnPedido] [smallint] NULL,
	[NivelNuevoPedido] [int] NULL,
	[Suspendido] [bit] NOT NULL,
 CONSTRAINT [PK_PRODUCTOS] PRIMARY KEY CLUSTERED 
(
	[IdProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PROVEEDORES]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROVEEDORES](
	[IdProveedor] [int] NOT NULL,
	[NombreCompañía] [nvarchar](40) NULL,
	[NombreContacto] [nvarchar](30) NULL,
	[CargoContacto] [nvarchar](30) NULL,
	[Dirección] [nvarchar](60) NULL,
	[Ciudad] [nvarchar](15) NULL,
	[Región] [nvarchar](15) NULL,
	[CódPostal] [nvarchar](10) NULL,
	[País] [nvarchar](15) NULL,
	[Teléfono] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
	[PáginaPrincipal] [ntext] NULL,
 CONSTRAINT [PK_PROVEEDORES] PRIMARY KEY CLUSTERED 
(
	[IdProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REGIONES]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REGIONES](
	[IdRegión] [int] NOT NULL,
	[Descripción] [nchar](50) NOT NULL,
 CONSTRAINT [PK_REGIONES] PRIMARY KEY CLUSTERED 
(
	[IdRegión] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TERRITORIOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TERRITORIOS](
	[IdTerritorio] [nvarchar](20) NOT NULL,
	[Descripción] [nchar](50) NOT NULL,
	[IdRegión] [int] NOT NULL,
 CONSTRAINT [PK_TERRITORIOS] PRIMARY KEY CLUSTERED 
(
	[IdTerritorio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[CLIENTES_PEDIDOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CLIENTES_PEDIDOS]
AS
	SELECT NOMBRECOMPAÑÍA AS NOMCLIENTE,IDPEDIDO,FECHAPEDIDO
		FROM CLIENTES C INNER JOIN PEDIDOS P
					 ON C.IDCLIENTE=P.IDCLIENTE

GO
/****** Object:  View [dbo].[VALORPEDIDOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VALORPEDIDOS]
AS
	SELECT P.IDPEDIDO, SUM(PRECIOUNIDAD*CANTIDAD) AS VALORPEDIDO
		FROM PEDIDOS P INNER JOIN [DETALLES DE PEDIDOS] DDP
					ON P.IDPEDIDO=DDP.IDPEDIDO
		GROUP BY P.IDPEDIDO

GO
/****** Object:  View [dbo].[CLIENTES_FECHAS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CLIENTES_FECHAS]	
AS
	SELECT NOMCLIENTE,FECHAPEDIDO,VALORPEDIDO
		FROM CLIENTES_PEDIDOS A INNER JOIN VALORPEDIDOS B
			                   ON A.IDPEDIDO = B.IDPEDIDO

GO
/****** Object:  View [dbo].[VENDEDOR_VENTAS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VENDEDOR_VENTAS]
AS
	SELECT APELLIDOS,SUM(VALORPEDIDO) AS VALORVENTAS
		FROM (SELECT APELLIDOS, IDPEDIDO
				FROM EMPLEADOS E INNER JOIN PEDIDOS P
							  ON E.IDEMPLEADO = P.IDEMPLEADO) A
					INNER JOIN
			VALORPEDIDOS VP
					ON A.IDPEDIDO = VP.IDPEDIDO
		GROUP BY APELLIDOS

GO
/****** Object:  View [dbo].[PEDIDOS_CLIENTES_AÑO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PEDIDOS_CLIENTES_AÑO]
AS
SELECT NOMBRECOMPAÑÍA AS CLIENTE,SUM(VALORPEDIDO)AS VALORPEDIDOS,YEAR(FECHAPEDIDO) AS AÑO
				FROM CLIENTES C 
						INNER JOIN 
					(SELECT IDCLIENTE,VALORPEDIDO,FECHAPEDIDO
						FROM PEDIDOS P INNER JOIN VALORPEDIDOS VP
									ON P.IDPEDIDO = VP.IDPEDIDO) A
				    		ON C.IDCLIENTE = A.IDCLIENTE
		GROUP BY NOMBRECOMPAÑÍA,YEAR(FECHAPEDIDO)


GO
/****** Object:  View [dbo].[PEDIDOS_VENDEDORES_MES]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PEDIDOS_VENDEDORES_MES]
AS
	SELECT APELLIDOS AS EMPLEADO,SUM(VALORPEDIDO)AS VALORPEDIDOS,
			YEAR(FECHAPEDIDO) AS AÑO, MONTH(FECHAPEDIDO) AS MES
		FROM EMPLEADOS  E
				INNER JOIN 
			(SELECT IDEMPLEADO,VALORPEDIDO,FECHAPEDIDO
				FROM PEDIDOS P INNER JOIN VALORPEDIDOS VP
							ON P.IDPEDIDO = VP.IDPEDIDO) A
		    		ON E.IDEMPLEADO = A.IDEMPLEADO
		GROUP BY APELLIDOS,YEAR(FECHAPEDIDO), MONTH(FECHAPEDIDO)

GO
/****** Object:  View [dbo].[VENTAS_ANUALES_POR_CLIENTE_Y_VENDEDOR]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VENTAS_ANUALES_POR_CLIENTE_Y_VENDEDOR]
AS
	SELECT IDCLIENTE,IDEMPLEADO,YEAR(FECHAPEDIDO) AS AÑO,SUM(VALORPEDIDO) AS VALORTOTAL
		FROM PEDIDOS P INNER JOIN VALORPEDIDOS VP
				ON P.IDPEDIDO = VP.IDPEDIDO
	GROUP BY YEAR(FECHAPEDIDO),IDCLIENTE,IDEMPLEADO

GO
/****** Object:  View [dbo].[VISTA_CATEG_PROD]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VISTA_CATEG_PROD]
AS
SELECT PAÍS,NOMBRECATEGORÍA,NOMBRECOMPAÑÍA,NOMBREPRODUCTO,PRECIOUNIDAD
FROM CATEGORÍAS C INNER JOIN
(SELECT PAÍS,IDCATEGORÍA,NOMBRECOMPAÑÍA,NOMBREPRODUCTO,PRECIOUNIDAD
FROM PRODUCTOS PROD INNER JOIN PROVEEDORES PROV
ON PROD.IDPROVEEDOR=PROV.IDPROVEEDOR) B
ON C.IDCATEGORÍA=B.IDCATEGORÍA

GO
/****** Object:  UserDefinedFunction [dbo].[PROVEEDORES_CATEGORÍAS_POR_PAÍSES]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PROVEEDORES_CATEGORÍAS_POR_PAÍSES]
(@PAÍS			nvarchar(15),
 @NOMBRECATEGORÍA	nvarchar(15))
 RETURNS TABLE
AS
	RETURN (SELECT NOMBRECOMPAÑÍA AS PROVEEDOR,NOMBREPRODUCTO AS PRODUCTO, PRECIOUNIDAD AS PRECIO
			FROM VISTA_CATEG_PROD
			WHERE PAÍS = @PAÍS AND NOMBRECATEGORÍA = @NOMBRECATEGORÍA)

GO
/****** Object:  View [dbo].[VALOR_VENTAS_POR_EMPLEADO_Y_FECHA]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VALOR_VENTAS_POR_EMPLEADO_Y_FECHA]
AS
SELECT IDEMPLEADO,FECHAPEDIDO,SUM(VALORPEDIDO) AS VALORVENTAS
	FROM PEDIDOS P INNER JOIN VALORPEDIDOS VP
				ON P.IDPEDIDO = VP.IDPEDIDO
	GROUP BY IDEMPLEADO,FECHAPEDIDO

GO
/****** Object:  View [dbo].[COMPAÑÍAS_POR_PAÍSES]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[COMPAÑÍAS_POR_PAÍSES]
AS
SELECT NOMBRECOMPAÑÍA,NUMENVÍOS,PAÍSDESTINATARIO
	FROM [COMPAÑÍAS DE ENVÍOS]  INNER JOIN
		(SELECT FORMAENVÍO,PAÍSDESTINATARIO,COUNT(*) AS NUMENVÍOS
			FROM PEDIDOS
			GROUP BY FORMAENVÍO,PAÍSDESTINATARIO) A
							ON IDCOMPAÑÍAENVÍOS = FORMAENVÍO

GO
/****** Object:  UserDefinedFunction [dbo].[PAÍS_DESTINO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PAÍS_DESTINO]
(@PAÍSDESTINATARIO	nvarchar(15))

RETURNS TABLE
AS
RETURN
	(SELECT  NOMBRECOMPAÑÍA,NUMENVÍOS
		FROM COMPAÑÍAS_POR_PAÍSES
		WHERE PAÍSDESTINATARIO = @PAÍSDESTINATARIO)

GO
/****** Object:  View [dbo].[EMPLEADOS_PEDIDOS_POR_AÑO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EMPLEADOS_PEDIDOS_POR_AÑO]
AS
SELECT REGIÓN,A.IDEMPLEADO,AÑO,VALORPEDIDOSAÑO
	FROM
		(SELECT IDEMPLEADO,YEAR(FECHAPEDIDO) AS AÑO, SUM(VALORPEDIDO) AS VALORPEDIDOSAÑO
			FROM PEDIDOS P INNER JOIN VALORPEDIDOS VP
						ON P.IDPEDIDO = VP.IDPEDIDO
			GROUP BY IDEMPLEADO, YEAR(FECHAPEDIDO)) A
					INNER JOIN

		(SELECT DISTINCT R.DESCRIPCIÓN AS REGIÓN,IDEMPLEADO
			FROM REGIONES R INNER JOIN TERRITORIOS T
							INNER JOIN EMPLEADOSTERRITORIOS ET
							ON T.IDTERRITORIO =ET.IDTERRITORIO
						ON R.IDREGIÓN = T.IDREGIÓN) B
					ON A.IDEMPLEADO = B.IDEMPLEADO

GO
/****** Object:  View [dbo].[VENTAS_POR_REGIÓN_EMPLEADO_Y_AÑO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VENTAS_POR_REGIÓN_EMPLEADO_Y_AÑO]
AS
SELECT DISTINCT R.DESCRIPCIÓN REGIÓN,APELLIDOS,AÑO,VALORPEDIDOSAÑO
	FROM (SELECT IDEMPLEADO,YEAR(FECHAPEDIDO) AÑO,SUM(VALORPEDIDO) VALORPEDIDOSAÑO
			FROM	PEDIDOS P INNER JOIN VALORPEDIDOS VP
		     		     ON P.IDPEDIDO =VP.IDPEDIDO
			GROUP BY IDEMPLEADO,YEAR(FECHAPEDIDO)) A
						INNER JOIN
						EMPLEADOS E INNER JOIN
								  EMPLEADOSTERRITORIOS ET INNER JOIN 
													 TERRITORIOS T INNER JOIN
																REGIONES R
																ON T.IDREGIÓN=R.IDREGIÓN
													  ON ET.IDTERRITORIO=T.IDTERRITORIO
								   ON E.IDEMPLEADO=ET.IDEMPLEADO
						ON A.IDEMPLEADO=E.IDEMPLEADO
				 			
							
											    

					
					
				  		
											
		
			
				 

GO
/****** Object:  UserDefinedFunction [dbo].[Clientes_por_regiones]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Clientes_por_regiones]
	(@región nvarchar(30))
	RETURNS table
AS
	RETURN 
		(SELECT idcliente, nombrecompañía,región
			FROM clientes
			WHERE 	región = @región)

GO
/****** Object:  UserDefinedFunction [dbo].[LÍNEA_DATOS_PEDIDOS_CLIENTE]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LÍNEA_DATOS_PEDIDOS_CLIENTE]
	(@NOMBRECLIENTE nvarchar(40))
	 RETURNS table
AS
RETURN
	(SELECT MAX(FECHAPEDIDO) AS FECHA
		FROM CLIENTES C INNER JOIN PEDIDOS P
					 ON C.IDCLIENTE = P.IDCLIENTE
		WHERE NOMBRECOMPAÑÍA = @NOMBRECLIENTE)

GO
/****** Object:  View [dbo].[CATEGORÍAS_AÑOS_VENTAS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CATEGORÍAS_AÑOS_VENTAS]
AS
	SELECT TOP 24 NOMBRECATEGORÍA, AÑO, SUM(VALORVENTAS) AS VENTASCATEGORÍA
		FROM (SELECT NOMBRECATEGORÍA,IDPRODUCTO
				FROM CATEGORÍAS C INNER JOIN PRODUCTOS P
							   ON C.IDCATEGORÍA =P.IDCATEGORÍA) A
				INNER JOIN
			(SELECT YEAR(FECHAPEDIDO)AS AÑO,IDPRODUCTO,SUM(CANTIDAD*PRECIOUNIDAD) AS VALORVENTAS
				FROM PEDIDOS P INNER JOIN [DETALLES DE PEDIDOS] DDP
							ON P.IDPEDIDO =DDP.IDPEDIDO
				GROUP BY YEAR(FECHAPEDIDO),IDPRODUCTO) B
				ON A.IDPRODUCTO = B.IDPRODUCTO
		GROUP BY AÑO,NOMBRECATEGORÍA
		ORDER BY NOMBRECATEGORÍA,AÑO

GO
/****** Object:  View [dbo].[CATEGORÍAS_PRODUCTOS_PRECIOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CATEGORÍAS_PRODUCTOS_PRECIOS]
AS
	SELECT TOP 77 NOMBRECATEGORÍA,NOMBREPRODUCTO,PRECIOUNIDAD
		FROM CATEGORÍAS C INNER JOIN PRODUCTOS P
				   ON C.IDCATEGORÍA = P.IDCATEGORÍA
		ORDER BY NOMBRECATEGORÍA,PRECIOUNIDAD DESC

GO
/****** Object:  View [dbo].[COMPAÑÍAS_PAÍSES]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[COMPAÑÍAS_PAÍSES]
AS
SELECT NOMBRECOMPAÑÍA,NUMENVÍOS,PAÍSDESTINATARIO
	FROM [COMPAÑÍAS DE ENVÍOS]  INNER JOIN
		(SELECT FORMAENVÍO,PAÍSDESTINATARIO,COUNT(*) AS NUMENVÍOS
			FROM PEDIDOS
			GROUP BY FORMAENVÍO,PAÍSDESTINATARIO) A
							ON IDCOMPAÑÍAENVÍOS = FORMAENVÍO

GO
/****** Object:  View [dbo].[TOTALPEDIDO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TOTALPEDIDO]
AS
SELECT IDPEDIDO, SUM(PRECIOUNIDAD*CANTIDAD) AS TOTALPEDIDO
	FROM [DETALLES DE PEDIDOS]
	GROUP BY IDPEDIDO

GO
/****** Object:  View [dbo].[ValorVentasEmpleados]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[ValorVentasEmpleados] as
select apellidos,SUM(dbo.valorpedidocon(idpedido)) valor
from empleados inner join PEDIDOS on (empleados.idempleado=pedidos.idempleado)
group by apellidos
GO
/****** Object:  View [dbo].[VMejorClienteAño]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create view [dbo].[VMejorClienteAño] as
 select IdCliente,YEAR(FechaPedido) Año, SUM(dbo.ValorPedidosin(IdPedido)) Valor
 from PEDIDOS
 group by IdCliente,YEAR(fechapedido)




GO
/****** Object:  View [dbo].[vregiones]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vregiones] as
	select descripción, IdEmpleado
	from REGIONES, empleados e
	where IdRegión in (select IdRegión
						from TERRITORIOS
						where IdTerritorio in (select idterritorio
												from EMPLEADOSTERRITORIOS
												where Idempleado = e.IdEmpleado))

GO
ALTER TABLE [dbo].[DETALLES DE PEDIDOS]  WITH CHECK ADD  CONSTRAINT [FK_DETALLES DE PEDIDOS_PEDIDOS] FOREIGN KEY([IdPedido])
REFERENCES [dbo].[PEDIDOS] ([IdPedido])
GO
ALTER TABLE [dbo].[DETALLES DE PEDIDOS] CHECK CONSTRAINT [FK_DETALLES DE PEDIDOS_PEDIDOS]
GO
ALTER TABLE [dbo].[DETALLES DE PEDIDOS]  WITH CHECK ADD  CONSTRAINT [FK_DETALLES DE PEDIDOS_PRODUCTOS] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[PRODUCTOS] ([IdProducto])
GO
ALTER TABLE [dbo].[DETALLES DE PEDIDOS] CHECK CONSTRAINT [FK_DETALLES DE PEDIDOS_PRODUCTOS]
GO
ALTER TABLE [dbo].[EMPLEADOSTERRITORIOS]  WITH CHECK ADD  CONSTRAINT [FK_EMPLEADOSTERRITORIOS_EMPLEADOS] FOREIGN KEY([Idempleado])
REFERENCES [dbo].[EMPLEADOS] ([IdEmpleado])
GO
ALTER TABLE [dbo].[EMPLEADOSTERRITORIOS] CHECK CONSTRAINT [FK_EMPLEADOSTERRITORIOS_EMPLEADOS]
GO
ALTER TABLE [dbo].[EMPLEADOSTERRITORIOS]  WITH CHECK ADD  CONSTRAINT [FK_EMPLEADOSTERRITORIOS_TERRITORIOS] FOREIGN KEY([IdTerritorio])
REFERENCES [dbo].[TERRITORIOS] ([IdTerritorio])
GO
ALTER TABLE [dbo].[EMPLEADOSTERRITORIOS] CHECK CONSTRAINT [FK_EMPLEADOSTERRITORIOS_TERRITORIOS]
GO
ALTER TABLE [dbo].[PEDIDOS]  WITH CHECK ADD  CONSTRAINT [FK_PEDIDOS_CLIENTES] FOREIGN KEY([IdCliente])
REFERENCES [dbo].[CLIENTES] ([IdCliente])
GO
ALTER TABLE [dbo].[PEDIDOS] CHECK CONSTRAINT [FK_PEDIDOS_CLIENTES]
GO
ALTER TABLE [dbo].[PEDIDOS]  WITH CHECK ADD  CONSTRAINT [FK_PEDIDOS_COMPAÑÍAS DE ENVÍOS] FOREIGN KEY([IdCompañíaEnvíos])
REFERENCES [dbo].[COMPAÑÍAS DE ENVÍOS] ([IdCompañíaEnvíos])
GO
ALTER TABLE [dbo].[PEDIDOS] CHECK CONSTRAINT [FK_PEDIDOS_COMPAÑÍAS DE ENVÍOS]
GO
ALTER TABLE [dbo].[PEDIDOS]  WITH CHECK ADD  CONSTRAINT [FK_PEDIDOS_EMPLEADOS] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[EMPLEADOS] ([IdEmpleado])
GO
ALTER TABLE [dbo].[PEDIDOS] CHECK CONSTRAINT [FK_PEDIDOS_EMPLEADOS]
GO
ALTER TABLE [dbo].[PRODUCTOS]  WITH CHECK ADD  CONSTRAINT [FK_PRODUCTOS_CATEGORÍAS] FOREIGN KEY([IdCategoría])
REFERENCES [dbo].[CATEGORÍAS] ([IdCategoría])
GO
ALTER TABLE [dbo].[PRODUCTOS] CHECK CONSTRAINT [FK_PRODUCTOS_CATEGORÍAS]
GO
ALTER TABLE [dbo].[PRODUCTOS]  WITH CHECK ADD  CONSTRAINT [FK_PRODUCTOS_PROVEEDORES] FOREIGN KEY([IdProveedor])
REFERENCES [dbo].[PROVEEDORES] ([IdProveedor])
GO
ALTER TABLE [dbo].[PRODUCTOS] CHECK CONSTRAINT [FK_PRODUCTOS_PROVEEDORES]
GO
ALTER TABLE [dbo].[TERRITORIOS]  WITH CHECK ADD  CONSTRAINT [FK_TERRITORIOS_REGIONES] FOREIGN KEY([IdRegión])
REFERENCES [dbo].[REGIONES] ([IdRegión])
GO
ALTER TABLE [dbo].[TERRITORIOS] CHECK CONSTRAINT [FK_TERRITORIOS_REGIONES]
GO
/****** Object:  StoredProcedure [dbo].[AACINCO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AACINCO]
@DÍAS		int				OUTPUT,
@VALORREAL	numeric(12,2)	OUTPUT,
@IDPEDIDO	int
AS
BEGIN
SET @DÍAS = (SELECT DAY(FECHAENTREGA - FECHAPEDIDO)
				FROM PEDIDOS
				WHERE IDPEDIDO = @IDPEDIDO)

SET @VALORREAL =
(SELECT VALORLÍNEAS+CARGO 
	FROM PEDIDOS P INNER JOIN
(SELECT IDPEDIDO, SUM((PRECIOUNIDAD*CANTIDAD)*(1-DESCUENTO))
			AS VALORLÍNEAS
	FROM [DETALLES DE PEDIDOS] 
	WHERE IDPEDIDO = @IDPEDIDO
	GROUP BY IDPEDIDO) A
				ON P.IDPEDIDO = A.IDPEDIDO)
END


GO
/****** Object:  StoredProcedure [dbo].[AACUATRO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AACUATRO]
@nombreproducto nvarchar(40) output,
@nombrecategoría nvarchar(15),
@año int
as
  declare @idcategoría int
  select @idcategoría=idcategoría
    from categorías
    where nombrecategoría=@nombrecategoría

  select @nombreproducto=nombreproducto
    from (
      select top 1 nombreproducto,sum(cantidad)as cant
	from productos pr join (
		pedidos p join [detalles de pedidos] dp
		on p.idpedido=dp.idpedido)
	      on pr.idproducto=dp.idproducto
	where year(fechapedido)=@año and idcategoría=@idcategoría
	group by nombreproducto
	order by sum(cantidad) desc) a

GO
/****** Object:  StoredProcedure [dbo].[AATRES]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AATRES]
@año int output,
@mes int output,
@nombrecliente nvarchar(40)
as
  declare @idcliente nvarchar(5)

  select @idcliente=idcliente
    from clientes
    where nombrecompañía=@nombrecliente

  select @año=año,@mes=mes
  from (
    select top 1 year(fechapedido)año,month(fechapedido)mes,
	         sum(preciounidad*cantidad) as valorpedidos
      from pedidos p join [detalles de pedidos] dp
	             on p.idpedido=dp.idpedido
      where idcliente=@idcliente
      group by year(fechapedido),month(fechapedido)
      order by valorpedidos desc) a


GO
/****** Object:  StoredProcedure [dbo].[ACINCO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ACINCO]
@NOMCLI 	nvarchar(40)	OUTPUT,
@NOMEMP	nvarchar(31)	OUTPUT,
@FECHPED	datetime		OUTPUT,
@NOMENV	nvarchar(40)	OUTPUT,
@IDPED	int
AS
BEGIN
	DECLARE @IDCLI	nvarchar(5)
	DECLARE @IDEMP	int
	DECLARE @IDENV	int
	SELECT @IDCLI = IDCLIENTE, @IDEMP = IDEMPLEADO, @FECHPED =FECHAPEDIDO, @IDENV = FORMAENVÍO
		FROM PEDIDOS
		WHERE IDPEDIDO =@IDPED
	SELECT @NOMCLI = NOMBRECOMPAÑÍA
		FROM CLIENTES
		WHERE IDCLIENTE = @IDCLI
	SELECT @NOMEMP = NOMBRE+' '+APELLIDOS
		FROM EMPLEADOS
		WHERE IDEMPLEADO = @IDEMP
	SELECT @NOMENV = NOMBRECOMPAÑÍA
		FROM [COMPAÑÍAS DE ENVÍOS]
		WHERE IDCOMPAÑÍAENVÍOS = @IDENV
END


GO
/****** Object:  StoredProcedure [dbo].[ACUATRO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ACUATRO]
@numpedidos int output,
@valortotal real output,
@apellidos nvarchar(20),
@año int
as
  declare @idempleado int
 
  select @idempleado=idempleado
    from empleados
    where apellidos=@apellidos

  select @numpedidos=numpedidos,@valortotal=valortotal
    from (  
      select count(*)numpedidos,
             sum(preciounidad*cantidad)valortotal
        from pedidos p join [detalles de pedidos] dp
	                on p.idpedido=dp.idpedido
        where year(fechapedido)=@año and idempleado=@idempleado) a

GO
/****** Object:  StoredProcedure [dbo].[ASIGNADO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ASIGNADO]
@APELLIDOS	nvarchar(20)
AS
BEGIN
DECLARE @JEFE	int
SELECT @JEFE=IDEMPLEADO
FROM EMPLEADOS
WHERE APELLIDOS = @APELLIDOS
DECLARE @VAPELLIDOS	nvarchar(20)
SET @VAPELLIDOS=@APELLIDOS
IF NOT EXISTS (SELECT *
				FROM EMPLEADOS
				WHERE JEFE = @JEFE)
	SELECT 'El Sr. '+@VAPELLIDOS+' no tiene empleados asignados'
ELSE
	BEGIN
	SELECT 'Empleados asignados al Sr. '+@VAPELLIDOS+':'
	SELECT APELLIDOS
		FROM EMPLEADOS
		WHERE JEFE = @JEFE
	END
END

GO
/****** Object:  StoredProcedure [dbo].[BBCINCO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BBCINCO]
@DÍAS		int				OUTPUT,
@VALORREAL	numeric(12,2)	OUTPUT,
@IDPEDIDO	int
AS
BEGIN
SET @DÍAS = (SELECT DAY(FECHAENTREGA - FECHAPEDIDO)
				FROM PEDIDOS
				WHERE IDPEDIDO = @IDPEDIDO)

SET @VALORREAL =
(SELECT VALORLÍNEAS+CARGO 
	FROM PEDIDOS P INNER JOIN
(SELECT IDPEDIDO, SUM((PRECIOUNIDAD*CANTIDAD)*(1-DESCUENTO))
			AS VALORLÍNEAS
	FROM [DETALLES DE PEDIDOS] 
	WHERE IDPEDIDO = @IDPEDIDO
	GROUP BY IDPEDIDO) A
				ON P.IDPEDIDO = A.IDPEDIDO)
END


GO
/****** Object:  StoredProcedure [dbo].[BCINCO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BCINCO]
@DÍAS		int				OUTPUT,
@VALORREAL	numeric(12,2)	OUTPUT,
@IDPEDIDO	int
AS
BEGIN
SET @DÍAS = (SELECT DAY(FECHAENTREGA - FECHAPEDIDO)
				FROM PEDIDOS
				WHERE IDPEDIDO = @IDPEDIDO)

SET @VALORREAL =
(SELECT VALORLÍNEAS+CARGO 
	FROM PEDIDOS P INNER JOIN
(SELECT IDPEDIDO, SUM((PRECIOUNIDAD*CANTIDAD)*(1-DESCUENTO))
			AS VALORLÍNEAS
	FROM [DETALLES DE PEDIDOS] 
	WHERE IDPEDIDO = @IDPEDIDO
	GROUP BY IDPEDIDO) A
				ON P.IDPEDIDO = A.IDPEDIDO)
END

GO
/****** Object:  StoredProcedure [dbo].[BTRES]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BTRES]
@año int output,
@mes int output,
@nombrecliente nvarchar(40)
as
  declare @idcliente nvarchar(5)

  select @idcliente=idcliente
    from clientes
    where nombrecompañía=@nombrecliente

  select @año=año,@mes=mes
  from (
    select top 1 year(fechapedido)año,month(fechapedido)mes,
	         sum(preciounidad*cantidad) as valorpedidos
      from pedidos p join [detalles de pedidos] dp
	             on p.idpedido=dp.idpedido
      where idcliente=@idcliente
      group by year(fechapedido),month(fechapedido)
      order by valorpedidos desc) a


GO
/****** Object:  StoredProcedure [dbo].[BUATRO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BUATRO]
@nombreproducto nvarchar(40) output,
@nombrecategoría nvarchar(15),
@año int
as
  declare @idcategoría int
  select @idcategoría=idcategoría
    from categorías
    where nombrecategoría=@nombrecategoría

  select @nombreproducto=nombreproducto
    from (
      select top 1 nombreproducto,sum(cantidad)as cant
	from productos pr join (
		pedidos p join [detalles de pedidos] dp
		on p.idpedido=dp.idpedido)
	      on pr.idproducto=dp.idproducto
	where year(fechapedido)=@año and idcategoría=@idcategoría
	group by nombreproducto
	order by sum(cantidad) desc) a

GO
/****** Object:  StoredProcedure [dbo].[CUATRO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CUATRO]
@numpedidos int output,
@valortotal real output,
@apellidos nvarchar(20),
@año int
as
  declare @idempleado int
 
  select @idempleado=idempleado
    from empleados
    where apellidos=@apellidos

  select @numpedidos=numpedidos,@valortotal=valortotal
    from (  
      select count(*)numpedidos,
             sum(preciounidad*cantidad)valortotal
        from pedidos p join [detalles de pedidos] dp
	                on p.idpedido=dp.idpedido
        where year(fechapedido)=@año and idempleado=@idempleado) a


GO
/****** Object:  StoredProcedure [dbo].[DATOSPEDIDO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DATOSPEDIDO]
@NOMCLI 	nvarchar(40)	OUTPUT,
@NOMEMP	nvarchar(31)	OUTPUT,
@FECHPED	datetime		OUTPUT,
@NOMENV	nvarchar(40)	OUTPUT,
@IDPED	int
AS
BEGIN
	DECLARE @IDCLI	nvarchar(5)
	DECLARE @IDEMP	int
	DECLARE @IDENV	int
	--DECLARE @FECHPED datetime
	SELECT @IDCLI = IDCLIENTE, @IDEMP = IDEMPLEADO, @FECHPED =FECHAPEDIDO, @IDENV = FORMAENVÍO
		FROM PEDIDOS
		WHERE IDPEDIDO = 10250
	SELECT @NOMCLI = NOMBRECOMPAÑÍA
		FROM CLIENTES
		WHERE IDCLIENTE = @IDCLI
	SELECT @NOMEMP = NOMBRE+' '+APELLIDOS
		FROM EMPLEADOS
		WHERE IDEMPLEADO = @IDEMP
	SELECT @NOMENV = NOMBRECOMPAÑÍA
		FROM [COMPAÑÍAS DE ENVÍOS]
		WHERE IDCOMPAÑÍAENVÍOS = @IDENV
END

GO
/****** Object:  StoredProcedure [dbo].[EJEMPLO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[EJEMPLO]
@idempleado int = null,
@apellidos  char(20)='King'
AS
--SET @apellidos='King'
SELECT @idempleado=idempleado
  FROM empleados
  WHERE apellidos=@apellidos
SELECT @idempleado AS Código

GO
/****** Object:  StoredProcedure [dbo].[ejemplo1]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ejemplo1]
@uno int,
@dos int,
@tres int,
@cuatro int = 4,
@cinco int = NULL
AS
SELECT @uno as uno,@dos as dos,@tres as tres,@cuatro as cuatro,@cinco as cinco

GO
/****** Object:  StoredProcedure [dbo].[ejemplo2]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ejemplo2]
@uno int,
@dos int =2,
@tres int,
@cuatro int = NULL,
@cinco int 
AS
SELECT @uno as uno,@dos as dos,@tres as tres,@cuatro as cuatro,@cinco as cinco

GO
/****** Object:  StoredProcedure [dbo].[ejemplo3]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ejemplo3]
@idempleado int OUTPUT,
@apellidos     nvarchar(20)
AS
SELECT @idempleado=idempleado
  FROM empleados
  WHERE apellidos=@apellidos

GO
/****** Object:  StoredProcedure [dbo].[JefesRegiones]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* función que obtine el identificador del empleado, si este existe, en otro caso devolverá el valor -1, que no puede
ser un identificador de ningún empleado*/
/*create function identificador_empleado(@apellidoEmpleado varchar(40)) returns int
begin
 declare @idempleado int
 select @idempleado=idEmpleado
 from EMPLEADOS
 where Apellidos=@apellidoEmpleado
 
 if @idempleado is null set @idempleado=-1
 return @idempleado
 
 end
 
 go*/
 /* ahora hago el procedimiento, obteniendo el jefe del empleado, utilizando el idempleado que obtengo de la funcion*/
 
 CREATE proc [dbo].[JefesRegiones] 
 @ApellidosEmpleado varchar(40),
 @NombreJefe varchar(40) output,
 @ApellidosJefe varchar(40) output,
 @region varchar(20) output
 
 as
 -- llamamos a la función para obtener el identificador del empleado
 declare @idEmpleado int
 select @idEmpleado=dbo.identificador_empleado(@apellidosEmpleado)
 -- si no existe el empleado, damos como nombre de jefe un mensaje de error. tenemos que asignar valor a todas
 --las variables de salida, pues contendrían valor null, al no extraer nada de la consulta. 
 if @idEmpleado=-1 
					 begin
                     set @NombreJefe='el empleado no existe'
                     set @ApellidosJefe=' '
                     set @region=' '
                     end
 -- si existe, continuamos buscando todos los datos, como hay varias sentencias van entre begin y end
    else
        begin
        --sacamos los datos del jefe
        declare @idjefe int
        
        select @idjefe=jefe
        from EMPLEADOS
        where IdEmpleado=@idempleado
        /* obtenemos el nombre y apellidos del jefe*/
        select @NombreJefe=Nombre, @ApellidosJefe=apellidos
        from EMPLEADOS
        where IdEmpleado=@idjefe
        /* comprobamos el valor de la variable por si no tiene jefe, esta en ese caso, contendrá null, la select no
        sacaría nada, habría que preguntar si exists*/
        if @NombreJefe is null begin set @NombreJefe='no tiene jefe'
                                     set @apellidosjefe=' ' end
        
        -- por ultimo obtenemos la región
        select @region=descripción
        from REGIONES 
        where idregión in (select idregión
                           from TERRITORIOS
                           where IdTerritorio in (select IdTerritorio
                                                  from EMPLEADOSTERRITORIOS
                                                  where Idempleado=@idEmpleado))
        end
        
      /* declare @nombreJefe varchar(40),
                @ApellidosJefe varchar(40),
                @region varchar(20) 
                
        exec JefesRegiones 'fuller',@nombreJefe output,@apellidosjefe output,@region output
        
        select @nombreJefe+' '+@ApellidosJefe "nombre y apellidos del jefe", @region region*/
 
 
 
GO
/****** Object:  StoredProcedure [dbo].[JERARQUÍAS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[JERARQUÍAS]
	@NOMBRE1 nvarchar(10),
	@NOMBRE2 nvarchar(10),
	@IDEMPLEADO1 int = NULL,
	@IDEMPLEADO2 int = NULL,
	@JEFE1 int = NULL,
	@JEFE2 int = NULL
AS
	SELECT @IDEMPLEADO1=IDEMPLEADO,@JEFE1=JEFE
		FROM EMPLEADOS
		WHERE NOMBRE=@NOMBRE1

	SELECT @IDEMPLEADO2=IDEMPLEADO,@JEFE2=JEFE
		FROM EMPLEADOS
		WHERE NOMBRE=@NOMBRE2

	IF @JEFE1=@IDEMPLEADO2
		SELECT 'El jefe de ',@NOMBRE1, ' es ',@NOMBRE2
	ELSE 
		IF @JEFE2=@IDEMPLEADO1
			SELECT 'El jefe de ',@NOMBRE2, ' es ',@NOMBRE1
		ELSE 
			SELECT 'Entre ',@NOMBRE1,' y ',@NOMBRE2, 'no existe relación jerárquica'

GO
/****** Object:  StoredProcedure [dbo].[pa_compañias_misma_ciudad]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[pa_compañias_misma_ciudad]
	@apellido nvarchar(30),
	@nombre nvarchar(40) output
as
	select @nombre = nombrecompañía
	from proveedores
	where ciudad = (select ciudad
					from clientes
					where nombrecontacto like '%' + @apellido + '%')

	if (@@ROWCOUNT = 0) --No hay filas afectadas
		print 'No existe ningún proveedor en su ciudad'

declare @nombreComp nvarchar(40)
exec pa_compañias_misma_ciudad 'anders', @nombreComp output
print @nombreComp
GO
/****** Object:  StoredProcedure [dbo].[pa_pedido_reciente]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[pa_pedido_reciente]
	@nombreComp NVARCHAR(40),
	@resultado int OUTPUT
as
	if((select nombrecompañía from CLIENTES where NombreCompañía like '%' + @nombreComp + '%') is null)
		BEGIN
			PRINT 'La compañía no existe'
			RETURN 0
		END
	ELSE
		BEGIN
			select top 1 @resultado = IdPedido
			from PEDIDOS p inner join clientes c on p.IdCliente=c.IdCliente
								where NombreCompañía like '%' + @nombreComp + '%'
			order by FechaPedido desc
		END

GO
/****** Object:  StoredProcedure [dbo].[pa_producto_mas_caro]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pa_producto_mas_caro]
	@categoria nvarchar(15),
	@producto nvarchar(40) output,
	@precio money output
as
	select top 1 @producto = nombreproducto, @precio = preciounidad
	from productos
	where idcategoría in (select IdCategoría
							from CATEGORÍAS
							where NombreCategoría = @categoria)
	order by PrecioUnidad desc

GO
/****** Object:  StoredProcedure [dbo].[pa_ventas_empleado]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[pa_ventas_empleado]
	@apellido nvarchar(30),
	@ventas money output
as
	if(@apellido not in (select apellidos from empleados))
		begin
			print 'No existe el usuario'
			return 1
		end
	else
		begin
			select @ventas = sum(p.cargo)
			from empleados e inner join pedidos p on e.idempleado = p.idempleado
			where apellidos = @apellido

			if(@ventas is not null)
				return 0
			else
				begin
					print 'No existen ventas'
					return 2
				end
		end
GO
/****** Object:  StoredProcedure [dbo].[PRECIOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PRECIOS]
	@PRECIO money
AS
SELECT *
	FROM PRODUCTOS
	WHERE PRECIOUNIDAD < @PRECIO

GO
/****** Object:  StoredProcedure [dbo].[PROCCON_DATOS_PEDIDOS_CLIENTE]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROCCON_DATOS_PEDIDOS_CLIENTE]
	@FECHA		datetime	OUTPUT,
	@NOMBRECLIENTE nvarchar(40)
AS
BEGIN
	DECLARE @IDCLIENTE nvarchar(5)
	SELECT @IDCLIENTE = IDCLIENTE
		FROM CLIENTES
		WHERE NOMBRECOMPAÑÍA = @NOMBRECLIENTE
	SELECT @FECHA = MAX(FECHAPEDIDO)
	FROM PEDIDOS
	WHERE IDCLIENTE = @IDCLIENTE
END

GO
/****** Object:  StoredProcedure [dbo].[PROCSIN_DATOS_PEDIDOS_CLIENTE]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROCSIN_DATOS_PEDIDOS_CLIENTE]
	@NOMBRECLIENTE nvarchar(40)
AS
BEGIN
	DECLARE @IDCLIENTE nvarchar(5)
	SELECT @IDCLIENTE = IDCLIENTE
		FROM CLIENTES
		WHERE NOMBRECOMPAÑÍA = @NOMBRECLIENTE
	DECLARE @FECHA datetime
	SELECT @FECHA = MAX(FECHAPEDIDO)
		FROM PEDIDOS
		WHERE IDCLIENTE = @IDCLIENTE
	SELECT @FECHA
	--SELECT VALORPEDIDO
END

GO
/****** Object:  StoredProcedure [dbo].[PRODUCTO_MÁS_CARO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PRODUCTO_MÁS_CARO]
	@NOMBREPRODUCTO 	nvarchar(40)	OUTPUT,
	@NOMBRECATEGORÍA	nvarchar(15)
AS
	SELECT @NOMBREPRODUCTO =
		(SELECT TOP 1 NOMBREPRODUCTO
			FROM CATEGORÍAS_PRODUCTOS_PRECIOS
			WHERE NOMBRECATEGORÍA=@NOMBRECATEGORÍA)

GO
/****** Object:  StoredProcedure [dbo].[producto_mas_caro_1]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[producto_mas_caro_1]
@nombreproducto varchar(40) output,
@nombrecategoria varchar(15)
as
if not exists (select * from CATEGORÍAS_PRODUCTOS_PRECIOS where NOMBRECATEGORÍA=@nombrecategoria)
               set @nombreproducto='no existe la categoria'
   else
        select @nombreproducto=nombreproducto
        from categorías_productos_precios
        where NOMBRECATEGORÍA=@nombrecategoria and PRECIOUNIDAD=(select MAX(preciounidad)
                                                                 from CATEGORÍAS_PRODUCTOS_PRECIOS
                                                                 where NOMBRECATEGORÍA=@nombrecategoria)
                                                                        
GO
/****** Object:  StoredProcedure [dbo].[pvalorventasempleado]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[pvalorventasempleado] 

@apellidos varchar(20)
as 
--declare @valorventas varchar(20)
select VALOR
from valorventasempleados
where apellidos=@apellidos




/*exec pvalorventasempleado 
'suyama'*/



GO
/****** Object:  StoredProcedure [dbo].[UNO]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UNO]
@NOMBRECLIENTE nvarchar(40)
AS
	SELECT TOP 1 FECHAPEDIDO AS [FECHA DEL PEDIDO MÁS CARO]
		FROM CLIENTES_FECHAS
		WHERE NOMCLIENTE=@NOMBRECLIENTE
		ORDER BY VALORPEDIDO DESC

GO
/****** Object:  StoredProcedure [dbo].[VALOR_PEDIDOS]    Script Date: 05/06/2018 19:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[VALOR_PEDIDOS]
	@NUMPEDIDOS	 int			OUTPUT,
	@VALORPEDIDOS	 numeric(10,2)	OUTPUT,
	@NOMBRECOMPAÑÍA nvarchar(40),
	@FECHAINICIO 	 datetime,
	@FECHAFIN		 datetime
AS
	DECLARE @IDCLIENTE	nvarchar(5)
	SELECT @IDCLIENTE =IDCLIENTE
		FROM CLIENTES
		WHERE NOMBRECOMPAÑÍA = @NOMBRECOMPAÑÍA
	SELECT @NUMPEDIDOS = COUNT(*), @VALORPEDIDOS = SUM(VALORPEDIDO)
		FROM PEDIDOS P INNER JOIN VALORPEDIDOS VP
					ON P.IDPEDIDO = VP.IDPEDIDO
		WHERE (IDCLIENTE = @IDCLIENTE) AND FECHAPEDIDO BETWEEN @FECHAINICIO AND @FECHAFIN
	GROUP BY IDCLIENTE

GO
/****** Object:  StoredProcedure [dbo].[valor_pedidos_con]    Script Date: 05/06/2018 19:45:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[valor_pedidos_con]
@numpedidos int output,
@valorpedidos numeric(10,2) output,
@nombrecompañia varchar(40),
@fecha_inicio datetime,
@fecha_fin datetime
as
declare @idcliente varchar(5)
select @idcliente=idcliente
from CLIENTES
where NombreCompañía=@nombrecompañia

select @numpedidos=isnull(COUNT(*),0), @valorpedidos=isnull(SUM(valorpedido),0)
from PEDIDOS p inner join VALORPEDIDOS vp on (p.IdPedido=vp.IDPEDIDO)
where (IdCliente=@idcliente) and FechaPedido between @fecha_inicio and @fecha_fin
group by IdCliente

GO
/****** Object:  StoredProcedure [dbo].[VALOR_VENTAS]    Script Date: 05/06/2018 19:45:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[VALOR_VENTAS]
	@VALORVENTAS numeric(10,2)	OUTPUT,	
	@APELLIDOS nvarchar(20)
AS
	SELECT @VALORVENTAS = VALORVENTAS
		FROM VENDEDOR_VENTAS
		WHERE APELLIDOS =@APELLIDOS

GO
/****** Object:  StoredProcedure [dbo].[vCATEGORÍAS]    Script Date: 05/06/2018 19:45:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[vCATEGORÍAS]
@categoría NVARCHAR(15)
AS
SELECT NOMBREPRODUCTO
from categorías c inner join productos p
on c.idcategoría = p.idcategoría
where nombrecategoría=@categoría

GO
/****** Object:  StoredProcedure [dbo].[ventas]    Script Date: 05/06/2018 19:45:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ventas]
  @fechacomienzo datetime, @fechafin datetime
AS
  SELECT sum(preciounidad*cantidad)
    FROM pedidos p INNER JOIN [detalles de pedidos] dp
			ON p.idpedido=dp.idpedido
    WHERE fechapedido BETWEEN @fechacomienzo AND @fechafin


			


GO
/****** Object:  StoredProcedure [dbo].[VENTAS_POR_CATEGORÍA]    Script Date: 05/06/2018 19:45:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[VENTAS_POR_CATEGORÍA]
@AÑO	int
AS
	SELECT NOMBRECATEGORÍA,VENTASCATEGORÍA
		FROM CATEGORÍAS_AÑOS_VENTAS
		WHERE AÑO=@AÑO

GO
USE [master]
GO
ALTER DATABASE [compraventa] SET  READ_WRITE 
GO
