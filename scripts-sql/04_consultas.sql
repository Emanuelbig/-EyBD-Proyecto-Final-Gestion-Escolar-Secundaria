-- Proyecto Final EyBD 2026 - Grupo 7
-- Sistema de gestion escolar (modulo docente)
-- 04_consultas: consultas de prueba
-- (se ejecuta despues de cargar los datos con 03_insercion_datos.sql)

USE gestion_escolar;

-- 1.Materias que se cursan a la tarde
--
-- Muestra las materias que empiezan desde las 13:00, con el curso donde se dan, ordenadas por horario.
-- Sirve para ver que se dicta en el turno tarde.
-- El horario ahora esta en contiene, porque la misma materia puede ir a distinta hora en cada curso.
--
SELECT
    m.nombre,
    c.anio,
    c.division,
    ct.horario_inicio,
    ct.duracion
FROM
    contiene ct
    JOIN materia m ON m.id_materia = ct.id_materia
    JOIN curso c ON c.id_curso = ct.id_curso
WHERE
    ct.horario_inicio >= '13:00:00'
ORDER BY
    ct.horario_inicio;

-- 2.Alumnos de cada curso del ciclo 2026
--
-- Muestra los alumnos inscriptos en cada curso de este año.
-- Sirve para que preceptoria arme las listas de cada curso.
--
SELECT
    c.anio,
    c.division,
    c.turno,
    CONCAT(p.apellido, ', ', p.nombre) AS alumno
FROM
    pertenece pe
    JOIN curso c ON c.id_curso = pe.id_curso
    JOIN persona p ON p.id_persona = pe.id_alumno
WHERE
    c.ciclo_lectivo = 2026
ORDER BY
    c.anio, c.division, p.apellido;

-- 3.Materias que da cada profesor y en que cursos
--
-- Muestra cada profesor con las materias que dicta y en que curso.
-- Para saber el curso hay que pasar por contiene (materia -> contiene -> curso).
--
SELECT
    CONCAT(p.apellido, ', ', p.nombre) AS profesor,
    m.nombre AS materia,
    c.anio,
    c.division,
    c.ciclo_lectivo
FROM
    materia m
    JOIN persona p ON p.id_persona = m.id_profesor
    JOIN contiene ct ON ct.id_materia = m.id_materia
    JOIN curso c ON c.id_curso = ct.id_curso
ORDER BY
    p.apellido, c.ciclo_lectivo, m.nombre;

-- 4.Nota final de cada alumno en cada materia
--
-- La nota final no se guarda en la base: se calcula con el promedio de los dos parciales.
-- Si falta el segundo parcial, la nota final queda vacia (NULL).
-- Con anio_plan se distingue Matematica de 1er año de Matematica de 2do.
--
SELECT
    CONCAT(p.apellido, ', ', p.nombre) AS alumno,
    m.nombre AS materia,
    m.anio_plan,
    c.parcial_1,
    c.parcial_2,
    ROUND((c.parcial_1 + c.parcial_2) / 2, 2) AS nota_final
FROM
    calificacion c
    JOIN persona p ON p.id_persona = c.id_alumno
    JOIN materia m ON m.id_materia = c.id_materia
ORDER BY
    p.apellido, m.anio_plan, m.nombre;

-- 5.Porcentaje de asistencia de cada alumno
--
-- Cuenta cuantas clases tuvo cada alumno y a cuantas vino, y calcula el porcentaje.
-- Sirve para detectar alumnos con muchas faltas.
--
SELECT
    CONCAT(p.apellido, ', ', p.nombre) AS alumno,
    COUNT(*) AS clases,
    SUM(a.presente) AS presentes,
    ROUND(SUM(a.presente) * 100 / COUNT(*), 2) AS porcentaje_asistencia
FROM
    asiste a
    JOIN persona p ON p.id_persona = a.id_alumno
GROUP BY
    p.id_persona, p.apellido, p.nombre
ORDER BY
    porcentaje_asistencia;
