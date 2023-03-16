ARG VERSION
FROM docker.io/twinproduction/gatus:v$VERSION as gatus

FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:07c7794ab341e45b5cbbe4648092ccfb2b74bbb1e33573f81f99ae773dd2a71d

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
