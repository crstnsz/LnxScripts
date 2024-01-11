docker stop $(docker ps -a -q)

dotnet watch test --filter FullyQualifiedName~$*