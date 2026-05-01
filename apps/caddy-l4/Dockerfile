ARG VERSION

FROM caddy:${VERSION}-builder AS builder
RUN xcaddy build \
    --with github.com/mholt/caddy-l4

FROM caddy:${VERSION}-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
