if [ -d "Logs" ]; then rm Logs/Log*; fi
touch Logs/Logs.txt

if [ -d "Logs/MQ" ]; then rm Logs/MQ/Log*; fi
touch Logs/MQ/Logs.txt

docker stop $(docker ps -a -q)

dotnet watch test --filter FullyQualifiedName~$* --logger:"console;verbosity=normal"