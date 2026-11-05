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