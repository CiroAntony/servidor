CREATE DATABASE IF NOT EXISTS cticsac DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE cticsac;

CREATE TABLE IF NOT EXISTS empresa (
  id_empresa int NOT NULL AUTO_INCREMENT,
  nombre varchar(70) NOT NULL,
  ruc varchar(20) NOT NULL,
  direccion varchar(45) NOT NULL,
  telefono varchar(9) NOT NULL,
  imagen MEDIUMBLOB,
  PRIMARY KEY (id_empresa)
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
  id_empresa int NOT NULL,
  imagen MEDIUMBLOB,
  estado int,
  PRIMARY KEY (id_usuario),
  KEY id_rol_idx (id_rol),
  KEY id_empresa_idx (id_empresa),
  CONSTRAINT id_rol FOREIGN KEY (id_rol) REFERENCES rol (id_rol),
  CONSTRAINT id_empresa FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE IF NOT EXISTS servicios (
  id_servicio int NOT NULL AUTO_INCREMENT,
  nombre varchar(100) NOT NULL,
  PRIMARY KEY (id_servicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS preguntas (
  id_pregunta int NOT NULL AUTO_INCREMENT,
  servicio_id int NOT NULL,
  pregunta varchar(200) NOT NULL,
  respuesta boolean NOT NULL default 0,
  PRIMARY KEY (id_pregunta),
  KEY servicio_id_idx (servicio_id),
  CONSTRAINT servicio_id FOREIGN KEY (servicio_id) REFERENCES servicios (id_servicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS informes (
  id_informe int NOT NULL AUTO_INCREMENT,
  empresa_id int NOT NULL,
  servicio_id int NOT NULL,
  fecha_creacion datetime NOT NULL,
  PRIMARY KEY (id_informe),
  KEY empresa_id_idx (empresa_id),
  KEY servicio_id_idx (servicio_id),
  CONSTRAINT fk_empresa_id FOREIGN KEY (empresa_id) REFERENCES empresa (id_empresa),
  CONSTRAINT fk_servicio_id FOREIGN KEY (servicio_id) REFERENCES servicios (id_servicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE IF NOT EXISTS respuestas (
id_respuesta int NOT NULL AUTO_INCREMENT,
informe_id int NOT NULL,
pregunta_id int NOT NULL,
respuesta boolean NOT NULL,
PRIMARY KEY (id_respuesta),
KEY informe_id_idx (informe_id),
KEY pregunta_id_idx (pregunta_id),
CONSTRAINT informe_id FOREIGN KEY (informe_id) REFERENCES informes (id_informe),
CONSTRAINT pregunta_id FOREIGN KEY (pregunta_id) REFERENCES preguntas (id_pregunta)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from informes i ;
select * from respuestas r ;


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


INSERT INTO rol (id_rol, rol) VALUES
(1, 'admin'),
(2, 'empleado');


INSERT INTO usuario (usuario, password, nombres, apellidos, correo, telefono, id_rol, id_empresa, estado) VALUES
('giovanni', 'gio2023$', 'Giovanni', 'Risco Collazos', 'giova@gmail.com', '935627744', 2,4,1),
('aly', 'aly2023$', 'Aly Jesus', 'Laos Cortez', 'aly@gmail.com', '983900638', 2,6,1);



INSERT INTO servicios (nombre) VALUES ('SERVERS'), ('WORKSTATION'), ('NETWORK'), ('EMAIL'), ('WEBSITE'), ('PHONES'), ('INTERNAL');

INSERT INTO preguntas (pregunta, servicio_id) VALUES
    -- Preguntas de SERVERS
    ('Is there a BDR device in place?', 1),
    ('Are backups secured offsite?', 1),
    ('Has a monthly test restore been performed?', 1),
    ('Are there complete images of all servers'' partitions backed up at least hourly (daily for non-production servers)?', 1),
    ('Are backups set to 256 bit AES encryption?', 1),
    ('Is the backup imaging software the most current version?', 1),
    ('Is (are) the data/databases stored on a different RAID set?', 1),
    ('Is the system state being backed up?', 1),
    ('Is the data on any non-Windows server being backed up?', 1),
    ('Has every server been test virtualized this quarter?', 1),
    
    -- Preguntas de WORKSTATION
    ('Is backup software taking an image of all workstations daily?', 2),
    ('Does the client have adequate Hot Spare workstations?', 2),
    ('Are the workstations'' backups 256 bit AES encryption?', 2),
    ('Have the workstations been mounted and data restored this quarter?', 2),
    ('Are the user''s Desktop and My Documents folders redirected to the server?', 2),
    ('Is all data outside of the cloud being backed up?', 2),
    
    -- Preguntas de NETWORK
    ('Is there a wireless guest network?', 3),
    ('Is the public wireless access completely segregated from the private network?', 3),
    ('Is the public wireless traffic encrypted using WPA2-PSK?', 3),
    ('Is the SSID naming convention generic (i.e., not using company name or initials)?', 3),
    
    -- Preguntas de EMAIL
    ('Is the client''s Email Hosted?', 4),
    ('Are the Exchange databases below the limit set by Microsoft?', 4),
    ('Are the user mailboxes set to a 20GB maximum?', 4),
    ('Are the send and receive limits properly set to 75MBs?', 4),
    ('Is a Smart host configuration enabled?', 4),
    ('Are Spam and antivirus protections enabled?', 4),
    ('Is the trusted SSL certificate enabled?', 4),
    ('Is OWA enabled and configured?', 4),
    ('Has Open-Relay been disabled and tested?', 4),
    ('Has auto-discover been enabled for Outlook Anywhere?', 4),
    ('Is the sending policy configured so that no one is sending from an email address containing ''.local''?', 4),
    ('Has the BSA been installed and executed?', 4),
    ('Have proper steps been taken to apply the BPA''s fixes?', 4),
    ('Is current storage capacity sufficient for future growth?', 4),
    
    -- Preguntas de WEBSITE
    ('Is the website being backed up by the vendor?', 5),
    ('Are all components of the website updated?', 5),
    ('Is the website certificate valid?', 5),
    
    -- Preguntas de PHONES
    ('Is the phone vendor''s information correctly documented?', 6),
    ('Are there any workstations connected to the network through a phone?', 6),
    ('Is the phone system protected by a UPS or surge protector?', 6),
    
    -- Preguntas de INTERNAL
    ('Is the Agent installed on every machine?', 7),
    ('Is any security solution installed on every workstation?', 7),
    ('Is your security solution scheduled to scan every day?', 7),
    ('Is the Script Module Installer installed on every workstation and server?', 7),
    ('Is there a NOC account created for off-hours maintenance?', 7),
    ('Have retired machines been removed from NOC and CW?', 7),
    ('Is client workstation setup accurate and up to date?', 7),
    ('Are all CW configurations accurate and up to date?', 7),
    ('Are the workstations clear of password managers? (LastPass, etc)', 7),
    ('Is the network topology documented and up-to-date?', 7);
