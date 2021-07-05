#VBoxManage startvm "Oracle 12C" --type headless &
#VBoxManage startvm Desenvolvimento
docker start oracle_container
docker start elasticsearch_container
docker start rabbitmq_container