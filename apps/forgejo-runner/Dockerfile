# syntax=docker/dockerfile:1

FROM ghcr.io/catthehacker/ubuntu:act-24.04@sha256:ab464a96ff6cb1cc1066c839206de15391accd9eb57276c14ade424693edb6a6

# Install packages from other images
COPY --from=ghcr.io/fluxcd/flux-cli:v2.8.5 /usr/local/bin/flux /usr/local/bin/flux
COPY --from=docker.io/alpine/helm:4.1.1 /usr/bin/helm /usr/local/bin/helm
COPY --from=ghcr.io/sigstore/cosign/cosign:v3.0.6 /ko-app/cosign /usr/local/bin/cosign

# Install recent Python
RUN \
    add-apt-repository ppa:deadsnakes/ppa \
    && apt-get -qq update \
    && apt-get -qq install python3.14 python3.14-venv rsync

# Install kustomize
# renovate: datasource=github-releases depName=kubernetes-sigs/kustomize
ARG KUSTOMIZE_VERSION=v5.7.1
ARG TARGETARCH
RUN wget -qO- \
    "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${TARGETARCH}.tar.gz" \
    | tar xz -C /usr/local/bin kustomize

# Install pipx
ENV PATH="/root/.local/bin/:$PATH"
RUN \
    mkdir -p ~/.local/bin \
    && python3.14 -m venv ~/.local/share/pipx-venv \
    && ~/.local/share/pipx-venv/bin/pip install pipx \
    && ln -s ~/.local/share/pipx-venv/bin/pipx ~/.local/bin/pipx

# Install flux-local
# renovate: datasource=github-releases depName=allenporter/flux-local
ARG FLUX_LOCAL_VERSION=8.1.0
RUN \
    pipx install flux-local==${FLUX_LOCAL_VERSION}

# Cleanup
RUN \
    apt-get clean \
    rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories'
