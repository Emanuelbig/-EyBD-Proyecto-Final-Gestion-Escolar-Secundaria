USE gestion_escolar;
#puse el id_persona por que si el insert falla 1 vez, por ejemplo me rebota algo por una restriccion y se vuelve a cargar, en esta caso apareceria de 20 en adelante.
#hay que preguntarle al profe, una compañera me dijo que lo saque. 
#sacar los primary key de aca, son autoincrementales esta parametrizado, no vale la pena ponerlo.
#mantener los comentarios en los sql
INSERT INTO persona (dni, nombre, apellido, fecha_nacimiento, email, telefono, legajo)
VALUES
	('28111222', 'Carlos', 'Ruiz', '1980-05-14', 'cruiz@colegio.edu.ar', '1144445555', 'PRO001'),
    ('30555666', 'Mariana', 'Silva', '1983-08-22', 'msilva@colegio.edu.ar', '1155556666', 'PRO002'),
    ('31999888', 'Jorge', 'Lopez', '1985-11-03', 'jlopez@colegio.edu.ar', '1166667777', 'PRO003'),
    ('29444333', 'Andrea', 'Fernandez', '1982-02-19', 'afernandez@colegio.edu.ar', '1177778888', 'PRO004'),
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
    
INSERT INTO profesor (id_persona)
VALUES
	(1),
    (2),
    (3),
    (4);
    
INSERT INTO alumno (id_persona)
VALUES
	(5),
    (6),
    (7),
    (8),
    (9),
    (10),
    (11),
    (12),
    (13),
    (14),
    (15),
    (16),
    (17),
    (18),
    (19);
    
INSERT INTO curso (anio, division, ciclo_lectivo, turno)
VALUES
	(1,'A',2025,'mañana'),
    (2,'A',2026,'mañana'),
    (1,'A',2026,'mañana'),
    (1,'B',2026,'tarde');
    
INSERT INTO materia (id_profesor, id_curso, nombre, horario_inicio, duracion, anio_plan)
VALUES
    #curso 1: 1 A 2025 (mañana)
    (1, 1, 'Matemática', '08:00:00', 80, 1),   
    (2, 1, 'Lengua',     '09:30:00', 80, 1),   
    (3, 1, 'Historia',   '11:00:00', 80, 1),   
    # curso 2: 2 A 2026 (mañana)
    (1, 2, 'Matemática', '08:00:00', 80, 2),   
    (2, 2, 'Lengua',     '09:30:00', 80, 2),   
    (4, 2, 'Física',     '11:00:00', 80, 2),   
    # curso 3: 1 A 2026 (mañana)
    (3, 3, 'Matemática', '08:00:00', 80, 1),   
    (4, 3, 'Lengua',     '09:30:00', 80, 1),   
    (2, 3, 'Historia',   '11:00:00', 80, 1),   
    #curso 4: 1 B 2026 (tarde)
    (1, 4, 'Matemática', '13:00:00', 80, 1),   
    (2, 4, 'Lengua',     '14:30:00', 80, 1),   
    (4, 4, 'Biología',   '16:00:00', 80, 1);

INSERT INTO pertenece (id_alumno, id_curso)
VALUES
    #nacidos en 2012:  1 A 2025 (curso 1) y después 2 A 2026 (curso 2) esto lo hago de ejemplo por si paso 1 año desde que se usa la bd
    #Entonces los nacidos en 2012, el año pasado cursaron 1 A 2025 (curso con id num 1) y este año estan a 2 A 2026 (curso con id numero 2).
    #Un alumno puede estar en muchos cursos (uno por año)
    # y un curso tiene muchos alumnos. Eso es la relación N:M, y por eso pertenece es una tabla aparte.
    (5, 1),  (5, 2),     
    (7, 1),  (7, 2),     
    (9, 1),  (9, 2),     
    (11, 1), (11, 2),    
    (13, 1), (13, 2),    
    (15, 1), (15, 2),    
    (17, 1), (17, 2),   
    (19, 1), (19, 2),    
    #nacidos en 2013: 1 A 2026 (curso 3)
    (6, 3),              
    (8, 3),              
    (10, 3),             
    (12, 3),             
    #nacidos en 2013: 1 B 2026, tarde (curso 4)
    (14, 4),             
    (16, 4),             
    (18, 4);
    
