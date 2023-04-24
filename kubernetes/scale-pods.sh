$numeroReplicas = $1
$nomeDeployment = $2

 
 kubectl scale --replicas=$numeroReplicas deployment/$nomeDeployment