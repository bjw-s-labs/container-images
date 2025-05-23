FROM scratch

ARG VERSION
ARG TARGETARCH
ARG TARGETARCH=${TARGETARCH/arm64/arm64}
ARG TARGETARCH=${TARGETARCH/amd64/64bit}

ADD --chown=65534:65534 --chmod=755 https://github.com/pgaskin/kepubify/releases/download/v${VERSION}/kepubify-linux-${TARGETARCH} /app/kepubify

WORKDIR /app

ENTRYPOINT [ "/app/kepubify" ]

LABEL org.opencontainers.image.source="https://github.com/pgaskin/kepubify"
