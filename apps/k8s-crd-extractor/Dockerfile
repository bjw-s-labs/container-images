# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-alpine3.22
ARG VERSION

ENV \
    UV_NO_CACHE=true \
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.22/"

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        kubectl \
    && \
    uv pip install --system pyyaml \
    && rm /bin/uv /bin/uvx \
    && rm -rf /tmp/*

USER nobody:nogroup
ENV HOME=/config
WORKDIR /config
WORKDIR /app
VOLUME ["/config", "/app"]

ADD --chown=1000:1000 --chmod=555 https://raw.githubusercontent.com/datreeio/CRDs-catalog/${VERSION}/Utilities/crd-extractor.sh /app/crd-extractor.sh
ADD --chown=1000:1000 --chmod=555 https://raw.githubusercontent.com/datreeio/CRDs-catalog/${VERSION}/Utilities/openapi2jsonschema.py /app/openapi2jsonschema.py

ENTRYPOINT ["/usr/bin/catatonit", "--", "/app/crd-extractor.sh"]
