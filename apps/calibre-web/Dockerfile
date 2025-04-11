FROM docker.io/library/python:3.12-alpine

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

ARG VERSION="0.6.23"

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
        libc6-compat \
        libldap \
        libmagic \
        libsasl \
        libxi \
        libxml2 \
        libxslt \
    && \
    apk add --no-cache --virtual=.build-deps \
        build-base \
        curl \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        openldap-dev \
    && \
    # Download calibre-web release
    mkdir -p /app \
    && curl -fsSL https://github.com/janeczku/calibre-web/archive/${VERSION}.tar.gz \
        | tar xzf - -C /app --strip-components=1 \
    # Install required python packages
    && pip install --upgrade pip uv \
    # TODO: Remove CFLAGS when netifaces installs without it again
    && CFLAGS="-Wno-int-conversion" uv pip install --system --requirement /app/requirements.txt \
    && uv pip install --system --requirement /app/optional-requirements.txt \
    # Cleanup
    && apk del --purge .build-deps \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/* \
    # Set permissions
    && chmod -R 755 /app

COPY --from=ghcr.io/cdloh/calibre-bare:8.2.100 / /opt/calibre
COPY --from=ghcr.io/bjw-s-labs/kepubify:4.0.4 /app/kepubify /opt/kepubify/kepubify
COPY ./entrypoint.sh /entrypoint.sh

USER nobody:nogroup

WORKDIR /config
VOLUME [ "/config" ]
CMD ["/entrypoint.sh"]
