-- Proyecto Final EyBD 2026 - Grupo 7
-- Sistema de gestion escolar (modulo docente)
-- 02_restricciones: restricciones de tabla, de dominio y de integridad referencial
-- (se ejecuta despues de 01_estructura.sql y antes de 03_insercion_datos.sql)

USE gestion_escolar;

-- Restricciones de tabla

-- Clave primaria para la tabla persona
ALTER TABLE persona
	ADD PRIMARY KEY (id_persona);
    
-- Clave primaria para la tabla profesor
ALTER TABLE profesor
	ADD PRIMARY KEY (id_persona);

-- Clave primaria para la tabla alumno
ALTER TABLE alumno
	ADD PRIMARY KEY (id_persona);

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

-- AUTO_INCREMENT Y NOT NULL DE LA TABLA PERSONA
ALTER TABLE persona
	MODIFY COLUMN id_persona INT UNSIGNED NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN dni CHAR(8) NOT NULL,
    MODIFY COLUMN nombre VARCHAR(50) NOT NULL,
    MODIFY COLUMN apellido VARCHAR(50) NOT NULL,
    MODIFY COLUMN legajo VARCHAR(10) NOT NULL;
    
-- UNIQUE Y CHECK DE LA TABLA PERSONA
ALTER TABLE persona
	ADD CONSTRAINT uq_persona_dni UNIQUE (dni),
    ADD CONSTRAINT uq_persona_email UNIQUE (email),
    ADD CONSTRAINT uq_persona_legajo UNIQUE (legajo),
    ADD CONSTRAINT ck_persona_dni CHECK (dni REGEXP '^[0-9]{7,8}$'),
    ADD CONSTRAINT ck_persona_email CHECK (email LIKE '%@%');
    
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

-- Clave foranea de la tabla profesor
ALTER TABLE profesor
    ADD CONSTRAINT fk_profesor_persona FOREIGN KEY (id_persona)
        REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE;

-- Clave foranea de la tabla alumno
ALTER TABLE alumno
    ADD CONSTRAINT fk_alumno_persona FOREIGN KEY (id_persona)
        REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE;

-- Claves foraneas de la tabla materia
ALTER TABLE materia
	-- Agregamos indices para buscar mas rapido
    ADD KEY idx_materia_profesor (id_profesor),
    ADD CONSTRAINT fk_materia_profesor FOREIGN KEY (id_profesor)
        REFERENCES profesor (id_persona) ON DELETE RESTRICT ON UPDATE CASCADE;

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
        REFERENCES alumno (id_persona) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_calificacion_materia FOREIGN KEY (id_materia)
        REFERENCES materia (id_materia) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Claves foraneas de la tabla pertenece
ALTER TABLE pertenece
    ADD KEY idx_pertenece_alumno (id_alumno),
    ADD KEY idx_pertenece_curso (id_curso),
    ADD CONSTRAINT fk_pertenece_alumno FOREIGN KEY (id_alumno)
        REFERENCES alumno (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk_pertenece_curso FOREIGN KEY (id_curso)
        REFERENCES curso (id_curso) ON DELETE CASCADE ON UPDATE CASCADE;

-- Claves foraneas de la tabla asiste
ALTER TABLE asiste
    ADD KEY idx_asiste_alumno (id_alumno),
    ADD KEY idx_asiste_materia (id_materia),
    ADD CONSTRAINT fk_asiste_alumno FOREIGN KEY (id_alumno)
        REFERENCES alumno (id_persona) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_asiste_materia FOREIGN KEY (id_materia)
        REFERENCES materia (id_materia) ON DELETE RESTRICT ON UPDATE CASCADE;
        
-- INDICES

-- Indice para buscar personas por apellido mas rapido
ALTER TABLE persona
    ADD KEY idx_persona_apellido (apellido);

-- Indice para buscar asistencias por fecha mas rapido
ALTER TABLE asiste
    ADD KEY idx_asiste_fecha (fecha);
    
-- Aca podriamos poner un trigger para quue no se pueda cargar una persona con fecha de nacimiento futura
-- y otro que no deje cargarle una nota a un alumno al que no pertenece a una materia en especifico.