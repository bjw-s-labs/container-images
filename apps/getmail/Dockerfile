FROM ghcr.io/onedr0p/alpine:rolling@sha256:35dc08b62b80ebd6d9a4e46ff1c4503967d4c0ca6a9ca8b04e299102b0319bf6

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018,DL3013
RUN apk add --no-cache \
        ca-certificates \
        python3 \
    && \
    apk add --no-cache --virtual=.build-deps \
        build-base \
        libffi-dev \
        openssl-dev \
        musl-dev \
        python3-dev \
        py3-pip \
    && \
    pip install --upgrade pip \
    && \
    pip install --no-cache-dir getmail6=="${VERSION}" \
    && apk del --purge .build-deps \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

USER kah
VOLUME [ "/config" ]
CMD [ "/usr/bin/getmail", "--getmaildir", "/config" ]

LABEL org.opencontainers.image.source="https://github.com/getmail6/getmail6"
