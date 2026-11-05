-- Proyecto Final EyBD 2026 - Grupo 7
-- Sistema de gestion escolar (modulo docente)
-- 00_script_unico: es el 01, el 02 y el 03 todo junto, con este se arma la base y se cargan los datos de una
-- (las consultas estan aparte en 04_consultas.sql)

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


-- Proyecto Final EyBD 2026 - Grupo 7
-- Sistema de gestion escolar (modulo docente)
-- 02_restricciones: restricciones de tabla, de dominio y de integridad referencial
-- (se ejecuta despues de 01_estructura.sql y antes de 03_insercion_datos.sql)

USE gestion_escolar;

-- Restricciones de tabla
    
-- Clave primaria para la tabla profesor
ALTER TABLE profesor
	ADD PRIMARY KEY (id_profesor);

-- Clave primaria para la tabla alumno
ALTER TABLE alumno
	ADD PRIMARY KEY (id_alumno);

-- Clave primaria para la tabla curso
ALTER TABLE curso
	ADD PRIMARY KEY (id_curso);

-- Clave primaria para la tabla materia
ALTER TABLE materia
	ADD PRIMARY KEY (id_materia);
    
-- Clave primaria para la tabla contiene
ALTER TABLE contiene
	ADD PRIMARY KEY (id_contiene);
    
-- Clave primaria para la tabla calificacion
ALTER TABLE calificacion
	ADD PRIMARY KEY (id_calificacion);
    
-- Clave primaria para la tabla pertenece
ALTER TABLE pertenece
	ADD PRIMARY KEY (id_pertenece);
    
-- Clave primaria para la tabla asiste
ALTER TABLE asiste
	ADD PRIMARY KEY (id_asistencia);
    
-- Restricciones de dominio

-- AUTO_INCREMENT Y NOT NULL DE LA TABLA ALUMNO
ALTER TABLE alumno
	MODIFY COLUMN id_alumno INT UNSIGNED NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN dni CHAR(8) NOT NULL,
    MODIFY COLUMN nombre VARCHAR(50) NOT NULL,
    MODIFY COLUMN apellido VARCHAR(50) NOT NULL,
    MODIFY COLUMN legajo VARCHAR(10) NOT NULL;
    
-- UNIQUE Y CHECK DE LA TABLA ALUMNO
ALTER TABLE alumno
	ADD CONSTRAINT uq_alumno_dni UNIQUE (dni),
    ADD CONSTRAINT uq_alumno_email UNIQUE (email),
    ADD CONSTRAINT uq_alumno_legajo UNIQUE (legajo),
    ADD CONSTRAINT ck_alumno_dni CHECK (dni REGEXP '^[0-9]{7,8}$'),
    ADD CONSTRAINT ck_alumno_email CHECK (email LIKE '%@%');
    
-- AUTO_INCREMENT Y NOT NULL DE LA TABLA PROFESOR
ALTER TABLE profesor
	MODIFY COLUMN id_profesor INT UNSIGNED NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN dni CHAR(8) NOT NULL,
    MODIFY COLUMN nombre VARCHAR(50) NOT NULL,
    MODIFY COLUMN apellido VARCHAR(50) NOT NULL,
    MODIFY COLUMN legajo VARCHAR(10) NOT NULL;
    
-- UNIQUE Y CHECK DE LA TABLA PROFESOR
ALTER TABLE profesor
	ADD CONSTRAINT uq_profesor_dni UNIQUE (dni),
    ADD CONSTRAINT uq_profesor_email UNIQUE (email),
    ADD CONSTRAINT uq_profesor_legajo UNIQUE (legajo),
    ADD CONSTRAINT ck_profesor_dni CHECK (dni REGEXP '^[0-9]{7,8}$'),
    ADD CONSTRAINT ck_profesor_email CHECK (email LIKE '%@%');    
    
-- AUTO INCREMENT Y NOT NULL DE LA TABLA CURSO
ALTER TABLE curso
	MODIFY COLUMN id_curso INT UNSIGNED NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN anio SMALLINT NOT NULL,
    MODIFY COLUMN division CHAR(1) NOT NULL,
    MODIFY COLUMN ciclo_lectivo SMALLINT NOT NULL,
    MODIFY COLUMN turno VARCHAR(10) NOT NULL;
    
