drop database if exists shorJobs;
create database if not exists shortJobs;

use shortJobs;


drop table if exists usuarios;

CREATE TABLE usuarios (
    dni VARCHAR(9) PRIMARY KEY,
    nombreCompleto VARCHAR(100),
    numeroSeguridadSocial INT,
    curriculum VARCHAR(255),
    direccion VARCHAR(100),
    ciudad VARCHAR(30),
    correoElectronico VARCHAR(30),
    nombreUsuario VARCHAR(50),
    contraseña VARCHAR(100) 
);

drop table if exists empresas;

create table empresas(
	id int primary key,
    tema varchar (100),
    nombre varchar (50),
    sedes varchar (255)
);

drop table if exists trabajos;
create table trabajos(
	id int primary key auto_increment,
    tipo varchar(50),
    empresa varchar (50),
    descripcion varchar (255),
    ubicacion varchar (50),
    fecha date,
    salario decimal,
    duracion decimal
);

INSERT INTO usuarios (dni, nombreCompleto, numeroSeguridadSocial, curriculum, direccion, ciudad, correoElectronico, nombreUsuario, contraseña) 
VALUES 
('111222333', 'Elena García', 123456789, 'Licenciada en Administración de Empresas', 'Calle Principal 123', 'Ciudad Principal', 'elena@example.com', 'elena.garcia', 'contraseña1'),
('222333444', 'Manuel Sánchez', 987654321, 'Experiencia en ventas y marketing', 'Calle de la Plaza 456', 'Ciudad Secundaria', 'manuel@example.com', 'manuel.sanchez', 'contraseña2'),
('333444555', 'Sofía Fernández', 123098765, 'Ingeniera Civil con experiencia en proyectos de infraestructura', 'Avenida del Sol 789', 'Ciudad Grande', 'sofia@example.com', 'sofia.fernandez', 'contraseña3'),
('444555666', 'Javier López', 456789123, 'Técnico en Informática con certificaciones en redes', 'Avenida de la Estrella 101', 'Ciudad Pequeña', 'javier@example.com', 'javier.lopez', 'contraseña4'),
('555666777', 'Marina Martínez', 789012345, 'Licenciada en Psicología con especialización en recursos humanos', 'Calle del Mar 567', 'Ciudad Costera', 'marina@example.com', 'marina.martinez', 'contraseña5'),
('666777888', 'Diego Rodríguez', 234567890, 'Graduado en Ingeniería Eléctrica', 'Carrera del Río 891', 'Ciudad Fluvial', 'diego@example.com', 'diego.rodriguez', 'contraseña6');

INSERT INTO empresas (id, tema, nombre, sedes) 
VALUES 
(5, 'Consultoría', 'TechConsult', 'Ciudad Alfa, Ciudad Beta'),
(6, 'Salud', 'MediCare', 'Ciudad Gama, Ciudad Delta'),
(7, 'Moda', 'StyleCorp', 'Ciudad Kappa, Ciudad Lambda');


INSERT INTO trabajos (tipo, empresa, descripcion, ubicacion, fecha, salario, duracion) 
VALUES 
('Tiempo completo', 'TechConsult', 'Consultor de sistemas informáticos', 'Ciudad Beta', '2024-05-01', 45000.00, 12),
('Medio tiempo', 'MediCare', 'Enfermero/a en atención primaria', 'Ciudad Delta', '2024-05-10', 28000.00, 6),
('Prácticas', 'StyleCorp', 'Asistente de diseño de moda', 'Ciudad Kappa', '2024-06-01', 18000.00, 3),
('Freelance', 'StyleCorp', 'Diseñador gráfico para campaña publicitaria', 'Ciudad Lambda', '2024-06-10', 35000.00, 4),
('Tiempo completo', 'MediCare', 'Médico de urgencias', 'Ciudad Gama', '2024-07-01', 60000.00, 24),
('Medio tiempo', 'TechConsult', 'Soporte técnico para clientes corporativos', 'Ciudad Alfa', '2024-07-10', 30000.00, 9);

select * from usuarios;
select * from empresas;
select * from trabajos;
SELECT * FROM usuarios WHERE ciudad = 'Ciudad Principal';
SELECT * FROM trabajos WHERE salario > 40000;
SELECT * FROM empresas WHERE tema = 'Tecnología';
SELECT * FROM trabajos WHERE empresa IN (SELECT nombre FROM empresas WHERE sedes LIKE '%Ciudad Delta%');


DELIMITER $$
CREATE PROCEDURE obtener_informacion_usuario(IN nombre_usuario VARCHAR(50))
BEGIN
    
    DECLARE nombre_completo VARCHAR(100);
    DECLARE dni_usuario VARCHAR(9);
    DECLARE ciudad_usuario VARCHAR(30);
    
    
    SELECT nombreCompleto, dni, ciudad INTO nombre_completo, dni_usuario, ciudad_usuario
    FROM usuarios
    WHERE nombreUsuario = nombre_usuario;
    
    
    SELECT 'Nombre completo:', nombre_completo;
    SELECT 'DNI:', dni_usuario;
    SELECT 'Ciudad:', ciudad_usuario;
    
    
    SELECT * FROM trabajos WHERE empresa IN (SELECT empresa FROM trabajos WHERE nombre = nombre_usuario);
END $$ ;
DELIMITER ;

DELIMITER $$
CREATE TRIGGER after_insert_usuario
AFTER INSERT ON usuarios
FOR EACH ROW
BEGIN
  
    INSERT INTO auditoria_usuarios (accion, usuario_afectado, fecha) VALUES ('INSERT', NEW.nombreUsuario, NOW());
END $$ ;
DELIMITER ;

