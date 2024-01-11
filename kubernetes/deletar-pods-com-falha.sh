namespace = $1
kubectl delete pods --field-selector status.phase=Failed -n $namespace