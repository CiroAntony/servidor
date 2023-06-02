CREATE TABLE IF NOT EXISTS empresa (
id_empresa int NOT NULL AUTO_INCREMENT,
nombre varchar(70) NOT NULL,
ruc varchar(20) NOT NULL,
direccion varchar(45) NOT NULL,
telefono varchar(9) NOT NULL,
PRIMARY KEY (id_empresa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS acta (
id_acta int NOT NULL AUTO_INCREMENT,
fecha_creado date NOT NULL,
id_empresa int NOT NULL,
id_norma int NOT NULL,
PRIMARY KEY (id_acta),
KEY id_empresa_idx (id_empresa,id_norma),
KEY id_norma (id_norma),
CONSTRAINT id_empresa FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS categoria (
id_categoria int NOT NULL AUTO_INCREMENT,
estado char(1) NOT NULL,
PRIMARY KEY (id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS norma (
id_norma int NOT NULL AUTO_INCREMENT,
descripcion varchar(250) NOT NULL,
estado int NOT NULL,
id_categoria int NOT NULL,
PRIMARY KEY (id_norma),
KEY id_categoria_idx (id_categoria),
CONSTRAINT id_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS rol (
id_rol int NOT NULL AUTO_INCREMENT,
rol varchar(45) NOT NULL,
PRIMARY KEY (id_rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE IF NOT EXISTS usuario (
  id_usuario int NOT NULL AUTO_INCREMENT,
  usuario varchar(60) NOT NULL,
  password varchar(45) NOT NULL,
  nombres varchar(200) NOT NULL,
  apellidos varchar(200) NOT NULL,
  correo varchar(160) NOT NULL,
  telefono char(16) NOT NULL,
  id_rol int NOT NULL,
  imagen MEDIUMBLOB,
  PRIMARY KEY (id_usuario),
  KEY id_rol_idx (id_rol),
  CONSTRAINT id_rol FOREIGN KEY (id_rol) REFERENCES rol (id_rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

