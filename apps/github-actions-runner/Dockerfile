ARG VERSION=latest

FROM ghcr.io/actions/actions-runner:${VERSION}

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
    sudo apt-get -qq update \
    && \
    sudo apt-get install -y \
        git \
    && \
    sudo rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/
