FROM ghcr.io/onedr0p/alpine:rolling@sha256:6d6a07c8c747e58846bb3125d4e14bb64cdea6287faef647ba072740892517f1

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

ARG VERSION

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="https://github.com/Control-D-Inc/ctrld"

ENV CTRLD_CONFIG_FILE "/config/ctrld.toml"

#hadolint ignore=DL3018,DL3013
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='amd64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    curl -L \
        "https://github.com/Control-D-Inc/ctrld/releases/download/v${VERSION}/ctrld_${VERSION}_linux_${ARCH}.tar.gz" \
        | tar -xz --strip-components=1 -C /app/ \
    && mkdir -p /config \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && chown -R kah:kah /config

USER kah
COPY ./apps/ctrld/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

