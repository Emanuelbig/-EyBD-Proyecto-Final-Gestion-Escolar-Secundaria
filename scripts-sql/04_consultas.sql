-- Proyecto Final EyBD 2026 - Grupo 7
-- Sistema de gestion escolar (modulo docente)
-- 04_consultas: consultas de validacion
-- (se ejecuta despues de cargar los datos con 03_insercion_datos.sql o 00_script_unico.sql)

USE gestion_escolar;

-- 1. Listado de alumnos de un curso especifico (Ej: id_curso = 2)
--
-- Lista de un curso con los datos de contacto de cada alumno.
-- Se muestra el ciclo lectivo porque "1 A" existe en 2025 y en 2026.
--
SELECT c.ciclo_lectivo, c.anio, c.division, c.turno, p.dni, p.apellido, p.nombre, p.email
FROM pertenece pe
JOIN persona p ON p.id_persona = pe.id_alumno
JOIN curso c ON c.id_curso = pe.id_curso
WHERE c.id_curso = 2
ORDER BY p.apellido, p.nombre;

-- 2. Cantidad de alumnos por curso
--
-- Con LEFT JOIN tambien aparecerian los cursos sin ningun inscripto (con 0).
--
SELECT c.ciclo_lectivo, c.anio, c.division, c.turno, COUNT(pe.id_alumno) AS total_alumnos
FROM curso c
LEFT JOIN pertenece pe ON pe.id_curso = c.id_curso
GROUP BY c.id_curso, c.ciclo_lectivo, c.anio, c.division, c.turno
ORDER BY c.ciclo_lectivo, c.anio, c.division;

-- 3. Materias que se cursan a la tarde
--
-- Muestra las materias que empiezan desde las 13:00, con el curso donde se dan.
-- El horario esta en contiene, porque la misma materia puede ir a distinta hora en cada curso.
--
SELECT m.nombre AS materia, m.anio_plan, c.ciclo_lectivo, c.anio, c.division, co.horario_inicio, co.duracion
FROM contiene co
JOIN materia m ON m.id_materia = co.id_materia
JOIN curso c ON c.id_curso = co.id_curso
WHERE co.horario_inicio >= '13:00:00'
ORDER BY co.horario_inicio;

-- 4. Materias del plan y el profesor que las dicta
--
SELECT m.id_materia, m.nombre AS materia, m.anio_plan,
       CONCAT(p.apellido, ', ', p.nombre) AS profesor, p.email AS email_profesor
FROM materia m
JOIN persona p ON p.id_persona = m.id_profesor
ORDER BY m.nombre, m.anio_plan;

-- 5. Materias que da cada profesor y en que cursos
--
-- Para saber el curso hay que pasar por contiene (materia -> contiene -> curso).
--
SELECT p.apellido, p.nombre, m.nombre AS materia, c.ciclo_lectivo, c.anio, c.division
FROM materia m
JOIN persona p ON p.id_persona = m.id_profesor
JOIN contiene co ON co.id_materia = m.id_materia
JOIN curso c ON c.id_curso = co.id_curso
ORDER BY p.apellido, c.ciclo_lectivo, c.anio, c.division;

-- 6. Alumnos que cursan una materia especifica (Ej: id_materia = 1)
--
-- La misma materia se da en varios cursos y ciclos, por eso se ordena primero por curso.
--
SELECT m.nombre AS materia, c.ciclo_lectivo, c.anio, c.division,
       CONCAT(p.apellido, ', ', p.nombre) AS alumno, p.dni
FROM contiene co
JOIN materia m ON m.id_materia = co.id_materia
JOIN curso c ON c.id_curso = co.id_curso
JOIN pertenece pe ON pe.id_curso = c.id_curso
JOIN persona p ON p.id_persona = pe.id_alumno
WHERE m.id_materia = 1
ORDER BY c.ciclo_lectivo, c.anio, c.division, p.apellido, p.nombre;

-- 7. Cursos y materias de un alumno especifico (Ej: id_alumno = 5)
--
SELECT CONCAT(p.apellido, ', ', p.nombre) AS alumno, c.ciclo_lectivo, c.anio, c.division, m.nombre AS materia
FROM pertenece pe
JOIN persona p ON p.id_persona = pe.id_alumno
JOIN curso c ON c.id_curso = pe.id_curso
JOIN contiene co ON co.id_curso = c.id_curso
JOIN materia m ON m.id_materia = co.id_materia
WHERE pe.id_alumno = 5
ORDER BY c.ciclo_lectivo, c.anio, m.nombre;

