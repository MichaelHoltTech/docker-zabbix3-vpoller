FROM zabbix/zabbix-3.0:3.0.1

COPY container-files /

ENV \
    ZS_LoadModule="vpoller.so"

# Layer: py-vpoller
RUN \
    yum clean all && \
    yum install -y nano python34 gcc gcc-c++ automake autoconf libtool python34-devel git psmisc && \
    curl https://bootstrap.pypa.io/get-pip.py | python3.4 && \
    pip3 install vpoller pyyaml pyzabbix && \
    mkdir -p /var/run/vpoller /var/log/vpoller /var/lib/vconnector /var/log/vconnector && \
    libzmq_dir=$( mktemp -d /tmp/libzmq.XXXXXX ) && \
    git clone https://github.com/zeromq/zeromq4-x.git ${libzmq_dir} && \
    cd ${libzmq_dir} && \
    ./autogen.sh && \
    ./configure && \
    make && make install && make clean && \
    ldconfig

# Layer: zabbix-vpoller
RUN \
    git clone --no-checkout https://github.com/dnaeon/py-vpoller /usr/local/src/vpoller-module && \
    cd /usr/local/src/vpoller-module && \
    git config core.sparseCheckout true && \
    echo "extra/zabbix/vpoller-module*"> .git/info/sparse-checkout && \
    git checkout master && \
    mv extra/zabbix/vpoller-module/* . && \
    rm -Rf extra && \
    export ZABBIX_SF_VERSION="$(echo ${ZABBIX_VERSION} | cut -d/ -f2)" && \
    cd /usr/local/src/ && \
    curl -O -J -L https://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/${ZABBIX_SF_VERSION}/zabbix-${ZABBIX_SF_VERSION}.tar.gz/download && \
    tar xvfz zabbix-${ZABBIX_SF_VERSION}.tar.gz && \
    cd zabbix-${ZABBIX_SF_VERSION} && \
    ./configure && \
    cp -a /usr/local/src/vpoller-module src/modules && \
    cd src/modules/vpoller-module && \
    make && \
    cp vpoller.so /usr/local/src/vpoller-module && \
    cd /usr/local/src/ && \
    rm -Rf zabbix-${ZABBIX_SF_VERSION} zabbix-${ZABBIX_SF_VERSION}.tar.gz

CMD ["/config/vpoller-bootstrap.sh"]
