USE baseTramites;
GO

-- Verificamos de existencia del trigger
IF OBJECT_ID('trg_CalcularTotalRecibo', 'TR') IS NOT NULL
DROP TRIGGER trg_CalcularTotalRecibo;
GO

CREATE TRIGGER trg_CalcularTotalRecibo
ON tRecibo
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE r
    SET totalR = i.cantidadR * c.costoC
    FROM tRecibo r
    INNER JOIN inserted i ON r.idR = i.idR
    INNER JOIN tConcepto c ON i.idC = c.idC;
END;
GO


INSERT INTO tRecibo
VALUES('R008', '08-10-2025 14:30:00', 2, NULL, 'C003', 'S001');

-- Consulta
SELECT * FROM tRecibo WHERE idR = 'R008';

CREATE TABLE tResumenTramite (
    idResumen INT IDENTITY(1,1) PRIMARY KEY,
    idT VARCHAR(4),
    nombreTramite VARCHAR(70),
    totalPagado DECIMAL(10,2),
    fechaTramite DATETIME,
    nombreSolicitante VARCHAR(100)
);

-- =============================================
-- TRIGGER: trg_InsertarResumenTramite
-- OBJETIVO: Al insertar en tRecibo_Tramite, generar
-- automáticamente un resumen en tResumenTramite
-- =============================================

GO
CREATE TRIGGER trg_InsertarResumenTramite
ON tRecibo_Tramite
AFTER INSERT
AS
BEGIN
    INSERT INTO tResumenTramite (idT, nombreTramite, totalPagado, fechaTramite, nombreSolicitante)
    SELECT 
        t.idT,
        t.nombreT,
        r.totalR,
        t.fechaHoraT,
        CONCAT(s.paternoS, ' ', s.maternoS, ', ', s.nombresS)
    FROM inserted i
    INNER JOIN tTramite t ON i.idT = t.idT
    INNER JOIN tRecibo r ON i.idR = r.idR
    INNER JOIN tSolicitante s ON t.idS = s.idS;
END
GO



-- Primero crea un nuevo recibo
INSERT INTO tRecibo
VALUES('R013', GETDATE(), 1, NULL, 'C002', 'S002');

-- Ahora crea el vínculo entre ese recibo y un trámite
INSERT INTO tRecibo_Tramite
VALUES('RT07', 'T003', 'R013');

-- Consultamos la tabla resumen
SELECT * FROM tResumenTramite;


CREATE TRIGGER trg_auditar_actualizacion_tramite
ON tTramite
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO tAuditoriaTramite (idT, fechaHoraCambio, usuario, accion, detalles)
    SELECT
        i.idT,
        GETDATE(),
        SUSER_NAME(),
        'UPDATE',
        'Cambios: ' +
        CASE WHEN d.fechaHoraT <> i.fechaHoraT THEN 'fechaHoraT: ' + CONVERT(VARCHAR, d.fechaHoraT, 120) + ' -> ' + CONVERT(VARCHAR, i.fechaHoraT, 120) + '; ' ELSE '' END +
        CASE WHEN d.nombreT <> i.nombreT THEN 'nombreT: ' + d.nombreT + ' -> ' + i.nombreT + '; ' ELSE '' END +
        CASE WHEN d.cantidadFoliosT <> i.cantidadFoliosT THEN 'cantidadFoliosT: ' + CAST(d.cantidadFoliosT AS VARCHAR) + ' -> ' + CAST(i.cantidadFoliosT AS VARCHAR) + '; ' ELSE '' END +
        CASE WHEN d.idS <> i.idS THEN 'idS: ' + d.idS + ' -> ' + i.idS + '; ' ELSE '' END +
        CASE WHEN d.idO <> i.idO THEN 'idO: ' + d.idO + ' -> ' + i.idO + '; ' ELSE '' END
    FROM inserted i
    JOIN deleted d ON i.idT = d.idT;
END;
GO

select * from tTramite
