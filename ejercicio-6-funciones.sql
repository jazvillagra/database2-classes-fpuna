
create or replace function f_fibonacci
    (pos in number)
    return number
is
begin
    if(pos < 2) then
        return 1;
    end if;
    return (f_fibonacci(pos - 2)+f_fibonacci(pos-1));
end;
/

declare
    resultado number :=0;
begin
    resultado := f_fibonacci(6);
    dbms_output.put_line(resultado);
end;
/
