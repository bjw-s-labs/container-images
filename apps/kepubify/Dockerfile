FROM ghcr.io/onedr0p/alpine:rolling@sha256:da2846e0398d55a5178448f7cb9ee1eeeeee13830fba40289152798595f78c8a

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
