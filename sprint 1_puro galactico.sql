USE MASTER;
GO

-- Si la base de datos ya existe, la elimina para una instalación limpia
IF DB_ID('ModeloLogico') IS NOT NULL
BEGIN
    -- Es necesario cerrar conexiones existentes antes de borrarla
    ALTER DATABASE ModeloLogico SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ModeloLogico;
END
GO

-- Crea la nueva base de datos
CREATE DATABASE ModeloLogico;
GO

-- Cambia el contexto a la nueva base de datos
USE ModeloLogico;
GO

-- 2. CREACIÓN DE TABLAS

PRINT 'Creando tablas...';

CREATE TABLE productos (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    NombreProd VARCHAR(100) NOT NULL UNIQUE,
    DescripcionProd VARCHAR(200),
    CategoriaProd VARCHAR(50),
    PrecioProd DECIMAL(10,2) NOT NULL CHECK (PrecioProd >= 0),
    UnidadMedida VARCHAR(50),
    ImagenP IMAGE
);
GO

CREATE TABLE proveedores (
    ProveedorID INT IDENTITY(1,1) PRIMARY KEY,
    NombreProv VARCHAR(100),
    ApellidoProv VARCHAR(100),
    DNIProv VARCHAR(20) UNIQUE,
    Comunidad VARCHAR(100),
    Region VARCHAR(100),
    Telefono VARCHAR(20),
    Email VARCHAR(100) UNIQUE,
    ProductoID INT,
    FOREIGN KEY (ProductoID) REFERENCES productos(ProductoID)
);
GO

CREATE TABLE clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    NombreC VARCHAR(100),
    ApellidoC VARCHAR(100),
    DNIC VARCHAR(20) UNIQUE,
    Direccion VARCHAR(255),
    Telefono VARCHAR(20),
    Email VARCHAR(100) UNIQUE NOT NULL
);
GO

CREATE TABLE usuarioPlataforma (
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT NOT NULL UNIQUE, -- Un cliente solo debe tener un usuario
    Contraseña VARCHAR(255) NOT NULL, -- En un sistema real, esto debería estar hasheado
    Rol VARCHAR(50) DEFAULT 'Cliente',
    FOREIGN KEY (ClienteID) REFERENCES clientes(ClienteID)
);
GO

CREATE TABLE pedidos (
    PedidoID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT,
    FechaPedido DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (ClienteID) REFERENCES clientes(ClienteID)
);
GO

CREATE TABLE detallesPedido (
    DetalleID INT IDENTITY(1,1) PRIMARY KEY,
    PedidoID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (PedidoID) REFERENCES pedidos(PedidoID),
    FOREIGN KEY (ProductoID) REFERENCES productos(ProductoID)
);
GO

CREATE TABLE pagos (
    PagoID INT IDENTITY(1,1) PRIMARY KEY,
    PedidoID INT NOT NULL,
    Monto DECIMAL(10,2) NOT NULL,
    FechaPago DATE NOT NULL,
    FOREIGN KEY (PedidoID) REFERENCES pedidos(PedidoID)
);
GO

CREATE TABLE metodoPago (
    MetodoPagoID INT IDENTITY(1,1) PRIMARY KEY,
    PagoID INT NOT NULL,
    TipoMetodo VARCHAR(50),
    Monto DECIMAL(10,2),
    FOREIGN KEY (PagoID) REFERENCES pagos(PagoID)
);
GO

CREATE TABLE logistica (
    LogisticaID INT IDENTITY(1,1) PRIMARY KEY,
    PedidoID INT NOT NULL,
    EmpresaEnvio VARCHAR(100),
    NumeroGuia VARCHAR(50),
    FechaEnvio DATE,
    FechaEntregaEstimada DATE,
    EstadoEnvio VARCHAR(50),
    DireccionEnvio VARCHAR(255),
    FOREIGN KEY (PedidoID) REFERENCES pedidos(PedidoID)
);
GO

