# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-alpine3.22
ARG VERSION

ENV \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_NO_CACHE=true \
    UV_SYSTEM_PYTHON=true \
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.22/"

RUN \
    apk add --no-cache \
        bash \
        catatonit \
        kubectl \
    && \
    pip install uv \
    && \
    uv pip install \
        pyyaml \
    && pip uninstall --yes uv \
    && rm -rf /tmp/*

USER nobody:nogroup
ENV HOME=/config
WORKDIR /config
WORKDIR /app
VOLUME ["/config", "/app"]

ADD --chown=1000:1000 --chmod=555 https://raw.githubusercontent.com/datreeio/CRDs-catalog/${VERSION}/Utilities/crd-extractor.sh /app/crd-extractor.sh
ADD --chown=1000:1000 --chmod=555 https://raw.githubusercontent.com/datreeio/CRDs-catalog/${VERSION}/Utilities/openapi2jsonschema.py /app/openapi2jsonschema.py

ENTRYPOINT ["/usr/bin/catatonit", "--", "/app/crd-extractor.sh"]
