ARG VERSION

FROM node:lts-alpine AS build
RUN \
  apk add --no-cache curl git \
  && git clone https://github.com/CorentinTh/it-tools.git /app \
  && cd /app \
  && git checkout $VERSION \
  && corepack enable  \
  && corepack prepare pnpm@latest --activate \
  && pnpm install --prefer-offline \
  && pnpm build

FROM ghcr.io/bjw-s-labs/caddy-scratch:2.8.4@sha256:5cccbdb2b64ace83643247c1d337365815f48f1b3086727883536ce319e41525
COPY --chown=1000:1000 --from=build /app/dist/ /app
CMD ["file-server", "--root", "/app", "--listen", ":8080"]
