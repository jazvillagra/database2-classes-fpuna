/* ejemplo de excepciones predefinidas - eliminacion de articulo */
create or replace procedure elim_articulo
    (p_id_articulo in b_articulos.id%TYPE) IS
    v_id b_articulos.id%TYPE;
BEGIN
    /*verifico antes si no tengo registro de ventas */
    BEGIN
        select id_articulo into v_id
        from b_detalle_ventas
        where id_articulo = p.id_articulo
        and ROWNUM = 1;
    EXCEPTION
        when NO_DATA_FOUND then
        -- No existen ventas, por lo tanto puedo borrar --
            delete from b_articulos
            where id = p_id_articulo;
            commit;
    END;
    EXCEPTION
        when OTHERS then
            rollback;
            dbms_output.put_line('Error inesperado');
END elim_articulo;
/

/* Ejemplo de errores no predefinidos */
DECLARE
    e_tiene_hijos   EXCEPTION;
    PRAGMA EXCEPTION_UNIT (e_tiene_hijos, -2292);
BEGIN
    DELETE FROM b_articulos WHERE id = &id;
    COMMIT;
EXCEPTION
    WHEN e_tiene_hijos THEN
        DBMS_OUTPUT.PUT_LINE('No puedo borrar,tiene items que hacen referencia al artículo');
END;
/

CREATE OR REPLACE PROCEDURE p_abm_areas
    (p_id_area number, p_nombre varchar2, p_id_area_sup number, p_operac varchar2) 
   --FUNCION INSERTAR
   IS FUNCTION F_INSERTAR(p_id_area number, p_nombre varchar2, p_id_area_sup number) RETURN BOOLEAN IS
   BEGIN
    INSERT INTO B_AREAS VALUES (p_id_area, p_nombre, SYSDATE, 'S', p_id_area_sup);
    RETURN TRUE;
   EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('CLAVE DUPLICADA');
        RETURN FALSE;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR '||SQLERRM);
        RETURN FALSE;
   END;
   --FUNCION ACTUALIZAR
   FUNCTION F_ACTUALIZAR(p_id_area number, p_nombre varchar2, p_id_area_sup number) RETURN BOOLEAN IS
   BEGIN
    UPDATE B_AREAS(nombre_area, id_area_superior)
    SET (p_nombre, p_id_area_sup)
    WHERE id = p_id_area;
   EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('CLAVE DUPLICADA');
        RETURN FALSE;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('VALOR NO PERMITIDO');
   END;
   FUNCTION F_BORRAR(p_id_area number) RETURN BOOLEAN IS
   BEGIN
   
   END;
BEGIN
    IF p_operac IS NOT IN ('A','B','M') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cod. de operacion no encontrado')
    END IF
    
    IF p_operac = 'A' THEN
        BANDERA := F_INSERTAR(p_id_area number, p_nombre varchar2, p_id_area_sup number);
    ELSE IF p_operac = 'B'
        BANDERA := F_BORRAR (p_id_area number);
    ELSE
        BANDERA := F_ACTUALIZAR(p_id_area number, p_nombre varchar2, p_id_area_sup number);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR');
END
