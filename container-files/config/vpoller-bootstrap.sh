#!/bin/bash

set -e
set -u

cp /usr/local/src/vpoller-module/vpoller.so /usr/lib/zabbix/modules

/config/bootstrap.sh
