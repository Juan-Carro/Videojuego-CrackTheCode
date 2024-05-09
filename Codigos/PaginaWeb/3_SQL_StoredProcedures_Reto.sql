-- Reto -> Stored Procedures

USE RetoBD;
GO

-- SP para Insertar datos
CREATE OR ALTER PROCEDURE PROC_Insertar_Pais
@Nombre AS VARCHAR(30)
AS
BEGIN
	INSERT INTO Pais VALUES(@Nombre)
END;
GO

CREATE OR ALTER PROCEDURE PROC_Insertar_Tutor
@Nombre AS VARCHAR(30), @ApellidoP AS VARCHAR(30), @ApellidoM AS VARCHAR(30), 
@Telefono AS VARCHAR(30), @Correo AS VARCHAR(50)
AS
BEGIN
	INSERT INTO Tutor VALUES(@Nombre, @ApellidoP, @ApellidoM, @Telefono, @Correo)
END;
GO

CREATE OR ALTER PROCEDURE PROC_Insertar_Niveles
@Nombre AS VARCHAR(30)
AS
BEGIN
	INSERT INTO Niveles VALUES(@Nombre)
END;
GO

CREATE OR ALTER PROCEDURE PROC_Insertar_Usuario
@Nombre AS VARCHAR(30), @ApellidoP AS VARCHAR(30), @ApellidoM AS VARCHAR(30),
@FechaNacim AS INT, @EmailTutor AS VARCHAR(50), @GamerTag AS VARCHAR(50), 
@Contraseña AS VARCHAR(96), @NombrePais AS VARCHAR(30)
AS
BEGIN
	DECLARE @TutorSearch AS INT;
	DECLARE @PaisSearch AS INT;
	SELECT @TutorSearch = (SELECT IDTutor FROM Tutor WHERE Correo LIKE @EmailTutor);
	SELECT @PaisSearch = (SELECT IDPais FROM Pais WHERE Nombre LIKE @NombrePais);
	INSERT INTO Usuario 
	VALUES (@PaisSearch, @TutorSearch, @Nombre, @ApellidoP, @ApellidoM, @FechaNacim, @GamerTag, @Contraseña)
END;
GO

CREATE OR ALTER PROCEDURE PROC_Insertar_Admin
@Nombre AS VARCHAR(30), @ApellidoP AS VARCHAR(30),  @ApellidoM AS VARCHAR(30),
@FechaNacim AS INT, @NombreUser AS VARCHAR(50), @Contraseña AS VARCHAR(96)
AS
BEGIN
	INSERT INTO [Admin] VALUES
	(@Nombre, @ApellidoP, @ApellidoM, @FechaNacim, @NombreUser, @Contraseña)
END;
GO

CREATE OR ALTER PROCEDURE PROC_Insertar_Puntuacion
@NombreNivel AS VARCHAR(30), @GamerTag AS VARCHAR(50),
@Puntos AS INT, @Registro AS DATE
AS
BEGIN
	DECLARE @NivelSearch AS INT;
	DECLARE @UsuarioSearch AS INT;
	SELECT @NivelSearch = (SELECT IDNivel FROM Niveles WHERE Nombre LIKE @NombreNivel);
	SELECT @UsuarioSearch = (SELECT IDUsuario FROM Usuario WHERE GamerTag LIKE @GamerTag);
	INSERT INTO Puntuacion VALUES (@NivelSearch, @UsuarioSearch, @Puntos, @Registro)
END;
GO


-- SP para Consultar datos

CREATE OR ALTER PROCEDURE PROC_Login
@GamerTag AS VARCHAR(50),
@Contraseña AS VARCHAR(96),
@Success AS BIT OUTPUT
AS
BEGIN
	DECLARE @StorePassword AS VARCHAR(96);
	SELECT @StorePassword = (SELECT Contraseña FROM Usuario WHERE GamerTag LIKE @GamerTag);

	DECLARE @Salt AS VARCHAR(32);
	SELECT @Salt = SUBSTRING(@StorePassword, 1, 32);

	DECLARE @HashedPassword AS VARCHAR(96);
	SELECT @HashedPassword = @Salt + CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', @Salt + @Contraseña), 2);

	SELECT @Success = (CASE WHEN @HashedPassword = @StorePassword THEN 1 ELSE 0 END);
END;
GO

