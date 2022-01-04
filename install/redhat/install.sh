#!/bin/bash

EMQTT_VER="emqx-centos7-v3.2.7"

function installCommons() {
  sudo yum -y update
  proceed

  sudo yum install -y sudo git nc tar curl net-tools nano wget unzip rsyslog psmisc ncurses-compat-libs
  proceed
}

function installJDK8() {
  sudo yum install -y java-1.8.0-openjdk-devel
  proceed
}

function installJDK13() {
  sudo curl -sL https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-14_linux-x64_bin.tar.gz | tar xzvf - -C /opt/
  proceed
}

function installNginx() {
  sudo yum install -y yum-utils
  sudo cp ${WORKDIR}/redhat/nginx.repo /etc/yum.repos.d/
  sudo yum-config-manager --enable nginx-stable
  sudo yum install -y nginx
  proceed

  sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo subscription-manager repos --enable "rhel-*-optional-rpms" --enable "rhel-*-extras-rpms"  --enable "rhel-ha-for-rhel-*-server-rpms"
  sudo yum install -y nodejs
  proceed

  sudo npm install pm2 -g
  proceed
}

function createUser() {
  id $1
  if [ $? != 0 ]; then
    echo "Creating user $1 with GID:$2"
    sudo adduser -u $2 -p ""  $1
    proceed
  else
    echo "User $1 exists, ignoring..."
  fi
}

function setupService() {
  sudo cp ${WORKDIR}/redhat/start-${1}.sh /usr/local/bin/
  proceed
  sudo chmod 744 /usr/local/bin/start-${1}.sh

  sudo cp ${WORKDIR}/redhat/${1}-startup.sh ${HOMEDIR}/${1}/
  proceed

  sudo cp ${WORKDIR}/redhat/${1}.service /etc/systemd/system/
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

  sudo cat ${WORKDIR}/redhat/env-cassandra.txt >> ${HOMEDIR}/cassandra/.bashrc
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

  sudo cat ${WORKDIR}/redhat/env-elastic.txt >> ${HOMEDIR}/elastic/.bashrc
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
  cat ${WORKDIR}/redhat/emqx_auth_http.conf > ${HOMEDIR}/emqtt/etc/plugins/emqx_auth_http.conf
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

  sudo cat ${WORKDIR}/redhat/env-elastic.txt >> ${HOMEDIR}/kibana/.bashrc
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

  sudo cat ${WORKDIR}/redhat/env-elastic.txt >> ${HOMEDIR}/boodskap/.bashrc
  proceed

  echo Dowloading ${BOODSKAP_BASE}/v${BOODSKAP_VER}/boodskap-${BOODSKAP_VER}-00.tar.gz
  sudo curl -sL ${BOODSKAP_BASE}/v${BOODSKAP_VER}/boodskap-${BOODSKAP_VER}-00.tar.gz | tar xzvf - -C ${HOMEDIR}/boodskap/
  proceed

  sudo rm -rf ${HOMEDIR}/boodskap/libs/patches

  echo Downloading ${BOODSKAP_BASE}/v${BOODSKAP_VER}/boodskap-patch-${BOODSKAP_VER}-${BOODSKAP_PATCH_VER}.tar.gz
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
  git checkout ${UI_VERSION}
  npm install
  sudo cat ${WORKDIR}/ubuntu/boodskapui.properties > ${HOMEDIR}/boodskapui/webapps/boodskap-ui/boodskapui.properties
  node build.js

  cd ${HOMEDIR}/boodskapui/webapps/platform-dashboard
  git checkout ${UI_VERSION}
  npm install
  node build.js

  setupService boodskapui

  sudo cat ${WORKDIR}/redhat/nginx-default > /etc/nginx/conf.d/default.conf
  systemctl enable nginx
  sudo service nginx restart
  sudo setsebool -P httpd_can_network_connect 1
}
