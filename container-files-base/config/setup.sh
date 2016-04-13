#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/02apt-speedup
echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
apt-get dist-upgrade -y
apt-get install -y \
        wget subversion nginx inotify-tools php5-fpm \
        php5-gd php5-cli php5-mysqlnd php5-snmp php5-ldap \
        gcc build-essential nano pkg-config fping libaio1 \
        libdbd-mysql-perl libdbi-perl libhtml-template-perl \
        libiksemel3 libltdl7 libmysqlclient18 libodbc1 \
        libopenipmi0 libssh2-1 snmpd mysql-client \
        mysql-client-5.5 mysql-client-core-5.5 mysql-common \
        git-core libxml2-dev libxslt-dev mysql-client \
        libmysqlclient-dev python-dev python-setuptools \
        swig python-imaging python-m2crypto gettext \
        python-iso8601 python3.4-dev libiksemel-dev \
        unixodbc-dev unixodbc-bin unixodbc libsnmp-dev \
        libssh2-1-dev libopenipmi-dev libcurl4-openssl-dev \
        libmysqld-dev openjdk-8-jdk ruby python-pip python3-pip
svn co svn://svn.zabbix.com/tags/3.0.1 /usr/local/src/zabbix
DATE=`date +%Y-%m-%d`
sed -i "s/ZABBIX_VERSION.*'\(.*\)'/ZABBIX_VERSION', '\1 ($DATE)'/g" /usr/local/src/zabbixfrontends/php/include/defines.inc.php
sed -i "s/ZABBIX_VERSION_RC.*\"\(.*\)\"/ZABBIX_VERSION_RC \"\1 (${DATE})\"/g" /usr/local/src/zabbixinclude/version.h
sed -i "s/String VERSION =.*\"\(.*\)\"/String VERSION = \"\1 (${DATE})\"/g" /usr/local/src/zabbixsrc/zabbix_java/src/com/zabbix/gateway/GeneralInformation.java
/usr/local/src/zabbix/usr/local/src/zabbix/bootstrap
/usr/local/src/zabbix/configure --enable-server --enable-agent --with-mysql --enable-java \
            --with-net-snmp --with-libcurl --with-libxml2 --with-openipmi \
            --enable-ipv6 --with-jabber --with-openssl --with-ssh2 \
            --with-ldap --with-unixodbc
make dbschema
gem install sass
make css
make install
mv /health/ /usr/local/src/zabbix/frontends/php/
cp /usr/local/etc/web/zabbix.conf.php /usr/local/src/zabbix/frontends/php/conf/
pip install py-zabbix
apt-get -y autoremove \
           gcc build-essential pkg-config \
           libopenipmi-dev libcurl4-openssl-dev libmysqld-dev \
           openjdk-8-jdk ruby subversion gcc build-essential \
           gettext python-setuptools swig python-imaging \
           python-m2crypto python-iso8601
