const express = require("express");
const mysql = require("mysql");
const bodyParser = require("body-parser");
const cors = require("cors");
const session = require("express-session");
const multer = require("multer");
const fs = require("fs");

const app = express();
app.use(bodyParser.json());
app.use(cors());
app.use(
  session({
    secret: "qwertyuiop",
    resave: false,
    saveUninitialized: false,
  })
);

// Conexión a la base de datos
const connection = mysql.createConnection({
  host: "localhost",
  user: "Vasquez",
  password: "MVasquez#19",
  database: "cticsac",
  port: 3306,
});

connection.connect((err) => {
  if (err) {
    console.error("Error al conectar con la BD:", err);
    return;
  }
  console.log("Conexión exitosa!");
});

// Configuración de almacenamiento de archivos con multer
const storage = multer.diskStorage({
  destination: "uploads/",
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  },
});

const upload = multer({ storage: storage });

// Ruta para el manejo de sesiones
app.post("/api/login", (req, res) => {
  const { usuario, password } = req.body;
  const query = `SELECT * FROM usuario WHERE usuario = '${usuario}' AND password = '${password}' AND estado = 1`; // Agregar condición "estado = 1"

  connection.query(query, (err, results) => {
    if (err) {
      console.error("Error al ejecutar la query:", err);
      res.status(500).send("Error en el servidor");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("Credenciales incorrectas o usuario inactivo"); // Actualizar mensaje de error
      return;
    }
    const user = results[0];
    req.session.user = user;
    res.status(200).json(user);
  });
});

// ruta para el manejo de cierre de sesion
app.post("/api/logout", (req, res) => {
  req.session.destroy();
  res.status(200).send("Cierro de sesion exitoso!");
});

// middleware para verificar si el usuario ha iniciado sesión
const requireLogin = (req, res, next) => {
  if (!req.session.user) {
    res.status(401).send("Restringido");
    return;
  }
  next();
};

// Ruta protegida que requiere inicio de sesión
app.get("/api/protected", requireLogin, (req, res) => {
  res.status(200).send("No puede continuar");
});

// Ruta para obtener todas las empresas
app.get("/api/companies", (req, res) => {
  const query = "SELECT * FROM empresa";

  connection.query(query, (err, results) => {
    if (err) {
      console.error("Error al obtener las empresas:", err);
      res.status(500).json({ error: "Error en el servidor" });
      return;
    }

    res.json(results);
  });
});

// Ruta para obtener una sola empresa
app.get("/api/companies/:id", (req, res) => {
  const { id } = req.params;
  const query = `SELECT id_empresa, nombre, ruc, direccion, telefono, imagen FROM empresa WHERE id_empresa = ${id}`;

  connection.query(query, (err, results) => {
    if (err) {
      console.error("Error al obtener la empresa:", err);
      res.status(500).json({ error: "Error en el servidor" });
      return;
    }

    if (results.length === 0) {
      res.status(404).json({ error: "No se encontró la empresa" });
      return;
    }

    res.json(results[0]);
  });
});

// Ruta para crear una nueva empresa con imagen
app.post("/api/companies", upload.single("imagen"), (req, res) => {
  const { nombre, ruc, direccion, telefono } = req.body;
  const imagenPath = req.file.path;

  const imagenData = fs.readFileSync(imagenPath);

  const query = `INSERT INTO empresa (nombre, ruc, direccion, telefono, imagen) VALUES (?, ?, ?, ?, ?)`;
  const values = [nombre, ruc, direccion, telefono, imagenData];

  connection.query(query, values, (err, results) => {
    if (err) {
      console.error("Error al crear la empresa:", err);
      res.status(500).json({ error: "Error en el servidor" });
      return;
    }

    fs.unlinkSync(imagenPath);

    res.status(201).json({ message: "Empresa creada exitosamente" });
  });
});

// Ruta para actualizar los datos de una empresa existente con imagen
app.put("/api/companies/:id", upload.single("imagen"), (req, res) => {
  const { id } = req.params;
  const { nombre, ruc, direccion, telefono } = req.body;
  const imagenPath = req.file?.path;

  let query = "UPDATE empresa SET ";
  const values = [];

  if (nombre) {
    query += "nombre = ?, ";
    values.push(nombre);
  }
  if (ruc) {
    query += "ruc = ?, ";
    values.push(ruc);
  }
  if (direccion) {
    query += "direccion = ?, ";
    values.push(direccion);
  }
  if (telefono) {
    query += "telefono = ?, ";
    values.push(telefono);
  }
  if (imagenPath) {
    const imagenData = fs.readFileSync(imagenPath);
    query += "imagen = ?, ";
    values.push(imagenData);
  }

  // Remove the trailing comma and space
  query = query.slice(0, -2);

  query += ` WHERE id_empresa = ${id}`;

  connection.query(query, values, (err, results) => {
    if (err) {
      console.error("Error al actualizar la empresa:", err);
      res.status(500).json({ error: "Error en el servidor" });
      return;
    }

    if (results.affectedRows === 0) {
      res.status(404).json({ error: "No se encontró la empresa" });
      return;
    }

    if (imagenPath) {
      fs.unlinkSync(imagenPath);
    }

    res.json({ message: "Empresa actualizada exitosamente" });
  });
});

