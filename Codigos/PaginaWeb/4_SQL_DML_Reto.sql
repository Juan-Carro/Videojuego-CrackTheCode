-- Reto -> DML
USE RetoBD;
GO

INSERT INTO Niveles VALUES ('Level 1');
INSERT INTO Niveles VALUES ('Level 2');
INSERT INTO Niveles VALUES ('Level 3');
GO

INSERT INTO Pais VALUES ('Argentina');
INSERT INTO Pais VALUES ('Belice');
INSERT INTO Pais VALUES ('Bolivia');
INSERT INTO Pais VALUES ('Brasil');
INSERT INTO Pais VALUES ('Chile');
INSERT INTO Pais VALUES ('Colombia');
INSERT INTO Pais VALUES ('Costa Rica');
INSERT INTO Pais VALUES ('Cuba');
INSERT INTO Pais VALUES ('Ecuador');
INSERT INTO Pais VALUES ('El Salvador');
INSERT INTO Pais VALUES ('Guatemala');
INSERT INTO Pais VALUES ('Guyana');
INSERT INTO Pais VALUES ('Haití');
INSERT INTO Pais VALUES ('Honduras');
INSERT INTO Pais VALUES ('Jamaica');
INSERT INTO Pais VALUES ('México');
INSERT INTO Pais VALUES ('Nicaragua');
INSERT INTO Pais VALUES ('Panamá');
INSERT INTO Pais VALUES ('Paraguay');
INSERT INTO Pais VALUES ('Perú');
INSERT INTO Pais VALUES ('Puerto Rico');
INSERT INTO Pais VALUES ('República Dominicana');
INSERT INTO Pais VALUES ('Surinam');
INSERT INTO Pais VALUES ('Uruguay');
INSERT INTO Pais VALUES ('Venezuela');
GO

INSERT INTO Tutor VALUES ('Paco', 'Rivera', 'Mendoza', '5589765432', 'paco.rivera45@gmail.com');
INSERT INTO Tutor VALUES ('Maria', 'Estrada', 'Cruz', '5553745214', 'mariaEstra_jsol@gmail.com');
INSERT INTO Tutor VALUES ('Emilio', 'Posada', 'García', '555267847', 'emi_posada1975@icloud.com');
INSERT INTO Tutor VALUES ('Paola', 'Torres', 'Pérez', '5584567843', 'pao.torres@yahoo.com');
INSERT INTO Tutor VALUES ('Santiago', 'Rios', 'Mejía', '5567938345', 'sants.mej@gmail.com');
INSERT INTO Tutor VALUES ('Regina', 'Suárez', 'Álvarez','5593456781', 'Reginaaa_srz@hotmail.com');
INSERT INTO Tutor VALUES ('Andrea', 'Cervantes', 'Ibarra', '5534678323', 'cervnt_andy@outlook.com');
INSERT INTO Tutor VALUES ('Julio', 'Ortiz', 'Valle', '5534354678', 'ortizValle_jules@gmail.com');
GO

INSERT INTO Usuario VALUES (6, 1, 'Ernesto', 'Rivera', 'Mendoza', 2008, 'TheNetoo', 'Mypassword');
INSERT INTO Usuario VALUES (6, 1, 'Frida', 'Rivera', 'Mendoza', 2009, 'LoveQueen', 'Riveraco');
INSERT INTO Usuario VALUES (20, 2, 'Andres', 'Estrada', 'Cruz', 2006, 'Andresol', 'Elcompadre');
INSERT INTO Usuario VALUES (16, 3, 'Matias', 'Posada', 'García', 2011, 'Cilantromaty', '2Contra2');
INSERT INTO Usuario VALUES (16, 4, 'Daniel', 'Torres', 'Pérez', 2011, 'comander02', 'ilovepizza');
INSERT INTO Usuario VALUES (16, 4, 'Sofia', 'Torres', 'Pérez', 2009, 'Sofia34', 'fod');
INSERT INTO Usuario VALUES (6, 5, 'Omar', 'Rios', 'Mejía', 2011, 'caballeroAzul', 'yogur4_D');
INSERT INTO Usuario VALUES (20, 6, 'Valentín', 'Suárez', 'Álvarez', 2006, 'LinVelrt', 'Theborn');
INSERT INTO Usuario VALUES (1, 7, 'Fernando', 'Cervantes', 'Ibarra', 2010, 'Knight', 'loyal');
INSERT INTO Usuario VALUES (1, 7, 'Rodrigo', 'Cervantes', 'Ibarra', 2008, 'CervRodri', 'segura');
INSERT INTO Usuario VALUES (21, 8, 'Israel', 'Ortiz', 'Valle', 2010, 'ValleISRA', 'poiuyt');
INSERT INTO Usuario VALUES (21, 8, 'Fabiola', 'Ortiz', 'Valle', 2006, 'Fabiola_ortz', 'progra');

