FROM ghcr.io/onedr0p/alpine:rolling@sha256:51632d23e56ae28a34f8e90df6fe8d02730b5462697ae52e8b01ad6484497819

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS

ENV \
  TERM=xterm-256color

RUN \
    apk add --no-cache \
        gum \
        jq \
        supercronic \
    && chown -R kah:kah /app

USER kah

COPY ./script.sh /app/script.sh
COPY ./entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
