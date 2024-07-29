--BUCLE WHILE

drop procedure if exists pa_generar_dos_aleatorios;

delimiter //
create procedure pa_generar_dos_aleatorios(
  out valor1 int,
  out valor2 int)
begin
  set valor1=0;
  set valor2=0;
  while valor1=valor2 do
    set valor1=rand()*10;
    set valor2=rand()*10;
  end while;
end //
delimiter ;

call pa_generar_dos_aleatorios(@v1,@v2);

select @v1,@v2;   

--El procedimiento almacenado 'pa_generar_dos_aleatorios' recibe dos parámetros de salida que debemos inicializarlos.

--Previo al while cargamos el valor 0 a cada parámetro:

  set valor1=0;
  set valor2=0;

  La primera vez que se ejecuta la condición del while se verifica verdadera ya que ambos parámetros almacenan el cero.

--Dentro del while y llamando a la función rand() generamos dos valores aleatorios comprendidos entre 0 y 10:

set valor1=rand()*10;
set valor2=rand()*10;

--En el caso que los dos valores aleatorios generados sean iguales la condición del while seguirá verificándose verdadera y se volverán a generar otros dos valores aleatorios. El while finaliza cuando los dos valores aleatorios son distintos.