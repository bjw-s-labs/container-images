FROM ghcr.io/onedr0p/alpine:rolling@sha256:41a5e9e7152569abf59cb6a8f4848ee5855f28ae6a8f54c129e7c13a1ae0a020

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

ARG VERSION

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="https://github.com/pgaskin/kepubify"

#hadolint ignore=DL3018,DL3013
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='64bit' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    curl -o \
        /app/kepubify -L \
        "https://github.com/pgaskin/kepubify/releases/download/v${VERSION}/kepubify-linux-${ARCH}" \
    && chown -R root:root /app \
    && chmod -R 755 /app

USER kah
CMD [ "/app/kepubify" ]
