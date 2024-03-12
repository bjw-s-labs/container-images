ARG VERSION

FROM ghcr.io/onedr0p/alpine:3.19.1@sha256:3fbc581cb0fe29830376161ae026e2a765dcc11e1747477fe9ebf155720b8638 as build

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
