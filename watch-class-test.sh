if [ -d "Logs" ]; then
    rm Logs/Log*;
    touch Logs/Logs.txt;
fi

if [ -d "Logs/MQ" ]; then 
    rm Logs/MQ/Log*;
    touch Logs/MQ/Logs.txt;
fi


if [[ $(pwd) == *"ApiClient"* ]]; then

    docker stop $(docker ps -q);

    docker rm $(docker ps -aqf "name=^test_");

    docker network rm api_test
fi

dotnet watch test --filter FullyQualifiedName~$* --logger:"console;verbosity=normal"