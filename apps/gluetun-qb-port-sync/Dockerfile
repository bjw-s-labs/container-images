FROM docker.io/library/alpine:3.20

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
        curl \
        gum \
        jq \
        supercronic

COPY ./script.sh /app/script.sh
COPY ./entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
