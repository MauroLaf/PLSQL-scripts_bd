--Llamada de forma recursiva
--Es una característica que hay que usar con cuidado ya que puede afectar la eficiencia de nuestros algoritmos. Por defecto MySQL tiene desactiva la posibilidad de hacer llamadas recursivas.

--Para activar la posibilidad de hacer llamadas recursivas debemos modificar la variable del sistema 'max_sp_recursion_depth' indicando la cantidad de llamadas recursivas posibles:

SET @@session.max_sp_recursion_depth = 10; 
--Implementar un procedimiento almacenado que calcule el factorial de un número haciendo llamadas recursivas en su algoritmo:

SET @@session.max_sp_recursion_depth = 10; 

drop procedure if exists pa_factorial;

delimiter //
create procedure pa_factorial(
  in valor int,
  out resu int)
begin
  if valor=0 then
    set resu=1;
  else
    call pa_factorial(valor-1,resu);
    set resu=valor*resu;
  end if;
end //  
delimiter ;

call pa_factorial(5,@resu);
select @resu;

call pa_factorial(valor-1,resu);

--Es importante notar que hemos activado las llamadas recursivas hasta 10 para la sesión activa:

SET @@session.max_sp_recursion_depth = 10; 
