ARG VERSION

FROM rust:1.73.0-slim@sha256:dcade53b45c5f00d952915496317a5db5abfd7d612b010f935bb040f8cc95c37 AS build

ENV CARGO_INSTALL_ROOT /usr/local/
ENV CARGO_TARGET_DIR /tmp/target/

ARG VERSION

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
        "mdbook@${VERSION}" \
        "mdbook-linkcheck" \
        "mdbook-admonish" \
        "mdbook-mermaid" \
        "mdbook-toc" \
        "mdbook-open-on-gh" \
        "mdbook-emojicodes" \
        "mdbook-regex"

FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:defe5e1d3d576d7df31ee7cb252509bff1127bd9e540c1ccea259d2e3d1b57b8

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

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
