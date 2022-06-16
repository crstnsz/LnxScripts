
if [ "-o" == "$1" ]; then
    docker start oracle_container
fi

if [ "-ms" == "$1" ];
  then
    docker start sqlserver_container
fi

if [ -z "$1" ]
  then
    docker start postgres_container
fi

docker start elasticsearch_container
docker start rabbitmq_container