CREATE OR ALTER PROCEDURE PROC_Login_Admin
@NombreUser AS VARCHAR(50),
@Contraseña AS VARCHAR(96),
@Success AS BIT OUTPUT
AS
BEGIN	
	DECLARE @StorePassword AS VARCHAR(96);
	SELECT @StorePassword = (SELECT Contraseña FROM [Admin] WHERE NombreUser LIKE @NombreUser);

	DECLARE @Salt AS VARCHAR(32);
	SELECT @Salt = SUBSTRING(@StorePassword, 1, 32);

	DECLARE @HashedPassword AS VARCHAR(96);
	SELECT @HashedPassword = @Salt + CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', @Salt + @Contraseña), 2);

	SELECT @Success = (CASE WHEN @HashedPassword = @StorePassword THEN 1 ELSE 0 END);
END;
GO

-- Gráfica: 1
CREATE OR ALTER PROCEDURE PROC_LeaderBoard_Pagina
@PageNumber AS INT
AS
BEGIN
	SELECT ROW_NUMBER() OVER(ORDER BY Puntos DESC,
	Puntuacion.IDNivel DESC) AS Place,
	GamerTag, Puntos, Niveles.Nombre
	FROM Puntuacion
	JOIN Usuario ON Puntuacion.IDUsuario = Usuario.IDUsuario
	JOIN Niveles ON Puntuacion.IDNivel = Niveles.IDNivel
	ORDER BY Puntos DESC, Puntuacion.IDNivel DESC
	OFFSET (@PageNumber - 1) * 10 ROWS
	FETCH NEXT 10 ROWS ONLY;
END;
GO

-- Gráfica: 2
CREATE OR ALTER PROCEDURE PROC_HistorialJugadores
@GamerTag AS VARCHAR(50), @NombreNivel AS VARCHAR(30)
AS
BEGIN
	DECLARE @UsuarioSearch AS INT;
	DECLARE @NivelSearch AS INT;
	SELECT @UsuarioSearch = (SELECT IDUsuario FROM Usuario WHERE GamerTag LIKE @GamerTag);
	SELECT @NivelSearch = (SELECT IDNivel FROM Niveles WHERE Nombre LIKE @NombreNivel);
	
	SELECT Puntos, Registro
	FROM Puntuacion
	WHERE (IDUsuario = @UsuarioSearch) AND (IDNivel = @NivelSearch)
END;
GO

-- Gráfica: 3
CREATE OR ALTER PROCEDURE PROC_PuntosPaises
AS
BEGIN
	SELECT Pais.Nombre, AVG(Puntos) AS Puntos
	FROM Puntuacion
	JOIN Usuario ON Puntuacion.IDUsuario = Usuario.IDUsuario
	JOIN Pais ON Usuario.IDPais = Pais.IDPais
	GROUP BY Pais.Nombre
END;
GO


-- Gráfica: 4
CREATE OR ALTER PROCEDURE PROC_PuntosEdades
AS
BEGIN 
	SELECT YEAR(GETDATE()) - FechaNacim AS Edad, AVG(Puntos) AS Puntos
	FROM Puntuacion
	JOIN Usuario ON Puntuacion.IDUsuario = Usuario.IDUsuario
	GROUP BY YEAR(GETDATE()) - FechaNacim
END;
GO

--Con parámetro:
CREATE OR ALTER PROCEDURE PROC_UsuariosPais_P
@NombreP AS VARCHAR(30)
AS 
BEGIN
	SELECT Pais.Nombre, COUNT(Usuario.IDPais) AS TotalUsuarios
	FROM Usuario
	JOIN Pais ON Usuario.IDPais = Pais.IDPais
	WHERE Pais.IDPais = (SELECT IDPais FROM Pais WHERE Nombre LIKE @NombreP)
	GROUP BY Pais.Nombre
END;
GO

-- Gráfica: 5
--General
CREATE OR ALTER PROCEDURE PROC_UsuariosPais
AS 
BEGIN
	SELECT Pais.Nombre, COUNT(Usuario.IDPais) AS TotalUsuarios
	FROM Usuario
	JOIN Pais ON Usuario.IDPais = Pais.IDPais
	GROUP BY Pais.Nombre
END;
GO


--Con parámetro:
CREATE OR ALTER PROCEDURE PROC_DatosGenerales_P
@IDNivel AS INT, @PageNumber AS INT
AS 
BEGIN
	SELECT Tutor.Nombre AS Tutor, Usuario.Nombre AS Alumno, Puntuacion.IDNivel, Puntuacion.Puntos
	FROM Usuario
	JOIN Tutor
	ON Usuario.IDTutor = Tutor.IDTutor
	JOIN Puntuacion
	ON Usuario.IDUsuario = Puntuacion.IDUsuario
	WHERE Puntuacion.IDNivel = @IDNivel
	ORDER BY Puntos DESC OFFSET (@PageNumber - 1) * 5 ROWS
	FETCH NEXT 5 ROWS ONLY;
