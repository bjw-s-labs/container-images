FROM ghcr.io/onedr0p/alpine:rolling@sha256:55b35f580db486e93271ce2bb5b222ceed8591abd6e5fa99142f9337e0ab504d

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
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

ENV \
    RADICALE_CONFIG_FILE=/config/config

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="https://github.com/Kozea/Radicale"

COPY ./config /app/config.default

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache --virtual=build-dependencies \
        gcc \
        musl-dev \
        libffi-dev \
        python3-dev \
    && apk add --no-cache \
        ca-certificates \
        python3 \
        py3-pip \
        py3-tz \
        tzdata \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install radicale==$VERSION passlib[bcrypt] \
    && chown -R 568:568 /app \
    && chmod -R 755 /app \
    && mkdir -p /data \
    && chown -R kah:kah /data \
    && chmod -R 775 /data \
    && apk del --purge build-dependencies \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

USER kah
COPY ./entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
