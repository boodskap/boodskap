#!/bin/bash
docker network create --attachable --subnet=172.38.0.0/16 --gateway  172.38.0.1 bskpnet

