FROM arm32v7/ubuntu:18.04

RUN apt update
RUN apt -y install openjdk-11-jdk
RUN apt -y install curl

ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-armhf"

RUN curl -sL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.5.1-linux-x86_64.tar.gz | tar xzf - -C /opt/

RUN echo xpack.ml.enabled: false >> /opt/elasticsearch-7.5.1/config/elasticsearch.yml

EXPOSE 9200 9300

RUN apt-get autoclean

CMD ["/opt/elasticsearch-7.5.1/bin/elasticsearch"]
