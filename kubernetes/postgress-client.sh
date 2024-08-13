kubectl apply -f postgresql-cli.YAML
kubectl attach --namespace=$namespace -ti postgresql-client      
#psql -h $ip -d $database -p $port -U $user
