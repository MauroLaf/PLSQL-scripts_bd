--Un procedimiento almacenado puede llamar a otro procedimiento almacenado. El procedimiento que es invocado por otro debe existir cuando creamos el procedimiento que lo llama. Es decir, si un procedimiento A llama a otro procedimiento B, B debe existir al crear A.

--Creamos un procedimiento almacenado que reciba 2 números enteros y nos retorne el producto de los mismos:

drop procedure if exists pa_multiplicar;
 
delimiter // 
create procedure pa_multiplicar(
  in numero1 int,
  in numero2 int,
  out producto int)
begin
  set producto=numero1*numero2;
end // 
delimiter ;


call pa_multiplicar(20,3,@resu);

select @resu;

--Hasta ahora hemos planteado un procedimiento almacenado y su llamada para ver si su algoritmo genera el resultado deseado.

--Ahora crearemos un segundo procedimiento almacenado que nos retorne el factorial de un número que llamará al procedimiento 'pa_multiplicar':

drop procedure if exists pa_multiplicar;
 
delimiter // 
create procedure pa_multiplicar(
  in numero1 int,
  in numero2 int,
  out producto int)
begin
  set producto=numero1*numero2;
end // 
delimiter ;


drop procedure if exists pa_factorial;

delimiter // 
create procedure pa_factorial(
  in numero int,
  out resultado int)
begin  
  declare num int;
  set resultado=1;
  set num=numero;
  while num>1 do
     call pa_multiplicar(resultado,num,resultado);
     set num=num-1;
  end while;
end //    
delimiter ;

call pa_factorial(5, @resu);
select @resu;

--El procedimiento almacenado 'pa_factorial' en su algoritmo llama al procedimiento 'pa_multiplicar'.