-- 8. Nota final de cada alumno en cada materia
--
-- La nota final no se guarda en la base: se calcula con el promedio de los dos parciales.
-- Si falta un parcial, la nota final queda vacia (NULL).
-- Con anio_plan se distingue Matematica de 1er año de Matematica de 2do.
--
SELECT p.apellido, p.nombre, m.nombre AS materia, m.anio_plan, k.parcial_1, k.parcial_2,
       ROUND((k.parcial_1 + k.parcial_2) / 2, 2) AS nota_final
FROM calificacion k
JOIN persona p ON p.id_persona = k.id_alumno
JOIN materia m ON m.id_materia = k.id_materia
ORDER BY p.apellido, p.nombre, m.anio_plan, m.nombre;

/*
PARA CHARLAR: version de la consulta 3 del txt de consultas (dejada comentada, no se ejecuta).
Por que esta mal: IFNULL(parcial, 0) cuenta como 0 un parcial que todavia no se rindio.
Ejemplo: Gimenez Sofia en Historia tiene 8.50 y el 2do parcial sin rendir: aca le da nota final 4.25.
Lo correcto segun el diccionario de datos es que la nota final quede NULL hasta tener los dos parciales.
Afecta a 7 de las 69 filas. Ademas no tiene ORDER BY y no muestra anio_plan (hay dos "Matematica").

SELECT 
    CONCAT(p.apellido, ', ', p.nombre) AS alumno,
    mat.nombre AS materia,
    cal.parcial_1, cal.parcial_2,
    ROUND((IFNULL(cal.parcial_1, 0) + IFNULL(cal.parcial_2, 0)) / 2, 2) AS nota_final
FROM CALIFICACION cal
JOIN ALUMNO a ON cal.id_alumno = a.id_persona
JOIN PERSONA p ON a.id_persona = p.id_persona
JOIN MATERIA mat ON cal.id_materia = mat.id_materia;
*/

-- 9. Alumnos en riesgo de desaprobar (nota final menor a 6)
--
-- El que esta peor sale primero.
-- Si le falta un parcial no sale, porque todavia no tiene nota final.
--
SELECT p.apellido, p.nombre, m.nombre AS materia, m.anio_plan,
       ROUND((k.parcial_1 + k.parcial_2) / 2, 2) AS nota_final
FROM calificacion k
JOIN persona p ON p.id_persona = k.id_alumno
JOIN materia m ON m.id_materia = k.id_materia
WHERE (k.parcial_1 + k.parcial_2) / 2 < 6
ORDER BY nota_final, p.apellido, p.nombre;

/*
PARA CHARLAR: version de la consulta 4 del txt de consultas (dejada comentada, no se ejecuta).
Por que esta mal: por el mismo IFNULL, un alumno sin el 2do parcial sale siempre en riesgo si su 1er parcial es menor a 12,
o sea, siempre, porque la nota maxima es 10. Devuelve 30 filas en vez de 23.
Las 7 de mas son alumnos sin nota final todavia (ejemplo: Gimenez Sofia con un 8.50, Castro Lucia con un 8.50).

SELECT 
    CONCAT(p.apellido, ', ', p.nombre) AS alumno,
    mat.nombre AS materia,
    ROUND((IFNULL(cal.parcial_1, 0) + IFNULL(cal.parcial_2, 0)) / 2, 2) AS nota_final
FROM CALIFICACION cal
JOIN ALUMNO a ON cal.id_alumno = a.id_persona
JOIN PERSONA p ON a.id_persona = p.id_persona
JOIN MATERIA mat ON cal.id_materia = mat.id_materia
WHERE (IFNULL(cal.parcial_1, 0) + IFNULL(cal.parcial_2, 0)) / 2 < 6;
*/

-- 10. Estado academico de cada alumno en cada materia
--
-- Primero se pregunta si falta un parcial: sin los dos parciales no se puede decidir.
--
SELECT p.apellido, p.nombre, m.nombre AS materia, m.anio_plan, k.parcial_1, k.parcial_2,
       ROUND((k.parcial_1 + k.parcial_2) / 2, 2) AS nota_final,
       CASE
           WHEN k.parcial_1 IS NULL OR k.parcial_2 IS NULL THEN 'PENDIENTE'
           WHEN (k.parcial_1 + k.parcial_2) / 2 >= 6 THEN 'APROBADO'
           ELSE 'EN RIESGO / DESAPROBADO'
       END AS estado
FROM calificacion k
JOIN persona p ON p.id_persona = k.id_alumno
JOIN materia m ON m.id_materia = k.id_materia
ORDER BY p.apellido, p.nombre, m.anio_plan, m.nombre;

