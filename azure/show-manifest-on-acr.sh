$registry = $1
$repository = $2

az acr repository show-manifests --name $registry --repository $repository