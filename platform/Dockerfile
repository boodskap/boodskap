FROM ubuntu:18.04

MAINTAINER platform@boodskap.io

LABEL Remarks="Boodskap IoT Platform"

RUN apt-get update && apt-get install -y software-properties-common curl && add-apt-repository -y ppa:openjdk-r/ppa && apt-get update -y && apt-get install -y openjdk-13-jdk && apt-get -y clean && rm -rf /var/cache/apt/lists

ARG PVERSION="4.0.0"

WORKDIR /root

RUN curl -sL https://github.com/BoodskapPlatform/boodskap-platform/releases/download/v${PVERSION}/boodskap-${PVERSION}.tar.gz | tar xzf - -C /root/

ARG PPATCH="0001"

RUN curl -sL https://github.com/BoodskapPlatform/boodskap-platform/releases/download/v${PVERSION}/boodskap-patch-${PVERSION}-${PPATCH}.tar.gz | tar xzf - -C /root/

RUN rm -rf /root/boodskap-*

WORKDIR /root/libs
RUN rm -rf patch* && rm -rf 0*
RUN ln -s /root/patches/${PPATCH} patch

WORKDIR /

COPY root/ /root/
COPY start-boodskap.sh .

RUN chmod +x /start-boodskap.sh
RUN chmod +x /root/bin/*.sh

EXPOSE 1883 18080 19090 2021 40000-60000 5555/udp

CMD ["/start-boodskap.sh"]

