const express = require('express');
const mssql = require('mssql');
const cors = require('cors');
const helmet = require('helmet');

const port = 8080;
const ipAddr = '3.219.153.3';

const app = express();
app.use(express.static(__dirname + '/public'));
app.use(express.json());
app.use(helmet());
app.use(cors());

const dbConfig = {
  user: process.env.MSSQL_USER,
  password: process.env.MSSQL_PASSWORD,
  database: 'RetoBD',
  server: 'localhost',
  pool: { max: 10, min: 0, idleTimeoutMillis: 30000 },
  options: { trustServerCertificate: true }
};


/*------------------------------ ENVÍO DE DATOS ----------------------------- */


// Insertar puntos desde unity
app.post('/insertaPuntos', async(req, res) => {
  try {
    const {nivel, gamertag, puntos, registro} = req.body;
    
    const pool = await mssql.connect(dbConfig);
    
    const request = pool.request();
    request.input('NombreNivel', mssql.VarChar(30), nivel);
    request.input('GamerTag', mssql.VarChar(50), gamertag);
    request.input('Puntos', mssql.Int(), puntos);
    request.input('Registro', mssql.Date(), registro);
    const result = await request.execute('PROC_Insertar_Puntuacion');
    
    return res.status(200).send('Puntuación agregada');
    
  } catch (err) {
    return res.status(500).send('Error al insertar los puntos');
  }
});


// REGISTRAR DATOS DE UN USUARIO POR PRIMERA VEZ
app.post('/userinfo', async(req, res) => {
  try {
    const { nameT, lastT1, lastT2, email, phone, nameE, lastE1, lastE2, bdate, gamertag, pwd, ctry } = req.body;

    const pool = await mssql.connect(dbConfig);
        
    const request1 = pool.request();
    request1.input('Nombre', mssql.VarChar(30), nameT); 
    request1.input('ApellidoP', mssql.VarChar(30), lastT1);
    request1.input('ApellidoM', mssql.VarChar(30), lastT2);
    request1.input('Correo', mssql.VarChar(50), email);
    request1.input('Telefono', mssql.VarChar(30), phone);
    const result1 = await request1.execute('PROC_Insertar_Tutor');

    const request2 = pool.request();
    request2.input('Nombre', mssql.VarChar(30), nameE);
    request2.input('ApellidoP', mssql.VarChar(30), lastE1);
    request2.input('ApellidoM', mssql.VarChar(30), lastE2);
    request2.input('FechaNacim',mssql.Int(), bdate);
    request2.input('EmailTutor',mssql.VarChar(50), email);
    request2.input('GamerTag',mssql.VarChar(50), gamertag);
    request2.input('Contraseña', mssql.VarChar(96), pwd);
    request2.input('NombrePais', mssql.VarChar(30), ctry);
    const result2 = await request2.execute('PROC_Insertar_Usuario');

    return res.status(201).send('OK');
    
  } catch (err) {
    return res.status(401).send('Error, puede que el gamertag ya esté en uso');
  }
});


// LOGIN DE USUARIO
app.post('/login', async(req, res) => {
  try {
    const {gamertag, pwd} = req.body;
    const pool = await mssql.connect(dbConfig);
    
    const request = pool.request();
    request.input('GamerTag', mssql.VarChar(50), gamertag);
    request.input('Contraseña', mssql.VarChar(96), pwd);
    request.output('Success', mssql.Bit());
    const result = await request.execute('PROC_Login');
    
    if(result.output.Success == true) {
      return res.status(201).send('OK');
    } else {
      return res.status(401).send('Gamertag y/o contraseña incorrecta');
    }
    
  } catch (err) {
    return res.status(500).send('Error en la conexión a la BD');
    
  }
});


// LOGIN DE ADMINISTRADOR
app.post('/loginAdmin', async(req, res) => {
  try {
    const {nombreuser, pwd} = req.body;
    const pool = await mssql.connect(dbConfig);
    
    const request = pool.request();
    request.input('NombreUser', mssql.VarChar(50), nombreuser);
    request.input('Contraseña', mssql.VarChar(96), pwd);
    request.output('Success', mssql.Bit());
    const result = await request.execute('PROC_Login_Admin');
    
    if(result.output.Success == true) {
      return res.status(201).send('OK');
    } else {
      return res.status(401).send('No tiene permisos de administrador');
    }
    
  } catch (err) {
    return res.status(500).send('Error en la conexión a la BD');
    
  }
});


