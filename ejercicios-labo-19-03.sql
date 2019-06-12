SELECT 'CREATE PUBLIC SYNONYM' || TNAME FROM TAB

-- 21/03
-- LOOPS
DECLARE
	CONT NUMBER;
BEGIN
	CONT := 0;
	LOOP
		CONT := CONT + 1;
		DBMS_OUTPUT.PUT_LINE(CONT);
		IF CONT = 12 THEN
			EXIT;
		END IF;
	END LOOP;
END;

DECLARE
	CONT NUMBER;
BEGIN
	CONT := 0;
	WHILE CONT < 12 LOOP
		CONT := CONT + 1;
		DBMS_OUTPUT.PUT_LINE(CONT);
	END LOOP;
END;

BEGIN
	FOR CONT IN 1..12 LOOP
		DBMS_OUTPUT.PUT_LINE(CONT);
	END LOOP;
END;

--SELECTS WITH EXCEPTIONS
DECLARE
	v_jefe   b_empleados.cedula_jefe%type:=952160;
	v_nom    b_empleados.nombre%type;
	v_ape    b_empleados.apellido%type;
BEGIN
	select nombre, apellido into v_nom, v_ape
	from b_empleadoswhere cedula_jefe = v_jefe;
	dbms_output.put_line(v_nom||', '||v_ape);
EXCEPTION
	when too_many_rows then 
		dbms_output.put_line('muchas lineas')
END;

--EJERCICIO 10
DECLARE
	A integer := &a;
	B integer := &b;
	C integer := &c;
	DISC integer;
	X1 integer;
	X2 integer;
	SQUARE integer;
BEGIN
	SELECT POWER(A,2)
	INTO DISC
	FROM dual;

	CASE 
		WHEN DISC < 0 THEN 
			DBMS_OUTPUT.PUT_LINE('No tiene solucion en el conjunto de los numeros reales');
		WHEN DISC = 0 THEN
			SELECT SQRT(DISC - 4*A*C)
			INTO SQUARE
			FROM dual;

			X1:= (-B+SQUARE)/ (2*A);
			DBMS_OUTPUT.PUT_LINE('El resultado es: '||TO_CHAR(X1));
		WHEN DISC > 0 THEN
			SELECT SQRT(DISC - 4*A*C)
			INTO SQUARE
			FROM dual;

			X1:= (-B+SQUARE)/ (2*A);
			X2:= (-B-SQUARE)/ (2*A);
			DBMS_OUTPUT.PUT_LINE('El resultado 1 es: '||TO_CHAR(X1));

			DBMS_OUTPUT.PUT_LINE('El resultado 2 es: '||TO_CHAR(X2));
	END CASE;
END;