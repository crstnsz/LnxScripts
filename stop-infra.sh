
if docker ps --format '{{.Names}}' | grep -w oracle_container &> /dev/null; then
    docker stop oracle_container
fi

if docker ps --format '{{.Names}}' | grep -w sqlserver_container &> /dev/null; then
    docker stop sqlserver_container
fi

if docker ps --format '{{.Names}}' | grep -w postgres_container &> /dev/null; then
    docker stop postgres_container
fi

if docker ps --format '{{.Names}}' | grep -w elasticsearch_container &> /dev/null; then
    docker stop elasticsearch_container
fi

if docker ps --format '{{.Names}}' | grep -w rabbitmq_container &> /dev/null; then
    docker stop rabbitmq_container
fi

if docker ps --format '{{.Names}}' | grep -w redis_container &> /dev/null; then
    docker stop redis_container
fi

if docker ps --format '{{.Names}}' | grep -w azurite_container &> /dev/null; then
    docker stop azurite_container
fi

