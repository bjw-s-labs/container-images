FROM docker.io/library/alpine:3.21

ENV \
  TERM=xterm-256color

USER root

RUN \
  apk add --no-cache \
  bash \
  ca-certificates \
  catatonit \
  curl \
  gum \
  jq \
  supercronic

COPY --chmod=755 ./entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /app
COPY --chown=65534:65534 --chmod=755 ./script.sh /app/script.sh

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
