ARG VERSION
FROM docker.io/twinproduction/gatus:v$VERSION as gatus

FROM docker.io/library/alpine:3.20

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="https://github.com/TwiN/gatus"

ENV GATUS_CONFIG_PATH "/config/config.yaml"

USER root

COPY --from=gatus /gatus /app/gatus
COPY --from=gatus /config/config.yaml /app/config.default.yaml

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
    && chmod -R 755 /app

COPY ./entrypoint.sh /entrypoint.sh

VOLUME [ "/config" ]
CMD ["/entrypoint.sh"]
