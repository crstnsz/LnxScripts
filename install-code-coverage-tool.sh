dotnet tool install --global dotnet-coverage

# adicionar o pacote do coverlet
#dotnet add package coverlet.msbuild

# Para executar no local do projeto
#dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=lcov /p:CoverletOutput=./lcov.info