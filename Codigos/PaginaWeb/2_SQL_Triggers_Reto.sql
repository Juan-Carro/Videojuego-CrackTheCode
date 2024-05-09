-- Reto -> Triggers
USE RetoBD;
GO

--Trigger para encriptar la contraseña de los usuarios 
CREATE OR ALTER TRIGGER TRG_Usuario_INSERT
ON Usuario
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @IDPais AS INT;
	DECLARE @IDTutor AS INT;
	DECLARE @Nombre AS VARCHAR(30);
	DECLARE @ApellidoP AS VARCHAR(30);
	DECLARE @ApellidoM AS VARCHAR(30);
	DECLARE @FechaNacim AS INT;
	DECLARE @GamerTag AS VARCHAR(50);
	DECLARE @Contraseña AS VARCHAR(64);
	
	SELECT @IDPais = (SELECT IDPais FROM inserted);
	SELECT @IDTutor = (SELECT IDTutor FROM inserted);
	SELECT @Nombre = (SELECT Nombre FROM inserted);
	SELECT @ApellidoP = (SELECT ApellidoP FROM inserted);
	SELECT @ApellidoM = (SELECT ApellidoM FROM inserted);
	SELECT @FechaNacim = (SELECT FechaNacim FROM inserted);
	SELECT @GamerTag = (SELECT GamerTag FROM inserted);
	SELECT @Contraseña = (SELECT Contraseña FROM inserted);
	
	DECLARE @Salt AS VARCHAR(32);
	SELECT @Salt = CONVERT(VARCHAR(32), CRYPT_GEN_RANDOM(16), 2);

	DECLARE @HashedPassword AS VARCHAR(96);
	SELECT @HashedPassword = @Salt + CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', @Salt + @Contraseña), 2);
	
	INSERT INTO Usuario
	VALUES (@IDPais, @IDTutor, @Nombre, @ApellidoP, @ApellidoM, @FechaNacim, @GamerTag, @HashedPassword);
END;
GO

--Trigger para encriptar la contraseña de los administradores 
CREATE OR ALTER TRIGGER TRG_Admin_INSERT
ON [Admin]
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @Nombre AS VARCHAR(30);
	DECLARE @ApellidoP AS VARCHAR(30);
	DECLARE @ApellidoM AS VARCHAR(30);
	DECLARE @FechaNacim AS INT;
	DECLARE @NombreUser AS VARCHAR(50);
	DECLARE @Contraseña AS VARCHAR(64);
	
	SELECT @Nombre = (SELECT Nombre FROM inserted);
	SELECT @ApellidoP = (SELECT ApellidoP FROM inserted);
	SELECT @ApellidoM = (SELECT ApellidoM FROM inserted);
	SELECT @FechaNacim = (SELECT FechaNacim FROM inserted);
	SELECT @NombreUser = (SELECT NombreUser FROM inserted);
	SELECT @Contraseña = (SELECT Contraseña FROM inserted);
	
	DECLARE @Salt AS VARCHAR(32);
	SELECT @Salt = CONVERT(VARCHAR(32), CRYPT_GEN_RANDOM(16), 2);

	DECLARE @HashedPassword AS VARCHAR(96);
	SELECT @HashedPassword = @Salt + CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', @Salt + @Contraseña), 2);
	
	INSERT INTO [Admin]
	VALUES (@Nombre, @ApellidoP, @ApellidoM, @FechaNacim, @NombreUser, @HashedPassword);
END;
GO

--Trigger para el actualizado de la contraseña de un usuario
CREATE OR ALTER TRIGGER TRG_Usuario_Contra
ON Usuario
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Contraseña AS VARCHAR(64);
	SELECT @Contraseña = (SELECT Contraseña FROM inserted);

	DECLARE @Salt AS VARCHAR(32);
	SELECT @Salt = CONVERT(VARCHAR(32), CRYPT_GEN_RANDOM(16), 2);

	DECLARE @HashedPassword AS VARCHAR(96);
	SELECT @HashedPassword = @Salt + CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', @Salt + @Contraseña), 2);
	
	UPDATE Usuario
	SET Contraseña = @HashedPassword
	FROM Usuario
	INNER JOIN inserted on Usuario.IDUsuario = inserted.IDUsuario
END;
GO

--Trigger para el actualizado de la contraseña de un administrador
CREATE OR ALTER TRIGGER TRG_Admin_Contra
ON [Admin]
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Contraseña AS VARCHAR(64);
	SELECT @Contraseña = (SELECT Contraseña FROM inserted);

	DECLARE @Salt AS VARCHAR(32);
	SELECT @Salt = CONVERT(VARCHAR(32), CRYPT_GEN_RANDOM(16), 2);

	DECLARE @HashedPassword AS VARCHAR(96);
	SELECT @HashedPassword = @Salt + CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', @Salt + @Contraseña), 2);
	
	UPDATE [Admin]
	SET Contraseña = @HashedPassword
	FROM [Admin]
	INNER JOIN inserted on [Admin].IDAdmin = inserted.IDAdmin
END;
GO


--Trigger para el borrado de registros (IDNivel)
CREATE OR ALTER TRIGGER TRG_Niveles_DELETE
ON Niveles
INSTEAD OF DELETE 
AS
BEGIN
	BEGIN TRANSACTION
		DELETE FROM Puntuacion WHERE IDNivel IN (SELECT IDNivel FROM deleted);
		DELETE FROM Niveles WHERE IDNivel IN (SELECT IDNivel FROM deleted);
	COMMIT;
END;
GO

--Trigger para el borrado de registros (IDPais)
CREATE OR ALTER TRIGGER TRG_Pais_DELETE
ON Pais
INSTEAD OF DELETE 
AS
BEGIN
	BEGIN TRANSACTION
		DELETE FROM	Puntuacion WHERE IDUsuario IN (SELECT IDUsuario FROM Usuario WHERE IDPais IN (SELECT IDPais FROM deleted));
		DELETE FROM Usuario WHERE IDPais IN (SELECT IDPais FROM deleted);
		DELETE FROM Pais WHERE IDPais IN (SELECT IDPais FROM deleted);
	COMMIT;
END;
GO

--Trigger para el borrado de registros (IDTutor)
CREATE OR ALTER TRIGGER TRG_Tutor_DELETE
ON Tutor
INSTEAD OF DELETE 
AS
BEGIN
	BEGIN TRANSACTION
		DELETE FROM	Puntuacion WHERE IDUsuario IN (SELECT IDUsuario FROM Usuario WHERE IDTutor IN (SELECT IDTutor FROM deleted));
		DELETE FROM Usuario WHERE IDTutor IN (SELECT IDTutor FROM deleted);
		DELETE FROM Tutor WHERE IDTutor IN (SELECT IDTutor FROM deleted);
	COMMIT;
END;
GO

--Trigger para el borrado de registros (IDUsuario)
CREATE OR ALTER TRIGGER TRG_Usuario_DELETE
ON Usuario
INSTEAD OF DELETE 
AS
BEGIN
	BEGIN TRANSACTION
		DELETE FROM Puntuacion WHERE IDUsuario IN (SELECT IDUsuario FROM deleted);
		DELETE FROM Usuario WHERE IDUsuario IN (SELECT IDUsuario FROM deleted);
	COMMIT;
END;
GO
