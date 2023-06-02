const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const session = require('express-session');
const multer = require('multer');
const fs = require('fs');

const pool = require('./db.js');
const { PORT } = require('./config.js');

const app = express();
app.use(bodyParser.json());
app.use(cors());
app.use(session({
  secret: 'qwertyuiop',
  resave: false,
  saveUninitialized: false
}));

pool.getConnection((err, connection) => {
  if (err) {
    console.error('Error al conectar con la BD:', err);
    return;
  }
  console.log('Conexión exitosa!');
  connection.release();
});

// Configuración de almacenamiento de archivos con multer
const storage = multer.diskStorage({
  destination: 'uploads/',
  filename: function(req, file, cb) {
    cb(null, file.originalname);
  }
});

const upload = multer({ storage: storage });

// Ruta para el manejo de sesiones
app.post('/api/login', (req, res) => {
  const { usuario, password } = req.body;
  const query = `SELECT * FROM usuario WHERE usuario = '${usuario}' AND password = '${password}'`;

  pool.query(query, (err, results) => {
    if (err) {
      console.error('Error al ejecutar la query:', err);
      res.status(500).send('Error en el servidor');
      return;
    }
    if (results.length === 0) {
      res.status(401).send('Credenciales incorrectas');
      return;
    }
    const user = results[0];
    req.session.user = user;
    res.status(200).json(user);
  });
});

// ruta para el manejo de cierre de sesion
app.post('/api/logout', (req, res) => {
  req.session.destroy();
  res.status(200).send('Cierre de sesión exitoso!');
});

// middleware para verificar si el usuario ha iniciado sesión
const requireLogin = (req, res, next) => {
  if (!req.session.user) {
    res.status(401).send('Restringido');
    return;
  }
  next();
};

// Ruta protegida que requiere inicio de sesión
app.get('/api/protected', requireLogin, (req, res) => {
  res.status(200).send('No puede continuar');
});

// Ruta para obtener todas las empresas
app.get('/api/companies', (req, res) => {
  const query = 'SELECT nombre, ruc, direccion, telefono FROM empresa';

  pool.query(query, (err, results) => {
    if (err) {
      console.error('Error al obtener las empresas:', err);
      res.status(500).json({ error: 'Error en el servidor' });
      return;
    }

    res.json(results);
  });
});

// Ruta para crear una nueva empresa
app.post('/api/companies', (req, res) => {
  const { nombre, ruc, direccion, telefono } = req.body;
  const query = `INSERT INTO empresa (nombre, ruc, direccion, telefono) VALUES ('${nombre}', '${ruc}', '${direccion}', '${telefono}')`;

  pool.query(query, (err, results) => {
    if (err) {
      console.error('Error al crear la empresa:', err);
      res.status(500).json({ error: 'Error en el servidor' });
      return;
    }

    res.status(201).json({ message: 'Empresa creada exitosamente' });
  });
});

// Ruta para obtener todos los empleados
app.get('/api/usuario', (req, res) => {
  const query = 'SELECT * FROM usuario';

  pool.query(query, (err, results) => {
    if (err) {
      console.error('Error al obtener la lista de empleados:', err);
      res.status(500).json({ error: 'Error en el servidor' });
      return;
    }

    res.json(results);
  });
});

// Ruta para crear un nuevo empleado con imagen
app.post('/api/usuario', upload.single('imagen'), (req, res) => {
  const { usuario, password, nombres, apellidos, correo, telefono, id_rol } = req.body;
  const imagenPath = req.file.path;

  const imagenData = fs.readFileSync(imagenPath);

  const query = `INSERT INTO usuario (usuario, password, nombres, apellidos, correo, telefono, id_rol, imagen) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;
  const values = [usuario, password, nombres, apellidos, correo, telefono, id_rol, imagenData];

  pool.query(query, values, (err, results) => {
    if (err) {
      console.error('Error al crear el empleado:', err);
      res.status(500).json({ error: 'Error en el servidor' });
      return;
    }

    fs.unlinkSync(imagenPath);

    res.status(201).json({ message: 'Empleado creado exitosamente' });
  });
});

// Ruta para obtener la lista de roles
app.get('/api/roles', (req, res) => {
  const query = 'SELECT id_rol, rol FROM rol';

  pool.query(query, (err, results) => {
    if (err) {
      console.error('Error al obtener la lista de roles:', err);
      res.status(500).json({ error: 'Error en el servidor' });
      return;
    }

    res.json(results);
  });
});

// Ruta para obtener la imagen de un empleado por su ID
app.get('/api/usuario/:id/imagen', (req, res) => {
  const { id } = req.params;
  const query = `SELECT imagen FROM usuario WHERE id_usuario = ${id}`;

  pool.query(query, (err, results) => {
    if (err) {
      console.error('Error al obtener la imagen:', err);
      res.status(500).json({ error: 'Error en el servidor' });
      return;
    }

    if (results.length === 0 || !results[0].imagen) {
      res.status(404).json({ error: 'No se encontró la imagen' });
      return;
    }

    const image = results[0].imagen;
    res.writeHead(200, {
      'Content-Type': 'image/jpeg',
      'Content-Length': image.length
    });
    res.end(image);
  });
});

// Iniciar el servidor
app.listen(PORT, () => console.log(`Iniciando servidor en el puerto: ${PORT}`));