-- UNIQUE Y CHECK DE LA TABLA CURSO
ALTER TABLE curso
	-- La combinacion de las 4 no se puede repetir , no puede haber 2 cursos iguales.
	ADD CONSTRAINT uq_curso UNIQUE (anio, division, ciclo_lectivo, turno),
    ADD CONSTRAINT ck_curso_anio CHECK (anio BETWEEN 1 AND 6),
	ADD CONSTRAINT ck_curso_division CHECK (division REGEXP '^[A-F]$'),
    ADD CONSTRAINT ck_curso_ciclo CHECK (ciclo_lectivo BETWEEN 2000 AND 2100),
    ADD CONSTRAINT ck_curso_turno CHECK (turno IN ('mañana', 'tarde', 'noche'));

-- AUTO_INCREMENT y NOT NULL DE LA TABLA MATERIA
ALTER TABLE materia
    MODIFY COLUMN id_materia INT UNSIGNED NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN id_profesor INT UNSIGNED NOT NULL,
    MODIFY COLUMN nombre VARCHAR(50) NOT NULL,
    MODIFY COLUMN anio_plan SMALLINT NOT NULL;

-- UNIQUE Y CHECK DE LA TABLA MATERIA
ALTER TABLE materia
	-- No puede haber 2 matematica de 1er año en el plan
    ADD CONSTRAINT uq_materia UNIQUE (nombre, anio_plan),
    ADD CONSTRAINT ck_materia_anio_plan CHECK (anio_plan BETWEEN 1 AND 6);

-- AUTO_INCREMENT y NOT NULL DE LA TABLA CONTIENE
ALTER TABLE contiene
    MODIFY COLUMN id_contiene INT UNSIGNED NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN id_materia INT UNSIGNED NOT NULL,
    MODIFY COLUMN id_curso INT UNSIGNED NOT NULL,
    MODIFY COLUMN horario_inicio TIME NOT NULL,
    MODIFY COLUMN duracion SMALLINT NOT NULL;    

-- UNIQUE y CHECK DE LA TABLA CONTIENE
ALTER TABLE contiene
	-- Un curso no puede tener la misma materia cargada dos veces
    ADD CONSTRAINT uq_contiene UNIQUE (id_curso, id_materia),
    ADD CONSTRAINT ck_contiene_horario_inicio CHECK (horario_inicio BETWEEN '07:00:00' AND '23:00:00'),
    ADD CONSTRAINT ck_contiene_duracion CHECK (duracion > 0);    

-- AUTO_INCREMENT y NOT NULL DE LA TABLA CALIFICACION
ALTER TABLE calificacion
    MODIFY COLUMN id_calificacion INT UNSIGNED NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN id_alumno INT UNSIGNED NOT NULL,
    MODIFY COLUMN id_materia INT UNSIGNED NOT NULL;

-- UNIQUE y CHECK DE LA TABLA CALIFICACION
ALTER TABLE calificacion
    ADD CONSTRAINT uq_calificacion UNIQUE (id_alumno, id_materia),
    ADD CONSTRAINT ck_calificacion_parcial_1 CHECK (parcial_1 BETWEEN 1 AND 10),
    ADD CONSTRAINT ck_calificacion_parcial_2 CHECK (parcial_2 BETWEEN 1 AND 10);

-- AUTO_INCREMENT y NOT NULL DE LA TABLA PERTENECE
ALTER TABLE pertenece
    MODIFY COLUMN id_pertenece INT UNSIGNED NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN id_alumno INT UNSIGNED NOT NULL,
    MODIFY COLUMN id_curso INT UNSIGNED NOT NULL;

-- UNIQUE DE LA TABLA PERTENECE
ALTER TABLE pertenece
    ADD CONSTRAINT uq_pertenece UNIQUE (id_alumno, id_curso);

-- AUTO_INCREMENT, NOT NULL y DEFAULT DE LA TABLA ASISTE
ALTER TABLE asiste
    MODIFY COLUMN id_asistencia INT UNSIGNED NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN id_alumno INT UNSIGNED NOT NULL,
    MODIFY COLUMN id_materia INT UNSIGNED NOT NULL,
    MODIFY COLUMN fecha DATE NOT NULL,
    MODIFY COLUMN presente BOOLEAN NOT NULL DEFAULT TRUE;

-- UNIQUE y CHECK DE LA TABLA ASISTE
ALTER TABLE asiste
    ADD CONSTRAINT uq_asiste UNIQUE (id_alumno, id_materia, fecha),
    ADD CONSTRAINT ck_asiste_presente CHECK (presente IN (0, 1));    

