-- Base de datos ElectrodomesticosABC
-- Puro Galactico 
-- 21/02/25 Cusco Peru

use master
go

if DB_ID('BDElectrodomesticosABC') is not null
	drop database BDElectrodomesticosABC

go
create database BDElectrodomesticosABC
go

use BDElectrodomesticosABC
go

--Creacion de Proveedor
if OBJECT_ID('Proveedor','U') is not null
	drop table Proveedor
go
create table Proveedor
(
	idProv int primary key,
	nombreProv varchar(50),
	direccion varchar(50),
	telefono varchar(9),
	email varchar(50)
)
go

--Creacion de OrdendeCompra
if OBJECT_ID('OrdendeCompra','U') is not null
	drop table OrdendeCompra
go
create table OrdendeCompra
(
	OrdenCompraID int primary key,
	nombreProv varchar(50),
	fechaHoraCompra varchar(50),
	montoTotal decimal(8,2),
	idProv int,
	foreign key (idProv) references Proveedor(idProv)
)
go

--Creacion de tabla Cliente
if OBJECT_ID('Cliente', 'U') is not null
drop table Cliente
go

create table Cliente
(
	ClienteID int primary key,
	NombreCliente varchar(50),
	Direccion varchar(40),
	Telefono varchar(11),
	Email varchar(30),
)
go

-- Creación de Comprobante
IF OBJECT_ID('Comprobante', 'U') IS NOT NULL
drop table Comprobante;
go

create table Comprobante 
(
	ComprobanteID int primary key,
	DetalleID varchar(50),
	Fechahoraventa varchar(20),
	Montototal DECIMAL(8,2),
	ClienteID int,
	foreign key (ClienteID) references Cliente(ClienteID)
)
go

--Creacion de Electrodomestico

if OBJECT_ID('Electrodomestico','U') is not null
	drop table Electrodomestico
go
create table Electrodomestico 
(
	ElectrodomesticoID int primary key,
	NombreElectrodomestico varchar(50),
	Descripcion Decimal(8,2),
	Marca varchar(50),
	PrecioCompra decimal(8,2),
	PrecioVenta decimal(8,2),
)
go

--Creacion de DetalledeIngresoSalida
if OBJECT_ID('DetalledeIngresoSalida','U') is not null
	drop table etalledeIngresoSalida
go
create table etalledeIngresoSalida 
(
	DetallaID int primary key,
	Cantidad varchar(50),
	Subtotal Decimal(8,2),
	OrdenCompraID int,
	ElectrodomesticoID int,
	ComprobanteID int,
	foreign key (ComprobanteID) references Comprobante(ComprobanteID),
	foreign key (ElectrodomesticoID) references Electrodomestico(ElectrodomesticoID),
	foreign key (OrdenCompraID) references OrdendeCompra(OrdenCompraID)
)
go
	