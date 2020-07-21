#bin/sh
echo "Informa a senha para SA"
stty -echo
read docmsspasswd
stty echo
docker exec -it mssqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $docmsspasswd