-- 3. MODIFICACIONES Y TABLAS ADICIONALES PARA TRIGGERS

PRINT 'Creando tablas de auditoría y modificando estructura...';

-- Añadir columna de Stock a la tabla de productos
ALTER TABLE productos
ADD Stock INT NOT NULL DEFAULT 0;
GO

-- Crear la tabla para guardar el historial de cambios de precios
CREATE TABLE AuditoriaPrecios (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    ProductoID INT,
    PrecioAnterior DECIMAL(10,2),
    PrecioNuevo DECIMAL(10,2),
    FechaModificacion DATETIME DEFAULT GETDATE(),
    UsuarioModificador VARCHAR(128) DEFAULT SUSER_SNAME()
);
GO

-- 4. INSERCIÓN DE DATOS DE EJEMPLO

PRINT 'Insertando datos de ejemplo...';

-- Productos
INSERT INTO productos (NombreProd, DescripcionProd, CategoriaProd, PrecioProd, UnidadMedida) VALUES
('Aceite de Oliva', 'Aceite prensado en frío', 'Alimentos', 25.50, 'Litro'),
('Queso Andino', 'Queso artesanal de altura', 'Lácteos', 15.00, 'Kilo'),
('Miel de Abeja', 'Miel 100% natural', 'Alimentos', 12.90, 'Frasco'),
('Café Orgánico', 'Café cultivado en selva alta', 'Bebidas', 18.75, 'Bolsa'),
('Harina de Quinua', 'Harina sin gluten', 'Cereales', 10.00, 'Paquete'),
('Panela', 'Endulzante natural', 'Endulzantes', 9.50, 'Bolsa'),
('Té de Muña', 'Infusión digestiva', 'Bebidas', 6.80, 'Caja');

-- Actualizar stock inicial
UPDATE productos SET Stock = 100 WHERE ProductoID IN (1, 2, 3);
UPDATE productos SET Stock = 50 WHERE ProductoID IN (4, 5, 6, 7);

-- Proveedores
INSERT INTO proveedores (NombreProv, ApellidoProv, DNIProv, Comunidad, Region, Telefono, Email, ProductoID) VALUES
('Luis', 'Gonzales', '87654321', 'Cusco', 'Andes', '987654321', 'luis@andinos.pe', 1),
('Carmen', 'Ramos', '12345678', 'Puno', 'Sur', '987112233', 'carmen@bio.pe', 2),
('Marco', 'Zevallos', '23456789', 'Ayacucho', 'Centro', '981234567', 'marco@org.pe', 3);

-- Clientes
INSERT INTO clientes (NombreC, ApellidoC, DNIC, Direccion, Telefono, Email) VALUES
('Ana', 'Torres', '90123456', 'Av. Libertad 123', '987123456', 'ana@gmail.com'),
('Carlos', 'Meza', '90234567', 'Jr. Huancavelica 456', '986234567', 'carlos@gmail.com'),
('Elena', 'Ríos', '90345678', 'Calle Luna 789', '985345678', 'elena@gmail.com'),
('Pedro', 'Castillo', '90456789', 'Av. Mariscal 321', '984456789', 'pedro@gmail.com'),
('Lucía', 'Gómez', '90567890', 'Jr. Amazonas 654', '983567890', 'lucia@gmail.com'),
('Mario', 'Ruiz', '90678901', 'Pasaje Sol 987', '982678901', 'mario@gmail.com'),
('Diana', 'Paredes', '90789012', 'Av. Perú 147', '981789012', 'diana@gmail.com');

-- Usuarios de la plataforma
INSERT INTO usuarioPlataforma (ClienteID, Contraseña, Rol) VALUES
(1, 'ana123', 'Cliente'), (2, 'carlos456', 'Cliente'), (3, 'elena789', 'Cliente'),
(4, 'pedro321', 'Cliente'), (5, 'lucia654', 'Cliente'), (6, 'mario987', 'Cliente'),
(7, 'diana147', 'Cliente');

