ARG VERSION

FROM ghcr.io/onedr0p/alpine:3.19.0@sha256:51632d23e56ae28a34f8e90df6fe8d02730b5462697ae52e8b01ad6484497819 as build

ARG VERSION

RUN \
    apk add --no-cache --virtual=build-dependencies \
        git \
    && git clone --branch "${VERSION}" "https://github.com/github/safe-settings.git" /src

FROM node:20-alpine

COPY --from=build /src/package.json /opt/safe-settings/
COPY --from=build /src/index.js /opt/safe-settings/
COPY --from=build /src/lib /opt/safe-settings/lib

WORKDIR /opt/safe-settings
RUN npm install

EXPOSE 3000
USER node
CMD npm start
