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
SELECT c.ciclo_lectivo, c.anio, c.division, c.turno, al.dni, al.apellido, al.nombre, al.email
FROM pertenece pe
JOIN alumno al ON al.id_alumno = pe.id_alumno
JOIN curso c ON c.id_curso = pe.id_curso
WHERE c.id_curso = 1
ORDER BY al.apellido, al.nombre;

-- 2. Cantidad de alumnos por curso
--
-- Con LEFT JOIN tambien aparecerian los cursos sin ningun inscripto (con 0).
--
SELECT c.ciclo_lectivo, c.anio, c.division, c.turno, COUNT(pe.id_alumno) AS total_alumnos -- con COUNT() contamos los alumnos y ponemos esa cantidad en una columna nueva llamada total_alumnos
FROM curso c
LEFT JOIN pertenece pe ON pe.id_curso = c.id_curso -- el LEFT es para que muestre todos los cursos (tambien los que estan en 0)
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
       CONCAT(pr.apellido, ', ', pr.nombre) AS profesor, pr.email AS email_profesor
FROM materia m
JOIN profesor pr ON pr.id_profesor = m.id_profesor
ORDER BY m.nombre, m.anio_plan;

-- 5. Materias que da cada profesor y en que cursos
--
-- Para saber el curso hay que pasar por contiene (materia -> contiene -> curso).
--
SELECT pr.apellido, pr.nombre, m.nombre AS materia, c.ciclo_lectivo, c.anio, c.division
FROM materia m
JOIN profesor pr ON pr.id_profesor = m.id_profesor
JOIN contiene co ON co.id_materia = m.id_materia
JOIN curso c ON c.id_curso = co.id_curso
ORDER BY pr.apellido, c.ciclo_lectivo, c.anio, c.division;

-- 6. Alumnos que cursan una materia especifica (Ej: id_materia = 1)
--
-- La misma materia se da en varios cursos y ciclos, por eso se ordena primero por curso.
--
SELECT m.nombre AS materia, c.ciclo_lectivo, c.anio, c.division,
       CONCAT(al.apellido, ', ', al.nombre) AS alumno, al.dni
FROM contiene co
JOIN materia m ON m.id_materia = co.id_materia
JOIN curso c ON c.id_curso = co.id_curso
JOIN pertenece pe ON pe.id_curso = c.id_curso
JOIN alumno al ON al.id_alumno = pe.id_alumno
WHERE m.id_materia = 1
ORDER BY c.ciclo_lectivo, c.anio, c.division, al.apellido, al.nombre;

-- 7. Cursos y materias de un alumno especifico (Ej: id_alumno = 5)
--
SELECT CONCAT(al.apellido, ', ', al.nombre) AS alumno, c.ciclo_lectivo, c.anio, c.division, m.nombre AS materia
FROM pertenece pe
JOIN alumno al ON al.id_alumno = pe.id_alumno
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
SELECT al.apellido, al.nombre, m.nombre AS materia, m.anio_plan, ca.parcial_1, ca.parcial_2,
       ROUND((ca.parcial_1 + ca.parcial_2) / 2, 2) AS nota_final
FROM calificacion ca
JOIN alumno al ON al.id_alumno = ca.id_alumno
JOIN materia m ON m.id_materia = ca.id_materia
ORDER BY al.apellido, al.nombre, m.anio_plan, m.nombre;

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
SELECT al.apellido, al.nombre, m.nombre AS materia, m.anio_plan,
       ROUND((ca.parcial_1 + ca.parcial_2) / 2, 2) AS nota_final
FROM calificacion ca
JOIN alumno al ON al.id_alumno = ca.id_alumno
JOIN materia m ON m.id_materia = ca.id_materia
WHERE (ca.parcial_1 + ca.parcial_2) / 2 < 6
ORDER BY nota_final, al.apellido, al.nombre;

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
SELECT al.apellido, al.nombre, m.nombre AS materia, m.anio_plan, ca.parcial_1, ca.parcial_2,
       ROUND((ca.parcial_1 + ca.parcial_2) / 2, 2) AS nota_final,
       CASE
           WHEN ca.parcial_1 IS NULL OR ca.parcial_2 IS NULL THEN 'PENDIENTE'
           WHEN (ca.parcial_1 + ca.parcial_2) / 2 >= 6 THEN 'APROBADO'
           ELSE 'EN RIESGO / DESAPROBADO'
       END AS estado
