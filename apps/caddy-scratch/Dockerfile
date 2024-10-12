ARG VERSION

FROM public.ecr.aws/docker/library/caddy:${VERSION}-builder AS build
RUN \
  xcaddy build \
  && setcap -r /usr/bin/caddy

FROM scratch
COPY --chown=1000:1000 --chmod=555 --from=caddy /usr/bin/caddy /caddy
ENV XDG_CONFIG_HOME=/config/rendered
ENV XDG_DATA_HOME=/config/data
USER 1000:1000
WORKDIR /config/rendered
WORKDIR /config/data
WORKDIR /config
ENTRYPOINT ["/caddy"]