END;
GO

--General:
CREATE OR ALTER PROCEDURE PROC_DatosGenerales
AS 
BEGIN
	SELECT Tutor.Nombre AS Tutor, Usuario.Nombre AS Alumno, Puntuacion.IDNivel, Puntuacion.Puntos
	FROM Usuario
	JOIN Tutor
	ON Usuario.IDTutor = Tutor.IDTutor
	JOIN Puntuacion
	ON Usuario.IDUsuario = Puntuacion.IDUsuario
END;
GO

-- Gráfica: 6
CREATE OR ALTER PROCEDURE PROC_RegistroJugadores
AS
BEGIN
	SELECT TOP 10 Usuario.GamerTag AS Jugador, COUNT(Puntuacion.Registro) AS Visitas
	FROM Usuario
	JOIN Puntuacion ON Puntuacion.IDUsuario = Usuario.IDUsuario
	GROUP BY Usuario.GamerTag
	ORDER BY Visitas ASC;
END;
GO




-- Gráfica: 7 (ADMIN)
CREATE OR ALTER PROCEDURE PROC_VistaPaises
AS
BEGIN
	SELECT Pais.*
	FROM Pais
	INNER JOIN Usuario ON Pais.IDPais = Usuario.IDPais
	GROUP BY Pais.IDPais, Pais.Nombre
	HAVING COUNT(Usuario.IDUsuario) > 0;
 
END;
GO

-- Gráfica: 8 (ADMIN)
CREATE OR ALTER PROCEDURE PROC_VistaTutor
AS
BEGIN
	SELECT *
	FROM Tutor
	ORDER BY IDTutor;
END;
GO

-- Gráfica: 9 (ADMIN)
CREATE OR ALTER PROCEDURE PROC_VistaUsuarios
AS
BEGIN
	SELECT IDUsuario, IDPais, IDTutor, Nombre,
	ApellidoP, ApellidoM, FechaNacim, GamerTag
	FROM Usuario
	ORDER BY IDUsuario;
END;
GO

CREATE OR ALTER PROCEDURE PROC_VistaAdmin
@PageNumber AS INT
AS
BEGIN
	SELECT IDAdmin, Nombre, ApellidoP, 
	ApellidoM, FechaNacim, NombreUser
	FROM [Admin]
	ORDER BY IDAdmin OFFSET (@PageNumber - 1) * 5 ROWS
	FETCH NEXT 5 ROWS ONLY;
END;
GO

CREATE OR ALTER PROCEDURE PROC_PromEdades
AS
BEGIN
	SELECT AVG(YEAR(GETDATE()) - FechaNacim) AS PromEdades
	FROM Usuario
END;
GO

CREATE OR ALTER PROCEDURE PROC_Puntos
AS
BEGIN
	Select IDNivel, MIN(Puntos) AS Puntaje
	FROM Puntuacion
	GROUP BY IDNivel
END;
GO

-- SP para Actualizar datos

CREATE OR ALTER PROCEDURE PROC_Actualizar_Pais
@IDPais AS INT, @Nombre AS VARCHAR(30)
AS
BEGIN 
	UPDATE Pais
	SET Nombre = @Nombre
	WHERE IDPais = @IDPais
END;
GO

CREATE OR ALTER PROCEDURE PROC_Actualizar_Tutor
@IDTutor AS INT, @Nombre AS VARCHAR(30), @ApellidoP AS VARCHAR(30),
@ApellidoM AS VARCHAR(30), @Telefono AS VARCHAR(30), @Correo AS VARCHAR(50)
AS
BEGIN 
	UPDATE Tutor
	SET Nombre = @Nombre, ApellidoP = @ApellidoP, ApellidoM = @ApellidoM,
	Telefono = @Telefono, Correo = @Correo
	WHERE IDTutor = @IDTutor
END;
GO

CREATE OR ALTER PROCEDURE PROC_Actualizar_Niveles
@IDnivel AS INT,
@NombreNiv AS VARCHAR(30)
AS
BEGIN 
	UPDATE Niveles
	SET Nombre = @NombreNiv
	WHERE IDNivel = @IDnivel
END;
GO

