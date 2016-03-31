#!/bin/bash

cp /usr/local/src/vpoller-module/vpoller.so /usr/lib/zabbix/modules

/config/bootstrap.sh

if [ ! -f /var/lib/vconnector/vconnector.db ]; then
  vconnector-cli init
  vconnector-cli -H ${VS_HOST} -U ${VS_UN} -P ${VS_PW} add
  vconnector-cli -H ${VS_HOST} enable
  supervisorctl restart vpoller-worker
fi
