# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.14-alpine3.23

ARG VERSION

ENV \
    UV_NO_CACHE=true \
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.23/"

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

#hadolint ignore=DL3018,DL3013
RUN apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
    && \
    apk add --no-cache --virtual=.build-deps \
        build-base \
        libffi-dev \
        openssl-dev \
        musl-dev \
    && \
    uv pip install --system getmail6=="${VERSION}" \
    && rm /bin/uv /bin/uvx \
    && apk del --purge .build-deps \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

USER nobody:nogroup
WORKDIR /config
VOLUME [ "/config" ]

ENTRYPOINT [ "/usr/bin/catatonit", "--", "/usr/local/bin/getmail" ]
CMD ["--getmaildir", "/config" ]
