create or replace function f_fibonacci(posicion number)
    return number is
    f_res number;
    first number := 0;
    second number := 1;
    i number;
begin
    for i in 2..posicion
    loop
        f_res := first + second;
        first := second;
        second := f_res;
        dbms_output.put_line(f_res);
    end loop;
    return f_res;
end;

