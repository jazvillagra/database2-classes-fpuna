-- inserte una nueva area denominada auditoria con el id igual al ultimo mas 
-- dependera del id perteneciente a la gerencia administrativa
insert into b_areas(id, nombre_area, fecha_crea, activa, id_area_superior)
values(
    (select max(id)+1 from b_areas),
    'Auditoria',
    to_date(SYSDATE, 'DD/MM/YYYY'),
    'S',
    (select id from b_areas where upper(nombre_area) like '%GERENCIA ADMINISTRATIVA%'));
-- actualizar la fecha de fin de la actual posicion de Ricardo Meza
update b_posicion_actual
set fecha_fin = to_date(SYSDATE, 'DD/MM/YYYY')
where cedula = (select cedula from b_empleados where upper(nombre) like '%RICARDO%' and upper(apellido) like '%MEZA%');
-- inserte una nueva posicion para ricardo meza, con la categoria y area de la senora amanda perez y fecha de inicio a partir de hoy
with empleados_pos as (
    select e.cedula cedula, e.nombre nombre, e.apellido apellido, c.cod_categoria cod_categoria
    from b_posicion_actual c
    join b_empleados e
        on e.cedula = c.cedula;
)
insert into b_posicion_actual(id, cod_categoria, cedula, id_area, fecha_ini)
values(
    (select max(id) from b_posicion_actual),
    (select cod_categoria from b_posicion_actual where cedula = (select cedula from b_empleados where upper(nombre) like '%AMANDA%' and upper(apellido) like '%PER')),
    (select cedula from b_posicion_actual where upper(nombre) like '%RICARDO%' and upper(apellido) like '%MEZA%'),
    (select id_area from empleados_pos where upper(nombre) like '%AMANDA%' and upper(apellido) like '%PER'),
    to_char(SYSDATE, 'DD/MM/YYYY')
);