FROM node:latest
RUN mkdir -p /usr/local/boodskap/webapps
WORKDIR /usr/local/boodskap/webapps
RUN git clone --depth 1 --branch v1.0 https://github.com/BoodskapPlatform/platform-dashboard.git
WORKDIR /usr/local/boodskap/webapps/platform-dashboard
RUN npm install
COPY ./dashboard.properties /usr/local/boodskap/webapps/platform-dashboard/dashboard.properties
RUN node build.js

ENTRYPOINT ["node", "platform-dashboard-node.js"]
