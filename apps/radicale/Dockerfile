FROM docker.io/library/python:3.13-alpine3.22

ARG VERSION

ENV \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_NO_CACHE=true \
    UV_SYSTEM_PYTHON=true \
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.22/"

ENV \
    RADICALE_CONFIG_FILE=/config/config

USER root

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
    && \
    pip install uv \
    && uv pip install \
        radicale==$VERSION \
        passlib[bcrypt] \
    && pip uninstall --yes uv \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

COPY --chmod=755 ./entrypoint.sh /entrypoint.sh

USER nobody:nogroup

COPY --chown=65534:65534 ./defaults/config /app/config.default

WORKDIR /config
WORKDIR /data
VOLUME [ "/config", "data" ]
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
