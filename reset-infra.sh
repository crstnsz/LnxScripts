
docker stop postgres_container
docker rm postgres_container
docker volume rm infrastructure_postgres-data
docker compose -f /d/git/Docspider/docker/infrastructure/docker-compose.infrastructure.yml up postgres --detach
docker stop elasticsearch_container
docker rm elasticsearch_container
docker volume rm infrastructure_elasticsearch-data
docker compose -f /d/git/Docspider/docker/infrastructure/docker-compose.infrastructure.yml up elasticsearch --detach
docker stop rabbitmq_container
docker rm rabbitmq_container
docker compose -f /d/git/Docspider/docker/infrastructure/docker-compose.infrastructure.yml up rabbitmq --detach
cd /d/git/Docspider/src/Docspider.Migrator/
dotnet run --project /d/git/Docspider/src/Docspider.Migrator/Docspider.Migrator.csproj -- -ef -fs --load-sample-data
