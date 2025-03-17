ARG VERSION

FROM docker.io/library/alpine:3.21 AS build

ARG VERSION

RUN \
    apk add --no-cache --virtual=build-dependencies \
    git \
    && git clone --branch "${VERSION}" "https://github.com/github/safe-settings.git" /src

FROM docker.io/library/node:23-alpine

LABEL org.opencontainers.image.source="https://github.com/github/safe-settings"

COPY --from=build /src/package.json /opt/safe-settings/
COPY --from=build /src/index.js /opt/safe-settings/
COPY --from=build /src/lib /opt/safe-settings/lib

WORKDIR /opt/safe-settings
RUN npm install

EXPOSE 3000
USER node
CMD ["npm", "start"]
