ARG VERSION

FROM node:lts-alpine AS build

RUN \
  apk add --no-cache curl git \
  && git clone https://github.com/CorentinTh/it-tools.git /app \
  && cd /app \
  && git checkout $VERSION

WORKDIR /app

RUN \
  corepack enable  \
  && corepack prepare pnpm@latest --activate \
  && pnpm install --prefer-offline \
  && pnpm build

FROM nginxinc/nginx-unprivileged:alpine

USER root
RUN \
  apk add --no-cache \
  catatonit

USER nginx

COPY --chown=101:101 --from=build /app/dist/ /usr/share/nginx/html/
COPY --chown=101:101 --from=build /app/nginx.conf /etc/nginx/conf.d/default.conf
COPY entrypoint.sh /entrypoint.sh

RUN \
  sed -i "s/worker_processes  auto;/worker_processes  2;/g" /etc/nginx/nginx.conf \
  && sed -i "s/80;/8080;/g" /etc/nginx/conf.d/default.conf

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
