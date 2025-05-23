ARG VERSION=latest

FROM ghcr.io/manyfold3d/manyfold:${VERSION}

USER root
RUN apk add --no-cache \
        bash \
        catatonit \
        valkey \
    && mv /usr/src/app /app \
    && chmod -R 777 /app/tmp \
    && chmod -R 777 /app/log

USER nobody:nogroup
WORKDIR /data
VOLUME ["/data"]

COPY --chmod=755 ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/manyfold3d/manyfold"
