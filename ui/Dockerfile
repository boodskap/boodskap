ARG VERSION
FROM node:latest
ARG VERSION
ENV BRANCH=$VERSION
RUN echo "boodskap.xyz gateway" > /etc/host.aliases
RUN mkdir -p /usr/local/boodskap/webapps
WORKDIR /usr/local/boodskap/webapps
RUN git clone --depth 1 --branch ${BRANCH} --single-branch https://github.com/BoodskapPlatform/boodskap-ui
WORKDIR /usr/local/boodskap/webapps/boodskap-ui
RUN npm install
COPY ./boodskapui.properties /usr/local/boodskap/webapps/boodskap-ui/boodskapui.properties
COPY ./api.yaml /usr/local/boodskap/webapps/boodskap-ui/yaml/api.yaml
RUN node build.js

ENTRYPOINT ["node", "boodskap-platform-node.js"]
