FROM ubuntu:20.04

ARG CONFIG_UID=1000
ARG CONFIG_GID=1000

COPY setup.sh /setup.sh
RUN /setup.sh

COPY ergo.tar.gz /ergo.tar.gz
RUN cd /usr && tar -xf /ergo.tar.gz --strip 1

RUN groupadd -g $CONFIG_GID default
RUN useradd -ms /bin/bash --uid $CONFIG_UID --gid $CONFIG_GID default
COPY wipal-artifactory-key /home/default/.config/wipal-artifactory-key
USER default
