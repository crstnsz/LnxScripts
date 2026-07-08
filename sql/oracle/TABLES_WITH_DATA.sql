SET SERVEROUTPUT ON;

DECLARE
    v_count NUMBER;
BEGIN
    FOR t IN (SELECT table_name FROM user_tables ORDER BY table_name) LOOP
        -- Executa um count dinâmico para cada tabela do usuário
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM "' || t.table_name || '" WHERE ROWNUM <= 1' INTO v_count;
        
        -- Se encontrou pelo menos 1 registro, exibe o nome da tabela
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE(t.table_name);
        END IF;
    END LOOP;
END;
/