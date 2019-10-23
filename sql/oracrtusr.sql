PROMPT &&USUARIO
PROMPT &&ESPACO


/* Criar tablespace */
CREATE TABLESPACE &ESPACO. DATAFILE '/opt/oracle/oradata/&ESPACO.001.dbf' SIZE 25M  AUTOEXTEND ON;

/* Criar usuario */
CREATE USER &USUARIO. IDENTIFIED BY &USUARIO. DEFAULT TABLESPACE &ESPACO.;

/* permite o usuario escrever no tablespace  */
ALTER USER &USUARIO. QUOTA UNLIMITED ON &USUARIO.

/* permite ao usuário conectar na instancia e criar objetos  */
GRANT CONNECT, RESOURCE TO &USUARIO.

/* informa que as duas regras são carregas com o usuário */
ALTER USER &USUARIO. DEFAULT ROLE CONNECT, RESOURCE