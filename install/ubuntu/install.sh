#!/bin/bash

function installCommons() {
  sudo apt-get -y update
  proceed

  sudo apt-get install -y sudo git software-properties-common netcat tar curl net-tools nano wget unzip rsyslog psmisc libncurses5
  proceed
}

function createUser() {
  id $1
  if [ $? != 0 ]; then
    echo "Creating user $1 with GID:$2"
    sudo adduser --disabled-password --gecos "" -u $2  $1
    proceed
  else
    echo "User $1 exists, ignoring..."
  fi
}

function installJDK8() {
  sudo apt-get install -y openjdk-8-jdk
  proceed
}

function installJDK13() {
  sudo apt-get install -y openjdk-13-jdk
  proceed
}

function installNginx() {
  sudo apt-get install -y nginx nodejs npm
  proceed
  sudo npm install pm2 -g
  proceed
}

function setupService() {
  sudo cp ${WORKDIR}/ubuntu/start-${1}.sh /usr/local/bin/
  proceed
  sudo chmod 744 /usr/local/bin/start-${1}.sh

  sudo cp ${WORKDIR}/ubuntu/${1}-startup.sh ${HOMEDIR}/${1}/
  proceed

  sudo cp ${WORKDIR}/ubuntu/${1}.service /etc/systemd/system/
  proceed
  sudo chmod 644 /etc/systemd/system/${1}.service

  sudo chown -R ${1}:${1} ${HOMEDIR}/${1}
  proceed

  sudo systemctl enable ${1}
  proceed
}

function installCassandra() {

  echo "Installing cassandra"

  installJDK8

  if [ ${CLEANUP} == 1 ]; then
    sudo rm -rf ${HOMEDIR}/cassandra/*
  fi

  createUser cassandra $CASSANDRA_GID

  sudo cat ${WORKDIR}/ubuntu/env-cassandra.txt >> ${HOMEDIR}/cassandra/.profile
  proceed

  sudo curl -sL ${CASSANDRA_BASE}/${CASSANDRA_VER}-bin.tar.gz | tar xzvf - -C ${HOMEDIR}/cassandra/
  proceed

  sudo mv ${HOMEDIR}/cassandra/${CASSANDRA_VER}/*  ${HOMEDIR}/cassandra/
  proceed

  sudo rm -rf ${HOMEDIR}/cassandra/${CASSANDRA_VER}
  proceed

  setupService cassandra 
}

function installElastic() {

  echo "Installing elasticsearch"
  
  installJDK13

  if [ ${CLEANUP} == 1 ]; then
    sudo rm -rf ${HOMEDIR}/elastic/*
  fi

  createUser elastic $ELASTIC_GID

  sudo cat ${WORKDIR}/ubuntu/env-elastic.txt >> ${HOMEDIR}/elastic/.profile
  proceed

  sudo curl -sL ${ELASTIC_BASE}/${ELASTIC_VER}-linux-x86_64.tar.gz | tar xzvf - -C ${HOMEDIR}/elastic/
  proceed

  sudo mv ${HOMEDIR}/elastic/${ELASTIC_VER}/*  ${HOMEDIR}/elastic/
  proceed

  sudo rm -rf ${HOMEDIR}/elastic/${ELASTIC_VER}
  proceed

  setupService elastic
}

function installEmqx() {
  echo "Installing EMQX"

  if [ ${CLEANUP} == 1 ]; then
    sudo rm -rf ${HOMEDIR}/emqtt/*
  fi

  createUser emqtt $EMQTT_GID

  sudo curl -sL ${EMQTT_BASE}/${EMQTT_VER}.zip  > ${HOMEDIR}/emqtt/${EMQTT_VER}.zip
  proceed

  cd ${HOMEDIR}/emqtt
  sudo unzip ${EMQTT_VER}.zip
  sudo mv ./emqx/* .
  cd ${WORKDIR}
  sudo rm -f ${HOMEDIR}/emqtt/${EMQTT_VER}.zip
  echo "{emqx_auth_http, true}." >> ${HOMEDIR}/emqtt/data/loaded_plugins
  cat ${WORKDIR}/ubuntu/emqx_auth_http.conf > ${HOMEDIR}/emqtt/etc/plugins/emqx_auth_http.conf
  proceed

  sudo rm -rf ${HOMEDIR}/eqtt/emqx
  proceed

  setupService emqtt
}

function installKibana() {
  echo "Installing kibana"

  installJDK13

  if [ ${CLEANUP} == 1 ]; then
    sudo rm -rf ${HOMEDIR}/kibana/*
  fi

  createUser kibana $KIBANA_GID

  sudo cat ${WORKDIR}/ubuntu/env-elastic.txt >> ${HOMEDIR}/kibana/.profile
  proceed

  sudo curl -sL ${KIBANA_BASE}/${KIBANA_VER}-linux-x86_64.tar.gz | tar xzvf - -C ${HOMEDIR}/kibana/
  proceed

  sudo mv ${HOMEDIR}/kibana/${KIBANA_VER}-linux-x86_64/*  ${HOMEDIR}/kibana/
  proceed

  sudo rm -rf ${HOMEDIR}/kibana/${KIBANA_VER}-linux-x86_64
  proceed

  setupService kibana
}

function installBoodskap() {
  echo "Installing boodskap"

  installJDK13

  if [ ${CLEANUP} == 1 ]; then
    sudo rm -rf ${HOMEDIR}/boodskap/*
  fi

  createUser boodskap $BOODSKAP_GID

  sudo cat ${WORKDIR}/ubuntu/env-elastic.txt >> ${HOMEDIR}/boodskap/.profile
  proceed

  sudo curl -sL ${BOODSKAP_BASE}/v${BOODSKAP_VER}/boodskap-${BOODSKAP_VER}.tar.gz | tar xzvf - -C ${HOMEDIR}/boodskap/
  proceed

  sudo rm -rf ${HOMEDIR}/boodskap/libs/patches

  sudo curl -sL ${BOODSKAP_BASE}/v${BOODSKAP_VER}/boodskap-patch-${BOODSKAP_VER}-${BOODSKAP_PATCH_VER}.tar.gz | tar xzvf - -C ${HOMEDIR}/boodskap/
  proceed

  ln -s ${HOMEDIR}/boodskap/patches/${BOODSKAP_PATCH_VER} ${HOMEDIR}/boodskap/libs/patches

  sudo chmod +x ${HOMEDIR}/boodskap/bin/*.sh

  setupService boodskap
}

function installBoodskapUi() {

  echo "Installing boodskap dashboard and developer console"

  installNginx

  if [ ${CLEANUP} == 1 ]; then
    sudo rm -rf ${HOMEDIR}/boodskapui/*
  fi

  createUser boodskapui $BOODSKAPUI_GID

  mkdir ${HOMEDIR}/boodskapui/webapps

  git clone https://github.com/BoodskapPlatform/boodskap-ui.git  ${HOMEDIR}/boodskapui/webapps/boodskap-ui

  git clone https://github.com/BoodskapPlatform/platform-dashboard.git ${HOMEDIR}/boodskapui/webapps/platform-dashboard

  cd ${HOMEDIR}/boodskapui/webapps/boodskap-ui
  npm install
  sudo cat ${WORKDIR}/ubuntu/boodskapui.properties > ${HOMEDIR}/boodskapui/webapps/boodskap-ui/boodskapui.properties
  node build.js

  cd ${HOMEDIR}/boodskapui/webapps/platform-dashboard
  npm install
  node build.js

  setupService boodskapui

  sudo cat ${WORKDIR}/ubuntu/nginx-default > /etc/nginx/sites-enabled/default
  sudo service nginx restart
}
