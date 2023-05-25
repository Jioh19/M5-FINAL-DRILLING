-- • Aquellas usadas para insertar, modificar y eliminar un Customer, Staff y Actor.
--* Insertar no tiene problemas. Eliminar o DELETE en cambio necesitan agregar 
--* "ON DELETE CASCADE" y UPDATE también a veces

--* TABLA CUSTOMER
INSERT INTO customer 
VALUES
    (customer_id, store_id, first_name, last_name, email, address_id, activebool, create_date, last_update, active);

UPDATE customer
SET 
    customer_id = valor_customer_id,
    store_id = valor_store_id,
    first_name = 
--* Para eliminar un customer no hay problema
ALTER TABLE payment DROP CONSTRAINT payment_customer_id_fkey;
ALTER TABLE payment ADD CONSTRAINT payment_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE;
ALTER TABLE rental DROP CONSTRAINT rental_customer_id_fkey;
ALTER TABLE rental ADD CONSTRAINT rental_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE;

--* Para eliminar staff si hay problemas.... 
BEGIN TRANSACTION;
ALTER TABLE payment DROP CONSTRAINT payment_staff_id_fkey;
ALTER TABLE payment ADD CONSTRAINT payment_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE rental DROP CONSTRAINT rental_staff_id_key;
ALTER TABLE rental ADD CONSTRAINT rental_staff_id_key FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE store DROP CONSTRAINT store_manager_staff_id_fkey;
ALTER TABLE store ADD CONSTRAINT store_manager_staff_id_fkey FOREIGN KEY (store_id) REFERENCES store(store_id) ON DELETE CASCADE;
--! Lanza este error
--! ERROR:  null value in column "rental_id" of relation "payment" violates not-null constraint
--! DETAIL:  Failing row contains (18173, 516, 2, null, 4.99, 2007-02-14 21:23:39.996577).
--! CONTEXT:  SQL statement "UPDATE ONLY "public"."payment" SET "rental_id" = NULL WHERE $1 OPERATOR(pg_catalog.=) "rental_id""
--! SQL state: 23502

--* Para eliminar un actor no hay problema
ALTER TABLE film_actor DROP CONSTRAINT film_actor_actor_id_fkey;
ALTER TABLE film_actor ADD CONSTRAINT film_actor_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES actor(actor_id) ON DELETE CASCADE;



-- • Listar todas las “rental” con los datos del “customer” dado un año y mes.
--* Retorna le fecha, nombre, apellido, email y pelicula 
SELECT to_char(rental_date, 'YYYY-MM'), customer.first_name, customer.last_name, email, title
    FROM rental
        INNER JOIN customer ON rental.customer_id = customer.customer_id 
        INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
        INNER JOIN film ON inventory.film_id = film.film_id
    WHERE customer.first_name = 'Mary' AND customer.last_name = 'Smith' AND to_char(rental_date, 'YYYY-MM') = '2005-06';

-- • Listar Número, Fecha (payment_date) y Total (amount) de todas las “payment”.
--* Decidí agruparlo por día, pero para agrupar por año o mes es trivial. Solo es neesario modificar 'YYYY-MM' ó 'YYYY' según sea el caso.
SELECT to_char(payment_date, 'YYYY-MM-DD') AS "Fecha", count(*) AS "Cantidad", sum(amount) AS "Subtotal"  
FROM payment 
GROUP BY "Fecha"
ORDER BY "Fecha";


-- • Listar todas las “film” del año 2006 que contengan un (rental_rate) mayor a 4.0.
SELECT title, release_year, rental_rate FROM film WHERE release_year = 2006 AND rental_rate > 4.0;


-- 5. Realiza un Diccionario de datos que contenga el nombre de las tablas y columnas, si
-- éstas pueden ser nulas, y su tipo de dato correspondiente.
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