// REGISTRO DE ADMINISTRADOR
app.post('/registerAdmin', async(req, res) => {
  try {
    const {name, lastP, lastM, bdate, pwd, user} = req.body;
    
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    request.input('Nombre', mssql.VarChar(30), name);
    request.input('ApellidoP', mssql.VarChar(30), lastP);
    request.input('ApellidoM', mssql.VarChar(30), lastM);
    request.input('FechaNacim', mssql.Int(), bdate);
    request.input('NombreUser', mssql.VarChar(50), user);
    request.input('Contraseña', mssql.VarChar(96), pwd);
    const result = await request.execute('PROC_Insertar_Admin');
    
    return res.status(201).send('Administrador ingresado');
    
  } catch (err) {
    return res.status(500).send('Error en la conexión a la BD');
  }
});


/*----------------------- ACTUALIZADO Y BORRADO ----------------------------- */


// Actualizar un país
app.put('/updateCtry', async (req, res) => {
  try {
    const {idPais, nombre} = req.body;
    
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    
    request.input('IDPais', mssql.Int(), idPais);
    request.input('Nombre', mssql.VarChar(30), nombre);
    
    const result = await request.execute('PROC_Actualizar_Pais');
    
    return res.status(200).send('País Actualizado');
  } catch (err) {
    return res.status(500).send('Error: ' + err.message);
  }
});


// Actualizar un usuario
app.put('/updateUser', async (req, res) => {
  try {
    const {id, name, lastP, lastM, ctry, email, bdate, gamertag } = req.body;
    
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    
    request.input('IDUsuario', mssql.Int(), id);
    request.input('Nombre', mssql.VarChar(30), name);
    request.input('ApellidoP', mssql.VarChar(50), lastP);
    request.input('ApellidoM', mssql.VarChar(30), lastM);
    request.input('NombrePais', mssql.VarChar(30), ctry);
    request.input('EmailTutor', mssql.Int, email);
    request.input('FechaNacim', mssql.VarChar(50), bdate);
    request.input('GamerTag', mssql.VarChar(50), gamertag);
    
    const result = await request.execute('PROC_Actualizar_Usuario');
    
    return res.status(200).send('Usuario Actualizado');
    
  } catch (err) {
    return res.status(500).send('Error: ' + err.message);
  }
});


// Actualizar un tutor
app.put('/updateTutor', async (req, res) => {
  try {
    const {id, name, lastP, lastM, phone, email} = req.body;
    
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    
    request.input('IDTutor', mssql.Int(), id);
    request.input('Nombre', mssql.VarChar(30), name);
    request.input('ApellidoP', mssql.VarChar(30), lastP);
    request.input('ApellidoM', mssql.VarChar(30), lastM);
    request.input('Telefono', mssql.VarChar(30), phone);
    request.input('Correo', mssql.VarChar(50), email);
    
    const result = await request.execute('PROC_Actualizar_Tutor');
    
    return res.status(200).send('Tutor Actualizado');
    
  } catch (err) {
    return res.status(500).send('Error: ' + err.message);
  }
});


// Borrar un país
app.delete('/deleteCtry', async (req, res) => {
  try {
    const {name} = req.body;
    
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    
    request.input('NombrePais', mssql.VarChar(30), name);
    const result = await request.execute('PROC_Borrar_Pais');
    
    return res.status(200).send('El pais se ha borrado');
    
  } catch (err) {
    return res.status(500).send('Error: ' + err.message);
  }
});


// Borrar un usuario
app.delete('/deleteUser', async (req, res) => {
  try {
    const {gamerTag} = req.body;
    
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    
    request.input('GamerTag', mssql.VarChar(50), gamerTag);
    const result = await request.execute('PROC_Borrar_Usuario');
    
    return res.status(200).send('El usuario se ha borrado');
    
  } catch (err) {
    return res.status(500).send('Error: ' + err.message);
  }
});


