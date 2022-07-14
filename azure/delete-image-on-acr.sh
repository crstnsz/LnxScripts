#https://docs.microsoft.com/en-us/azure/container-registry/container-registry-delete

$acrName = $1
$repositoryName = $2
$digest = $3

az acr repository delete --name $acrName --image $repositoryName@$digest