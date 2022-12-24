ARG VERSION
FROM docker.io/twinproduction/gatus:v$VERSION as gatus

FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:31fd2819a2589a6ee807f9f6eb1b8c0da4febd0731117148dde6f09cc6d7a8ba

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="https://github.com/TwiN/gatus"

COPY --from=gatus /gatus /app/gatus
COPY --from=gatus /config/config.yaml /app/config.default.yaml

ENV GATUS_CONFIG_FILE "/config/config.yaml"

#hadolint ignore=DL3018,DL3013
RUN \
    mkdir -p /config \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && chown -R kah:kah /config \
    && chmod -R 755 /app

USER kah
COPY ./apps/gatus/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