-- Restricciones de integridad referencial
-- Aca controlamos que los datos que se relacionan entre tablas se relacionen bien y no queden rotos, que no se pueda borrar un profesor si tiene materias, etc.

-- Claves foraneas de la tabla materia
ALTER TABLE materia
	-- Agregamos indices para buscar mas rapido
    ADD KEY idx_materia_profesor (id_profesor),
    ADD CONSTRAINT fk_materia_profesor FOREIGN KEY (id_profesor)
        REFERENCES profesor (id_profesor) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Claves foraneas de la tabla contiene
ALTER TABLE contiene
    ADD KEY idx_contiene_materia (id_materia),
    ADD KEY idx_contiene_curso (id_curso),
    ADD CONSTRAINT fk_contiene_materia FOREIGN KEY (id_materia)
        REFERENCES materia (id_materia) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_contiene_curso FOREIGN KEY (id_curso)
        REFERENCES curso (id_curso) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Claves foraneas de la tabla calificacion
ALTER TABLE calificacion
    ADD KEY idx_calificacion_alumno (id_alumno),
    ADD KEY idx_calificacion_materia (id_materia),
    ADD CONSTRAINT fk_calificacion_alumno FOREIGN KEY (id_alumno)
        REFERENCES alumno (id_alumno) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_calificacion_materia FOREIGN KEY (id_materia)
        REFERENCES materia (id_materia) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Claves foraneas de la tabla pertenece
ALTER TABLE pertenece
    ADD KEY idx_pertenece_alumno (id_alumno),
    ADD KEY idx_pertenece_curso (id_curso),
    ADD CONSTRAINT fk_pertenece_alumno FOREIGN KEY (id_alumno)
        REFERENCES alumno (id_alumno) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk_pertenece_curso FOREIGN KEY (id_curso)
        REFERENCES curso (id_curso) ON DELETE CASCADE ON UPDATE CASCADE;

-- Claves foraneas de la tabla asiste
ALTER TABLE asiste
    ADD KEY idx_asiste_alumno (id_alumno),
    ADD KEY idx_asiste_materia (id_materia),
    ADD CONSTRAINT fk_asiste_alumno FOREIGN KEY (id_alumno)
        REFERENCES alumno (id_alumno) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_asiste_materia FOREIGN KEY (id_materia)
        REFERENCES materia (id_materia) ON DELETE RESTRICT ON UPDATE CASCADE;
        
-- INDICES

-- Indice para buscar alumnos por apellido mas rapido
ALTER TABLE alumno
    ADD KEY idx_alumno_apellido (apellido);
    
-- Indice para buscar profesores por apellido mas rapido
ALTER TABLE profesor
    ADD KEY idx_profesor_apellido (apellido);

-- Indice para buscar asistencias por fecha mas rapido
ALTER TABLE asiste
    ADD KEY idx_asiste_fecha (fecha);
    
-- Aca podriamos poner un trigger para que no se pueda cargar un profesor o un alumno con fecha de nacimiento futura
-- y otro que no deje cargarle una nota a un alumno en una materia que no es de su curso.

-- 03_insercion_datos: aca se cargan los datos

USE gestion_escolar;
#puse el id_persona por que si el insert falla 1 vez, por ejemplo me rebota algo por una restriccion y se vuelve a cargar, en esta caso apareceria de 20 en adelante.
#hay que preguntarle al profe, una compañera me dijo que lo saque. 
#sacar los primary key de aca, son autoincrementales esta parametrizado, no vale la pena ponerlo.
#mantener los comentarios en los sql
INSERT INTO profesor (dni, nombre, apellido, fecha_nacimiento, email, telefono, legajo)
VALUES
	('28111222', 'Carlos', 'Ruiz', '1980-05-14', 'cruiz@colegio.edu.ar', '1144445555', 'PRO001'),
    ('30555666', 'Mariana', 'Silva', '1983-08-22', 'msilva@colegio.edu.ar', '1155556666', 'PRO002'),
    ('31999888', 'Jorge', 'Lopez', '1985-11-03', 'jlopez@colegio.edu.ar', '1166667777', 'PRO003'),
    ('29444333', 'Andrea', 'Fernandez', '1982-02-19', 'afernandez@colegio.edu.ar', '1177778888', 'PRO004');
    
