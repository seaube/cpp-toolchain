FROM ubuntu:22.04

ARG TARGETARCH
ARG CONFIG_UID=1000
ARG CONFIG_GID=1000

COPY setup.sh /setup.sh
RUN /setup.sh

RUN groupadd -g $CONFIG_GID default
RUN useradd -ms /bin/bash --uid $CONFIG_UID --gid $CONFIG_GID --no-log-init default

ADD --chmod=755 https://github.com/bazelbuild/bazelisk/releases/download/v1.21.0/bazelisk-linux-$TARGETARCH /usr/bin/bazelisk

USER default
