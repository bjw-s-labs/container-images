FROM ghcr.io/onedr0p/alpine:rolling@sha256:b3d3b9e47e3b5736d045a5e9f2f1d1bbf5c1c38b8c0c296d4609079cfaf9a4bd

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
