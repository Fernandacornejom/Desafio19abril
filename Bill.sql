--Para cumplir los siguientes requerimientos, debes recordar tener desactivado el autocommit en tu base de datos.
--1. Cargar el respaldo de la base de datos unidad2.sql. 
--psql -U fernandacornejo bill < copiaunidad2.sql

--2. El cliente usuario01 ha realizado la siguiente compra:
--● producto: producto9.
--● cantidad: 5.
--● fecha: fecha del sistema.
BEGIN; 
INSERT INTO compra (cliente_id) VALUES (1);
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (9, 1, 5); 
UPDATE producto SET stock = stock - 5 WHERE id = 9; 
COMMIT;
--Mediante el uso de transacciones, realiza las consultas correspondientes para este requerimiento y luego consulta la tabla producto para validar si fue efectivamente descontado en el stock.
SELECT * FROM producto WHERE id = 9;
-- id | descripcion | stock | precio 
----+-------------+-------+--------
--  9 | producto9   |     3 |   4219
--(1 row)

SELECT * FROM detalle_compra WHERE compra_id = 1;
-- id | producto_id | compra_id | cantidad 
----+-------------+-----------+----------
-- 21 |          17 |         1 |        7
-- 22 |          18 |         1 |        9
-- 61 |           9 |         1 |        5
--(3 rows)

--3. El cliente usuario02 ha realizado la siguiente compra:
--● producto: producto1, producto 2, producto 8.
--● cantidad: 3 de cada producto.
--● fecha: fecha del sistema.
BEGIN; 
INSERT INTO compra (cliente_id) VALUES (2);
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (1, 1, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 1;
COMMIT;

BEGIN;
INSERT INTO compra (cliente_id) VALUES (2);
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (2, 1, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 2;
COMMIT;

BEGIN;
INSERT INTO compra (cliente_id) VALUES (2);
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (8, 1, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 8;
COMMIT;

--Mediante el uso de transacciones, realiza las consultas correspondientes para este requerimiento y luego consulta la tabla producto para validar que si alguno de ellos se queda sin stock, no se realice la compra. 
SELECT * FROM producto WHERE id = 1;
SELECT * FROM producto WHERE id = 2;
SELECT * FROM producto WHERE id = 8;

-- id | descripcion | stock | precio 
----+-------------+-------+--------
--  1 | producto1   |     3 |   9107
--(1 row)

-- id | descripcion | stock | precio 
----+-------------+-------+--------
--  2 | producto2   |     2 |   1760
--(1 row)

-- id | descripcion | stock | precio 
----+-------------+-------+--------
--  8 | producto8   |     0 |   8923
--(1 row)

SELECT * FROM detalle_compra WHERE producto_id = 1;
SELECT * FROM detalle_compra WHERE producto_id = 2;
SELECT * FROM detalle_compra WHERE producto_id = 8;
-- id | producto_id | compra_id | cantidad 
----+-------------+-----------+----------
-- 20 |           1 |         6 |       10
-- 40 |           1 |        32 |        3
-- 84 |           1 |         1 |        3
--(3 rows)

-- id | producto_id | compra_id | cantidad 
----+-------------+-----------+----------
--  1 |           2 |         2 |        9
--  6 |           2 |        14 |        6
-- 10 |           2 |         3 |        5
-- 31 |           2 |        18 |       10
-- 41 |           2 |        32 |        3
-- 85 |           2 |         1 |        3
--(6 rows)

-- id | producto_id | compra_id | cantidad 
----+-------------+-----------+----------
-- 42 |           8 |        32 |        3
--(1 rows)


--4. Realizar las siguientes consultas:
--a. Deshabilitar el AUTOCOMMIT .
--\set AUTOCOMMIT off

--b. Insertar un nuevo cliente.
SAVEPOINT sp1;
BEGIN;
INSERT INTO cliente (id, nombre, email) VALUES (11, 'usuario11', 'fernandacornejom@gmail.com');
SAVEPOINT
COMMIT;

--c. Confirmar que fue agregado en la tabla cliente.
SELECT * FROM cliente;

-- id |   nombre   |            email            
----+------------+-----------------------------
--  2 | usuario02  | usuario02@yahoo.com
--  3 | usuario03  | usuario03@hotmail.com
--  4 | usuario04  | usuario04@hotmail.com
--  5 | usuario05  | usuario05@yahoo.com
--  6 | usuario06  | usuario06@hotmail.com
--  7 | usuario07  | usuario07@yahoo.com
--  8 | usuario08  | usuario08@yahoo.com
--  9 | usuario09  | usuario09@hotmail.com
-- 10 | usuario010 | usuario010@hotmail.com
--  1 | usuario01  | usuario01@gmail.com
-- 11 | usuario11  | fernandacornejom@gmail.com
--(11 rows)

--d. Realizar un ROLLBACK.
ROLLBACK TO sp1;

--e. Confirmar que se restauró la información, sin considerar la inserción del punto b.
SELECT * FROM cliente;
-- id |   nombre   |         email          
------+------------+------------------------
--  2 | usuario02  | usuario02@yahoo.com
--  3 | usuario03  | usuario03@hotmail.com
--  4 | usuario04  | usuario04@hotmail.com
--  5 | usuario05  | usuario05@yahoo.com
--  6 | usuario06  | usuario06@hotmail.com
--  7 | usuario07  | usuario07@yahoo.com
--  8 | usuario08  | usuario08@yahoo.com
--  9 | usuario09  | usuario09@hotmail.com
-- 10 | usuario010 | usuario010@hotmail.com
--  1 | usuario01  | usuario01@gmail.com
--(10 rows)

--f. Habilitar de nuevo el AUTOCOMMIT
--\set AUTOCOMMIT on