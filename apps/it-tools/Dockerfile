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

FROM ghcr.io/bjw-s-labs/caddy-scratch:2.9.0@sha256:d6833f3809807c5641ee04b87e4efa756a7d8d99d9cde2b06b341de91c1088de
COPY --chown=1000:1000 --from=build /app/dist/ /app
CMD ["file-server", "--root", "/app", "--listen", ":8080"]
