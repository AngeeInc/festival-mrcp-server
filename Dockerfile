# Based on tutorial: http://developer.voxtron.com/?p=85
FROM ubuntu:16.04

MAINTAINER Ondrej Platek

RUN apt-get update && \
    apt-get install -y wget build-essential python3 python3-dev python3-pip

RUN wget http://www.festvox.org/flite/packed/flite-1.4/flite-1.4-release.tar.bz2 && bunzip2 flite-1.4-release.tar.bz2 && tar xvf flite-1.4-release.tar && cd flite-1.4-release && ./configure && make
RUN wget http://unimrcp.googlecode.com/files/unimrcp-deps-1.2.0.tar.gz  && tar -xzvf unimrcp-deps-1.2.0.tar.gz && cd unimrcp-deps-1.2.0 
# problem ./build-dep-libs.sh
# Do you want to build APR libraries (y/n)? => y
# Do you want to build Sofia-SIP library (y/n)? => y
# cd ..
# RUN wget http://unimrcp.googlecode.com/files/unimrcp-1.1.0.tar.gz