INSERT INTO alumno (dni, nombre, apellido, fecha_nacimiento, email, telefono, legajo)
VALUES
	('52100101', 'Mateo', 'Rossi', '2012-03-15', 'mrossi@alumno.edu.ar', '1122334401', 'ALU001'),
    ('53200202', 'Sofia', 'Gimenez', '2013-05-20', 'sgimenez@alumno.edu.ar', '1122334402', 'ALU002'),
    ('52300303', 'Lucas', 'Romero', '2012-08-10', 'lromero@alumno.edu.ar', '1122334403', 'ALU003'),
    ('53400404', 'Valentina', 'Sosa', '2013-11-25', 'vsosa@alumno.edu.ar', '1122334404', 'ALU004'),
    ('52500505', 'Joaquin', 'Diaz', '2012-01-05', NULL, '1122334405', 'ALU005'),
    ('53600606', 'Camila', 'Alvarez', '2013-07-30', 'calvarez@alumno.edu.ar', '1122334406', 'ALU006'),
    ('52700707', 'Thiago', 'Benitez', '2012-09-12', 'tbenitez@alumno.edu.ar', NULL, 'ALU007'),
    ('53800808', 'Martina', 'Acosta', '2013-04-18', NULL, '1122334408', 'ALU008'),
    ('52900909', 'Santino', 'Molina', '2012-12-02', 'smolina@alumno.edu.ar', NULL, 'ALU009'),
    ('53111111', 'Lucia', 'Castro', '2013-02-14', 'lcastro@alumno.edu.ar', '1122334410', 'ALU010'),
    ('52222222', 'Bautista', 'Ortiz', '2012-06-22', 'bortiz@alumno.edu.ar', '1122334411', 'ALU011'),
    ('53333333', 'Emma', 'Luna', '2013-09-08', 'eluna@alumno.edu.ar', NULL, 'ALU012'),
    ('52444444', 'Benjamin', 'Cabrera', '2012-10-17', 'bcabrera@alumno.edu.ar', '1122334413', 'ALU013'),
    ('53555555', 'Mia', 'Rios', '2013-12-05', 'mrios@alumno.edu.ar', '1122334414', 'ALU014'),
    ('52666666', 'Felipe', 'Vega', '2012-05-09', 'fvega@alumno.edu.ar', '1122334415', 'ALU015');
    
INSERT INTO curso (anio, division, ciclo_lectivo, turno)
VALUES
	(1,'A',2025,'mañana'),
    (2,'A',2026,'mañana'),
    (1,'A',2026,'mañana'),
    (1,'B',2026,'tarde');
    
INSERT INTO materia (id_profesor, nombre, anio_plan)
VALUES
    #materias del plan de estudios: cada materia se carga una sola vez y despues se asigna a los cursos en contiene
    (1, 'Matemática', 1),   
    (2, 'Lengua',     1),   
    (3, 'Historia',   1),   
    (4, 'Biología',   1),   
    (1, 'Matemática', 2),   
    (2, 'Lengua',     2),   
    (4, 'Física',     2);

INSERT INTO contiene (id_materia, id_curso, horario_inicio, duracion)
VALUES
    #aca se ve el N:M: Matematica de 1er año (materia 1) esta en los cursos 1, 3 y 4
    #y cada curso tiene varias materias
    #curso 1: 1 A 2025 (mañana)
    (1, 1, '08:00:00', 80),   
    (2, 1, '09:30:00', 80),   
    (3, 1, '11:00:00', 80),   
    # curso 2: 2 A 2026 (mañana)
    (5, 2, '08:00:00', 80),   
    (6, 2, '09:30:00', 80),   
    (7, 2, '11:00:00', 80),   
    # curso 3: 1 A 2026 (mañana)
    (1, 3, '08:00:00', 80),   
    (2, 3, '09:30:00', 80),   
    (3, 3, '11:00:00', 80),   
    #curso 4: 1 B 2026 (tarde)
    (1, 4, '13:00:00', 80),   
    (2, 4, '14:30:00', 80),   
    (4, 4, '16:00:00', 80);

INSERT INTO pertenece (id_alumno, id_curso)
VALUES
    #nacidos en 2012:  1 A 2025 (curso 1) y después 2 A 2026 (curso 2) esto lo hago de ejemplo por si paso 1 año desde que se usa la bd
    #Entonces los nacidos en 2012, el año pasado cursaron 1 A 2025 (curso con id num 1) y este año estan a 2 A 2026 (curso con id numero 2).
    #Un alumno puede estar en muchos cursos (uno por año)
    # y un curso tiene muchos alumnos. Eso es la relación N:M, y por eso pertenece es una tabla aparte.
    (1, 1),  (1, 2),     
    (3, 1),  (3, 2),     
    (5, 1),  (5, 2),     
    (7, 1), (7, 2),    
    (9, 1), (9, 2),    
    (11, 1), (11, 2),    
    (13, 1), (13, 2),   
    (15, 1), (15, 2),    
    #nacidos en 2013: 1 A 2026 (curso 3)
    (2, 3),              
    (4, 3),              
    (6, 3),             
    (8, 3),             
    #nacidos en 2013: 1 B 2026, tarde (curso 4)
    (10, 4),             
    (12, 4),             
    (14, 4);
    
