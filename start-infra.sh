$oracle = "-o";

if [ $1 -eq $oracle]; then
    docker start oralce_container
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