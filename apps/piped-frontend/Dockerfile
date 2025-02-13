ARG VERSION

FROM node:lts-alpine AS build
ARG VERSION
RUN \
  apk add --no-cache curl git \
  && git clone https://github.com/TeamPiped/Piped.git /app \
  && cd /app \
  && git checkout $VERSION \
  && npm install -g corepack@latest \
  && corepack enable  \
  && corepack prepare pnpm@latest --activate \
  && pnpm install --prefer-offline \
  && pnpm build \
  && ./localizefonts.sh

FROM ghcr.io/bjw-s-labs/caddy-scratch:2.9.1@sha256:d837d2501aa7fdb995581e6a96f4e8e4c160b38923484274857db0333196f563
COPY --chown=1000:1000 Caddyfile /config/Caddyfile
COPY --chown=1000:1000 --from=build /app/dist/ /app
CMD ["run", "--config", "/config/Caddyfile"]
