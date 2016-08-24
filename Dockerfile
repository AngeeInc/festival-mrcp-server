# Based on tutorial: http://developer.voxtron.com/?p=85
FROM ubuntu:16.04

MAINTAINER Ondrej Platek

RUN apt-get update && \
    apt-get install -y wget build-essential python3 python3-dev python3-pip pkg-config automake autoconf libtool 

RUN wget http://www.festvox.org/flite/packed/flite-1.4/flite-1.4-release.tar.bz2 && \
    bunzip2 flite-1.4-release.tar.bz2 && \
    tar xvf flite-1.4-release.tar && \
    cd flite-1.4-release && \
    ./configure --enable-shared && \
    cat config/config | sed 's/\(CFLAGS.*\)/\1 -fPIC/' > cfg && mv cfg config/config && \
    make && \
    make install

RUN wget http://unimrcp.googlecode.com/files/unimrcp-deps-1.2.0.tar.gz  && \
    tar -xzvf unimrcp-deps-1.2.0.tar.gz && cd unimrcp-deps-1.2.0  && \
    cat build-dep-libs.sh | sed 's/.*if \[.*yes.*\].*/if \[ $MAKEINSTALL = "yes" \] ; then/' > build.sh && chmod +x build.sh && \
    ./build.sh -s

RUN export PATH=$PATH:/usr/local && wget http://unimrcp.googlecode.com/files/unimrcp-1.1.0.tar.gz && \
    tar -xzvf unimrcp-1.1.0.tar.gz && \
    cd unimrcp-1.1.0 && \
    ./configure --enable-shared --enable-flite-plugin --with-flite=../flite-1.4-release && \
    make
# --enable-flite-plugin --with-flite=../flite-1.4-release

RUN cd unimrcp-1.1.0 && \
    make install && \
    ldconfig
