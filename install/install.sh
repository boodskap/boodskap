#!/bin/bash

#set -e

BOODSKAP_VER="4.4.9"
BOODSKAP_PATCH_VER="02"
UI_VERSION="v3.4.4"
DASHBOARD_VERSION="v1.0.3"

CASSANDRA_GID=5001
ELASTIC_GID=5002
EMQTT_GID=5003
KIBANA_GID=5004
BOODSKAP_GID=6000
BOODSKAPUI_GID=6001

CLEANUP=1
WORKDIR=`pwd`
HOMEDIR="/home"

CASSANDRA_BASE="https://archive.apache.org/dist/cassandra/3.11.5/"
CASSANDRA_VER="apache-cassandra-3.11.5"
ELASTIC_BASE="https://artifacts.elastic.co/downloads/elasticsearch"
ELASTIC_VER="elasticsearch-7.5.1"
KIBANA_BASE="https://artifacts.elastic.co/downloads/kibana"
KIBANA_VER="kibana-7.5.1"
EMQTT_BASE="https://www.emqx.io/downloads/broker/v3.2.7"
EMQTT_VER="emqx-ubuntu18.04-v3.2.7"
BOODSKAP_BASE="https://github.com/BoodskapPlatform/boodskap-platform/releases/download"


if cat /etc/*release | grep ^NAME | grep CentOS; then
    echo "==============================================="
    echo "Installing on CentOS"
    echo "==============================================="
    OS="centos"
elif cat /etc/*release | grep ^NAME | grep Red; then
    echo "==============================================="
    echo "Installing on RedHat"
    echo "==============================================="
    OS="redhat"
elif cat /etc/*release | grep ^NAME | grep Fedora; then
    echo "================================================"
    echo "Installing on Fedorea"
    echo "================================================"
    OS="fedora"
elif cat /etc/*release | grep ^NAME | grep Ubuntu; then
    echo "==============================================="
    echo "Installing on Ubuntu"
    echo "==============================================="
    OS="ubuntu"
elif cat /etc/*release | grep ^NAME | grep Debian ; then
    echo "==============================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Debian"
    echo "==============================================="
    OS="debian"
else
    echo "UN SUPPORTED OS, couldn't install"
    exit 1;
 fi

function proceed() {
  if [ $? != 0 ]; then
    echo "setup failed, exitting..."
    exit 1
  fi
}

source ./${OS}/install.sh

installCommons

while true; do
    read -p "Do you wish to install Cassandra? [y/n]" yn
    case $yn in
        [Yy]* ) installCassandra; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you wish to install ElasticSearch? [y/n]" yn
    case $yn in
           [Yy]* ) installElastic; break;;
           [Nn]* ) break;;
           * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you wish to install Kibana? [y/n]" yn
    case $yn in
           [Yy]* ) installKibana; break;;
           [Nn]* ) break;;
           * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you wish to install Emqx? [y/n]" yn
    case $yn in
           [Yy]* ) installEmqx; break;;
           [Nn]* ) break;;
           * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you wish to install Boodskap IoT Platform? [y/n]" yn
    case $yn in
           [Yy]* ) installBoodskap; break;;
           [Nn]* ) break;;
           * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you wish to install Boodskap Admin UI? [y/n]" yn
    case $yn in
           [Yy]* ) installBoodskapUi; break;;
           [Nn]* ) break;;
           * ) echo "Please answer yes or no.";;
    esac
done

echo "All Done."
