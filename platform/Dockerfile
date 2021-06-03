ARG PVERSION
ARG PPATCH
ARG MODE
FROM ubuntu:18.04

MAINTAINER platform@boodskap.io

LABEL Remarks="Boodskap IoT Platform"

RUN apt-get update && apt-get install -y software-properties-common curl && add-apt-repository -y ppa:openjdk-r/ppa && apt-get update -y && apt-get install -y openjdk-13-jdk && apt-get -y clean && rm -rf /var/cache/apt/lists

RUN echo "**** VERSION:${PVERSION}, PATCH:${PPATCH} ****"

WORKDIR /root

ARG PVERSION
ENV RELEASE=$PVERSION
ENV ARCHIVE=boodskap-$PVERSION-00.tar.gz
RUN echo "Downloading ${ARCHIVE}..."

RUN curl -sL https://github.com/BoodskapPlatform/boodskap-platform/releases/download/v${RELEASE}/${ARCHIVE} | tar xzf - -C /root/

ARG PPATCH
ENV PATCH=$PPATCH
ENV PARCHIVE=boodskap-patch-${RELEASE}-${PATCH}.tar.gz
RUN echo "Downloading ${PARCHIVE}..."

RUN curl -sL https://github.com/BoodskapPlatform/boodskap-platform/releases/download/v${RELEASE}/${PARCHIVE} | tar xzf - -C /root/

RUN rm -rf /root/boodskap-*

WORKDIR /root/libs
RUN rm -rf patch* && rm -rf 0*
RUN ln -s /root/patches/${RELEASE}-${PATCH} patch

WORKDIR /

RUN rm -f /root/libs/boodskap/h2*

COPY root/ /root/
COPY start-boodskap.sh .

RUN chmod +x /start-boodskap.sh
RUN chmod +x /root/bin/*.sh

ARG MODE
ENV CMODE=$MODE
WORKDIR /root/config
RUN rm -f default-config.xml && rm -f boodskap.properties
RUN ln -s ${CMODE}.xml default-config.xml
RUN ln -s ${CMODE}.properties boodskap.properties

WORKDIR /root

EXPOSE 1883 18080 19090 2021 40000-60000 5555/udp

CMD ["/start-boodskap.sh"]

