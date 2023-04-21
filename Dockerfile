FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Make sure the package repository is up to date.
RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends \
    build-essential \
    debhelper \
    wget \
    patchelf \
    ca-certificates \
# build dependencies
    lib32gcc1 \
    lib32stdc++6 \
    libc6-i386
 
#ARG version=5.11.11.1010533
ARG version=5.12.2.1101534
ARG filename=URSim_Linux-$version.tar.gz
ARG url=https://s3-eu-west-1.amazonaws.com/ur-support-site/168410/$filename

RUN wget $url && \
    mv $filename sdur-ursim_$version.orig.tar.gz && \
    tar -xvzf sdur-ursim_$version.orig.tar.gz && \
    mv ursim-$version ursim

RUN dpkg -i ursim/ursim-dependencies/*amd64.deb

COPY debian /ursim/debian
WORKDIR /ursim
RUN dpkg-buildpackage -uc -us
WORKDIR /

ENV QUILT_PATCHES=debian/patches
