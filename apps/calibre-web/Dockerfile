FROM ghcr.io/cdloh/calibre-bare:6.7.1@sha256:1931ef4d1183efaaf731e2b01f38a036677f0ce53987aebd3fafca8f6cabb2f5 as calibre
FROM ghcr.io/bjw-s/kepubify:4.0.4@sha256:96646b80df61888aeb17378add65503fecf270414e0b425be3ce5454613920ec as kepubify

FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:90fc29f4c1a9dcabff4ee64b3e33882335811713ab0742cae0998b51f1a6b9da

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
    PIP_DISABLE_PIP_VERSION_CHECK=1

ENV \
    CALIBRE_DBPATH=/config

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
    && chown -R 568:568 /app \
    && chmod -R 755 /app \
    && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

COPY --from=calibre / /opt/calibre
COPY --from=kepubify /app/kepubify /opt/kepubify/kepubify

USER kah
COPY ./apps/calibre-web/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
