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

ENV \
    CALIBRE_DBPATH=/config

USER root

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
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
    && \
    pip install uv \
    # TODO: Remove CFLAGS when netifaces installs without it again
    && CFLAGS="-Wno-int-conversion" uv pip install \
        --requirement /app/requirements.txt \
        --requirement /app/optional-requirements.txt \
    # TODO: Remove when new calibre-web version is released
    && uv pip install pyopenssl --upgrade \
    # Cleanup
    && pip uninstall --yes uv \
    && apk del --purge .build-deps \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/* \
    # Set permissions
    && chmod -R 755 /app

COPY --chmod=755 --from=ghcr.io/cdloh/calibre-bare:9.1.0 / /opt/calibre
COPY --chmod=755 --from=ghcr.io/bjw-s-labs/kepubify:4.0.4 /app/kepubify /opt/kepubify/kepubify
COPY --chmod=755 ./entrypoint.sh /entrypoint.sh

USER nobody:nogroup

WORKDIR /config
VOLUME [ "/config" ]
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
