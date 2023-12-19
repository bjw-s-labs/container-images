ARG VERSION

FROM rust:1.74.1-slim@sha256:8741e29c32a709553f74f9d0063d4562446ce0f5b40f5e672b07d8384eac0bba AS build

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
        "mdbook-regex" \
        "mdbook-mermaid"

FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:85b8ba04811ac92038898c97edbb54bedf2a45d952c0b1ce8bf31c5011b469e0

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
