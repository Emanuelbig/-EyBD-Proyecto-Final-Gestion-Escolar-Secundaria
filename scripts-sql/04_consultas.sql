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
SELECT materia.nombre, curso.anio, curso.division, contiene.horario_inicio
FROM contiene
JOIN materia ON materia.id_materia = contiene.id_materia
JOIN curso ON curso.id_curso = contiene.id_curso
WHERE contiene.horario_inicio >= '13:00:00'
ORDER BY contiene.horario_inicio;

-- 2.Alumnos de cada curso del ciclo 2026
--
-- Muestra los alumnos inscriptos en cada curso de este año.
-- Sirve para que preceptoria arme las listas de cada curso.
--
SELECT curso.anio, curso.division, persona.apellido, persona.nombre
FROM pertenece
JOIN curso ON curso.id_curso = pertenece.id_curso
JOIN persona ON persona.id_persona = pertenece.id_alumno
WHERE curso.ciclo_lectivo = 2026
ORDER BY curso.anio, curso.division, persona.apellido;

-- 3.Materias que da cada profesor y en que cursos
--
-- Muestra cada profesor con las materias que dicta y en que curso.
-- Para saber el curso hay que pasar por contiene (materia -> contiene -> curso).
--
SELECT persona.apellido, persona.nombre, materia.nombre AS materia, curso.anio, curso.division, curso.ciclo_lectivo
FROM materia
JOIN persona ON persona.id_persona = materia.id_profesor
JOIN contiene ON contiene.id_materia = materia.id_materia
JOIN curso ON curso.id_curso = contiene.id_curso
ORDER BY persona.apellido, curso.ciclo_lectivo;

-- 4.Nota final de cada alumno en cada materia
--
-- La nota final no se guarda en la base: se calcula con el promedio de los dos parciales.
-- Si falta el segundo parcial, la nota final queda vacia (NULL).
-- Con anio_plan se distingue Matematica de 1er año de Matematica de 2do.
--
SELECT persona.apellido, persona.nombre, materia.nombre AS materia, materia.anio_plan,
       calificacion.parcial_1, calificacion.parcial_2,
       ROUND((calificacion.parcial_1 + calificacion.parcial_2) / 2, 2) AS nota_final
FROM calificacion
JOIN persona ON persona.id_persona = calificacion.id_alumno
JOIN materia ON materia.id_materia = calificacion.id_materia
ORDER BY persona.apellido, materia.anio_plan;

-- 5.Porcentaje de asistencia de cada alumno
--
-- Calcula el porcentaje de clases a las que vino cada alumno.
-- presente vale 1 o 0, asi que el promedio por 100 da el porcentaje.
-- Sirve para detectar alumnos con muchas faltas.
--
SELECT persona.apellido, persona.nombre,
       ROUND(AVG(asiste.presente) * 100, 2) AS porcentaje_asistencia
FROM asiste
JOIN persona ON persona.id_persona = asiste.id_alumno
GROUP BY persona.id_persona
ORDER BY porcentaje_asistencia;
