#!/bin/bash

cd $HOME/webapps/boodskap-ui
node boodskap-platform-node.js &

cd $HOME/webapps/platform-dashboard
node platform-dashboard-node.js
