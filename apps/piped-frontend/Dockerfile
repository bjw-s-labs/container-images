ARG VERSION

FROM node:lts-alpine AS build
ARG VERSION
RUN \
  apk add --no-cache curl git \
  && git clone https://github.com/TeamPiped/Piped.git /app \
  && cd /app \
  && git checkout $VERSION \
  && corepack enable  \
  && corepack prepare pnpm@latest --activate \
  && pnpm install --prefer-offline \
  && pnpm build \
  && ./localizefonts.sh

FROM ghcr.io/bjw-s-labs/caddy-scratch:2.9.0@sha256:d6833f3809807c5641ee04b87e4efa756a7d8d99d9cde2b06b341de91c1088de
COPY --chown=1000:1000 Caddyfile /config/Caddyfile
COPY --chown=1000:1000 --from=build /app/dist/ /app
CMD ["run", "--config", "/config/Caddyfile"]
