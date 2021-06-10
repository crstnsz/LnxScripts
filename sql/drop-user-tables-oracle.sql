DECLARE
    sql_stmt    VARCHAR2(100);
BEGIN
    FOR record IN (select table_name from USER_TABLES)
    LOOP
        sql_stmt := 'drop table "'|| record.table_name ||'" cascade constraints';

        EXECUTE IMMEDIATE  sql_stmt;
    END LOOP; 
END;
