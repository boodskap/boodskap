#!/bin/bash

cd $HOME/webapps/boodskap-ui
pm2 start boodskap-platform-node.js

cd $HOME/webapps/platform-dashboard
pm2 start platform-dashboard-node.js
