declare

    cursos c_emp is
        select p.cedula, c.asignacion,
            (select sum(d.precio*d.cantidad * (a.por_com/100))
                from b_ventas_detalles, b_ventas, b_articulos
                where v.cedula_empleados = p.cedula) comision
        from b_posicion_actual p
            join b_categorias_salariales c
            on c.cod_categoria = p.cod_categoria
            join b_articulos
            on 
        where p.fecha_fin is null
            and c.fecha_fin is null;

    v_id number;
begin
    select max(id) into v_id
    from b_liquidacion;
    v_id := nvl(v_id,0) + 1;
    insert into b_liquidacion values(......);
    for reg in c_emp loop
        v_ips:= reg.asignacion * 0.095;
        insert into b_planilla values(v.id, reg.cedula, reg.asignacion, v_ips, reg.comision, reg.asignacion - (v_ips + reg.comision));
    end loop;
    commit;
end