GO

INSERT INTO [Admin] VALUES ('Héctor', 'González', 'Sánchez', 2003, 'Gonza.Hector', 'contra3');
INSERT INTO [Admin] VALUES ('Carlos', 'Carro', 'Cruz', 2002, 'Carro.Cruz', '123456');
INSERT INTO [Admin] VALUES ('Luis', 'Abarca', 'Gómez', 2003, 'Abarca.Luis', 'qwert');
GO

-- (IDNivel, IDUsuario, Puntos, Registro)
INSERT INTO Puntuacion VALUES (1, 1, 3000, '2023-03-18');
INSERT INTO Puntuacion VALUES (1, 1, 3908, '2023-03-24');
INSERT INTO Puntuacion VALUES (1, 1, 2038, '2023-03-26');
INSERT INTO Puntuacion VALUES (1, 1, 2008, '2023-03-29');
INSERT INTO Puntuacion VALUES (2, 1, 1073, '2023-04-09');
INSERT INTO Puntuacion VALUES (2, 1, 2033, '2023-04-18');
INSERT INTO Puntuacion VALUES (2, 1, 2052, '2023-04-21');
INSERT INTO Puntuacion VALUES (2, 1, 1233, '2023-04-24');
INSERT INTO Puntuacion VALUES (3, 1, 302, '2023-04-13');
INSERT INTO Puntuacion VALUES (3, 1, 1302, '2023-04-14');
INSERT INTO Puntuacion VALUES (3, 1, 2302, '2023-04-25');
INSERT INTO Puntuacion VALUES (3, 1, 2502, '2023-04-27');
INSERT INTO Puntuacion VALUES (1, 2, 1050, '2023-03-15');
INSERT INTO Puntuacion VALUES (2, 2, 2000, '2023-03-21');
INSERT INTO Puntuacion VALUES (2, 2, 3040, '2023-03-21');
INSERT INTO Puntuacion VALUES (2, 2, 4100, '2023-03-22');
INSERT INTO Puntuacion VALUES (1, 3, 1043, '2023-03-22');
INSERT INTO Puntuacion VALUES (2, 3, 320, '2023-03-26');
INSERT INTO Puntuacion VALUES (2, 3, 1000, '2023-03-26');
INSERT INTO Puntuacion VALUES (2, 3, 3000, '2023-03-29');
INSERT INTO Puntuacion VALUES (3, 3, 1089, '2023-04-05');
INSERT INTO Puntuacion VALUES (1, 4, 900, '2023-03-18');
INSERT INTO Puntuacion VALUES (1, 4, 2900, '2023-03-21');
INSERT INTO Puntuacion VALUES (3, 4, 907, '2023-03-24');
INSERT INTO Puntuacion VALUES (1, 5, 3005, '2023-03-26');
INSERT INTO Puntuacion VALUES (1, 6, 1020, '2023-03-31');
INSERT INTO Puntuacion VALUES (1, 6, 1208, '2023-04-01');
INSERT INTO Puntuacion VALUES (1, 7, 3002, '2023-04-07');
INSERT INTO Puntuacion VALUES (2, 7, 3206, '2023-04-09');
INSERT INTO Puntuacion VALUES (3, 7, 3045, '2023-04-11');
INSERT INTO Puntuacion VALUES (1, 8, 2019, '2023-03-24');
INSERT INTO Puntuacion VALUES (1, 9, 220, '2023-03-27');
INSERT INTO Puntuacion VALUES (1, 9, 504, '2023-03-31');
INSERT INTO Puntuacion VALUES (1, 10, 1408, '2023-03-27');
INSERT INTO Puntuacion VALUES (1, 10, 1078, '2023-03-29');
INSERT INTO Puntuacion VALUES (1, 10, 2003, '2023-03-31');
INSERT INTO Puntuacion VALUES (2, 10, 1090, '2023-04-05');
INSERT INTO Puntuacion VALUES (2, 10, 1805, '2023-04-06');
INSERT INTO Puntuacion VALUES (2, 10, 1900, '2023-04-10');
INSERT INTO Puntuacion VALUES (3, 10, 1029, '2023-04-15');
INSERT INTO Puntuacion VALUES (1, 11, 2029, '2023-04-18');
INSERT INTO Puntuacion VALUES (1, 12, 3359, '2023-04-15');
GO