INSERT INTO calificacion (id_alumno, id_materia, parcial_1, parcial_2)
VALUES
    #materia 1: Matematica de 1ero A 2025
    (5, 1, 7.50, 8),             
    (7, 1, 6.50, 6.50),          
    (9, 1, 9, 9.50),             
    (11, 1, 3.50, 5.50),         
    (13, 1, 7.50, 6),            
    (15, 1, 4.50, 5),            
    (17, 1, 8, 9.50),            
    (19, 1, 7, 4.50),            
    #materia 2: Lengua de 1ero A 2025
    (5, 2, 8, 7.50),             
    (7, 2, 5.50, 7.50),         
    (9, 2, 9.50, 9),            
    (11, 2, 4, 5),              
    (13, 2, 6.50, 7),           
    (15, 2, 6, 5.50),           
    (17, 2, 8.50, 9),           
    (19, 2, 6, 5.50),           
    #materia 3: Historia de 1ero A 2025
    (5, 3, 8.50, 7),            
    (7, 3, 6, 7),               
    (9, 3, 8.50, 10),           
    (11, 3, 4.50, 4.50),        
    (13, 3, 7, 6.50),           
    (15, 3, 5, 6.50),           
    (17, 3, 9, 8.50),           
    (19, 3, 6.50, 5),           
    #materia 4: Matematica de 2do A 2026
    (5, 4, 7.50, 8),            
    (7, 4, 6.50, 6.50),        
    (9, 4, 9, 9.50),            
    (11, 4, 2.50, 4.50),        
    (13, 4, 7.50, 6),           
    (15, 4, 5.50, 6),           
    (17, 4, 8, 9.50),           
    (19, 4, 7, 4.50),           
    #materia 5: Lengua de 2do A 2026
    (5, 5, 8, 7.50),            
    (7, 5, 5.50, 7.50),         
    (9, 5, 9.50, 9),            
    (11, 5, 4, 5),              
    (13, 5, 6.50, 7),           
    (15, 5, 6, 5.50),           
    (17, 5, 8.50, 9),           
    (19, 5, 6, 5.50),           
    #materia 6: Física de 2° A 2026
    (5, 6, 8.50, 7),           
    (7, 6, 6, 7),             
    (9, 6, 8.50, 10),           
    (11, 6, 4.50, 4.50),        
    (13, 6, 7, 6.50),           
    (15, 6, 5, 6.50),          
    (17, 6, 9, 8.50),          
    (19, 6, 4, 5),              
	#materia 7: Matematica de 1ero A 2026
    (6, 7, 9, 8.50),            
    (8, 7, 6.50, 8),            
    (10, 7, 5.50, 5),           
    (12, 7, 3.50, 4),           
    #materia 8: Lengua de 1ero A 2026
    (6, 8, 9.50, 8),            
    (8, 8, 7, 7.50),            
    (10, 8, 5.50, 7),           
    (12, 8, 4, 3.50),           
	#materia 9: Historia de 1ero A 2026 (parcial 2 todavia no rendido)
    (6, 9, 8.50, NULL),         
    (8, 9, 7.50, NULL),         
    (10, 9, 6, NULL),           
    (12, 9, 3, NULL),           
    #materia 10: Matematica de 1ero B 2026 (tarde)
    (14, 10, 7.50, 8.50),      
    (16, 10, 4.50, 3),          
    (18, 10, 7.50, 9),          
    #materia 11: Lengua de 1ero B 2026 (tarde)
    (14, 11, 8, 8),             
    (16, 11, 4.50, 5),          
    (18, 11, 8, 8.50),          
    #materia 12: Biologia de 1ero B 2026 (tarde) (parcial 2 todavia no rendido)
    (14, 12, 8.50, NULL),       
    (16, 12, 5, NULL),          
    (18, 12, 7, NULL);    
    
