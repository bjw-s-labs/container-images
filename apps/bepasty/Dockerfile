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
    LISTEN="0.0.0.0:8000" \
    BEPASTY_CONFIG=/config/bepasty.conf \
    WORKERS=4

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="https://github.com/bepasty/bepasty-server"

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache \
        ca-certificates \
        python3 \
        py3-gunicorn \
        py3-pip \
        py3-tz \
        tzdata \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install flask==2.2.2 Werkzeug==2.3.7 \
    && python3 -m pip install bepasty=="${VERSION}" \
    && mkdir -p /config \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && mkdir -p /data \
    && chown -R kah:kah /data \
    && chmod -R 775 /data \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

COPY ./config.py /config/bepasty.conf

USER kah
COPY ./entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
