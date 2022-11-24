docker network create --attachable --subnet=172.10.0.0/24 gwnet
docker network create --attachable --subnet=172.10.1.0/24 emqxnet
docker network create --attachable --subnet=172.10.2.0/24 elasticnet
docker network create --attachable --subnet=172.10.3.0/24 cassandranet
docker network create --attachable --subnet=172.10.4.0/24 uinet
docker network create --attachable --subnet=172.10.5.0/24 dashboardnet
docker network create --attachable --subnet=172.10.6.0/24 ignitenet
docker network create --attachable --subnet=172.10.7.0/24 platformnet

cd cassandra
deploy

cd ..\elastic
deploy

cd ..\emqx
deploy

cd ..\ignite
deploy

cd ..\platform
deploy

cd ..\ui
deploy

cd ..\gateway
deploy

cd ..\haproxy
deploy

cd ..
