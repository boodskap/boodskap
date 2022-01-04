VERSION=v3.4.4

docker build --build-arg VERSION=${VERSION} -t boodskapiot/ui:latest -t boodskapiot/ui:${VERSION} .
