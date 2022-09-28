UNDEFINE USUARIO, ESPACO

PROMPT &&USUARIO
PROMPT &&ESPACO
PROMPT &&SENHA



/* Excluir usuario */
DROP USER &USUARIO. CASCADE;

/* Criar usuario */
CREATE USER &USUARIO. IDENTIFIED BY &SENHA. DEFAULT TABLESPACE &ESPACO.;

/* permite o usuario escrever no tablespace  */
ALTER USER &USUARIO. QUOTA UNLIMITED ON &ESPACO.;

/* permite ao usuário conectar na instancia e criar objetos  */
GRANT CONNECT, RESOURCE TO &USUARIO.;

/* informa que as duas regras são carregas com o usuário */
ALTER USER &USUARIO. DEFAULT ROLE CONNECT, RESOURCE;

EXIT;
