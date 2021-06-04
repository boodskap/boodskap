ARG VERSION
FROM node:latest
ARG VERSION
ENV BRANCH=$VERSION
RUN mkdir -p /usr/local/boodskap/webapps
WORKDIR /usr/local/boodskap/webapps
RUN git clone --depth 1 --branch ${BRANCH} https://github.com/BoodskapPlatform/platform-dashboard.git
WORKDIR /usr/local/boodskap/webapps/platform-dashboard
RUN npm install
COPY ./dashboard.properties /usr/local/boodskap/webapps/platform-dashboard/dashboard.properties
RUN node build.js

EXPOSE 10000

ENTRYPOINT ["node", "platform-dashboard-node.js"]
