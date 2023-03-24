$podName = $1
$containerName = $2 

kubectl logs --previous $podName $containerName -n homolog