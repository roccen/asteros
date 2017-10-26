FROM aarch64/debian:jessie

MAINTAINER Pavel Shirshov

## Copy dependencies
COPY \
debs/libthrift-0.9.3_0.9.3-2_arm64.deb debs/python-thrift_0.9.3-2_arm64.deb debs/python-ptf_0.9-1_all.deb debs/

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

## Set the apt source, update package cache and install necessary packages
RUN sed --in-place 's/httpredir.debian.org/mirrors.163.com/' /etc/apt/sources.list \
    && sed --in-place 's/deb.debian.org/mirrors.163.com/' /etc/apt/sources.list \
    && apt-get update          \
    && apt-get upgrade -y   \
    && apt-get dist-upgrade -y  \
    && apt-get install -y   \
        openssh-server      \
        vim                 \
        net-tools           \
        traceroute          \
        lsof                \
        tcpdump             \
        unzip               \
        pkg-config          \
        binutils            \
        net-tools           \
        build-essential     \
        libssl-dev          \
        libffi-dev          \
        wget                \
        cmake               \
        libqt5core5a        \
        libqt5network5      \
        less                \
        git                 \
        iputils-ping        \
        hping3              \
        curl                \
        python              \
        python-dev          \
        python-scapy

RUN dpkg -i \
debs/libthrift-0.9.3_0.9.3-2_arm64.deb debs/python-thrift_0.9.3-2_arm64.deb debs/python-ptf_0.9-1_all.deb 

# Install all python modules from pypi. python-scapy is exception, ptf debian package requires python-scapy
RUN rm -rf /debs \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && wget --https-only https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && rm -f get-pip.py \
    && pip install setuptools \
    && pip install supervisor \
    && pip install ipython==5.4.1 \
    && git clone https://github.com/p4lang/scapy-vxlan.git \
    && cd scapy-vxlan \
    && python setup.py install \
    && cd .. \
    && rm -fr scapy-vxlan \
    && wget https://github.com/nanomsg/nanomsg/archive/1.0.0.tar.gz \
    && tar xvfz 1.0.0.tar.gz \
    && cd nanomsg-1.0.0    \
    && mkdir -p build      \
    && cd build            \
    && cmake ..            \
    && make install        \
    && ldconfig            \
    && cd ../..            \
    && rm -fr nanomsg-1.0.0 \
    && rm -f 1.0.0.tar.gz  \
    && pip install cffi    \
    && pip install nnpy    \
    && pip install dpkt    \
    && pip install ipaddress \
    && pip install pysubnettree \
    && pip install paramiko \
    && pip install flask   \
    && pip install exabgp==3.4.17\
    && pip install pyaml   \
    && mkdir -p /opt       \
    && cd /opt             \
    && wget https://raw.githubusercontent.com/p4lang/ptf/master/ptf_nn/ptf_nn_agent.py

## Adjust sshd settings
RUN mkdir /var/run/sshd \
 && echo 'root:root' | chpasswd \
 && sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
 && sed -i '$aUseDNS no' /etc/ssh/sshd_config

COPY ["supervisord.conf", "/etc/supervisor/"]
COPY ["conf.d/supervisord.conf", "conf.d/sshd.conf", "conf.d/ptf_nn_agent.conf", "/etc/supervisor/conf.d/"]

RUN mkdir -p /var/log/supervisor

EXPOSE 22

ENTRYPOINT ["/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]