FROM ghcr.io/cdloh/calibre-bare:7.12.0@sha256:2aaae6f7ee5bb33985a4bebd206fabdfac57e2266de1fbd0cf1fdf743c6812d6 as calibre
FROM ghcr.io/bjw-s/kepubify:4.0.4@sha256:9b260ed42cf364e1de727cb9bb428a121b0da22a1fdc95ea3a0ac0f5f8f80f6f as kepubify

FROM docker.io/library/python:3.11-alpine

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

ARG VERSION

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="https://github.com/janeczku/calibre-web"

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1

ENV \
    CALIBRE_DBPATH=/config \
    UMASK="0002"

USER root

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        ghostscript \
        libldap \
        libsasl \
        libxi \
        libxslt \
    && \
    apk add --no-cache --virtual=.build-deps \
        build-base \
        curl \
        libffi-dev \
        linux-headers \
        openldap-dev \
    && \
    # Download calibre-web release
    mkdir -p /app \
    && curl -fsSL https://github.com/janeczku/calibre-web/archive/${VERSION}.tar.gz \
        | tar xzf - -C /app --strip-components=1 \
    # Install required python packages
    && pip install --upgrade pip uv \
    && uv pip install --system --requirement /app/requirements.txt \
    && uv pip install --system --requirement /app/optional-requirements.txt \
    # Cleanup
    && apk del --purge .build-deps \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/* \
    # Set permissions
    && chmod -R 755 /app

COPY --from=calibre / /opt/calibre
COPY --from=kepubify /app/kepubify /opt/kepubify/kepubify
COPY ./entrypoint.sh /entrypoint.sh

VOLUME [ "/config" ]
CMD ["/entrypoint.sh"]
