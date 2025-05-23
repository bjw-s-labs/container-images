ARG VERSION

FROM public.ecr.aws/docker/library/caddy:builder AS build
ARG VERSION
RUN \
    xcaddy build "v${VERSION}" --with "github.com/caddyserver/replace-response" \
    && setcap -r /usr/bin/caddy

FROM scratch
COPY --chown=65534:65534 --chmod=555 --from=build /usr/bin/caddy /caddy
ENV \
    XDG_CONFIG_HOME=/config/rendered \
    XDG_DATA_HOME=/config/data

WORKDIR /config/rendered
WORKDIR /config/data
WORKDIR /config

ENTRYPOINT ["/caddy"]

LABEL org.opencontainers.image.source="https://github.com/caddyserver/caddy"
