# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.15

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" && apt-get dist-upgrade -y

ADD container-files-base /

COPY container-files-zabbix /

# Get Zabbix built from Source
RUN \
    chmod +x /config/setup.sh && \
    /config/setup.sh


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
