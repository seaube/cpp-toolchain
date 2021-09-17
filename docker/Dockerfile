FROM ubuntu:20.04

ARG CONFIG_UID=1000
ARG CONFIG_GID=1000

COPY setup.sh /setup.sh
RUN /setup.sh

COPY ergo.tar.gz /ergo.tar.gz
RUN cd /usr && tar -xf /ergo.tar.gz
RUN cd /usr && tar -xf /ergo.tar.gz --strip-components 1

RUN groupadd -g $CONFIG_GID default
RUN useradd -ms /bin/bash --uid $CONFIG_UID --gid $CONFIG_GID default
COPY wipal-artifactory-key /home/default/.config/wipal-artifactory-key
COPY wipal-gitlab-key /home/default/.config/wipal-gitlab-key

COPY lgs-gitlab.crt /usr/local/share/ca-certificates/
COPY lgs-rootca.crt /usr/local/share/ca-certificates/
COPY lgs-subca.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

USER default
