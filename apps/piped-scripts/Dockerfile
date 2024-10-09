FROM docker.io/library/alpine:3.20

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS

ENV \
  TERM=xterm-256color

USER root
WORKDIR /app

RUN \
  apk add --no-cache \
  bash \
  ca-certificates \
  catatonit \
  curl \
  gum \
  jq \
  postgresql-client \
  supercronic

COPY ./scripts /app
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
