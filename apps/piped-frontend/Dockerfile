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

FROM ghcr.io/bjw-s-labs/caddy-scratch:2.8.4@sha256:a63636103a9d0ab1ae0ceeeb5bb8f29397368541035f1805a53f0755b1d44db3
COPY --chown=1000:1000 Caddyfile /config/Caddyfile
COPY --chown=1000:1000 --from=build /app/dist/ /app
CMD ["run", "--config", "/config/Caddyfile"]
