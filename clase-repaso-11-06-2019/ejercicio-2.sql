CREATE OR REPLACE PACKAGE pkg_tratamiento IS
	FUNCTION f_calcular_fin (f_fecha_inicio DATE, f_c_sesiones NUMBER) RETURN DATE;
	PROCEDURE p_completar_sesion (id_tratamiento NUMBER, fechora_ini DATE, fechora_fin DATE);
END;
/

CREATE OR REPLACE PACKAGE BODY pkg_tratamiento IS
	FUNCTION f_calcular_fin (f_fecha_inicio DATE, f_c_sesiones NUMBER) IS
		f_inicio DATE;
		f_fin DATE;
		fecha_act DATE;
		sesion_act NUMBER;
		es_feriado NUMBER;
		dia_semana VARCHAR2(30);
	BEGIN
		sesion_act := 1;
		WHILE sesion_act <= f_c_sesiones
		LOOP
			fecha_act := fecha_act + 1;
			dia_semana := TO_CHAR(fecha_act, 'd');
			IF dia_semana >=2 AND dia_semana <=6 THEN
				SELECT COUNT(dia_feriado)
					INTO es_feriado
					FROM feriado
					WHERE dia_feriado = fecha_act;
				IF es_feriado = 0 THEN
					sesion_act := sesion_act + 1;
				END IF;
			END IF;
		END LOOP;
		RETURN fecha_act;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20001, 'An error was encountered - '||SQLCODE||' ERROR - '||SQLERRM);
	END;
	PROCEDURE p_completar_sesion(id_tratamiento NUMBER, fechora_ini DATE, fechora_fin DATE) IS
		cant_sesiones NUMBER;
		ult_sesion NUMBER;
		list_sesiones TAB_SESION;
		var_sesion T_SESION;
	BEGIN
		SELECT t.sesiones, t.nro_sesiones
			INTO list_sesiones, cant_sesiones
			FROM tratamiento t
			WHERE t.id_tratamiento = id_tratamiento;
			
		ult_sesion := NVL(list_sesiones.LAST, 0);
		
		IF ult_sesion = cant_sesiones THEN
			raise_application_error(-20031, 'No puede haber mas sesiones que la cant. indicada');
		END IF;
		var_sesion := t_sesion(fechora_ini, fechora_fin);
		IF var_sesion.validar_horario(id_tratamiento) THEN
			
			ult_sesion := ult_sesion + 1;
			
			IF ult_sesion = 1 THEN
				list_sesiones := tab_sesion();
			END IF;
			
			list_sesiones.EXTEND;
			list_sesiones(ult_sesion) := var_sesion;
			
			UPDATE tratamiento t
			SET t.sesiones = v_sesiones
			WHERE t.id_tratamiento = id_tratamiento;
			
			COMMIT;
	END;
END;
