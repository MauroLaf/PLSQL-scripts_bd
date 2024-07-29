DROP DATABASE IF EXISTS tutorial;
create database tutorial;
use tutorial;
drop table if exists libros;

create table libros(
  codigo int auto_increment,
  titulo varchar(40),
  autor varchar(30),
  editorial varchar(20),
  precio decimal(5,2),
  stock int,
  primary key(codigo)
);

 insert into libros(titulo,autor,editorial,precio,stock) 
  values('Alicia en el pais de las maravillas','Lewis Carroll','Emece',20.00, 9);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Alicia en el pais de las maravillas','Lewis Carroll','Plaza',35.00, 50);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Aprenda PHP','Mario Molina','Siglo XXI',40.00, 3);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('El aleph','Borges','Emece',10.00, 18);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Ilusiones','Richard Bach','Planeta',15.00, 22);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Java en 10 minutos','Mario Molina','Siglo XXI',50.00, 7);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Martin Fierro','Jose Hernandez','Planeta',20.00, 3);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Martin Fierro','Jose Hernandez','Emece',30.00, 70);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Uno','Richard Bach','Planeta',10.00, 120);

 drop procedure if exists pa_libros_limite_stock;

 delimiter //
 create procedure pa_libros_limite_stock()
 begin
   select * from libros
   where stock<=10;
 end //
 delimiter ;
 

------------------------Modificar el procedimiento para que tenga un valor predeterminado con MariaDB-------------------------------------
-- Cambiar el delimitador para definir el procedimiento
DELIMITER //

-- Crear o reemplazar el procedimiento almacenado
CREATE OR REPLACE PROCEDURE pa_libros_limite_stock_elegido(IN p_max_stock INT)
BEGIN
    -- Mostrar el valor del parámetro
    SELECT CONCAT('Mostrando libros con stock menor o igual a: ', p_max_stock) AS mensaje;

    -- Mostrar los detalles de los libros
    SELECT codigo, titulo, autor, editorial, FORMAT(precio, 2) AS precio, stock
    FROM libros
    WHERE stock <= p_max_stock
    ORDER BY stock;
END //

-- Restaurar el delimitador
DELIMITER ;

------------------------Modificar el procedimiento para que cuente los libros que cumplen la cond. y guardar en variable luego mostrarlos-------------------------------------
-- Cambiar el delimitador para definir el procedimiento
DELIMITER //

-- Crear o reemplazar el procedimiento almacenado
CREATE OR REPLACE PROCEDURE pa_libros_limite_stock_elegido(
    IN p_max_stock INT,
    OUT p_libros INT
)
BEGIN
    -- Contar el número de libros con stock menor o igual al valor dado
    SELECT COUNT(*) INTO p_libros
    FROM libros
    WHERE stock <= p_max_stock;
    
    -- Mostrar los detalles de los libros con stock menor o igual al valor dado
    SELECT codigo, titulo, autor, editorial, FORMAT(precio, 2) AS precio, stock
    FROM libros
    WHERE stock <= p_max_stock;
END //

-- Restaurar el delimitador
DELIMITER ;
-- Declarar una variable de usuario para el parámetro de salida
SET @p_libros = 0;

-- Llamar al procedimiento almacenado
CALL pa_libros_limite_stock_elegido(10, @p_libros);

-- Mostrar el valor del parámetro de salida
SELECT @p_libros;

