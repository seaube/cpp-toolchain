FROM centos:8

ARG CONFIG_UID=1000
ARG CONFIG_GID=1000

RUN dnf install -y dnf-plugins-core
RUN dnf config-manager --set-enabled PowerTools
RUN dnf install -y wget xz git bash autoconf automake bison flex texinfo help2man gawk libtool ncurses-devel gettext-devel python3-devel rsync make bzip2 unzip file which patch gcc-c++ diffutils cmake zlib-devel
RUN groupadd -g $CONFIG_GID default
RUN adduser -u $CONFIG_UID -g default default
USER default
