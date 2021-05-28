

BEGIN
    FOR record IN (select 'drop table "' || table_name || '" cascade constraints;' as cmd from USER_TABLES)
    LOOP
        EXECUTE IMMEDIATE record.cmd;
    END LOOP; 
END;