FROM ubuntu:22.04

ARG TARGETARCH

COPY setup.sh /setup.sh
RUN /setup.sh

RUN useradd -ms /bin/bash default

ADD --chmod=755 https://github.com/bazelbuild/bazelisk/releases/download/v1.21.0/bazelisk-linux-$TARGETARCH /usr/bin/bazelisk

USER default
