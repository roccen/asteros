FROM docker-ptf

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

COPY \
debs/python-saithrift_0.9.4_arm64.deb debs/

RUN dpkg -i \
debs/python-saithrift_0.9.4_arm64.deb 

COPY ["*.ini", "/etc/ptf/"]