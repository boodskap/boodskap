CONFIG="default"
docker build --build-arg CONFIG=${CONFIG} -t boodskapiot/gateway:latest -t boodskapiot/gateway:v1.0.3 .
