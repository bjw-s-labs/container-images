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

FROM ghcr.io/bjw-s-labs/caddy-scratch:2.8.4@sha256:013bc8bdec6fb00e425549ca91337fafdef8bc741fd3f6d32458040b3c0036ed
COPY --chown=1000:1000 Caddyfile /config/Caddyfile
COPY --chown=1000:1000 --from=build /app/dist/ /app
CMD ["run", "--config", "/config/Caddyfile"]
