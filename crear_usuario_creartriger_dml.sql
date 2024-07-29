--CREAMOS BD bd_auditoria y creamos una TABLA auditoria que registrara LOS DML que se hagan desde mi base de datos usuarios que contiene la tabla ventas y libros

-- Crear la base de datos de auditoría y la tabla de auditoría
CREATE DATABASE IF NOT EXISTS bd_auditoria;

USE bd_auditoria;

-- Crear la tabla para registrar auditoría de las operaciones en la tabla ventas
CREATE TABLE IF NOT EXISTS auditoria_ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    operacion VARCHAR(10),      -- Tipo de operación (INSERT, UPDATE, DELETE)
    numero INT,                 -- Número del registro de ventas
    codigolibro INT,            -- Código del libro
    precio FLOAT,               -- Precio del libro
    cantidad INT,               -- Cantidad del libro vendida
    fecha TIMESTAMP DEFAULT NOW() -- Fecha y hora de la operación
);

-- Crear la base de datos original y las tablas
CREATE DATABASE IF NOT EXISTS usuarios;

USE usuarios;

-- Crear la tabla de libros
CREATE TABLE IF NOT EXISTS libros (
    codigo INT AUTO_INCREMENT,  -- Código único para cada libro
    titulo VARCHAR(50),        -- Título del libro
    autor VARCHAR(50),         -- Autor del libro
    editorial VARCHAR(30),     -- Editorial del libro
    precio FLOAT,              -- Precio del libro
    stock INT,                 -- Stock disponible del libro
    PRIMARY KEY (codigo)       -- Establecer la clave primaria
);

-- Crear la tabla de ventas
CREATE TABLE IF NOT EXISTS ventas (
    numero INT AUTO_INCREMENT,  -- Número único para cada venta
    codigolibro INT,            -- Código del libro vendido
    precio FLOAT,               -- Precio del libro en la venta
    cantidad INT,               -- Cantidad de libros vendidos
    PRIMARY KEY (numero)       -- Establecer la clave primaria
);

-- Insertar algunos registros de ejemplo en la tabla libros
INSERT INTO libros (titulo, autor, editorial, precio, stock)
VALUES
('Uno', 'Richard Bach', 'Planeta', 15, 100),
('Ilusiones', 'Richard Bach', 'Planeta', 18, 50),
('El aleph', 'Borges', 'Emece', 25, 200),
('Aprenda PHP', 'Mario Molina', 'Emece', 45, 200);

-- Crear el trigger para `INSERT`
DROP TRIGGER IF EXISTS before_ventas_insert;

DELIMITER //
CREATE TRIGGER before_ventas_insert
BEFORE INSERT ON ventas
FOR EACH ROW
BEGIN
    -- Actualizar stock en la tabla libros al insertar una venta
    UPDATE libros
    SET stock = stock - NEW.cantidad
    WHERE NEW.codigolibro = codigo;

    -- Insertar un registro en la tabla de auditoría para la operación de inserción
    INSERT INTO bd_auditoria.auditoria_ventas (operacion, numero, codigolibro, precio, cantidad, fecha)
    VALUES ('INSERT', NEW.numero, NEW.codigolibro, NEW.precio, NEW.cantidad, NOW());
END;
//
DELIMITER ;

-- Crear el trigger para `UPDATE`
DROP TRIGGER IF EXISTS before_ventas_update;

DELIMITER //
CREATE TRIGGER before_ventas_update
BEFORE UPDATE ON ventas
FOR EACH ROW
BEGIN
    -- Ajustar el stock en la tabla libros
    -- Primero, revertir el stock anterior
    UPDATE libros
    SET stock = stock + OLD.cantidad
    WHERE OLD.codigolibro = codigo;

    -- Luego, ajustar el stock con la nueva cantidad
    UPDATE libros
    SET stock = stock - NEW.cantidad
    WHERE NEW.codigolibro = codigo;

    -- Insertar un registro en la tabla de auditoría para la operación de actualización
    INSERT INTO bd_auditoria.auditoria_ventas (operacion, numero, codigolibro, precio, cantidad, fecha)
    VALUES ('UPDATE', OLD.numero, OLD.codigolibro, OLD.precio, OLD.cantidad, NOW());
END;
//
DELIMITER ;

-- Crear el trigger para `DELETE`
DROP TRIGGER IF EXISTS before_ventas_delete;

DELIMITER //
CREATE TRIGGER before_ventas_delete
BEFORE DELETE ON ventas
FOR EACH ROW
BEGIN
    -- Ajustar el stock en la tabla libros
    UPDATE libros
    SET stock = stock + OLD.cantidad
    WHERE OLD.codigolibro = codigo;

    -- Insertar un registro en la tabla de auditoría para la operación de eliminación
    INSERT INTO bd_auditoria.auditoria_ventas (operacion, numero, codigolibro, precio, cantidad, fecha)
    VALUES ('DELETE', OLD.numero, OLD.codigolibro, OLD.precio, OLD.cantidad, NOW());
END;
//
DELIMITER ;

-- Crear el usuario y otorgar privilegios
CREATE USER 'fulanito'@'localhost' IDENTIFIED BY 'Maurok92';

-- Otorgar privilegios de consulta, inserción, actualización y eliminación en las tablas de ventas y libros
GRANT SELECT, INSERT, UPDATE, DELETE ON usuarios.ventas TO 'fulanito'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON usuarios.libros TO 'fulanito'@'localhost';

-- Aplicar los cambios para que los nuevos privilegios tengan efecto
FLUSH PRIVILEGES;

-- Pruebas (opcional)

-- Insertar un registro en la tabla ventas
USE usuarios;
INSERT INTO ventas (codigolibro, precio, cantidad)
VALUES (1, 15, 2);

-- Verificar el registro en la tabla de auditoría
USE bd_auditoria;
SELECT * FROM auditoria_ventas;

-- Realizar una actualización en la tabla ventas
USE usuarios;
UPDATE ventas
SET cantidad = 3, precio = 20
WHERE numero = 1;

-- Verificar el registro de actualización en la tabla de auditoría
USE bd_auditoria;
SELECT * FROM auditoria_ventas;

-- Realizar una eliminación en la tabla ventas
USE usuarios;
DELETE FROM ventas
WHERE numero = 1;

-- Verificar el registro de eliminación en la tabla de auditoría
USE bd_auditoria;
SELECT * FROM auditoria_ventas;
