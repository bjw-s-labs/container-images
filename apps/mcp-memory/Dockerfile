FROM node:24-alpine
ARG VERSION

USER root:root

ENV MEMORY_FILE_PATH="/data/memory.jsonl"

RUN \
    apk add --no-cache catatonit \
    && npm install -g "@modelcontextprotocol/server-memory@${VERSION}"

USER nobody:nogroup

WORKDIR /data
VOLUME [ "/data" ]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/usr/local/bin/mcp-server-memory"]
