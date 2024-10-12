ARG VERSION

FROM rust:1.81.0-alpine AS build
ARG TARGETPLATFORM
ENV PKGCONFIG_SYSROOTDIR=/
WORKDIR /app
RUN \
  case "${TARGETPLATFORM}" in \
  'linux/amd64') \
  export ARCH='x86_64'; \
  ;; \
  'linux/arm64') \
  export ARCH='aarch64'; \
  ;; \
  esac \
  && apk add --no-cache \
  git \
  musl-dev \
  openssl \
  openssl-dev \
  && rustup target add "${ARCH}-unknown-linux-musl" \
  && rustup toolchain install "stable-${ARCH}-unknown-linux-musl" \
  && git clone "https://github.com/chmln/sd.git" /app \
  && git checkout $VERSION \
  && cargo build --target "${ARCH}-unknown-linux-musl" --release \
  && mv "/app/target/${ARCH}-unknown-linux-musl/release/sd" /app/sd

# FROM rust:1.81.0-slim
FROM scratch
COPY --chown=1000:1000 --chmod=555 --from=build /app/sd /sd
USER 1000:1000
ENTRYPOINT [ "/sd" ]
