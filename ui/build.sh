VERSION=v3.2.5

docker build --build-arg VERSION=${VERSION} -t boodskapiot/ui:latest -t boodskapiot/ui:${VERSION} .
