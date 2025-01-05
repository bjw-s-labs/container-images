ARG VERSION

FROM docker.io/library/golang:1.23.4 AS build
ARG VERSION
RUN \
  go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest \
  && xcaddy build "v${VERSION}" --with "github.com/caddyserver/replace-response"

FROM scratch
COPY --chown=1000:1000 --chmod=555 --from=build /go/caddy /caddy
ENV XDG_CONFIG_HOME=/config/rendered
ENV XDG_DATA_HOME=/config/data
USER 1000:1000
WORKDIR /config/rendered
WORKDIR /config/data
WORKDIR /config
ENTRYPOINT ["/caddy"]
