FROM docker.io/library/python:3.13-alpine3.22

ARG VERSION

ENV \
    UV_NO_CACHE=true \
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.22/"

ENV \
    RADICALE_CONFIG_FILE=/config/config

USER root

COPY --from=ghcr.io/astral-sh/uv:0.8.23@sha256:94390f20a83e2de83f63b2dadcca2efab2e6798f772edab52bf545696c86bdb4 /uv /uvx /bin/
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
