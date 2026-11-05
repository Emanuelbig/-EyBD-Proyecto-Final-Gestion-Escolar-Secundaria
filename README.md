# Sistema de gestión escolar - Módulo docente

Trabajo final de Estructura y Base de Datos (UTN - INSPT, 2026).
Grupo 7: Forclaz - Ponce - Morano Solé.

Base de datos en MySQL para una escuela secundaria: profesores, alumnos, cursos, materias, inscripciones, asistencia y notas.

## Qué hay en cada carpeta

- `scripts-sql`: los scripts de la base.
- `diagramas`: MER y modelo de tablas (versión 5).
- `documentacion`: informe y diccionario de datos.
- `versiones-anteriores`: la entrega parcial y los primeros bocetos.

## Cómo probarla

La forma más rápida es ejecutar estos dos scripts:

1. `00_script_unico.sql`: crea la base, agrega las restricciones y carga los datos de prueba.
2. `04_consultas.sql`: corre las 16 consultas de validación.

También se puede hacer por partes, en este orden:

1. `01_estructura.sql`: crea la base y las tablas.
2. `02_restricciones.sql`: agrega claves, reglas e índices.
3. `03_insercion_datos.sql`: carga los datos de prueba.
4. `04_consultas.sql`: corre las 16 consultas de validación.

Los datos cargados son inventados.

Usamos MySQL 8.0.46.
