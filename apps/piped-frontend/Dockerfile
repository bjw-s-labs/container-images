ARG VERSION

FROM node:lts-alpine AS build
ARG VERSION
RUN \
  apk add --no-cache curl git \
  && git clone https://github.com/TeamPiped/Piped.git /app \
  && cd /app \
  && git checkout $VERSION \
  && corepack enable  \
  && corepack prepare pnpm@10.0.0 --activate \
  && pnpm install --prefer-offline \
  && pnpm build \
  && ./localizefonts.sh

FROM ghcr.io/bjw-s-labs/caddy-scratch:2.9.1@sha256:7e38da5a58a670e444c76742c3e968d8c609b08032ff215b10ef3bade154c8a5
COPY --chown=1000:1000 Caddyfile /config/Caddyfile
COPY --chown=1000:1000 --from=build /app/dist/ /app
CMD ["run", "--config", "/config/Caddyfile"]
