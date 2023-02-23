$namespace=$1
$pod = $2
$conteiner=$2 #container name in the YAML file

 kubectl exec -it --namespace=$namespace $pod bash -c $container