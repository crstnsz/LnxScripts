UNDEFINE USUARIO, ESPACO

PROMPT &&USUARIO


/* Criar usuario */
CREATE USER &USUARIO. IDENTIFIED BY &USUARIO. DEFAULT TABLESPACE USERS;

/* permite o usuario escrever no tablespace  */
ALTER USER &USUARIO. QUOTA UNLIMITED ON USERS.

/* permite ao usuário conectar na instancia e criar objetos  */
GRANT CONNECT, RESOURCE TO &USUARIO.

/* informa que as duas regras são carregas com o usuário */
ALTER USER &USUARIO. DEFAULT ROLE CONNECT, RESOURCE

