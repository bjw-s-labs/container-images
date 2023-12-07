ARG VERSION

FROM ghcr.io/onedr0p/alpine:3.18.5@sha256:55b35f580db486e93271ce2bb5b222ceed8591abd6e5fa99142f9337e0ab504d as build

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