INSERT INTO calificacion (id_alumno, id_materia, parcial_1, parcial_2)
VALUES
    #Matematica de 1er año (materia 1) en 1ero A 2025
    (1, 1, 7.50, 8),
    (3, 1, 6.50, 6.50),
    (5, 1, 9, 9.50),
    (7, 1, 3.50, 5.50),
    (9, 1, 7.50, 6),
    (11, 1, 4.50, 5),
    (13, 1, 8, 9.50),
    (15, 1, 7, 4.50),
    #Lengua de 1er año (materia 2) en 1ero A 2025
    (1, 2, 8, 7.50),
    (3, 2, 5.50, 7.50),
    (5, 2, 9.50, 9),
    (7, 2, 4, 5),
    (9, 2, 6.50, 7),
    (11, 2, 6, 5.50),
    (13, 2, 8.50, 9),
    (15, 2, 6, 5.50),
    #Historia de 1er año (materia 3) en 1ero A 2025
    (1, 3, 8.50, 7),
    (3, 3, 6, 7),
    (5, 3, 8.50, 10),
    (7, 3, 4.50, 4.50),
    (9, 3, 7, 6.50),
    (11, 3, 5, 6.50),
    (13, 3, 9, 8.50),
    (15, 3, 6.50, 5),
    #Matematica de 2do año (materia 5) en 2do A 2026
    (1, 5, 7.50, 8),
    (3, 5, 6.50, 6.50),
    (5, 5, 9, 9.50),
    (7, 5, 2.50, 4.50),
    (9, 5, 7.50, 6),
    (11, 5, 5.50, 6),
    (13, 5, 8, 9.50),
    (15, 5, 7, 4.50),
    #Lengua de 2do año (materia 6) en 2do A 2026
    (1, 6, 8, 7.50),
    (3, 6, 5.50, 7.50),
    (5, 6, 9.50, 9),
    (7, 6, 4, 5),
    (9, 6, 6.50, 7),
    (11, 6, 6, 5.50),
    (13, 6, 8.50, 9),
    (15, 6, 6, 5.50),
    #Física de 2do año (materia 7) en 2° A 2026
    (1, 7, 8.50, 7),
    (3, 7, 6, 7),
    (5, 7, 8.50, 10),
    (7, 7, 4.50, 4.50),
    (9, 7, 7, 6.50),
    (11, 7, 5, 6.50),
    (13, 7, 9, 8.50),
    (15, 7, 4, 5),
    #Matematica de 1er año (materia 1) en 1ero A 2026
    (2, 1, 9, 8.50),
    (4, 1, 6.50, 8),
    (6, 1, 5.50, 5),
    (8, 1, 3.50, 4),
    #Lengua de 1er año (materia 2) en 1ero A 2026
    (2, 2, 9.50, 8),
    (4, 2, 7, 7.50),
    (6, 2, 5.50, 7),
    (8, 2, 4, 3.50),
    #Historia de 1er año (materia 3) en 1ero A 2026 (parcial 2 todavia no rendido)
    (2, 3, 8.50, NULL),
    (4, 3, 7.50, NULL),
    (6, 3, 6, NULL),
    (8, 3, 3, NULL),
    #Matematica de 1er año (materia 1) en 1ero B 2026 (tarde)
    (10, 1, 7.50, 8.50),
    (12, 1, 4.50, 3),
    (14, 1, 7.50, 9),
    #Lengua de 1er año (materia 2) en 1ero B 2026 (tarde)
    (10, 2, 8, 8),
    (12, 2, 4.50, 5),
    (14, 2, 8, 8.50),
    #Biologia de 1er año (materia 4) en 1ero B 2026 (tarde) (parcial 2 todavia no rendido)
    (10, 4, 8.50, NULL),
    (12, 4, 5, NULL),
    (14, 4, 7, NULL);

