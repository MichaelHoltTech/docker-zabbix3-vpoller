#!/bin/bash

cp /usr/local/src/vpoller-module/vpoller.so /usr/lib/zabbix/modules
rm -f /var/lib/vconnector/vconnector.db
vconnector-cli init
vconnector-cli -H ${VS_HOST} -U ${VS_UN} -P ${VS_PW} add
vconnector-cli -H ${VS_HOST} enable

if [ -f /config/vsphere-import.yaml ]; then
  echo "*/15 * * * * /usr/local/bin/zabbix-vsphere-import -f /config/vsphere-import.yaml > /data/logs/vsphere-import.log" | crontab
fi

# PUT EVERYTHING BEFORE THIS LINE
/config/bootstrap.sh
