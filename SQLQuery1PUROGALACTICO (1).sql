USE BDPuroGalactico;

GO

-- Crear tabla tSolicitante
CREATE TABLE tSolicitante (
    idS VARCHAR(4) NOT NULL, 
    tipoS VARCHAR(7),
    tipoDocumS VARCHAR(7),
    nroDocumS VARCHAR(15),
    paternoS VARCHAR(50),
    maternoS VARCHAR(50),
    nombresS VARCHAR(50),
    razonSocialS VARCHAR(50),
    celularS VARCHAR(15),
    telefonoS VARCHAR(15),
    dirElectronS VARCHAR(50),
    PRIMARY KEY (idS)
);
GO

-- Insertar datos en tSolicitante
INSERT INTO tSolicitante VALUES
('S001','EST', 'carnet','123016101J','Torres', 'Loza','Boris', NULL,'911111111','51-84-221111','123016101J@uandina.edu.pe'),
('S002','EST','carnet','123015100A','Pérez','Sánchez','José', NULL,'922222222','51-84-222222','123015100A@uandina.edu.pe'),
('S003','EST','carnet','123014200D','Arenas','Campos','Raul', NULL,'933333333','51-84-223333','123014200D@uandina.edu.pe'),
('S004','EST','carnet','123015300F','Maldonado', 'Rojas','Jorge', NULL,'944444444','51-84-224444','123015300F@uandina.edu.pe'),
('S005','EST', 'carnet','123015300B','Salinas','Valle','Daniel',NULL,'955555555','51-84-225555','123015300B@uandina.edu.pe');
GO

-- Crear tabla tOficina
CREATE TABLE tOficina (
    idO VARCHAR(4) NOT NULL,
    denominacionO VARCHAR(50),
    ubicacionO VARCHAR(50),
    responsableO VARCHAR(50),
    PRIMARY KEY (idO)
);
GO

-- Insertar datos en tOficina
INSERT INTO tOficina VALUES
('O001','Rectorado','AG-101 Larapa','Zambrano Ramos, Juan'),
('O002','Dirección de Tecnologías de Información','ING-205 Larapa', 'Torres Campos, César'),
('O003','Dirección del D.A. de Ingeniería de Sistemas','ING-211 Larapa', 'Zamalloa Campos, Gino');
GO

-- Crear tabla tConcepto
CREATE TABLE tConcepto (
    idC VARCHAR(4) NOT NULL,
    denominacionC VARCHAR(50),
    costoC DECIMAL(10,2),
    PRIMARY KEY (idC)
);
GO

-- Insertar datos en tConcepto
INSERT INTO tConcepto VALUES
('C001','Convalidación de sílabos',9),
('C002','Constancia de seguimiento de estudios',20),
('C003','Certificado de estudios',30);
GO

-- Crear tabla tRecibo
CREATE TABLE tRecibo (
    idR VARCHAR(4) NOT NULL, 
    fechaHoraR DATETIME,
    cantidadR INT,
    totalR DECIMAL(10,2),
    idC VARCHAR(4),
    PRIMARY KEY (idR),
    FOREIGN KEY (idC) REFERENCES tConcepto(idC),
    idS VARCHAR(4),
    FOREIGN KEY (idS) REFERENCES tSolicitante(idS)
);
GO

-- Insertar datos en tRecibo
INSERT INTO tRecibo VALUES
('R002','2017-06-27 11:30:00',9,NULL, 'C001', 'S001');
GO

-- Crear tabla tTramite
CREATE TABLE tTramite (
    idT VARCHAR(4) NOT NULL, 
    fechaHoraT DATETIME,
    nombreT VARCHAR(70),
    cantidadFoliosT INT,
    idS VARCHAR(4),
    PRIMARY KEY (idT),
    FOREIGN KEY (idS) REFERENCES tSolicitante(idS),
    idO VARCHAR(4),
    FOREIGN KEY (idO) REFERENCES tOficina(idO)
);
GO

-- Crear tabla tRecibo_Tramite
CREATE TABLE tRecibo_Tramite (
    idRT VARCHAR(4) NOT NULL,
    PRIMARY KEY (idRT),
    idT VARCHAR(4),
    FOREIGN KEY (idT) REFERENCES tTramite(idT),
    idR VARCHAR(4),
    FOREIGN KEY (idR) REFERENCES tRecibo(idR)
);
GO

-- CONSULTAS ANIDADAS:

-- 1. Listar solicitantes que han realizado pagos
SELECT idS, nombresS  
FROM tSolicitante 
WHERE idS IN (SELECT idS FROM tRecibo);
GO

-- 2. Listar oficinas que han gestionado trámites
SELECT idO, denominacionO 
FROM tOficina 
WHERE idO IN (SELECT idO FROM tTramite);
GO

-- 3. Listar conceptos con pagos registrados
SELECT idC, denominacionC 
FROM tConcepto 
WHERE idC IN (SELECT idC FROM tRecibo);
GO

-- 4. Listar oficinas que han generado ingresos
SELECT idO, denominacionO 
FROM tOficina 
WHERE idO IN (SELECT idO FROM tTramite WHERE idT IN (SELECT idT FROM tRecibo_Tramite));
GO

-- 5. Mostrar conceptos que no han generado dinero
SELECT idC, denominacionC 
FROM tConcepto 
WHERE idC NOT IN (SELECT idC FROM tRecibo);
GO

-- 6. Listar trámites de un solicitante específico
SELECT 
    T.idT AS TramiteID,
    CONCAT(S.paternoS, ' ', S.maternoS, ' ', S.nombresS) AS DatosSolicitante,
    O.denominacionO AS Oficina,
    T.nombreT AS NombreTramite,
    T.fechaHoraT AS FechaHora
FROM tTramite T
JOIN tSolicitante S ON T.idS = S.idS
JOIN tOficina O ON T.idO = O.idO
WHERE T.idS = 'S001'
ORDER BY T.fechaHoraT DESC;
GO

