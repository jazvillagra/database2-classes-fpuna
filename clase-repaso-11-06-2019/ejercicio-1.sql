-- author: jvillagra
-- 1- Crear en la BD el objeto T_SESION con los siguientes elementos
-- FECHORA_INI DATE
-- FECHORA_FIN DATE
-- el metodo VALIDAR_HORARIO que recibe como parametro el ID de Tratamiento. El metodo valida:
--   a) que la fecha_fin del tratamiento no este aun asignada
--   b) que el atributo fechora_ini sea igual o mayor a la fecha de inicio del tratamiento
--   c) que el atributo hora de inicio corresponda al horario del turno asignado al tratamiento
--   d) que fechora_fin sea mayor y corresponda al mismo dia que fechora_ini.
-- Si estas condiciones se cumplen, retorna true. Caso contrario, retorna false
create or replace type T_SESION as object(
	fechora_ini DATE,
	fechora_fin DATE,
	MEMBER FUNCTION validar_horario(id_tratamiento NUMBER) RETURN BOOLEAN
);

create or replace type body T_SESION IS
	MEMBER FUNCTION validar_horario (id_tratamiento NUMBER) RETURN BOOLEAN
	IS
		-- boolean a retornar
		b BOOLEAN := FALSE;
		-- variable para almacenar dato fecha_ini de tabla tratamiento
		fecha_ini_tratamiento DATE;
		-- variable para almacenar diferencias entre fechas y horas
		diff_fechas NUMBER;
		-- variable para almacenar dato fecha_fin de tabla tratamiento
		fecha_fin_tratamiento DATE;
		-- variable para almacenar dato hora_inicio de tabla horario
		horario VARCHAR2(5);
	BEGIN
		-- insertar datos de union de tablas tratamiento y horario
		SELECT
			t.fecha_inicio, t.fecha_fin, h.hora_inicio
		INTO
			fecha_ini_tratamiento, fecha_fin_tratamiento, horario
		FROM
			tratamiento t
		JOIN
			horario h
		ON 
			t.nro_turno = h.nro_turno
		WHERE
			t.id_tratamiento = id_tratamiento;
		-- verifica que fecha_fin de tratamiento no este asignada
		IF fecha_fin_tratamiento is NULL THEN
			-- guarda diferencia entre fecha de inicio recibida como parametro y fecha_ini de tabla de tratamiento
			diff_fechas := fechora_ini - fecha_ini_tratamiento;
			-- verifica que la fecha de inicio recibida es mayor o igual a la fecha_ini de tabla de tratamiento
			IF diff_fechas >= 0 THEN
				-- verifica que el horario de inicio en tabla horario sea igual a la hora de la fecha_ini en tabla de tratamiento
				IF TO_CHAR(fecha_ini_tratamiento, 'HH 24:MI') = horario THEN
					-- guarda diferencia entre fecha de inicio y fecha de fin recibidos como parametros
					diff_fechas := fechora_fin - fechora_ini;
					-- verifica que la diferencia entre ambos sea de menos de 1 dia;
					IF diff_fechas > 0 AND diff_fechas < 1 THEN
						b := TRUE;
					ELSE
						b:= FALSE;
					END IF;
				ELSE
					b := FALSE;
				END IF;
			ELSE
				b:= FALSE;
			END IF;
		ELSE
			b := FALSE;
		END IF;
		return b;
	END;
END;

-- 2- Cree el tipo TAB_SESION como un VARRAY de 20 ocurrencias del tipo T_SESION
create or replace type TAB_SESION as VARRAY(20) of T_SESION;

-- 3- Incorporar a la tabla tratamiento, el atributo SESIONES del tipo TAB_SESION
alter table tratamiento add sesiones tab_sesion;
