uCREATE DATABASE IF NOT EXISTS cticsac DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE cticsac;

CREATE TABLE IF NOT EXISTS empresa (
id_empresa int NOT NULL AUTO_INCREMENT,
nombre varchar(70) NOT NULL,
ruc varchar(20) NOT NULL,
direccion varchar(45) NOT NULL,
telefono varchar(9) NOT NULL,
PRIMARY KEY (id_empresa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO empresa (nombre, ruc, direccion, telefono) VALUES
('Empresa del Sur', '12345678901', 'Avenida Principal 123', '123456789'),
('Compañía de Transporte Rápido', '23456789012', 'Calle Central 456', '234567890'),
('Servicios Tecnológicos Innovadores', '34567890123', 'Plaza Mayor 789', '345678901'),
('Industrias del Norte', '45678901234', 'Carretera Secundaria 567', '456789012'),
('Comercializadora Internacional', '56789012345', 'Callejón de la Montaña 890', '567890123'),
('Constructora Moderna', '67890123456', 'Avenida de los Constructores 123', '678901234'),
('Agropecuaria San Juan', '78901234567', 'Camino Rural 456', '789012345'),
('Consultoría Estratégica Global', '89012345678', 'Paseo Empresarial 789', '890123456'),
('Tiendas del Este', '90123456789', 'Boulevard Comercial 012', '901234567'),
('Distribuidora de Alimentos', '01234567890', 'Avenida de los Almacenes 345', '012345678'),
('Inversiones Financieras', '12345098761', 'Plaza Financiera 678', '123450987'),
('Manufacturas Industriales', '23456109872', 'Calle de las Fábricas 901', '234561098'),
('Importadora de Productos', '34567210983', 'Calle de las Importaciones 234', '345672109'),
('Exportadora de Servicios', '45678321094', 'Avenida de las Exportaciones 567', '456783210'),
('Agencia de Publicidad Creativa', '56789432105', 'Calle de la Creatividad 890', '567894321'),
('Estudio Jurídico & Asociados', '67890543216', 'Avenida Legal 123', '678905432'),
('Inmobiliaria del Oeste', '78901654327', 'Calle Inmobiliaria 456', '789016543'),
('Empresa de Energías Renovables', '89012765438', 'Avenida Ecológica 789', '890127654'),
('Consultoría de Recursos Humanos', '90123876549', 'Calle de los Recursos 012', '901238765'),
('Compañía de Telecomunicaciones', '01234987650', 'Avenida de las Comunicaciones 345', '012349876'),
('Constructora Residencial', '12345098761', 'Calle de las Construcciones 678', '123450987');

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

INSERT INTO rol (id_rol, rol) VALUES
(1, 'admin'),
(2, 'empleado');

CREATE TABLE IF NOT EXISTS usuario (
id_usuario int NOT NULL AUTO_INCREMENT,
usuario varchar(60) NOT NULL,
password varchar(45) NOT NULL,
correo varchar(60) NOT NULL,
telefono char(9) NOT NULL,
id_rol int NOT NULL,
PRIMARY KEY (id_usuario),
KEY id_rol_idx (id_rol),
CONSTRAINT id_rol FOREIGN KEY (id_rol) REFERENCES rol (id_rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO usuario (usuario, password, nombres, apellidos, correo, telefono, id_rol) VALUES
('giovanni', 'gio2023$', 'Giovanni', 'Risco Collazos', 'giova@gmail.com', '935627744', 2),
('ciro', 'ci2023$', 'Ciro Antony', 'Vasquez Mendez', 'ciro@gmail.com', '967864367', 2),
('aly', 'aly2023$', 'Aly Jesus', 'Laos Cortez', 'aly@gmail.com', '983900638', 2),
('admin', 'admin$2023', 'Admin', 'Admin', 'admin@gmail.com', '955421566', 1);
