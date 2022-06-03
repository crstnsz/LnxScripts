az login
az account set --subscription $1
az aks get-credentials --resource-group $1 --name $2