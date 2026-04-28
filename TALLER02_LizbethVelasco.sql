-- ============================================
-- TALLER 2 - MySQL PRACTICO (SAKILA)
-- Nombre: Lizbeth Velasco

-- Este script fue probado completamente en la base de datos Sakila
-- Todas las consultas fueron verificadas sin errores
-- ============================================

-- Se selecciona la base de datos Sakila para trabajar sobre ella
USE sakila;

-- ============================================
-- PARTE 1 - SELECT Y WHERE
-- ============================================

-- 1. Mostrar nombre y apellido de todos los clientes
-- SELECT permite elegir qué columnas quiero ver
-- FROM indica de qué tabla se obtienen los datos
-- En este caso, se extraen los nombres y apellidos de la tabla customer
SELECT first_name, last_name
FROM customer;

-- 2. Películas con duración mayor a 120 minutos
-- WHERE permite filtrar los datos según una condición
-- Solo se muestran películas cuya duración (length) sea mayor a 120 minutos
SELECT title, length
FROM film
WHERE length > 120;


-- ============================================
-- PARTE 2 - ORDER BY
-- ============================================

-- 3. Ordenar clientes por apellido (A-Z)
-- ORDER BY permite ordenar los resultados
-- ASC significa orden ascendente (de la A a la Z)
SELECT first_name, last_name
FROM customer
ORDER BY last_name ASC;

-- 4. Top 5 películas más largas
-- ORDER BY DESC ordena de mayor a menor
-- LIMIT restringe la cantidad de resultados mostrados
SELECT title, length
FROM film
ORDER BY length DESC
LIMIT 5;


-- ============================================
-- PARTE 3 - INNER JOIN
-- ============================================

-- 5. Cantidad pagada y fecha con nombre del cliente
-- INNER JOIN permite unir tablas que tienen relación entre sí
-- La tabla payment contiene los pagos realizados
-- La tabla customer contiene la información de los clientes
-- Se relacionan mediante el campo customer_id
-- Solo se muestran registros que coinciden en ambas tablas
SELECT c.first_name, c.last_name, p.amount, p.payment_date
FROM payment p
INNER JOIN customer c 
ON p.customer_id = c.customer_id;

-- 6. Películas alquiladas
-- Se hace una unión entre tres tablas:
-- rental: contiene los alquileres
-- inventory: relaciona cada alquiler con una copia de la película
-- film: contiene la información de la película
-- Esto permite obtener el nombre de la película alquilada
SELECT f.title, r.rental_date
FROM rental r
INNER JOIN inventory i 
ON r.inventory_id = i.inventory_id
INNER JOIN film f 
ON i.film_id = f.film_id;


-- ============================================
-- PARTE 4 - LEFT JOIN
-- ============================================

-- 7. Clientes sin pagos
-- LEFT JOIN trae todos los registros de la tabla izquierda (customer)
-- y los combina con payment si existe coincidencia
-- Si no hay coincidencia, los campos de payment quedan en NULL
-- Se usa WHERE para filtrar aquellos clientes que NO tienen pagos
SELECT c.first_name, c.last_name
FROM customer c
LEFT JOIN payment p 
ON c.customer_id = p.customer_id
WHERE p.payment_id IS NULL;

-- 8. Películas sin actores
-- Se relaciona film con film_actor
-- Si una película no tiene registros en film_actor, significa que no tiene actores asociados
-- Se identifican porque actor_id queda en NULL
SELECT f.title, f.length
FROM film f
LEFT JOIN film_actor fa 
ON f.film_id = fa.film_id
WHERE fa.actor_id IS NULL;


-- ============================================
-- PARTE 5 - INSERT, UPDATE, DELETE
-- ============================================

-- IMPORTANTE: estas operaciones modifican la base de datos

-- 9. Insertar actor temporal
-- INSERT INTO permite agregar un nuevo registro
-- Se especifican las columnas y los valores correspondientes
INSERT INTO actor (first_name, last_name)
VALUES ('TEMP', 'ACTOR');

-- 10. Actualizar actor
-- UPDATE modifica registros existentes
-- SET define el nuevo valor
-- WHERE es fundamental para evitar modificar todos los registros
-- Aquí se cambia el nombre TEMP a PRUEBA
UPDATE actor
SET first_name = 'PRUEBA'
WHERE first_name = 'TEMP' AND last_name = 'ACTOR';

-- 11. Eliminar actor
-- DELETE elimina registros de la tabla
-- WHERE asegura que solo se elimine el actor creado previamente
DELETE FROM actor
WHERE first_name = 'PRUEBA' AND last_name = 'ACTOR';


-- ============================================
-- PARTE 6 - CONSULTAS AVANZADAS
-- ============================================

-- 12. Top 5 clientes que más dinero han pagado
-- SUM() es una función de agregación que suma valores
-- GROUP BY agrupa los datos por cliente
-- Se calcula el total pagado por cada cliente
-- ORDER BY permite ordenar de mayor a menor
-- LIMIT muestra solo los 5 primeros resultados
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_pagado
FROM customer c
INNER JOIN payment p 
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_pagado DESC
LIMIT 5;

-- 13. Top 5 películas más alquiladas
-- COUNT() cuenta cuántas veces se alquila cada película
-- GROUP BY agrupa por película
-- Se ordena de mayor a menor cantidad de alquileres
SELECT f.title, COUNT(r.rental_id) AS total_rentas
FROM rental r
INNER JOIN inventory i 
ON r.inventory_id = i.inventory_id
INNER JOIN film f 
ON i.film_id = f.film_id
GROUP BY f.film_id
ORDER BY total_rentas DESC
LIMIT 5;