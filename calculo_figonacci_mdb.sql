--CREANDO UN PROCEDIMIENTO PARA CALCULAR LA ENECIMA DE UNA SERIE FIGONACCI
-- Cambiar el delimitador para definir el procedimiento
DELIMITER //

-- Crear el procedimiento almacenado
CREATE PROCEDURE calcular_fibonacci(IN n INT, OUT resultado INT)
BEGIN
    DECLARE a INT DEFAULT 0;
    DECLARE b INT DEFAULT 1;
    DECLARE i INT DEFAULT 0;
    DECLARE temp INT;

    -- Casos base
    IF n = 0 THEN
        SET resultado = a;
    ELSEIF n = 1 THEN
        SET resultado = b;
    ELSE
        -- Iteración para calcular el término n-ésimo
        WHILE i < n - 1 DO
            SET temp = a;
            SET a = b;
            SET b = temp + b;
            SET i = i + 1;
        END WHILE;
        SET resultado = b;
    END IF;
END //

-- Restaurar el delimitador
DELIMITER ;

-- Declarar una variable de usuario para el resultado
SET @resultado = 0;

-- Llamar al procedimiento almacenado con el valor deseado de n
CALL calcular_fibonacci(10, @resultado);

-- Mostrar el resultado del cálculo
SELECT @resultado AS fibonacci_term;