INSERT INTO asiste (id_alumno, id_materia, fecha, presente)
VALUES
    #Matemática de 2do año (materia 5) en 2° A 2026
    (1, 5, '2026-10-05', 1), (1, 5, '2026-10-12', 1), (1, 5, '2026-10-19', 1),
    (3, 5, '2026-10-05', 1), (3, 5, '2026-10-12', 1), (3, 5, '2026-10-19', 1),
    (5, 5, '2026-10-05', 1), (5, 5, '2026-10-12', 1), (5, 5, '2026-10-19', 1),
    (7, 5, '2026-10-05', 0), (7, 5, '2026-10-12', 0), (7, 5, '2026-10-19', 1),
    (9, 5, '2026-10-05', 1), (9, 5, '2026-10-12', 1), (9, 5, '2026-10-19', 1),
    (11, 5, '2026-10-05', 1), (11, 5, '2026-10-12', 1), (11, 5, '2026-10-19', 1),
    (13, 5, '2026-10-05', 1), (13, 5, '2026-10-12', 1), (13, 5, '2026-10-19', 1),
    (15, 5, '2026-10-05', 1), (15, 5, '2026-10-12', 1), (15, 5, '2026-10-19', 1),
    #Lengua de 2do año (materia 6) en 2° A 2026
    (1, 6, '2026-10-06', 1), (1, 6, '2026-10-13', 1), (1, 6, '2026-10-20', 1),
    (3, 6, '2026-10-06', 1), (3, 6, '2026-10-13', 1), (3, 6, '2026-10-20', 1),
    (5, 6, '2026-10-06', 1), (5, 6, '2026-10-13', 1), (5, 6, '2026-10-20', 1),
    (7, 6, '2026-10-06', 1), (7, 6, '2026-10-13', 0), (7, 6, '2026-10-20', 1),
    (9, 6, '2026-10-06', 1), (9, 6, '2026-10-13', 1), (9, 6, '2026-10-20', 1),
    (11, 6, '2026-10-06', 1), (11, 6, '2026-10-13', 1), (11, 6, '2026-10-20', 1),
    (13, 6, '2026-10-06', 1), (13, 6, '2026-10-13', 1), (13, 6, '2026-10-20', 1),
    (15, 6, '2026-10-06', 1), (15, 6, '2026-10-13', 1), (15, 6, '2026-10-20', 0),
    #Matemática de 1er año (materia 1) en 1° A 2026
    (2, 1, '2026-10-05', 1), (2, 1, '2026-10-12', 1), (2, 1, '2026-10-19', 1),
    (4, 1, '2026-10-05', 1), (4, 1, '2026-10-12', 1), (4, 1, '2026-10-19', 1),
    (6, 1, '2026-10-05', 1), (6, 1, '2026-10-12', 1), (6, 1, '2026-10-19', 1),
    (8, 1, '2026-10-05', 0), (8, 1, '2026-10-12', 1), (8, 1, '2026-10-19', 0),
    #Lengua de 1er año (materia 2) en 1° A 2026
    (2, 2, '2026-09-30', 1), (2, 2, '2026-10-07', 1), (2, 2, '2026-10-14', 1),
    (4, 2, '2026-09-30', 1), (4, 2, '2026-10-07', 1), (4, 2, '2026-10-14', 1),
    (6, 2, '2026-09-30', 0), (6, 2, '2026-10-07', 1), (6, 2, '2026-10-14', 1),
    (8, 2, '2026-09-30', 1), (8, 2, '2026-10-07', 0), (8, 2, '2026-10-14', 1),
    #Matemática de 1er año (materia 1) en 1° B 2026 (tarde)
    (10, 1, '2026-10-05', 1), (10, 1, '2026-10-12', 1), (10, 1, '2026-10-19', 1),
    (12, 1, '2026-10-05', 1), (12, 1, '2026-10-12', 0), (12, 1, '2026-10-19', 1),
    (14, 1, '2026-10-05', 1), (14, 1, '2026-10-12', 1), (14, 1, '2026-10-19', 1),
    #Lengua de 1er año (materia 2) en 1° B 2026 (tarde)
    (10, 2, '2026-10-06', 1), (10, 2, '2026-10-13', 1), (10, 2, '2026-10-20', 1),
    (12, 2, '2026-10-06', 1), (12, 2, '2026-10-13', 1), (12, 2, '2026-10-20', 1),
    (14, 2, '2026-10-06', 1), (14, 2, '2026-10-13', 1), (14, 2, '2026-10-20', 1);
