FROM ghcr.io/cdloh/calibre-bare:6.29.0@sha256:a62a5fa7d3b6d225addf69639f50664f219a367a688871efa7e48598b9960210 as calibre
FROM ghcr.io/bjw-s/kepubify:4.0.4@sha256:28e89df671c8ba48d52630f8cd852b45db74ea7ff7495ae098163a7e8c56f1bb as kepubify

FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:6e060e90482632408063d0fbb4b616c77914ef10eaa6b089a00de5815471006c

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
        libldap-2.5-0 \
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
COPY ./entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
