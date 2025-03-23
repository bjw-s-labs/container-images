FROM docker.io/library/alpine:3.21

ARG TARGETPLATFORM
ARG VERSION

USER root

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        curl

USER nobody:nogroup
WORKDIR /app
RUN case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='64bit' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && curl -o \
        kepubify -L \
        "https://github.com/pgaskin/kepubify/releases/download/v${VERSION}/kepubify-linux-${ARCH}" \
    && chmod -R 755 kepubify

CMD [ "/app/kepubify" ]

LABEL org.opencontainers.image.source="https://github.com/pgaskin/kepubify"
