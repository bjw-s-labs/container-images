FROM ghcr.io/onedr0p/alpine:rolling@sha256:3fbc581cb0fe29830376161ae026e2a765dcc11e1747477fe9ebf155720b8638

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
