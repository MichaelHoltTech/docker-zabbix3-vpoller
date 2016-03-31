### Initial Configuration

manually import templates from https://github.com/MichaelHoltTech/docker-zabbix3-vpoller/extras/templates
make sure every "create new" box is checked


### Notes

````
docker build -t zabbix3-vpoller .


docker run \
    -d \
    --name zabbix \
    -p 80:80 \
    -p 10051:10051 \
    -v /etc/localtime:/etc/localtime:ro \
    --link zabbix-db:zabbix.db \
    --env="ZS_DBHost=zabbix.db" \
    --env="ZS_DBUser=zabbix" \
    --env="ZS_DBPassword=zabbix" \
    --env="VS_HOST=ladbtwelve.ladbnet.local" \
    --env="VS_UN=vpoller@vsphere.local" \
    --env="VS_PW=SomePass1!" \
    zabbix3-vpoller
````
