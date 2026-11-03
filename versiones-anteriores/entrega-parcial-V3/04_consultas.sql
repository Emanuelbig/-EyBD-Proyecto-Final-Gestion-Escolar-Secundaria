-- Proyecto Final EyBD 2026 - Grupo 7
-- Sistema de gestion escolar (modulo docente)
-- 04_consultas: consultas de prueba
-- (se ejecuta despues de cargar los datos con 03_insercion_datos.sql)

USE gestion_escolar;

-- 1.Materias que se cursan a la tarde
--
-- Muestra las materias que empiezan desde las 13:00, ordenadas por horario.
-- Sirve para ver que se dicta en el turno tarde.
--
SELECT
    m.nombre,
    m.horario_inicio,
    m.duracion
FROM
    materia m
WHERE
    m.horario_inicio >= '13:00:00'
ORDER BY
    m.horario_inicio;