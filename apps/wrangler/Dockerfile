# syntax=docker/dockerfile:1

FROM docker.io/library/node:22-alpine
ARG VERSION
RUN npm install --global wrangler@${VERSION}

USER nobody:nogroup

ENTRYPOINT ["/usr/local/bin/wrangler"]
