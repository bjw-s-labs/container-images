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

FROM ghcr.io/bjw-s-labs/caddy-scratch:2.8.4@sha256:d13a019d74f62b39ac4a5780b8821c20e028e1a3356b0f32eb1593e0bb517b4a
COPY --chown=1000:1000 --from=build /app/dist/ /app
CMD ["file-server", "--root", "/app", "--listen", ":8080"]
