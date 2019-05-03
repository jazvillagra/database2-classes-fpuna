CREATE PROCEDURE P_ESTADISTICA_ARTICULOS IS
    CURSOR c_art IS
        (SELECT a.id, a.nombre, compras.monto_compras, ventas.monto_ventas
        FROM b_articulos a
        LEFT OUTER JOIN
        (SELECT d.id_articulo, SUM(d.cantidad*d.precio_compra) monto_compras
        FROM b_detalle_compras d
        JOIN b_compras c
            ON c.id = d.id_compra
        WHERE EXTRACT(year from c.fecha) = 2011
        GROUP BY d.id_articulo) compras
        LEFT OUTER JOIN
        (SELECT d.id_articulo, SUM(d.cantidad*d.precio) monto_ventas
        FROM b_detalle_ventas d
        JOIN b_ventas v
            ON v.id = d.id_venta
        WHERE EXTRACT(year from v.fecha) = 2011
        GROUP BY d.id_articulo) ventas
        ON ventas.id_articulo = a.id);
    TYPE r_articulos IS RECORD
        (ID_ARTICULO NUMBER(8),
	    NOMBRE VARCHAR2(80),
        MONTO_COMPRAS NUMBER(12),
        MONTO_VENTAS NUMBER(12));
    TYPE t_art IS TABLE OF r_art
        INDEX BY BINARY_INTEGER;
    v_art t_art;
    ind NUMBER;
BEGIN
    FOR reg IN c_art LOOP
        v_art(reg.id).id_articulo:= reg.id;
        v_art(reg.id).nombre := reg.nombre;
        v_art(reg.id).monto_compras := reg.monto_compras;
        v_art(reg.id).monto_ventas := reg.monto_ventas;
    END LOOP;
    ind := v_art.FIRST;
    WHILE ind <= v_art.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Art ' ||
                            to_char(v_art(ind).id_articulo, '000000') ||
                            '-' ||
                            v_art(ind).nombre);
        ind := v_art.NEXT(ind);
    END LOOP;
END;
