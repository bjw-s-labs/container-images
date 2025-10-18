FROM docker.io/library/python:3.13-alpine3.22

ARG VERSION

ENV \
    UV_NO_CACHE=true \
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.22/"

ENV \
    RADICALE_CONFIG_FILE=/config/config

USER root

COPY --from=ghcr.io/astral-sh/uv:0.9.4@sha256:c4089b0085cf4d38e38d5cdaa5e57752c1878a6f41f2e3a3a234dc5f23942cb4 /uv /uvx /bin/
ADD --chmod=755 ./entrypoint.sh /entrypoint.sh
ADD --keep-git-dir=false https://github.com/Kozea/Radicale.git#v${VERSION} /app
ADD --chown=65534:65534 ./defaults/config /app/config.default

WORKDIR /app

RUN \
    apk add --no-cache \
        ca-certificates \
        catatonit \
    && uv sync --no-dev \
    && chown -R root:root /app && chmod -R 755 /app \
    && rm /bin/uv /bin/uvx \
    && rm -rf /root/.cache /root/.cargo /tmp/*

USER nobody:nogroup
ENV PATH="/app/.venv/bin:$PATH"

WORKDIR /config
WORKDIR /data
VOLUME [ "/config", "data" ]
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
