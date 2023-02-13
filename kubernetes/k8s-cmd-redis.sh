$pod = $1
$namespace = $2

kubectl exec --stdin --tty $pod -n $namespace -- redis-cli