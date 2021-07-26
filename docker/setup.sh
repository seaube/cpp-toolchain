#!/bin/sh

TZ=America/New_York
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
apt-get update
apt-get install -y wget xz-utils git autoconf automake bison flex texinfo help2man gawk libtool-bin ncurses-dev python3-dev rsync make bzip2 unzip g++ diffutils cmake zlib1g-dev
