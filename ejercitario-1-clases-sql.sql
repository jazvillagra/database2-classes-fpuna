-- listar id_venta, numero_cuota, monto_cuota que vencieron en el primer semestre del año 2011.
-- ordenar registros por campos id_venta, numero_cuota en forma descendente
-- formatear el campo monto_cuota para que se muestre con separador de miles
select id_venta, numero_cuota, to_char(monto_cuota, '9G999G999', 'NLS_NUMERIC_CHARACTERS="."') as monto_cuota
from b_plan_pago
where vencimiento between TO_DATE('01-JAN-11','DD-MON-YY') and TO_DATE('30-JUN-11','DD-MON-YY')
order by id_venta, numero_cuota DESC;
-- recuperar datos de personas fisicas que sean clientes y cuyas direcciones de correo correspondan al proveedor hotmail o gmail
select * from b_personas
where tipo_persona='F'
    and (correo_electronico like '%@hotmail%' or correo_electronico like '%@gmail%');
-- liste precio de los articulos existentes, impidiendo que se vean los registros repetidos y ordene de mayor a menor
select DISTINCT precio from b_articulos;
-- calcular monto correspondiente a comisiones por vender x unidades de cada articulo. El valor de x debe ser ingresado por teclado.
-- Mostrar id, nombre, unidad de medida, precio, % comision, sub-total (cantidad x precio) y comision (subtotal * % comision)
select a.id, a.nombre, a.unidad_medida, a.precio, a.porc_comision, (dv.cantidad * a.precio) as sub_total, ((dv.cantidad * a.precio) * a.porc_comision) as comision
from b_articulos a
    join b_detalle_ventas dv
        on a.id = dv.id_articulo;
-- mostrar el codigo del area y el codigo del puesto que ocupan actualmente los empleados cuyas cedulas son 1607843, 2204219, 3008180
-- los cargos actuales son aquellos que no tienen un valor alguno en el campo fecha_fin
select id as cod_puesto_actual, id_area
from b_posicion_actual
where cedula in ('1607843', '2204219', '3008180') and fecha_fin is null;
