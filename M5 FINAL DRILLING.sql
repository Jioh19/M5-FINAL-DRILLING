-- • Aquellas usadas para insertar, modificar y eliminar un Customer, Staff y Actor.
--* Insertar no tiene problemas. Eliminar o DELETE en cambio necesitan agregar 
--* "ON DELETE CASCADE" y UPDATE también a veces. Lo había tratado de hacer asi, pero
--* saber modificar tablas creo que no tenían mucho beneficio académico.... Quedó como
--* recuerdo en el GITHUB.

--* Lo hice todos los queries como ejemplos.

--* TABLA CUSTOMER

-- Insertar
INSERT INTO customer (customer_id, store_id, first_name, last_name, email, address_id, activebool, create_date, last_update, active)
VALUES 
	(601, 1, 'Juan', 'Oh', 'correo1', 601, true, CURRENT_DATE, CURRENT_DATE, 1);

-- Update	
UPDATE customer
SET
	customer_id = 602,
	store_id = 2,
	first_name = 'Nombre',
	last_name = 'Apellido',
	address_id = 602,
	activebool = true,
	last_update = CURRENT_DATE, 
	active = 1
WHERE customer_id = 601;

-- Delete
DELETE FROM customer WHERE customer_id = 602;

--* TABLA STAFF

-- Insertar:
INSERT INTO staff (staff_id, first_name,last_name, address_id, email, store_id, active, username, password, last_update)
VALUES  
    (3, 'Staffer', 'McStaff', 5, 'correo2', 1, true, 'staff', 'qwerty', CURRENT_DATE);

-- Update
UPDATE staff
SET	
	staff_id = 4,
	first_name = 'Stuffo',
	last_name = 'McStufy',
	address_id = 6,
	email = 'correo3',
	store_id = 2,
	active = false, 
	username = 'stufo',
	password = 'asdfghj'
WHERE staff_id = 3;

-- Delete
DELETE FROM staff WHERE staff_id = 4;

--* TABLA ACTOR

-- Insertar
INSERT INTO actor (actor_id, first_name, last_name, last_update)
VALUES
	(201, 'Actor', 'McActor', CURRENT_DATE);

-- Update
UPDATE actor
SET
	actor_id = 202,
	first_name = 'Bactor',
	last_name = 'BaBactor'
WHERE actor_id = 201;

-- Delete
DELETE FROM actor WHERE actor_id = 202;

-- • Listar todas las “rental” con los datos del “customer” dado un año y mes.
--* Retorna le fecha, nombre, apellido, email y pelicula 
SELECT to_char(rental_date, 'YYYY-MM'), customer.first_name, customer.last_name, email, title
    FROM rental
        INNER JOIN customer ON rental.customer_id = customer.customer_id 
        INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
        INNER JOIN film ON inventory.film_id = film.film_id
    WHERE customer.first_name = 'Mary' AND customer.last_name = 'Smith' AND to_char(rental_date, 'YYYY-MM') = '2005-06';

--* Esto hace lo mismo, pero genera la lista entera de clientes ordenados alfabéticamente.
SELECT to_char(rental.rental_date, 'YYYY-MM'), customer.first_name, customer.last_name, email, title
    FROM rental
        INNER JOIN customer ON rental.customer_id = customer.customer_id 
        INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
        INNER JOIN film ON inventory.film_id = film.film_id
    WHERE to_char(rental_date, 'YYYY-MM') = '2005-06'
    ORDER BY (customer.first_name, customer.last_name);

-- • Listar Número, Fecha (payment_date) y Total (amount) de todas las “payment”.
--* Decidí agruparlo por día, pero para agrupar por año o mes es trivial. Solo es neesario modificar 'YYYY-MM' ó 'YYYY' según sea el caso.
SELECT to_char(payment_date, 'YYYY-MM-DD') AS "Fecha", count(*) AS "Cantidad", sum(amount) AS "Subtotal"  
FROM payment 
GROUP BY "Fecha"
ORDER BY "Fecha";


-- • Listar todas las “film” del año 2006 que contengan un (rental_rate) mayor a 4.0.
--* Relativamente trivial.
SELECT title, release_year, rental_rate FROM film WHERE release_year = 2006 AND rental_rate > 4.0;


-- 5. Realiza un Diccionario de datos que contenga el nombre de las tablas y columnas, si
-- éstas pueden ser nulas, y su tipo de dato correspondiente.
--* Lo visto en clases.
SELECT
    t1.TABLE_NAME AS tabla_nombre,
    t1.COLUMN_NAME AS columna_nombre,
    t1.COLUMN_DEFAULT AS columna_defecto,
    t1.IS_NULLABLE AS columna_nulo,
    t1.DATA_TYPE AS columna_tipo_dato,
    COALESCE(t1.NUMERIC_PRECISION,
    t1.CHARACTER_MAXIMUM_LENGTH) AS columna_longitud,
    PG_CATALOG.COL_DESCRIPTION(t2.OID,
    t1.DTD_IDENTIFIER::int) AS columna_descripcion,
    t1.DOMAIN_NAME AS columna_dominio
FROM
    INFORMATION_SCHEMA.COLUMNS t1
    INNER JOIN PG_CLASS t2 ON (t2.RELNAME = t1.TABLE_NAME)
WHERE
    t1.TABLE_SCHEMA = 'public'
ORDER BY
    t1.TABLE_NAME;
-- Agregar comentario random
