CREATE OR REPLACE PROCEDURE calculadora 
							(operando1 NUMBER,
							 operando2 NUMBER,
							 operador CHAR)
IS 
	division_por_cero EXCEPTION;
BEGIN	
	IF operador = '+' THEN 
		DBMS_OUTPUT.PUT_LINE('Suma de '
			|| TO_CHAR(operando1) || '+' || TO_CHAR(operando2)
			|| ' es:' || TO_CHAR(operando1 + operando2));
	ELSIF operador = '-' THEN
		DBMS_OUTPUT.PUT_LINE('Resta de '
			|| TO_CHAR(operando1) || '-' || TO_CHAR(operando2)
			|| ' es:' || TO_CHAR(operando1 - operando2));
	ELSIF operador = '*' THEN
		DBMS_OUTPUT.PUT_LINE('Multiplicación de '
			|| TO_CHAR(operando1) || '*' || TO_CHAR(operando2)
			|| ' es:' || TO_CHAR(operando1 * operando2));
	ELSIF operador = '/' THEN
		IF operando2 = 0 THEN
			RAISE division_por_cero;
		ELSE
			DBMS_OUTPUT.PUT_LINE('División de '
				|| TO_CHAR(operando1) || '/' || TO_CHAR(operando2)
				|| ' es:' || TO_CHAR(operando1 / operando2));
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('Operador no reconocido');
	END IF;
EXCEPTION
	WHEN division_por_cero THEN
		DBMS_OUTPUT.PUT_LINE('Error: No se puede dividir entre cero');
END;
/
—--OJO!!! para que lo devuelva correctamente hay que poner ---
SET SERVEROUTPUT ON;
Para comprobar que el procedimiento está correcto. ejemplo
EXECUTE calculadora (3,6,'+')
