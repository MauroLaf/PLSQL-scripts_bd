CREATE OR REPLACE PROCEDURE insert_into_test AS BEGIN
    INSERT INTO test VALUES ('Job X', SYSDATE);
    COMMIT;
    END;
    /
    BEGIN 
        DEBMS_SCHEDULER.CREATE_JOB (
            job_name        => 'insertion_event',
            job_type        => 'STORED_PROCEDURE',
            job_action      => 'insert_into_text',
            start_date      =>  SYSDATE,
            repeat_interval => 'FREQ=MINUTELY;INTERVAL=1', /* every other day */
            end_date        =>  SYSDATE+1,
            auto_drop       =>  FALSE,
            comments        => 'Este job es similar al evento creado en MariaDB');
    END;
    /

-----------------OTRA FORMA------------------------
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'insertion_event_job',
        job_type        => 'PLSQL_BLOCK',
        job_action      => '
            BEGIN
                INSERT INTO test (event_name, event_time) VALUES (''Evento 1'', SYSTIMESTAMP);
            END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=1',
        enabled         => TRUE
    );
END;
/ 