-- • Aquellas usadas para insertar, modificar y eliminar un Customer, Staff y Actor.
BEGIN TRANSACTION;
DELETE FROM customer where store_id=1;

-- • Listar todas las “rental” con los datos del “customer” dado un año y mes.
-- • Listar Número, Fecha (payment_date) y Total (amount) de todas las “payment”.
-- • Listar todas las “film” del año 2006 que contengan un (rental_rate) mayor a 4.0.