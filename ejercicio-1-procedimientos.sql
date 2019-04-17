create or replace function f_obtener_salario(pcedula number)
  return number is
  v_salario number;
begin
  select c.asignacion into v_salario
  from b_posicion_actual p join b_categorias_salariales c
  on c.cod_categoria = p.cod_categoria
  where
  p.cedula = pcedula
  and p.fecha_fin is null
  and c.fecha_fin is null;
  return v_salario;
exception
  when no_data_found then
    return -1;
end;

select cedula, f_obtener_salario(cedula) salario from b_empleados;
