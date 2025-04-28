USE MASTER
GO
CREATE DATABASE ModeloLogico
USE ModeloLogico
GO

-- TABLAS ------------------------------
CREATE TABLE productos (
    ProductoID INT PRIMARY KEY,
    NombreProd VARCHAR(100),
    DescripcionProd VARCHAR(200),
    CategoriaProd VARCHAR(50),
    PrecioProd DECIMAL(10,2),
    UnidadMedida VARCHAR(50),
    ImagenP IMAGE
);

CREATE TABLE proveedores (
    ProveedorID INT PRIMARY KEY,
    NombreProv VARCHAR(100),
    ApellidoProv VARCHAR(100),
    DNIProv VARCHAR(20),
    Comunidad VARCHAR(100),
    Region VARCHAR(100),
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    ProductoID INT,
    FOREIGN KEY (ProductoID) REFERENCES productos(ProductoID)
);

CREATE TABLE clientes (
    ClienteID INT PRIMARY KEY,
    NombreC VARCHAR(100),
    ApellidoC VARCHAR(100),
    DNIC VARCHAR(20),
    Direccion VARCHAR(255),
    Telefono VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE pedidos (
    PedidoID INT PRIMARY KEY,
    FechaPedido DATE,
    ClienteID INT,
    FOREIGN KEY (ClienteID) REFERENCES clientes(ClienteID)
);

CREATE TABLE detallesPedido (
    DetalleID INT PRIMARY KEY,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    PedidoID INT,
    ProductoID INT,
    FOREIGN KEY (PedidoID) REFERENCES pedidos(PedidoID),
    FOREIGN KEY (ProductoID) REFERENCES productos(ProductoID)
);

CREATE TABLE pagos (
    PagoID INT PRIMARY KEY,
    Monto DECIMAL(10,2),
    FechaPago DATE,
    PedidoID INT,
    FOREIGN KEY (PedidoID) REFERENCES pedidos(PedidoID)
);

CREATE TABLE metodoPago (
    MetodoPagoID INT PRIMARY KEY,
    TipoMetodo VARCHAR(50),
    Monto DECIMAL(10,2),
    PagoID INT,
    FOREIGN KEY (PagoID) REFERENCES pagos(PagoID)
);

CREATE TABLE logistica (
    LogisticaID INT PRIMARY KEY,
    EmpresaEnvio VARCHAR(100),
    NumeroGuia VARCHAR(50),
    FechaEnvio DATE,
    FechaEntregaEstimada DATE,
    EstadoEnvio VARCHAR(50),
    DireccionEnvio VARCHAR(255),
    PedidoID INT,
    FOREIGN KEY (PedidoID) REFERENCES pedidos(PedidoID)
);

CREATE TABLE usuarioPlataforma (
    UsuarioID INT PRIMARY KEY,
    Contraseña VARCHAR(255),
    Rol VARCHAR(50),
    ClienteID INT,
    FOREIGN KEY (ClienteID) REFERENCES clientes(ClienteID)
);

-- INSERTS ------------------------------
INSERT INTO productos VALUES
(1, 'Aceite de Oliva', 'Aceite prensado en frío', 'Alimentos', 25.50, 'Litro', NULL),
(2, 'Queso Andino', 'Queso artesanal de altura', 'Lácteos', 15.00, 'Kilo', NULL),
(3, 'Miel de Abeja', 'Miel 100% natural', 'Alimentos', 12.90, 'Frasco', NULL),
(4, 'Café Orgánico', 'Café cultivado en selva alta', 'Bebidas', 18.75, 'Bolsa', NULL),
(5, 'Harina de Quinua', 'Harina sin gluten', 'Cereales', 10.00, 'Paquete', NULL),
(6, 'Panela', 'Endulzante natural', 'Endulzantes', 9.50, 'Bolsa', NULL),
(7, 'Té de Muña', 'Infusión digestiva', 'Bebidas', 6.80, 'Caja', NULL);

INSERT INTO proveedores VALUES
(1, 'Luis', 'Gonzales', '87654321', 'Cusco', 'Andes', '987654321', 'luis@andinos.pe', 1),
(2, 'Carmen', 'Ramos', '12345678', 'Puno', 'Sur', '987112233', 'carmen@bio.pe', 2),
(3, 'Marco', 'Zevallos', '23456789', 'Ayacucho', 'Centro', '981234567', 'marco@org.pe', 3),
(4, 'Lucía', 'Espinoza', '34567890', 'Junín', 'Centro', '985678123', 'lucia@natural.pe', 4),
(5, 'Daniel', 'Lopez', '45678901', 'Ancash', 'Norte', '982345678', 'daniel@campo.pe', 5),
(6, 'Sofía', 'Tello', '56789012', 'Arequipa', 'Sur', '983456789', 'sofia@pacha.pe', 6),
(7, 'Jorge', 'Salas', '67890123', 'Apurímac', 'Andes', '984567890', 'jorge@eco.pe', 7);

INSERT INTO clientes VALUES
(1, 'Ana', 'Torres', '90123456', 'Av. Libertad 123', '987123456', 'ana@gmail.com'),
(2, 'Carlos', 'Meza', '90234567', 'Jr. Huancavelica 456', '986234567', 'carlos@gmail.com'),
(3, 'Elena', 'Ríos', '90345678', 'Calle Luna 789', '985345678', 'elena@gmail.com'),
(4, 'Pedro', 'Castillo', '90456789', 'Av. Mariscal 321', '984456789', 'pedro@gmail.com'),
(5, 'Lucía', 'Gómez', '90567890', 'Jr. Amazonas 654', '983567890', 'lucia@gmail.com'),
(6, 'Mario', 'Ruiz', '90678901', 'Pasaje Sol 987', '982678901', 'mario@gmail.com'),
(7, 'Diana', 'Paredes', '90789012', 'Av. Perú 147', '981789012', 'diana@gmail.com');

INSERT INTO pedidos VALUES
(1, '2025-04-01', 1), (2, '2025-04-02', 2), (3, '2025-04-03', 3),
(4, '2025-04-04', 4), (5, '2025-04-05', 5), (6, '2025-04-06', 6), (7, '2025-04-07', 7);

INSERT INTO detallesPedido VALUES
(1, 2, 25.50, 1, 1), (2, 1, 15.00, 2, 2), (3, 3, 12.90, 3, 3),
(4, 2, 18.75, 4, 4), (5, 1, 10.00, 5, 5), (6, 2, 9.50, 6, 6), (7, 4, 6.80, 7, 7);

INSERT INTO pagos VALUES
(1, 51.00, '2025-04-08', 1), (2, 15.00, '2025-04-08', 2), (3, 38.70, '2025-04-09', 3),
(4, 37.50, '2025-04-09', 4), (5, 10.00, '2025-04-10', 5), (6, 19.00, '2025-04-10', 6), (7, 27.20, '2025-04-11', 7);

INSERT INTO metodoPago VALUES
(1, 'Yape', 51.00, 1), (2, 'Plin', 15.00, 2), (3, 'Yape', 38.70, 3),
(4, 'Yape', 37.50, 4), (5, 'Plin', 10.00, 5), (6, 'Plin', 19.00, 6), (7, 'Yape', 27.20, 7);

INSERT INTO logistica VALUES
(1, 'Servientrega', 'G123', '2025-04-09', '2025-04-11', 'En ruta', 'Av. Libertad 123', 1),
(2, 'Olva Courier', 'G124', '2025-04-09', '2025-04-12', 'En bodega', 'Jr. Huancavelica 456', 2),
(3, 'Servientrega', 'G125', '2025-04-10', '2025-04-13', 'En ruta', 'Calle Luna 789', 3),
(4, 'Olva Courier', 'G126', '2025-04-10', '2025-04-13', 'Entregado', 'Av. Mariscal 321', 4),
(5, 'Servientrega', 'G127', '2025-04-11', '2025-04-14', 'Entregado', 'Jr. Amazonas 654', 5),
(6, 'Olva Courier', 'G128', '2025-04-11', '2025-04-14', 'En ruta', 'Pasaje Sol 987', 6),
(7, 'Servientrega', 'G129', '2025-04-12', '2025-04-15', 'Pendiente', 'Av. Perú 147', 7);

INSERT INTO usuarioPlataforma VALUES
(1, 'ana123', 'Cliente', 1), (2, 'carlos456', 'Cliente', 2), (3, 'elena789', 'Cliente', 3),
(4, 'pedro321', 'Cliente', 4), (5, 'lucia654', 'Cliente', 5), (6, 'mario987', 'Cliente', 6), (7, 'diana147', 'Cliente', 7);

-- CONSULTAS ------------------------------
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