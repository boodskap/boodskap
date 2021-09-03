VERSION="v1.0.3"

docker build --build-arg VERSION=${VERSION} -t boodskapiot/dashboard:latest -t boodskapiot/dashboard:${VERSION} .