/*
PARA CHARLAR: version de la consulta 9 del txt de consultas (dejada comentada, no se ejecuta).
La idea del CASE es buena y por eso se conservo, pero por el mismo IFNULL marca "EN RIESGO / DESAPROBADO"
a los 7 alumnos a los que les falta el 2do parcial. En la version de arriba esos 7 salen como PENDIENTE.

SELECT 
    CONCAT(p.apellido, ', ', p.nombre) AS alumno,
    mat.nombre AS materia, cal.parcial_1, cal.parcial_2,
    ROUND((IFNULL(cal.parcial_1, 0) + IFNULL(cal.parcial_2, 0)) / 2, 2) AS promedio,
    CASE 
        WHEN (IFNULL(cal.parcial_1, 0) + IFNULL(cal.parcial_2, 0)) / 2 >= 6 THEN 'APROBADO'
        ELSE 'EN RIESGO / DESAPROBADO'
    END AS estado
FROM CALIFICACION cal
JOIN ALUMNO a ON cal.id_alumno = a.id_persona
JOIN PERSONA p ON a.id_persona = p.id_persona
JOIN MATERIA mat ON cal.id_materia = mat.id_materia
ORDER BY alumno, materia;
*/

-- 11. Alumnos con notas de parcial pendientes de carga
--
SELECT p.apellido, p.nombre, m.nombre AS materia, m.anio_plan,
       CASE
           WHEN k.parcial_1 IS NULL AND k.parcial_2 IS NULL THEN 'Faltan los dos parciales'
           WHEN k.parcial_1 IS NULL THEN 'Falta 1er parcial'
           ELSE 'Falta 2do parcial'
       END AS estado_notas
FROM calificacion k
JOIN persona p ON p.id_persona = k.id_alumno
JOIN materia m ON m.id_materia = k.id_materia
WHERE k.parcial_1 IS NULL OR k.parcial_2 IS NULL
ORDER BY m.anio_plan, m.nombre, p.apellido;

-- 12. Promedio de notas finales por materia
--
-- AVG ignora los NULL: solo promedia a los alumnos que ya tienen los dos parciales.
-- Si nadie tiene los dos parciales, el promedio queda NULL.
--
SELECT m.nombre AS materia, m.anio_plan,
       COUNT((k.parcial_1 + k.parcial_2) / 2) AS alumnos_con_nota_final,
       ROUND(AVG((k.parcial_1 + k.parcial_2) / 2), 2) AS promedio_materia
FROM calificacion k
JOIN materia m ON m.id_materia = k.id_materia
GROUP BY m.id_materia, m.nombre, m.anio_plan
ORDER BY m.anio_plan, m.nombre;

-- 13. Porcentaje de asistencia de cada alumno por materia
--
SELECT p.apellido, p.nombre, m.nombre AS materia, m.anio_plan,
       COUNT(a.id_asistencia) AS total_clases,
       SUM(a.presente) AS total_presentes,
       ROUND(SUM(a.presente) * 100 / COUNT(a.id_asistencia), 2) AS porcentaje_asistencia
FROM asiste a
JOIN persona p ON p.id_persona = a.id_alumno
JOIN materia m ON m.id_materia = a.id_materia
GROUP BY p.id_persona, p.apellido, p.nombre, m.id_materia, m.nombre, m.anio_plan
ORDER BY p.apellido, p.nombre, m.anio_plan, m.nombre;

-- 14. Porcentaje de asistencia general de cada alumno
--
-- presente vale 1 o 0, asi que el promedio por 100 da el porcentaje.
-- El que tiene menos asistencia sale primero.
--
SELECT p.apellido, p.nombre, ROUND(AVG(a.presente) * 100, 2) AS porcentaje_asistencia
FROM asiste a
JOIN persona p ON p.id_persona = a.id_alumno
GROUP BY p.id_persona, p.apellido, p.nombre
ORDER BY porcentaje_asistencia, p.apellido, p.nombre;

-- 15. Alumnos con ausencias y total de faltas por materia
--
-- HAVING filtra despues de agrupar: se queda solo con los que tienen alguna falta.
--
SELECT p.apellido, p.nombre, m.nombre AS materia, m.anio_plan,
       SUM(CASE WHEN a.presente = 0 THEN 1 ELSE 0 END) AS total_faltas
FROM asiste a
JOIN persona p ON p.id_persona = a.id_alumno
JOIN materia m ON m.id_materia = a.id_materia
GROUP BY p.id_persona, p.apellido, p.nombre, m.id_materia, m.nombre, m.anio_plan
HAVING total_faltas > 0
ORDER BY total_faltas DESC, p.apellido, p.nombre;

-- 16. Materias sin ninguna asistencia cargada
--
-- Subconsulta: busca las materias que no aparecen en asiste.
-- Sirve para detectar en que materias todavia no se tomo asistencia.
--
SELECT m.id_materia, m.nombre AS materia, m.anio_plan
FROM materia m
WHERE m.id_materia NOT IN (SELECT a.id_materia FROM asiste a)
ORDER BY m.anio_plan, m.nombre;
