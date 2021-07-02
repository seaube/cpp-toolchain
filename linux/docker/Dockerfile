FROM ubuntu:20.04

ARG CONFIG_UID=1000
ARG CONFIG_GID=1000

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y wget xz-utils git autoconf automake bison flex texinfo help2man gawk libtool-bin ncurses-dev python3-dev rsync make bzip2 unzip g++ diffutils cmake zlib1g-dev

COPY ergo.tar.gz /ergo.tar.gz
RUN cd /usr && tar -xf /ergo.tar.gz --strip 1

RUN groupadd -g $CONFIG_GID default
RUN useradd -ms /bin/bash --uid $CONFIG_UID --gid $CONFIG_GID default
COPY wipal-artifactory-key /home/default/.config/wipal-artifactory-key
USER default
