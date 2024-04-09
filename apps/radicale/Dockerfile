FROM docker.io/library/python:3.12-alpine

ARG VERSION
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1

ENV \
    RADICALE_CONFIG_FILE=/config/config

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="https://github.com/Kozea/Radicale"

COPY ./config /app/config.default

USER root

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
    && apk add --no-cache --virtual=build-dependencies \
        build-base \
        linux-headers \
    && pip install --upgrade pip uv \
    && uv pip install --system radicale==$VERSION passlib[bcrypt] \
    && chmod -R 755 /app \
    && apk del --purge build-dependencies \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

COPY ./entrypoint.sh /entrypoint.sh

VOLUME [ "/config" "/data" ]
CMD ["/entrypoint.sh"]
