CREATE OR REPLACE PROCEDURE parametros (p1 IN   INTEGER
                                        ,P2 OUT  INTEGER
                                        ,p3 IN OUT INTEGER)
AS
BEGIN
    p2 := p1;
    p3 := p3*2;
END;
/
DECLARE
    p1 INTEGER := 1;
    p2 INTEGER := 2;
    p3 INTEGER := 3;
BEGIN
    DBMS_OUTPUT.PUT_LINE('P1 = '||p1);
        DBMS_OUTPUT.PUT_LINE('P2 = '||p2);
            DBMS_OUTPUT.PUT_LINE('P2 = '||p3);
    parametros (p1, p2, p3);
     DBMS_OUTPUT.PUT_LINE('P1 = '||p1);
      DBMS_OUTPUT.PUT_LINE('P1 = '||p1);
       DBMS_OUTPUT.PUT_LINE('P1 = '||p1);
END;
/