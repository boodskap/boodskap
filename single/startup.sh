#!/bin/bash

cd cassandra
docker-compose up --no-start
docker-compose start

cd ../elastic
docker-compose up --no-start
docker-compose start

cd ../emqx
docker-compose up --no-start
docker-compose start

cd ../ignite
docker-compose up --no-start
docker-compose start

cd ../platform
docker-compose up --no-start
docker-compose start

cd ../ui
docker-compose up --no-start
docker-compose start

cd ../gateway
docker-compose up --no-start
docker-compose start

cd ..

