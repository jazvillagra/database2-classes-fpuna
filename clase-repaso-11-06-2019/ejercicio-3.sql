CREATE OR REPLACE TRIGGER modificar_tratamiento
BEFORE INSERT OR UPDATE
ON tratamiento FOR EACH ROW
DECLARE
	fecha_ini_tratamiento DATE;
	fecha_fin_tratamiento DATE;
	fechafin DATE;
	hora_turno NUMBER;
	cant_sesiones NUMBER;
BEGIN
	SELECT
		t.fecha_inicio,
		t.fecha_fin,
		t.nro_sesiones,
		h.hora_inicio
	INTO
		fecha_ini_tratamiento,
		fecha_fin_tratamiento,
		cant_sesiones,
		hora_turno
	FROM tratamiento t
	JOIN horario h
		ON t.nro_turno = h.nro_turno
	WHERE t.id_tratamiento = :new.id_tratamiento 

	fechafin := pkg_tratamiento.f_calcular_fin(fecha_ini_tratamiento, cant_sesiones);
	
	IF fecha_fin_tratamiento IS NOT NULL THEN
		SELECT count(t.id_tratamiento) INTO disp_paciente
		FROM tratamiento t
		JOIN horario h
		ON t.nro_turno = h.nro_turno
		WHERE t.cedula = :new.cedula
			AND t.nro_turno = :new.nro_turno;
		
		SELECT count(t.id_tratamiento) INTO disp_fisioterapeuta
		FROM tratamiento t
		JOIN horario h
		ON t.nro_turno = h.nro_turno
		WHERE t.cod_fisioterapeuta = :new.cod_fisioterapeuta
			AND t.nro_turno = :new.nro_turno;

		IF disp_pacientee = 0 AND disp_fisioterapeuta = 0 THEN
		END IF;
	END IF;
END