// Borrar un tutor
app.delete('/deleteTutor', async (req, res) => {
  try {
    const {email} = req.body;
    
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    
    request.input('EmailTutor', mssql.VarChar(50), email);
    const result = await request.execute('PROC_Borrar_Tutor');
    
    return res.status(200).send('El tutor se ha borrado');
    
  } catch (err) {
    return res.status(500).send('Error: ' + err.message);
  }
});


/*------------------------------ GRÁFICAS ------------------------------------*/


// Tabla de puntuaciones
app.get('/puntuaciones/:page', async (req, res) => {
  try {
    const pageNumber = parseInt(req.params.page);
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    request.input('PageNumber', mssql.Int(), pageNumber)
    const result = await request.execute('PROC_LeaderBoard_Pagina');
    const table = result.recordset;
    
    return res.status(200).send({table});
    
  } catch (err) {
    return res.status(400).send('Error en la conexón a la BD');
  }
});


// Usuarios por país
app.get('/countryUser', async(req, res) => {
  try {
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    const result = await request.execute('PROC_UsuariosPais');
    const table = result.recordset;
    
    return res.status(200).send({table});
    
  } catch (err) {
    return res.status(400).send('Error en la conexión a la BD');
  }
});


// Promedio de puntuaciones con nivel
app.get('/scoreAverage', async(req, res) => {
  try {
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    const result = await request.execute('PROC_Puntos');
    const table = result.recordset;
    
    return res.status(200).send({table});
    
  } catch (err) {
    return res.status(400).send('Error en la conexión a la BD');
  }
});


// Usuarios por país
app.get('/ageAverage', async(req, res) => {
  try {
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    const result = await request.execute('PROC_PromEdades');
    const table = result.recordset;
    
    return res.status(200).send({table});
    
  } catch (err) {
    return res.status(400).send('Error en la conexión a la BD');
  }
});


app.get('/ctryLeaderboard', async(req, res) => {
  try {
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    const result = await request.execute('PROC_PuntosPaises');
    const table = result.recordset;
    
    return res.status(200).send({table});
    
  } catch (err) {
    return res.status(400).send('Error en la conexión a la BD');
  }
});


app.get('/scoreAge', async(req, res) => {
  try {
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    const result = await request.execute('PROC_PuntosEdades');
    const table = result.recordset;
    
    return res.status(200).send({table});
    
  } catch (err) {
    return res.status(400).send('Error en la conexión a la BD');
  }
});




// Vista de todos los tutores con paginación
app.get('/tutorInfo', async (req, res) => {
  try{
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    const result = await request.execute('PROC_VistaTutor');
    const table = result.recordset
    
    return res.status(200).send({table});

  } catch (err) {
    return res.status(500).send('Error: ' + err.message);
  }
});


// Vista de todos los usuarios con paginación
app.get('/userInfo', async (req, res) => {
  try{
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    const result = await request.execute('PROC_VistaUsuarios');
    const table = result.recordset;
    
    return res.status(200).send({table});
  
  } catch (err) {
    return res.status(500).send('Error: ' + err.message);
  }
});


// Últimos países Insertados
app.get('/countryInfo', async (req, res) => {
  try{
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    const result = await request.execute('PROC_VistaPaises');
    const table = result.recordset;
    
    return res.status(200).send({table});
    
  } catch (err) {
    res.status(500).send('Error '+ err.message);
  }
});


// Inicio de sesión jugadores por país
app.get('/ctryLogin', async (req, res) => {
  try{
    const pool = await mssql.connect(dbConfig);
    const request = pool.request();
    const result = await request.execute('PROC_RegistroJugadores');
    const table = result.recordset;
    
    return res.status(200).send({table});
    
  } catch (err) {
    return res.status(500).send('Error: ' + err.message);
  }
});


/*---------------------- APLICACIÓN Y PÁGINA 404 -----------------------------*/


app.use((req, res) => {
  res.type('text/plain').status(404).send('404 - Not Found');
});

app.listen(port, () => console.log(
  `Express started on http://${ipAddr}:${port}`
  + '\nPress Ctrl-C to terminate.'));