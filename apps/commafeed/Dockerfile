FROM docker.io/library/alpine:3.21

ARG TARGETPLATFORM
ARG VERSION

ENV \
  QUARKUS_DATASOURCE_JDBC_URL="jdbc:h2:/data/db;DEFRAG_ALWAYS=TRUE"

USER root
WORKDIR /app

RUN \
  apk add --no-cache \
    ca-certificates \
    curl \
    gcompat \
  && \
  case "${TARGETPLATFORM}" in \
      'linux/amd64') export ARCH="x86_64" ;; \
      'linux/arm64') export ARCH="aarch_64" ;; \
  esac \
  && \
  curl -L -o /app/commafeed "https://github.com/Athou/commafeed/releases/download/${VERSION}/commafeed-${VERSION}-h2-linux-${ARCH}-runner" \
  && chown -R root:root /app/commafeed \
  && chmod -R 755 /app/commafeed \
  && rm -rf \
    /root/.cache \
    /root/.cargo \
    /tmp/*

USER nobody:nogroup
WORKDIR /data
VOLUME ["/data"]
CMD ["/app/commafeed"]
