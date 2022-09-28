-- Tabelas do usuário [SCHEMA]
SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = '[SCHEMA]'

-- Rapido mas com poucos dados
SELECT COLUMN_NAME, DATA_TYPE, NULLABLE  FROM ALL_TAB_COLUMNS WHERE OWNER = '[SCHEMA]' AND TABLE_NAME = '[TABLE]'

-- Extair os creates com o tipo mas demora                                 -- se quiser filtar
SELECT DBMS_METADATA.GET_DDL('TABLE',TABLE_NAME, '[SCHEMA]') FROM ALL_TABLES-- WHERE OWNER = '[SCHEMA]' AND TABLE_NAME = '[TABLE]'

-- Extair os indices                                                                 -- se quiser filtar
SELECT DBMS_METADATA.get_dependent_ddl('INDEX',TABLE_NAME, '[SCHEMA]') FROM ALL_TABLES -- WHERE OWNER = '[SCHEMA]' AND TABLE_NAME = '[TABLE]'