-- Pedidos
INSERT INTO pedidos (ClienteID, FechaPedido) VALUES
(1, '2025-04-01'), (2, '2025-04-02'), (3, '2025-04-03'), (4, '2025-04-04'),
(5, '2025-04-05'), (6, '2025-04-06'), (7, '2025-04-07');

-- Detalles de Pedido
INSERT INTO detallesPedido (PedidoID, ProductoID, Cantidad, PrecioUnitario) VALUES
(1, 1, 2, 25.50), (2, 2, 1, 15.00), (3, 3, 3, 12.90), (4, 4, 2, 18.75),
(5, 5, 1, 10.00), (6, 6, 2, 9.50), (7, 7, 4, 6.80);

-- Pagos y Métodos de Pago
INSERT INTO pagos (PedidoID, Monto, FechaPago) VALUES
(1, 51.00, '2025-04-08'), (2, 15.00, '2025-04-08'), (3, 38.70, '2025-04-09'),
(4, 37.50, '2025-04-09'), (5, 10.00, '2025-04-10'), (6, 19.00, '2025-04-10'),
(7, 27.20, '2025-04-11');

INSERT INTO metodoPago (PagoID, TipoMetodo, Monto) VALUES
(1, 'Yape', 51.00), (2, 'Plin', 15.00), (3, 'Yape', 38.70), (4, 'Yape', 37.50),
(5, 'Plin', 10.00), (6, 'Plin', 19.00), (7, 'Yape', 27.20);

-- Logística
INSERT INTO logistica (PedidoID, EmpresaEnvio, NumeroGuia, FechaEnvio, FechaEntregaEstimada, EstadoEnvio, DireccionEnvio) VALUES
(1, 'Servientrega', 'G123', '2025-04-09', '2025-04-11', 'En ruta', 'Av. Libertad 123'),
(2, 'Olva Courier', 'G124', '2025-04-09', '2025-04-12', 'En bodega', 'Jr. Huancavelica 456'),
(3, 'Servientrega', 'G125', '2025-04-10', '2025-04-13', 'En ruta', 'Calle Luna 789');

GO

-- 6. CREACIÓN DE CONSULTA Y SUBCONSULTAS
-- CONSULTAS----------
-- JOIN

SELECT c.NombreC, p.PedidoID, p.FechaPedido
FROM clientes c JOIN pedidos p ON c.ClienteID = p.ClienteID;

SELECT p.PedidoID, pr.NombreProd, dp.Cantidad, dp.PrecioUnitario
FROM pedidos p
JOIN detallesPedido dp ON p.PedidoID = dp.PedidoID
JOIN productos pr ON dp.ProductoID = pr.ProductoID;

SELECT c.NombreC, p.Monto, p.FechaPago
FROM pagos p
JOIN pedidos pe ON p.PedidoID = pe.PedidoID
JOIN clientes c ON pe.ClienteID = c.ClienteID;


-- LEFT JOIN

SELECT c.NombreC, p.PedidoID
FROM clientes c LEFT JOIN pedidos p ON c.ClienteID = p.ClienteID;

SELECT p.PedidoID, pg.Monto
FROM pedidos p LEFT JOIN pagos pg ON p.PedidoID = pg.PedidoID;

SELECT pr.NombreProd, dp.Cantidad
FROM productos pr LEFT JOIN detallesPedido dp ON pr.ProductoID = dp.ProductoID;


-- SUBCONSULTAS

SELECT NombreC FROM clientes
WHERE ClienteID IN (
    SELECT pe.ClienteID FROM pedidos pe
    JOIN pagos pg ON pe.PedidoID = pg.PedidoID
    WHERE pg.Monto > 30
);

SELECT NombreProd FROM productos
WHERE ProductoID IN (
    SELECT ProductoID FROM detallesPedido
    WHERE PedidoID IN (
        SELECT PedidoID FROM pagos WHERE Monto > 50
    )
);

SELECT PedidoID FROM detallesPedido
GROUP BY PedidoID
HAVING COUNT(*) > 2;

