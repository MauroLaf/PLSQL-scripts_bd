CREATE TABLE libros (
  codigo NUMBER(10) PRIMARY KEY,
  titulo VARCHAR2(40),
  autor VARCHAR2(30),
  editorial VARCHAR2(20),
  precio NUMBER(5,2),
  stock NUMBER(10)
);

CREATE SEQUENCE seq_libros_codigo
START WITH 1;

CREATE OR REPLACE TRIGGER trg_libros_codigo
BEFORE INSERT ON libros
FOR EACH ROW
BEGIN
  IF :new.codigo IS NULL THEN
    SELECT seq_libros_codigo.NEXTVAL INTO :new.codigo FROM dual;
  END IF;
END;
/
-- Insertar registros en la tabla libros
INSERT INTO libros (titulo, autor, editorial, precio, stock)
VALUES ('Alicia en el pais de las maravillas', 'Lewis Carroll', 'Emece', 20.00, 9);

INSERT INTO libros (titulo, autor, editorial, precio, stock)
VALUES ('Alicia en el pais de las maravillas', 'Lewis Carroll', 'Plaza', 35.00, 50);

INSERT INTO libros (titulo, autor, editorial, precio, stock)
VALUES ('Aprenda PHP', 'Mario Molina', 'Siglo XXI', 40.00, 3);

INSERT INTO libros (titulo, autor, editorial, precio, stock)
VALUES ('El aleph', 'Borges', 'Emece', 10.00, 18);

INSERT INTO libros (titulo, autor, editorial, precio, stock)
VALUES ('Ilusiones', 'Richard Bach', 'Planeta', 15.00, 22);

INSERT INTO libros (titulo, autor, editorial, precio, stock)
VALUES ('Java en 10 minutos', 'Mario Molina', 'Siglo XXI', 50.00, 7);

INSERT INTO libros (titulo, autor, editorial, precio, stock)
VALUES ('Martin Fierro', 'Jose Hernandez', 'Planeta', 20.00, 3);

INSERT INTO libros (titulo, autor, editorial, precio, stock)
VALUES ('Martin Fierro', 'Jose Hernandez', 'Emece', 30.00, 70);

INSERT INTO libros (titulo, autor, editorial, precio, stock)
VALUES ('Uno', 'Richard Bach', 'Planeta', 10.00, 120);

-- Crear o reemplazar el procedimiento almacenado
CREATE OR REPLACE PROCEDURE pa_libros_limite_stock_elegido(
    p_max_stock IN NUMBER,
    p_libros OUT NUMBER
) AS
BEGIN
    -- Contar el número de libros con stock menor o igual al valor dado
    SELECT COUNT(*) INTO p_libros
    FROM libros
    WHERE stock <= p_max_stock;
    
    -- Mostrar los detalles de los libros con stock menor o igual al valor dado
    FOR r IN (
        SELECT codigo, titulo, autor, editorial, TO_CHAR(precio, 'FM99990.00') AS precio, stock
        FROM libros
        WHERE stock <= p_max_stock
        ORDER BY stock
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(r.codigo || ' | ' || r.titulo || ' | ' || r.autor || ' | ' || r.editorial || ' | ' || r.precio || ' | ' || r.stock);
    END LOOP;
END;
/
SET SERVEROUTPUT ON;
-- Declarar una variable de PL/SQL para el parámetro de salida
DECLARE
    v_libros NUMBER;
BEGIN
    -- Llamar al procedimiento almacenado
    pa_libros_limite_stock_elegido(10, v_libros);

    -- Mostrar el valor del parámetro de salida
    DBMS_OUTPUT.PUT_LINE('Número de libros: ' || v_libros);
END;
/
-- Crear o reemplazar el procedimiento almacenado
CREATE OR REPLACE PROCEDURE pa_libros_limite_stock_elegido(
    p_max_stock IN NUMBER,
    p_libros OUT NUMBER
) AS
BEGIN
    -- Contar el número de libros con stock menor o igual al valor dado
    SELECT COUNT(*) INTO p_libros
    FROM libros
    WHERE stock <= p_max_stock;
    
    -- Mostrar los detalles de los libros con stock menor o igual al valor dado
    FOR r IN (
        SELECT codigo, titulo, autor, editorial, TO_CHAR(precio, 'FM99990.00') AS precio, stock
        FROM libros
        WHERE stock <= p_max_stock
        ORDER BY stock
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(r.codigo || ' | ' || r.titulo || ' | ' || r.autor || ' | ' || r.editorial || ' | ' || r.precio || ' | ' || r.stock);
    END LOOP;
END;
/
-- Habilitar la salida del servidor
SET SERVEROUTPUT ON;

-- Ejecutar el procedimiento almacenado y mostrar el valor del parámetro de salida
DECLARE
    v_libros NUMBER;
BEGIN
    -- Llamar al procedimiento almacenado
    pa_libros_limite_stock_elegido(10, v_libros);

    -- Mostrar el valor del parámetro de salida
    DBMS_OUTPUT.PUT_LINE('Número de libros: ' || v_libros);
END;
/


