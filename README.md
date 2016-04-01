Zabbix3 with vPoller
============================

This container runs vPoller based off of the [Zabbix Github repo](https://github.com/zabbix/zabbix-community-docker)

zabbix-3.0.1
=================

Compiled Zabbix with almost all features (MySQL support, Java, SNMP,
Curl, IPMI, IPv6, Jabber, fping), vPoller Module and Zabbix web UI based on CentOS 7,
Supervisor, Nginx, PHP. Image requires external MySQL/MariaDB database (you can
run MySQL/MariaDB also as Docker container).

#### Standard Dockerized Zabbix deployment

```
# create /var/lib/mysql as persistent volume storage
docker run -d -v /var/lib/mysql --name zabbix-db-storage busybox:latest

# start DB for Zabbix - default 1GB innodb_buffer_pool_size is used
docker run \
    -d \
    --name zabbix-db \
    -v /backups:/backups \
    -v /etc/localtime:/etc/localtime:ro \
    --volumes-from zabbix-db-storage \
    --env="MARIADB_USER=zabbix" \
    --env="MARIADB_PASS=my_password" \
    zabbix/zabbix-db-mariadb

# start Zabbix linked to started DB
docker run \
    -d \
    --name zabbix \
    -p 80:80 \
    -p 10051:10051 \
    -v /etc/localtime:/etc/localtime:ro \
    --link zabbix-db:zabbix.db \
    --env="ZS_DBHost=zabbix.db" \
    --env="ZS_DBUser=zabbix" \
    --env="ZS_DBPassword=my_password" \
    --env="VS_HOST=vc01.example.com" \
    --env="VS_UN=vpoller@vsphere.local" \
    --env="VS_PW=VPoller1!" \
    --env="ZB_UN=Admin" \
    --env="ZB_PW=zabbix" \
    michaelholttech/zabbix3-vpoller:latest
# wait ~60 seconds for Zabbix initialization
# Zabbix web will be available on the port 80, Zabbix server on the port 10051

# Backup of Zabbix configuration data only
docker exec \
    -ti zabbix-db \
    /zabbix-backup/zabbix-mariadb-dump -u zabbix -p my_password -o /backups

# Full DB backup of Zabbix
docker exec \
    -ti zabbix-db \
    bash -c "\
    mysqldump -u zabbix -pmy_password zabbix | \
    bzip2 -cq9 > /backups/zabbix_db_dump_$(date +%Y-%m-%d-%H.%M.%S).sql.bz2"
```

#### Environmental variables
You can use environmental variables to config Zabbix and Zabbix web UI (PHP). Available
variables:

##### vPoller Variables

| Variable | Default value | Required? | Notes |
| -------- | ------------- | --------- | ----- |
| VS_HOST | | YES | vSphere URL |
| VS_UN | | YES | vSphere username (Read-Only Access) |
| VS_PW | | YES | vSphere Password |
| ZB_UN | | OPTIONAL | Specify Zabbix UN for using the Auto-Import |
| ZB_PW | | OPTIONAL | Specify Zabbix PW for using the Auto-Import |

Specifying the ``ZB_UN`` and ``ZB_PW`` uses the process of [Importing vSphere objects as regular Zabbix hosts](http://vpoller.readthedocs.org/en/latest/vpoller-zabbix.html#importing-vsphere-objects-as-regular-zabbix-hosts).

If you don't specify this, you need to configure Zabbix using the vPoller Documentation about [Monitoring your VMware environment with vPoller and Zabbix](http://vpoller.readthedocs.org/en/latest/vpoller-zabbix.html#monitoring-your-vmware-environment-with-vpoller-and-zabbix).

##### Zabbix Variables

*NOTE: Do NOT set the ''ZS_LoadModule'' as this will disable the vPoller module.*

Please see the Zabbix Documentation [here](https://github.com/zabbix/zabbix-community-docker/tree/master/Dockerfile/zabbix-3.0#environmental-variables).

#### Configuration from volume

Please see the Zabbix Documentation [here](https://github.com/zabbix/zabbix-community-docker/tree/master/Dockerfile/zabbix-3.0#configuration-from-volume).


#### Access to Zabbix web interface
To log in into zabbix web interface for the first time use credentials
`Admin:zabbix`.

Access web interface under [http://docker_host_ip]()

Related Zabbix Docker projects
==============================

* [Zabbix agent 3.0 XXL with Docker monitoring support](https://github.com/monitoringartist/zabbix-agent-xxl)
* Dockerised project [Grafana XXL](https://github.com/monitoringartist/grafana-xxl), which includes also [Grafana Zabbix datasource](https://github.com/alexanderzobnin/grafana-zabbix)
* Scale your Dockerised [Zabbix with Kubernetes](https://github.com/monitoringartist/kubernetes-zabbix)
