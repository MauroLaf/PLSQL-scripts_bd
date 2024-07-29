--Necesitamos almacenar en una tabla llamada "usuarios" los datos de los usuarios de un sitio web. Cada vez que el usuario cambia su clave se debe almacenar en otra tabla llamada "clavesanteriores" el dato de la clave vieja.
--Borramos las dos tablas si existen:

drop table if exists usuarios;
drop table if exists clavesanteriores;

create table usuarios(
 nombre varchar(30),
 clave varchar(30),
 primary key (nombre)
);

--Creamos ambas tablas con las siguientes estructuras:
create table clavesanteriores(
 numero int auto_increment,
 nombre varchar(30),
 clave varchar(30),
 primary key (numero)
);

--Si existe el trigger 'before_usuarios_update' procedemos a borrarlo:
drop trigger if exists before_usuarios_update;

--Creamos el trigger 'before_usuarios_update':
delimiter //
create trigger before_usuarios_update
  before update
  on usuarios
  for each row
begin
  insert into clavesanteriores(nombre, clave) values (old.nombre, old.clave); 
end //
delimiter ;

--Este trigger se dispara cada vez que ejecutemos el comando SQL 'update' con la tabla 'usuarios':
before update
on usuarios

--Mediante las palabras claves 'old' y 'new' podemos acceder a los valores actuales de la fila y los valores que se actualizarán en la tabla 'usuarios':

old.nombre y old.clave
new.nombre y new.clave

--Ejecutemos ahora un insert en la tabla 'usuarios':
insert into usuarios(nombre,clave) values ('marcos','123abc');
--Ahora procedamos a modificar la clave del usuario mediante el comando 'update':
update usuarios set clave='999zzz' where nombre='marcos';
--Cuando se ejecuta el 'update' además de actualizarse la clave del usuario en la tabla 'usuarios' se dispara el trigger donde se efectúa la inserción de una fila en la tabla 'clavesanteriores'.
--Listemos la tabla 'clavesanteriores'

select * from clavesanteriores;

--Si volvemos a cambiar la clave del usuario 'marcos' y listamos nuevamente las claves anteriores nos aparecerá las 2 actualizaciones:

update usuarios set clave='123456' where nombre='marcos';