// Ruta para obtener todos los servicios
app.get("/api/services", (req, res) => {
  const query = "SELECT * FROM servicios";

  connection.query(query, (err, results) => {
    if (err) {
      console.error("Error al obtener los servicios:", err);
      res.status(500).json({ error: "Error en el servidor" });
      return;
    }

    res.json(results);
  });
});

// Ruta para obtener todos los empleados
app.get("/api/usuario", (req, res) => {
  const query = "SELECT * FROM usuario";

  connection.query(query, (err, results) => {
    if (err) {
      console.error("Error al obtener la lista de empleados:", err);
      res.status(500).json({ error: "Error en el servidor" });
      return;
    }

    res.json(results);
  });
});

// Ruta para crear un nuevo empleado con imagen
app.post("/api/usuario", upload.single("imagen"), (req, res) => {
  const {
    usuario,
    password,
    nombres,
    apellidos,
    correo,
    telefono,
    id_rol,
    id_empresa,
    estado,
  } = req.body;
  const imagenPath = req.file.path;

  const imagenData = fs.readFileSync(imagenPath);

  const query = `INSERT INTO usuario (usuario, password, nombres, apellidos, correo, telefono, id_rol, id_empresa, estado, imagen) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
  const values = [
    usuario,
    password,
    nombres,
    apellidos,
    correo,
    telefono,
    id_rol,
    id_empresa,
    estado,
    imagenData,
  ];

  connection.query(query, values, (err, results) => {
    if (err) {
      console.error("Error al crear el empleado:", err);
      res.status(500).json({ error: "Error en el servidor" });
      return;
    }

    fs.unlinkSync(imagenPath);

    res.status(201).json({ message: "Empleado creado exitosamente" });
  });
});

// Ruta para actualizar los datos de un empleado existente
app.put("/api/usuario/:id", upload.single("imagen"), (req, res) => {
  const { id } = req.params;
  const {
    usuario,
    password,
    nombres,
    apellidos,
    correo,
    telefono,
    id_rol,
    id_empresa,
    estado,
  } = req.body;
  const imagenPath = req.file?.path;

  let query = "UPDATE usuario SET ";
  const values = [];

  if (usuario) {
    query += "usuario = ?, ";
    values.push(usuario);
  }
  if (password) {
    query += "password = ?, ";
    values.push(password);
  }
  if (nombres) {
    query += "nombres = ?, ";
    values.push(nombres);
  }
  if (apellidos) {
    query += "apellidos = ?, ";
    values.push(apellidos);
  }
  if (correo) {
    query += "correo = ?, ";
    values.push(correo);
  }
  if (telefono) {
    query += "telefono = ?, ";
    values.push(telefono);
  }
  if (id_rol) {
    query += "id_rol = ?, ";
    values.push(id_rol);
  }
  if (id_empresa) {
    query += "id_empresa = ?, ";
    values.push(id_empresa);
  }
  if (estado) {
    query += "estado = ?, ";
    values.push(estado);
  }
  if (imagenPath) {
    const imagenData = fs.readFileSync(imagenPath);
    query += "imagen = ?, ";
    values.push(imagenData);
  }

  // Eliminar la coma y el espacio adicionales al final de la consulta
  query = query.slice(0, -2);
  query += ` WHERE id_usuario = ${id}`;

  connection.query(query, values, (err, results) => {
    if (err) {
      console.error("Error al actualizar el empleado:", err);
      res.status(500).json({ error: "Error en el servidor" });
      return;
    }

    if (imagenPath) {
      fs.unlinkSync(imagenPath);
    }

    res.status(200).json({ message: "Empleado actualizado exitosamente" });
  });
});

// Ruta para obtener la lista de roles
app.get("/api/roles", (req, res) => {
  const query = "SELECT id_rol, rol FROM rol";

  connection.query(query, (err, results) => {
    if (err) {
      console.error("Error al obtener la lista de roles:", err);
      res.status(500).json({ error: "Error en el servidor" });
      return;
    }

    res.json(results);
  });
});

// Ruta para obtener la imagen de un empleado por su ID
app.get("/api/usuario/:id/imagen", (req, res) => {
  const { id } = req.params;
  const query = `SELECT imagen FROM usuario WHERE id_usuario = ${id}`;

  connection.query(query, (err, results) => {
    if (err) {
      console.error("Error al obtener la imagen:", err);
      res.status(500).json({ error: "Error en el servidor" });
      return;
    }

    if (results.length === 0 || !results[0].imagen) {
      res.status(404).json({ error: "No se encontró la imagen" });
      return;
    }

    const image = results[0].imagen;
    res.writeHead(200, {
      "Content-Type": "image/jpeg",
      "Content-Length": image.length,
    });
    res.end(image);
  });
});

// Ruta para obtener la imagen de un empleado por su ID
app.get("/api/companies/:id/imagen", (req, res) => {
  const { id } = req.params;
  const query = `SELECT imagen FROM empresa WHERE id_empresa = ${id}`;

  connection.query(query, (err, results) => {
    if (err) {
      console.error("Error al obtener la imagen:", err);
      res.status(500).json({ error: "Error en el servidor" });
      return;
    }

    if (results.length === 0 || !results[0].imagen) {
      res.status(404).json({ error: "No se encontró la imagen" });
      return;
    }

    const image = results[0].imagen;
    res.writeHead(200, {
      "Content-Type": "image/jpeg",
      "Content-Length": image.length,
    });
    res.end(image);
  });
});

// Iniciar el servidor
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Iniciando servidor en el puerto: ${PORT}`));
