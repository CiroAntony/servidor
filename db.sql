create database cticDB;

create table Usuarios (
	id_usuario int NOT NULL AUTO_INCREMENT,
	usuario varchar(100),
	nombre varchar(100),
	password varchar(100),
	PRIMARY KEY (id_usuario)
)

insert into Usuarios (usuario,nombre,password)
values("VasquezM19","Antony","vm2002")

select * from Usuarios;
