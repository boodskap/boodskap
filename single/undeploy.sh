#!/bin/bash

cd cassandra
docker-compose down

cd ../elastic
docker-compose down

cd ../emqx
docker-compose down

cd ../ignite
docker-compose down

cd ../platform
docker-compose down

cd ../ui
docker-compose down

cd ../gateway
docker-compose down

cd ..

docker network rm gwnet
docker network rm emqxnet
docker network rm elasticnet
docker network rm cassandranet
docker network rm uinet
docker network rm dashboardnet
docker network rm ignitenet
docker network rm platformnet