CREATE OR ALTER PROCEDURE PROC_Actualizar_Usuario
@IDUsuario AS INT, @NombrePais AS VARCHAR(30), @EmailTutor AS VARCHAR(50),
@Nombre AS VARCHAR(30), @ApellidoP AS VARCHAR(30), @ApellidoM AS VARCHAR(30),
@FechaNacim AS INT, @GamerTag AS VARCHAR(50)
AS
BEGIN
	DECLARE @PaisSearch AS INT;
	DECLARE @TutorSearch AS INT;
	SELECT @PaisSearch = (SELECT IDPais FROM Pais WHERE Nombre LIKE @NombrePais);
	SELECT @TutorSearch = (SELECT IDTutor FROM Tutor WHERE Correo LIKE @EmailTutor);
	UPDATE Usuario
	SET IDPais = @PaisSearch, IDTutor = @TutorSearch, Nombre = @Nombre, ApellidoP = @ApellidoP,
	ApellidoM = @ApellidoM, FechaNacim = @FechaNacim, GamerTag = @GamerTag
	WHERE IDUsuario = @IDUsuario
END;
GO

CREATE OR ALTER PROCEDURE PROC_Actualizar_Admin
@IDAdmin AS INT, @Nombre AS VARCHAR(30), @ApellidoP AS VARCHAR(30),  @ApellidoM AS VARCHAR(30),
@FechaNacim AS INT, @NombreUser AS VARCHAR(50)
AS
BEGIN
	UPDATE [Admin]
	SET Nombre = @Nombre, ApellidoP = @ApellidoP, ApellidoM = @ApellidoM,
	FechaNacim = @FechaNacim, NombreUser = @NombreUser
	WHERE IDAdmin = @IDAdmin
END;
GO

CREATE OR ALTER PROCEDURE PROC_Actualizar_ContraU
@IDUsuario AS INT, @Contraseña AS VARCHAR(96)
AS
BEGIN
	UPDATE Usuario
	SET Contraseña = @Contraseña
	WHERE IDUsuario = @IDUsuario
END;
GO

CREATE OR ALTER PROCEDURE PROC_Actualizar_ContraA
@IDAdmin AS INT, @Contraseña AS VARCHAR(96)
AS
BEGIN
	UPDATE [Admin]
	SET Contraseña = @Contraseña
	WHERE IDAdmin = @IDAdmin
END;
GO

CREATE OR ALTER PROCEDURE PROC_Actualizar_Puntuacion
@IDPuntos AS INT,
@Puntos AS INT
AS
BEGIN
	UPDATE Puntuacion
	SET Puntos = @Puntos
	WHERE IDPuntos = @IDPuntos
END;
GO


-- SP para Borrar datos
CREATE OR ALTER PROCEDURE PROC_Borrar_Pais
@NombrePais AS VARCHAR(30)
AS
BEGIN
	DECLARE @PaisSearch AS INT;
	SELECT @PaisSearch = (SELECT IDPais FROM Pais WHERE Nombre LIKE @NombrePais);
	DELETE FROM Pais WHERE IDPais = @PaisSearch 
END;
GO

CREATE OR ALTER PROCEDURE PROC_Borrar_Tutor
@EmailTutor AS VARCHAR(50)
AS
BEGIN
	DECLARE @TutorSearch AS INT;
	SELECT @TutorSearch = (SELECT IDTutor FROM Tutor WHERE Correo LIKE @EmailTutor);
	DELETE FROM Tutor WHERE IDTutor = @TutorSearch
END;
GO

CREATE OR ALTER PROCEDURE PROC_Borrar_Niveles
@IDNivel AS INT
AS
BEGIN
	DELETE FROM Niveles WHERE IDNivel = @IDNivel
END;
GO

CREATE OR ALTER PROCEDURE PROC_Borrar_Usuario
@GamerTag AS VARCHAR(50)
AS
BEGIN
	DECLARE @UsuarioSearch AS INT;
	SELECT @UsuarioSearch = (SELECT IDUsuario FROM Usuario WHERE GamerTag LIKE @GamerTag);
	DELETE FROM Usuario WHERE IDUsuario = @UsuarioSearch
END;
GO

CREATE OR ALTER PROCEDURE PROC_Borrar_Admin
@NombreUser AS VARCHAR(50)
AS
BEGIN
	DECLARE @AdminSearch AS INT;
	SELECT @AdminSearch = (SELECT IDAdmin FROM [Admin] WHERE NombreUser LIKE @NombreUser);
	DELETE FROM [Admin] WHERE IDAdmin = @AdminSearch
END;
GO

CREATE OR ALTER PROCEDURE PROC_Borrar_Puntos
@IDPuntos AS INT
AS
BEGIN
	DELETE FROM Puntuacion WHERE IDPuntos = @IDPuntos
END;
GO

CREATE OR ALTER PROCEDURE PROC_Borrar_PuntMenor
@Puntos AS INT
AS
BEGIN
	DELETE FROM Puntuacion WHERE Puntos < @Puntos;
END;
GO