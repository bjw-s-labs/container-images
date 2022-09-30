FROM ghcr.io/cdloh/calibre-bare:6.6.1@sha256:f5307fa4443259c6efe5d9d7122ac25aef79ace7e88f570ea5901e6ba1cac88f as calibre

FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:a3f50b8f3603708774e6450e0601499ad41f1720fe516c3e1ed660a9baa13eb9

ARG VERSION

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

ENV \
    CALIBRE_DBPATH=/config

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
    apt-get -qq update \
    && \
    apt-get -qq install -y \
        imagemagick \
        libegl1 \
        libfontconfig1 \
        libgl1-mesa-glx \
        libldap-2.4-2 \
        libnss3 \
        libopengl0 \
        libsasl2-2 \
        libxcomposite1 \
        libxdamage1 \
        libxi6 \
        libxkbcommon0 \
        libxrandr2 \
        libxslt1.1 \
        python3 \
        python3-pip \
        python3-pkg-resources \
    && \
    # Dev
    apt-get -qq install -y \
        libldap2-dev \
        libsasl2-dev \
        python3-dev \
        gcc \
        g++ \
    && \
    curl -fsSL https://github.com/janeczku/calibre-web/releases/download/${VERSION}/calibre-web-${VERSION}.tar.gz \
        | tar xzf - -C /app --strip-components=1 \
    && pip install --upgrade pip \
    && pip install --upgrade --requirement /app/requirements.txt \
    && pip install --upgrade --requirement /app/optional-requirements.txt \
    && apt-get purge -y --auto-remove libldap2-dev libsasl2-dev python3-dev gcc g++\
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/ \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

COPY --from=calibre / /opt/calibre

USER kah
COPY ./apps/calibre-web/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/janeczku/calibre-web"
