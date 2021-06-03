FROM ubuntu:20.04

WORKDIR /root

RUN apt-get update && apt-get install -y unzip curl libncurses5

ENV EMQTT_BASE="https://www.emqx.io/downloads/broker/v3.2.7"
ENV EMQTT_VER="emqx-ubuntu18.04-v3.2.7"

RUN curl -sL ${EMQTT_BASE}/${EMQTT_VER}.zip  > ${EMQTT_VER}.zip
RUN unzip ${EMQTT_VER}.zip
RUN mv /root/emqx/* /root/
RUN rm -f /root/${EMQTT_VER}.zip
RUN echo "{emqx_auth_http, true}." >> /root/data/loaded_plugins
COPY etc/ /root/etc/

EXPOSE 1883 8083

CMD ["/root/bin/emqx", "foreground"]
