FROM debian:stable
MAINTAINER Kinsey Moore <kinsey.moore@oarcorp.com>
LABEL Description="rtems-arm crosscompiler"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ARG RSB_VERSION=5
ENV PATH="/opt/rtems/${RSB_VERSION}/bin:${PATH}"
COPY . /RSB

RUN echo == Installing dependencies... &&\
        apt-get update &&\
        apt-get install -y --no-install-recommends binutils make patch gcc g++ gdb pax python2.7-dev zlib1g-dev git bison &&\
        apt-get install -y --no-install-recommends flex texinfo bzip2 xz-utils unzip libtinfo-dev &&\
        ln -T /usr/bin/python2.7 /usr/bin/python &&\
    echo == Building crosscompiler... &&\
        cd RSB &&\
        ./source-builder/sb-check &&\
        cd rtems &&\
        ../source-builder/sb-set-builder --prefix=/opt/rtems/${RSB_VERSION} ${RSB_VERSION}/rtems-arm &&\
    echo == Removing dependencies... &&\
        apt-get --purge -y autoremove gcc g++ gdb zlib1g-dev bison flex texinfo libtinfo-dev &&\
        apt-get install -y --no-install-recommends python3 libssl-dev wget device-tree-compiler u-boot-tools autoconf ca-certificates libpixman-1-0 libglib2.0-0 &&\
        rm -rf /var/lib/apt/lists/*
