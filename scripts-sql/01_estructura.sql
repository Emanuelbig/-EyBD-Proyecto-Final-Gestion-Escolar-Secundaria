-- Proyecto Final EyBD 2026 - Grupo 7
-- Sistema de gestion escolar (modulo docente)
-- 01_estructura: creacion de la base y de las tablas
-- (las restricciones van en 02_restricciones.sql)
-- (la insercion de datos va en 03_insercion_datos.sql)

DROP DATABASE IF EXISTS gestion_escolar;
CREATE DATABASE gestion_escolar CHARACTER SET utf8mb4;
USE gestion_escolar;

-- Tabla profesor
CREATE TABLE IF NOT EXISTS profesor (
	id_profesor INT UNSIGNED,
    dni CHAR(8),
    nombre VARCHAR(50),
    apellido VARCHAR(50), 
    fecha_nacimiento DATE,
    email VARCHAR(50),
    telefono VARCHAR(20),
    legajo VARCHAR(10)
); 

-- Tabla alumno
CREATE TABLE IF NOT EXISTS alumno (
	id_alumno INT UNSIGNED,
    dni CHAR(8),
    nombre VARCHAR(50),
    apellido VARCHAR(50), 
    fecha_nacimiento DATE,
    email VARCHAR(50),
    telefono VARCHAR(20),
    legajo VARCHAR(10)
); 

-- Tabla curso
CREATE TABLE IF NOT EXISTS curso (
	id_curso INT UNSIGNED,
    anio SMALLINT,
    division CHAR(1),
    ciclo_lectivo SMALLINT, 
    turno VARCHAR(10)
);

-- Tabla materia
CREATE TABLE IF NOT EXISTS materia (
	id_materia INT UNSIGNED,
    id_profesor INT UNSIGNED,
    nombre VARCHAR(50), 
    anio_plan SMALLINT
);

-- Tabla contiene es para que materias tiene cada curso y a que hora
CREATE TABLE IF NOT EXISTS contiene (
	id_contiene INT UNSIGNED,
    id_materia INT UNSIGNED,
    id_curso INT UNSIGNED,
    horario_inicio TIME,
    duracion SMALLINT
);

-- Tabla calificacion
CREATE TABLE IF NOT EXISTS calificacion (
	id_calificacion INT UNSIGNED,
    id_alumno INT UNSIGNED,
    id_materia INT UNSIGNED,
    parcial_1 DECIMAL(4,2),
    parcial_2 DECIMAL(4,2)
);
 
 -- Tabla pertenece
CREATE TABLE IF NOT EXISTS pertenece (
	id_pertenece INT UNSIGNED,
	id_alumno INT UNSIGNED,
    id_curso INT UNSIGNED
); 

-- Tabla asiste
CREATE TABLE IF NOT EXISTS asiste (
	id_asistencia INT UNSIGNED,
    id_alumno INT UNSIGNED,
    id_materia INT UNSIGNED,
    fecha DATE,
    presente BOOLEAN
);
