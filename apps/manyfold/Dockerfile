ARG VERSION=latest

FROM ghcr.io/manyfold3d/manyfold:${VERSION}

USER nobody:nogroup
WORKDIR /data
VOLUME ["/data"]

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/manyfold3d/manyfold"
