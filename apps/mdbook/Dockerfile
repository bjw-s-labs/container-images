FROM rust:1.66.0-slim@sha256:2bcbf9c3c854168ce803d8cec4301778bdf360df7bc0bd4196b3ad71567288f9 AS build

ARG VERSION

# Version numbers for all the crates we're going to install
ARG MDBOOK_VERSION="${VERSION}"
ARG MDBOOK_LINKCHECK_VERSION="0.7.7"
ARG MDBOOK_MERMAID_VERSION="0.12.6"
ARG MDBOOK_TOC_VERSION="0.11.0"
ARG MDBOOK_OPEN_ON_GH_VERSION="2.3.1"

ENV CARGO_INSTALL_ROOT /usr/local/
ENV CARGO_TARGET_DIR /tmp/target/

RUN \
    apt-get -qq update \
    && \
    apt-get install -y \
        libssl-dev \
        pkg-config \
        ca-certificates \
        build-essential \
        make \
        perl \
        gcc \
        libc6-dev

RUN \
    cargo install --verbose \
        "mdbook@${MDBOOK_VERSION}" \
        "mdbook-linkcheck@${MDBOOK_LINKCHECK_VERSION}" \
        "mdbook-mermaid@${MDBOOK_MERMAID_VERSION}" \
        "mdbook-toc@${MDBOOK_TOC_VERSION}" \
        "mdbook-open-on-gh@${MDBOOK_OPEN_ON_GH_VERSION}" \
        "mdbook-emojicodes"

FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:6354de1c9666bf401b6fc18e49eea81a6d68655caf35727526ff0d76a909f98c

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

ARG VERSION

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="https://github.com/rust-lang/mdBook"

ENV \
    RUST_LOG=info

COPY --from=build /usr/local/bin/mdbook* /bin/

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
    apt-get -qq update \
    && \
    apt-get -qq install --no-install-recommends -y \
        ca-certificates \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/

# Used when serving
EXPOSE 3000

WORKDIR /data
VOLUME [ "/data" ]
