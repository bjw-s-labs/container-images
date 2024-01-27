FROM ghcr.io/onedr0p/alpine:rolling@sha256:0e3067295cc20dafbd4cf63789ccc71858ad555f3998200ca10b271328c7285e

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
