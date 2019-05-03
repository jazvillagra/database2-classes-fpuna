--ejemplo 1
CREATE OR REPLACE TRIGGER actualizar_stock
	AFTER INSERT ON b_detalle_ventas
	FOR EACH ROW
		WHEN (new.cantidad>0)
	DECLARE
	BEGIN
		UPDATE b_articulos
		SET stock_actual=stock_actual - :new.cantidad
		WHERE id=: new.id_articulo;
	END;

--ejemplo 2
-- Creación de 2 tablas: VENDEDOR y CONTROL_ABM
CREATE TABLE vendedor
	(id number, nombre varchar2(60));
CREATE TABLE control_abm
	(fecha date, tipo varchar2(1), usuario varchar2(60));
CREATE OR REPLACE TRIGGER t_control_dml
	AFTER INSER OR UPDATE OR DELETE ON vendedor
	DECLARE
		tipo CHAR(1);
	BEGIN
		IF INSERTING THEN
			tipo:='I';
		ELSEIF UPDATING THEN
			tipo:='U';
		ELSEIF DELETING THEN
			tipo:='D';
		END IF;
		INSERT INTO control_abm
			VALUES(SYSDATE, tipo, user);
	END t_control_abm;
/

-- ejemplo 3

CREATE OR REPLACE TRIGGER actualizar_stock_upd
	AFTER UPDATE ON b_detalle_ventas
	FOR EACH ROW
		WHEN (new.cantidad>0)
	DECLARE
	BEGIN
		UPDATE b_articulos
		SET stock_actual= stock_actual + :old.cantidad
		WHERE id=: old.id_articulo;
		UPDATE b_articulos
		SET stock_actual= stock_actual - :new.cantidad
		WHERE id=: new.id_articulo;
	END;

--ejemplo 4

CREATE OR REPLACE TRIGGER actualizar_stock_del
	AFTER DELETE ON b_detalle_ventas
	FOR EACH ROW
		WHEN (new.cantidad>0)
	DECLARE
	BEGIN
		UPDATE b_articulos
		SET stock_actual= stock_actual + :old.cantidad
		WHERE id=: old.id_articulo;
	END;

-- ejercicio 1.2


--CREATE OR REPLACE TRIGGER t_control_stock_actual
--      BEFORE UPDATE OR INSERT ON stock_actual



