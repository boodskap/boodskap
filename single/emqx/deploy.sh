#!/bin/bash

docker-compose up --no-start
docker-compose start && docker-compose ps

