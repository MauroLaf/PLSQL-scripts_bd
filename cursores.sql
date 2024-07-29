DELIMITER //

DROP PROCEDURE IF EXISTS facilito_procedure//
CREATE PROCEDURE facilito_procedure()
BEGIN

  DECLARE var_codigo INTEGER;
  DECLARE var_stock INTEGER;
  DECLARE var_titulo VARCHAR(255);
  DECLARE var_final INTEGER DEFAULT 0;

  DECLARE cursor1 CURSOR FOR SELECT codigo, titulo, stock FROM libros;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = TRUE;

  OPEN cursor1;

  bucle: LOOP

    FETCH cursor1 INTO var_codigo, var_titulo, var_stock;

    IF var_final THEN
      LEAVE bucle;
    END IF;

    UPDATE libros SET stock = var_stock + 10 WHERE codigo = var_codigo;

    SELECT
      var_titulo AS  'titulo',
      var_stock AS 'Anterior',
      stock AS 'Incremento'
      FROM libros WHERE codigo = var_codigo;


  END LOOP bucle;
  CLOSE cursor1;

END//
DELIMITER ;