FROM calificacion ca
JOIN alumno al ON al.id_alumno = ca.id_alumno
JOIN materia m ON m.id_materia = ca.id_materia
ORDER BY al.apellido, al.nombre, m.anio_plan, m.nombre;

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
SELECT al.apellido, al.nombre, m.nombre AS materia, m.anio_plan,
       CASE
           WHEN ca.parcial_1 IS NULL AND ca.parcial_2 IS NULL THEN 'Faltan los dos parciales'
           WHEN ca.parcial_1 IS NULL THEN 'Falta 1er parcial'
           ELSE 'Falta 2do parcial'
       END AS estado_notas
FROM calificacion ca
JOIN alumno al ON al.id_alumno = ca.id_alumno
JOIN materia m ON m.id_materia = ca.id_materia
WHERE ca.parcial_1 IS NULL OR ca.parcial_2 IS NULL
ORDER BY m.anio_plan, m.nombre, al.apellido;

-- 12. Promedio de notas finales por materia
--
-- AVG ignora los NULL: solo promedia a los alumnos que ya tienen los dos parciales.
-- Si nadie tiene los dos parciales, el promedio queda NULL.
--
SELECT m.nombre AS materia, m.anio_plan,
       COUNT((ca.parcial_1 + ca.parcial_2) / 2) AS alumnos_con_nota_final,
       ROUND(AVG((ca.parcial_1 + ca.parcial_2) / 2), 2) AS promedio_materia
FROM calificacion ca
JOIN materia m ON m.id_materia = ca.id_materia
GROUP BY m.id_materia, m.nombre, m.anio_plan
ORDER BY m.anio_plan, m.nombre;

-- 13. Porcentaje de asistencia de cada alumno por materia
--
SELECT al.apellido, al.nombre, m.nombre AS materia, m.anio_plan,
       COUNT(a.id_asistencia) AS total_clases,
       SUM(a.presente) AS total_presentes,
       ROUND(SUM(a.presente) * 100 / COUNT(a.id_asistencia), 2) AS porcentaje_asistencia
FROM asiste a
JOIN alumno al ON al.id_alumno = a.id_alumno
JOIN materia m ON m.id_materia = a.id_materia
GROUP BY al.id_alumno, al.apellido, al.nombre, m.id_materia, m.nombre, m.anio_plan
ORDER BY al.apellido, al.nombre, m.anio_plan, m.nombre;

-- 14. Porcentaje de asistencia general de cada alumno
--
-- presente vale 1 o 0, asi que el promedio por 100 da el porcentaje.
-- El que tiene menos asistencia sale primero.
--
SELECT al.apellido, al.nombre, ROUND(AVG(a.presente) * 100, 2) AS porcentaje_asistencia
FROM asiste a
JOIN alumno al ON al.id_alumno = a.id_alumno
GROUP BY al.id_alumno, al.apellido, al.nombre
ORDER BY porcentaje_asistencia, al.apellido, al.nombre;

-- 15. Alumnos con ausencias y total de faltas por materia
--
-- HAVING filtra despues de agrupar: se queda solo con los que tienen alguna falta.
--
SELECT al.apellido, al.nombre, m.nombre AS materia, m.anio_plan,
       SUM(CASE WHEN a.presente = 0 THEN 1 ELSE 0 END) AS total_faltas
FROM asiste a
JOIN alumno al ON al.id_alumno = a.id_alumno
JOIN materia m ON m.id_materia = a.id_materia
GROUP BY al.id_alumno, al.apellido, al.nombre, m.id_materia, m.nombre, m.anio_plan
HAVING total_faltas > 0
ORDER BY total_faltas DESC, al.apellido, al.nombre;

