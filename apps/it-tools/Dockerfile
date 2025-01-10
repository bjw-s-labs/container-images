ARG VERSION

FROM node:lts-alpine AS build
ARG VERSION
RUN \
  apk add --no-cache curl git \
  && git clone -b v${VERSION} --single-branch https://github.com/CorentinTh/it-tools.git /app \
  && cd /app \
  && corepack enable  \
  && corepack prepare pnpm@latest --activate \
  && pnpm install --prefer-offline \
  && pnpm build

FROM ghcr.io/bjw-s-labs/caddy-scratch:2.9.1@sha256:7e38da5a58a670e444c76742c3e968d8c609b08032ff215b10ef3bade154c8a5
COPY --chown=1000:1000 --from=build /app/dist/ /app
CMD ["file-server", "--root", "/app", "--listen", ":8080"]
