ARG VERSION

FROM public.ecr.aws/docker/library/caddy:${VERSION}-builder AS build
ARG PLUGINS="github.com/caddyserver/replace-response"
RUN \
  for plugin in $(echo $PLUGINS | tr "," " "); do \
  withFlags="$withFlags --with $plugin"; \
  done \
  && xcaddy build ${withFlags} \
  && setcap -r /usr/bin/caddy

FROM scratch
COPY --chown=1000:1000 --chmod=555 --from=build /usr/bin/caddy /caddy
ENV XDG_CONFIG_HOME=/config/rendered
ENV XDG_DATA_HOME=/config/data
USER 1000:1000
WORKDIR /config/rendered
WORKDIR /config/data
WORKDIR /config
ENTRYPOINT ["/caddy"]
