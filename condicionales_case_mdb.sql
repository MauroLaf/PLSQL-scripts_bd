--CONDICIONAL CASE 
--Primer variante
drop procedure if exists pa_tipo_medalla;
delimiter //
create procedure pa_tipo_medalla(
  in puesto int,
  out tipo varchar(20))
begin
  case puesto
    when 1 then
      set tipo='oro';
    when 2 then
      set tipo='plata';
    when 3 then
      set tipo='bronce';
  end case;          
end //
delimiter ;

call pa_tipo_medalla(1,@ti);

select @ti;

call pa_tipo_medalla(2,@ti);

select @ti;
--Como podemos observar en la estructura 'case' simple se compara el contenido del parámetro 'puesto' con los valores 1,2 y 3.
--La segunda variante de la estructura 'case' permite disponer condiciones para cada when:
drop procedure if exists pa_cantidad_digitos;
delimiter //
create procedure pa_cantidad_digitos(
  in numero int,
  out cantidad int)
begin
  case 
    when numero<10 then
      set cantidad=1;
    when numero>=10 and numero<100 then
      set cantidad=2;
    when numero>=100 and numero<1000 then
      set cantidad=3;      
  end case;
end //
delimiter ;

call pa_cantidad_digitos(5, @cant);
select @cant;

call pa_cantidad_digitos(50, @cant);
select @cant;

call pa_cantidad_digitos(500, @cant);
select @cant;

--otro ejercicio
drop table if exists clientes;
 drop table if exists provincias;

 create table clientes (
  codigo int unsigned auto_increment,
  nombre varchar(30) not null,
  domicilio varchar(30),
  ciudad varchar(20),
  codigoprovincia tinyint unsigned,
  telefono varchar(11),
  primary key(codigo)
 );

 create table provincias(
  codigo tinyint unsigned auto_increment,
  nombre varchar(20),
  primary key (codigo)
 );

 insert into provincias (nombre) values('Cordoba');
 insert into provincias (nombre) values('Santa Fe');
 insert into provincias (nombre) values('Corrientes');
 insert into provincias (nombre) values('Misiones');
 insert into provincias (nombre) values('Salta');
 insert into provincias (nombre) values('Buenos Aires');
 insert into provincias (nombre) values('Neuquen');

 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Lopez Marcos', 'Colon 111', 'Córdoba',1,'null');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Perez Ana', 'San Martin 222', 'Cruz del Eje',1,'4578585');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Garcia Juan', 'Rivadavia 333', 'Villa Maria',1,'4578445');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Perez Luis', 'Sarmiento 444', 'Rosario',2,null);
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Pereyra Lucas', 'San Martin 555', 'Cruz del Eje',1,'4253685');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Gomez Ines', 'San Martin 666', 'Santa Fe',2,'0345252525');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Torres Fabiola', 'Alem 777', 'Villa del Rosario',1,'4554455');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Lopez Carlos', 'Irigoyen 888', 'Cruz del Eje',1,null);
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Ramos Betina', 'San Martin 999', 'Cordoba',1,'4223366');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Lopez Lucas', 'San Martin 1010', 'Posadas',4,'0457858745');

--Crearemos un procedimiento almacenado que le enviemos como parámetro los nombres de dos provincias y genere como resultado el nombre de la provincia que tiene más clientes y su cantidad, en caso de tener la misma cantidad mostrar las dos provincias y la cantidad:
drop procedure if exists pa_mas_clientes_provincias;

delimiter //
 create procedure pa_mas_clientes_provincias(
   in provincia1 varchar(20),
   in provincia2 varchar(20))
 begin
   declare canti1 int;
   declare canti2 int;
   select count(*) into canti1 from clientes as cli
     join provincias as pro 
     on pro.codigo=cli.codigoprovincia
     where pro.nombre=provincia1;
   select count(*) into canti2 from clientes as cli
     join provincias as pro 
     on pro.codigo=cli.codigoprovincia
     where pro.nombre=provincia2;     
   case  
     when canti1>canti2 then
       select provincia1,canti1;
     when canti2>canti1 then
       select provincia2,canti2;
     else
       select provincia1,provincia2,canti1;
   end case;  
 end //
 delimiter ;

--Dentro del procedimiento almacenado definimos dos variables locales llamadas 'canti1' y 'canti2' que almacenan en forma temporal la cantidad de clientes que hay en cada una de las dos provincias consultadas.

--Seguidamente mediante una estructura condicional case para verificar cual de las dos variables almacena un valor mayor o si son iguales:

 case  
     when canti1>canti2 then
       select provincia1,canti1;
     when canti2>canti1 then
       select provincia2,canti2;
     else
       select provincia1,provincia2,canti1;
   end case;  

--Llamamos luego al procedimiento almacenado pasando dos provincias:
 call pa_mas_clientes_provincias('Cordoba','Santa Fe');