INSERT INTO asiste (id_alumno, id_materia, fecha, presente)
VALUES
    #materia 4: Matemática de 2° A 2026
    (5, 4, '2026-10-05', 1), (5, 4, '2026-10-12', 1), (5, 4, '2026-10-19', 1),  
    (7, 4, '2026-10-05', 1), (7, 4, '2026-10-12', 1), (7, 4, '2026-10-19', 1), 
    (9, 4, '2026-10-05', 1), (9, 4, '2026-10-12', 1), (9, 4, '2026-10-19', 1),  
    (11, 4, '2026-10-05', 0), (11, 4, '2026-10-12', 0), (11, 4, '2026-10-19', 1),  
    (13, 4, '2026-10-05', 1), (13, 4, '2026-10-12', 1), (13, 4, '2026-10-19', 1), 
    (15, 4, '2026-10-05', 1), (15, 4, '2026-10-12', 1), (15, 4, '2026-10-19', 1),  
    (17, 4, '2026-10-05', 1), (17, 4, '2026-10-12', 1), (17, 4, '2026-10-19', 1),  
    (19, 4, '2026-10-05', 1), (19, 4, '2026-10-12', 1), (19, 4, '2026-10-19', 1),  
    #materia 5: Lengua de 2° A 2026
    (5, 5, '2026-10-06', 1), (5, 5, '2026-10-13', 1), (5, 5, '2026-10-20', 1),  
    (7, 5, '2026-10-06', 1), (7, 5, '2026-10-13', 1), (7, 5, '2026-10-20', 1),  
    (9, 5, '2026-10-06', 1), (9, 5, '2026-10-13', 1), (9, 5, '2026-10-20', 1),  
    (11, 5, '2026-10-06', 1), (11, 5, '2026-10-13', 0), (11, 5, '2026-10-20', 1),  
    (13, 5, '2026-10-06', 1), (13, 5, '2026-10-13', 1), (13, 5, '2026-10-20', 1),  
    (15, 5, '2026-10-06', 1), (15, 5, '2026-10-13', 1), (15, 5, '2026-10-20', 1),  
    (17, 5, '2026-10-06', 1), (17, 5, '2026-10-13', 1), (17, 5, '2026-10-20', 1),  
    (19, 5, '2026-10-06', 1), (19, 5, '2026-10-13', 1), (19, 5, '2026-10-20', 0),  
    #materia 7: Matemática de 1° A 2026
    (6, 7, '2026-10-05', 1), (6, 7, '2026-10-12', 1), (6, 7, '2026-10-19', 1),  
    (8, 7, '2026-10-05', 1), (8, 7, '2026-10-12', 1), (8, 7, '2026-10-19', 1),  
    (10, 7, '2026-10-05', 1), (10, 7, '2026-10-12', 1), (10, 7, '2026-10-19', 1),  
    (12, 7, '2026-10-05', 0), (12, 7, '2026-10-12', 1), (12, 7, '2026-10-19', 0),  
    #materia 8: Lengua de 1° A 2026
    (6, 8, '2026-09-30', 1), (6, 8, '2026-10-07', 1), (6, 8, '2026-10-14', 1),  
    (8, 8, '2026-09-30', 1), (8, 8, '2026-10-07', 1), (8, 8, '2026-10-14', 1),  
    (10, 8, '2026-09-30', 0), (10, 8, '2026-10-07', 1), (10, 8, '2026-10-14', 1),  
    (12, 8, '2026-09-30', 1), (12, 8, '2026-10-07', 0), (12, 8, '2026-10-14', 1),  
    #materia 10: Matemática de 1° B 2026 (tarde)
    (14, 10, '2026-10-05', 1), (14, 10, '2026-10-12', 1), (14, 10, '2026-10-19', 1),  
    (16, 10, '2026-10-05', 1), (16, 10, '2026-10-12', 0), (16, 10, '2026-10-19', 1),  
    (18, 10, '2026-10-05', 1), (18, 10, '2026-10-12', 1), (18, 10, '2026-10-19', 1),  
    #materia 11: Lengua de 1° B 2026 (tarde)
    (14, 11, '2026-10-06', 1), (14, 11, '2026-10-13', 1), (14, 11, '2026-10-20', 1),  
    (16, 11, '2026-10-06', 1), (16, 11, '2026-10-13', 1), (16, 11, '2026-10-20', 1),  
    (18, 11, '2026-10-06', 1), (18, 11, '2026-10-13', 1), (18, 11, '2026-10-20', 1);  