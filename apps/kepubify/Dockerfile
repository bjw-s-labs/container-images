FROM ghcr.io/onedr0p/alpine:rolling@sha256:6d6a07c8c747e58846bb3125d4e14bb64cdea6287faef647ba072740892517f1

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