-- 16. Materias sin ninguna asistencia cargada
--
-- Subconsulta: busca las materias que no aparecen en asiste.
-- Sirve para detectar en que materias todavia no se tomo asistencia.
--
SELECT m.id_materia, m.nombre AS materia, m.anio_plan
FROM materia m
WHERE m.id_materia NOT IN (SELECT a.id_materia FROM asiste a)
ORDER BY m.anio_plan, m.nombre;

-- 17. Trayectoria: en que curso estuvo cada alumno en 2025 y en cual esta en 2026
--
-- Se usa pertenece y curso dos veces (una por cada ciclo), es un self join.
-- Solo salen los que estuvieron en los dos ciclos.
--
SELECT al.apellido, al.nombre,
       CONCAT(c25.anio, '° ', c25.division) AS curso_2025,
       CONCAT(c26.anio, '° ', c26.division) AS curso_2026
FROM alumno al
JOIN pertenece p25 ON p25.id_alumno = al.id_alumno
JOIN curso c25 ON c25.id_curso = p25.id_curso AND c25.ciclo_lectivo = 2025
JOIN pertenece p26 ON p26.id_alumno = al.id_alumno
JOIN curso c26 ON c26.id_curso = p26.id_curso AND c26.ciclo_lectivo = 2026
ORDER BY c26.anio, c26.division, al.apellido, al.nombre;

-- 18. Alumnos que estaban en 2025 y no siguen en 2026
--
-- Si estaban en 6to egresaron; si no, dejaron la escuela.
--
SELECT al.legajo, al.apellido, al.nombre, c.anio, c.division,
       CASE WHEN c.anio = 6 THEN 'EGRESADO' ELSE 'DEJO LA ESCUELA' END AS situacion
FROM alumno al
JOIN pertenece pe ON pe.id_alumno = al.id_alumno
JOIN curso c ON c.id_curso = pe.id_curso
WHERE c.ciclo_lectivo = 2025
  AND al.id_alumno NOT IN (SELECT pe2.id_alumno
                           FROM pertenece pe2
                           JOIN curso c2 ON c2.id_curso = pe2.id_curso
                           WHERE c2.ciclo_lectivo = 2026)
ORDER BY c.anio, c.division, al.apellido;

-- 19. Edad de cada alumno de un curso (Ej: 3ro A del 2026)
--
-- TIMESTAMPDIFF con YEAR cuenta los años completos entre la fecha de nacimiento y hoy.
-- Si todavia no cumplio en el año, no le suma ese año.
--
SELECT al.apellido, al.nombre,
       DATE_FORMAT(al.fecha_nacimiento, '%d/%m/%Y') AS fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, al.fecha_nacimiento, CURDATE()) AS edad
FROM alumno al
JOIN pertenece pe ON pe.id_alumno = al.id_alumno
JOIN curso c ON c.id_curso = pe.id_curso
WHERE c.ciclo_lectivo = 2026 AND c.anio = 3 AND c.division = 'A'
ORDER BY al.fecha_nacimiento;

-- 20. Edad promedio, minima y maxima por curso del 2026
--
-- La edad se calcula igual que en la 19 y despues se agrupa por curso.
--
SELECT c.anio, c.division, c.turno, COUNT(*) AS alumnos,
       ROUND(AVG(TIMESTAMPDIFF(YEAR, al.fecha_nacimiento, CURDATE())), 1) AS edad_promedio,
       MIN(TIMESTAMPDIFF(YEAR, al.fecha_nacimiento, CURDATE())) AS edad_minima,
       MAX(TIMESTAMPDIFF(YEAR, al.fecha_nacimiento, CURDATE())) AS edad_maxima
FROM alumno al
JOIN pertenece pe ON pe.id_alumno = al.id_alumno
JOIN curso c ON c.id_curso = pe.id_curso
WHERE c.ciclo_lectivo = 2026
GROUP BY c.id_curso, c.anio, c.division, c.turno
ORDER BY c.anio, c.division;

-- 21. Alumnos del 2026 que cumplen años este mes
--
-- MONTH saca el mes de la fecha. Se compara con el mes de hoy.
-- Se ordena por DAY para que salgan en el orden en que cumplen.
--
SELECT al.apellido, al.nombre, CONCAT(c.anio, '° ', c.division) AS curso,
       DATE_FORMAT(al.fecha_nacimiento, '%d/%m') AS cumple,
       YEAR(CURDATE()) - YEAR(al.fecha_nacimiento) AS cumple_anios
