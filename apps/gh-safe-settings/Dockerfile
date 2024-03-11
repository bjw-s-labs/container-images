ARG VERSION

FROM ghcr.io/onedr0p/alpine:3.19.1@sha256:b3d3b9e47e3b5736d045a5e9f2f1d1bbf5c1c38b8c0c296d4609079cfaf9a4bd as build

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
