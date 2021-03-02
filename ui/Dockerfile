FROM node:latest
RUN mkdir -p /usr/local/boodskap/webapps
WORKDIR /usr/local/boodskap/webapps
RUN git clone --depth 1 --branch v3.0.11 --single-branch https://github.com/BoodskapPlatform/boodskap-ui
WORKDIR /usr/local/boodskap/webapps/boodskap-ui
RUN npm install
COPY ./boodskapui.properties /usr/local/boodskap/webapps/boodskap-ui/boodskapui.properties
RUN node build.js

ENTRYPOINT ["node", "boodskap-platform-node.js"]