-- 6. CREACIÓN DE PROCEDIMIENTOS ALMACENADOS

PRINT 'Creando Procedimientos Almacenados...';
GO

-- 1. Procedimiento para agregar un nuevo producto de forma segura
CREATE PROCEDURE sp_AgregarProducto
    @NombreProd VARCHAR(100),
    @DescripcionProd VARCHAR(200),
    @CategoriaProd VARCHAR(50),
    @PrecioProd DECIMAL(10, 2),
    @UnidadMedida VARCHAR(50),
    @StockInicial INT = 0,
    @ImagenP IMAGE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM productos WHERE NombreProd = @NombreProd)
    BEGIN
        RAISERROR ('Error: Ya existe un producto con el nombre "%s".', 16, 1, @NombreProd);
        RETURN;
    END

    INSERT INTO productos (NombreProd, DescripcionProd, CategoriaProd, PrecioProd, UnidadMedida, Stock, ImagenP)
    VALUES (@NombreProd, @DescripcionProd, @CategoriaProd, @PrecioProd, @UnidadMedida, @StockInicial, @ImagenP);

    PRINT 'Producto "' + @NombreProd + '" agregado exitosamente con el ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR);
END
GO

-- 2. Procedimiento para obtener los detalles completos de un pedido
CREATE PROCEDURE sp_ObtenerDetallesPedido
    @PedidoID INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM pedidos WHERE PedidoID = @PedidoID)
    BEGIN
        RAISERROR ('Error: El PedidoID %d no existe.', 16, 1, @PedidoID);
        RETURN;
    END

    SELECT
        p.PedidoID,
        p.FechaPedido,
        c.NombreC AS NombreCliente,
        c.Email AS EmailCliente,
        pr.NombreProd AS Producto,
        dp.Cantidad,
        dp.PrecioUnitario,
        (dp.Cantidad * dp.PrecioUnitario) AS Subtotal,
        l.EmpresaEnvio,
        l.EstadoEnvio,
        l.FechaEntregaEstimada
    FROM pedidos p
    JOIN clientes c ON p.ClienteID = c.ClienteID
    JOIN detallesPedido dp ON p.PedidoID = dp.PedidoID
    JOIN productos pr ON dp.ProductoID = pr.ProductoID
    LEFT JOIN logistica l ON p.PedidoID = l.PedidoID
    WHERE p.PedidoID = @PedidoID;
END
GO

-- 7. CREACIÓN DE TRIGGERS (DISPARADORES)

PRINT 'Creando Triggers...';
GO

-- 1. Trigger para actualizar el stock después de insertar un detalle de pedido (venta)
CREATE TRIGGER tr_ActualizarStock_Venta
ON detallesPedido
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProductoID INT, @CantidadVendida INT;
    SELECT @ProductoID = ProductoID, @CantidadVendida = Cantidad FROM inserted;

    UPDATE productos
    SET Stock = Stock - @CantidadVendida
    WHERE ProductoID = @ProductoID;

    IF (SELECT Stock FROM productos WHERE ProductoID = @ProductoID) < 0
    BEGIN
        RAISERROR ('Error: No hay stock suficiente para el producto ID %d. La operación ha sido cancelada.', 16, 1, @ProductoID);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO

-- 2. Trigger para auditar los cambios de precio en la tabla de productos
CREATE TRIGGER tr_AuditarCambioPrecio
ON productos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(PrecioProd)
    BEGIN
        INSERT INTO AuditoriaPrecios (ProductoID, PrecioAnterior, PrecioNuevo)
        SELECT
            i.ProductoID,
            d.PrecioProd,
            i.PrecioProd
        FROM
            inserted i
        JOIN
            deleted d ON i.ProductoID = d.ProductoID
        WHERE
            d.PrecioProd <> i.PrecioProd; -- Solo si el precio realmente cambió
    END
END
GO

PRINT '*** Base de Datos ModeloLogico creada y poblada exitosamente ***';
GO


