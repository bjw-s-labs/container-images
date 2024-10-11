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

COPY --chown=101:101 --from=build /app/dist/ /usr/share/nginx/html/
COPY --chown=101:101 --from=build /app/nginx.conf /etc/nginx/conf.d/default.conf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