FROM alumno al
JOIN pertenece pe ON pe.id_alumno = al.id_alumno
JOIN curso c ON c.id_curso = pe.id_curso
WHERE c.ciclo_lectivo = 2026
  AND MONTH(al.fecha_nacimiento) = MONTH(CURDATE())
ORDER BY DAY(al.fecha_nacimiento), al.apellido;

-- 22. Porcentaje de asistencia por mes
--
-- DATE_FORMAT con '%Y-%m' deja solo el año y el mes, asi se agrupan todas las clases del mismo mes.
--
SELECT DATE_FORMAT(a.fecha, '%Y-%m') AS mes,
       COUNT(*) AS registros,
       SUM(a.presente = 0) AS faltas,
       ROUND(AVG(a.presente) * 100, 2) AS porcentaje_asistencia
FROM asiste a
GROUP BY mes
ORDER BY mes;

-- 23. Faltas por dia de la semana
--
-- lc_time_names cambia el idioma de DAYNAME para que salga "lunes" y no "Monday".
-- Se ordena por WEEKDAY (0 = lunes) para que los dias salgan en orden y no alfabetico.
--
SET lc_time_names = 'es_AR';

SELECT DAYNAME(a.fecha) AS dia,
       COUNT(*) AS registros,
       SUM(a.presente = 0) AS faltas,
       ROUND(SUM(a.presente = 0) * 100 / COUNT(*), 2) AS porcentaje_faltas
FROM asiste a
GROUP BY dia, WEEKDAY(a.fecha)
ORDER BY WEEKDAY(a.fecha);

-- 24. Alumnos con 2 faltas o mas en octubre de 2026
--
-- BETWEEN incluye las dos puntas: del 1 al 31 de octubre.
--
SELECT al.apellido, al.nombre, COUNT(*) AS faltas_octubre,
       GROUP_CONCAT(DATE_FORMAT(a.fecha, '%d/%m') ORDER BY a.fecha SEPARATOR ', ') AS dias
FROM asiste a
JOIN alumno al ON al.id_alumno = a.id_alumno
WHERE a.presente = 0
  AND a.fecha BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY al.id_alumno, al.apellido, al.nombre
HAVING faltas_octubre >= 2
ORDER BY faltas_octubre DESC, al.apellido;

-- 25. Ultima falta de cada alumno en el 2026 y cuantos dias pasaron
--
-- YEAR deja solo las faltas del 2026. MAX sobre una fecha devuelve la mas reciente.
-- DATEDIFF da la diferencia en dias entre hoy y esa fecha.
--
SELECT al.apellido, al.nombre,
       MAX(a.fecha) AS ultima_falta,
       DATEDIFF(CURDATE(), MAX(a.fecha)) AS dias_desde_la_falta
FROM asiste a
JOIN alumno al ON al.id_alumno = a.id_alumno
WHERE a.presente = 0
  AND YEAR(a.fecha) = 2026
GROUP BY al.id_alumno, al.apellido, al.nombre
ORDER BY ultima_falta DESC, al.apellido;

-- 26. Horario de cada materia de un curso con la hora de fin (Ej: 3ro A del 2026)
--
-- duracion esta en minutos. SEC_TO_TIME pasa los segundos a formato hora
-- y ADDTIME se la suma a la hora de inicio.
--
SELECT m.nombre AS materia,
       TIME_FORMAT(co.horario_inicio, '%H:%i') AS inicio,
       TIME_FORMAT(ADDTIME(co.horario_inicio, SEC_TO_TIME(co.duracion * 60)), '%H:%i') AS fin,
       co.duracion AS minutos
FROM contiene co
JOIN materia m ON m.id_materia = co.id_materia
JOIN curso c ON c.id_curso = co.id_curso
WHERE c.ciclo_lectivo = 2026 AND c.anio = 3 AND c.division = 'A'
ORDER BY co.horario_inicio;
