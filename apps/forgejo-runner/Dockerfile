# syntax=docker/dockerfile:1

FROM ghcr.io/catthehacker/ubuntu:runner-24.04@sha256:60e9b2b3fb10a01dd7b0efaafadb1a154dec5ae67a0e312ebe1045be4be6629e

USER root

# Install packages from other images
COPY --from=ghcr.io/fluxcd/flux-cli:v2.8.0  /usr/local/bin/flux  /usr/local/bin/flux
COPY --from=docker.io/alpine/helm:4.1.1     /usr/bin/helm        /usr/local/bin/helm

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

USER runner

# Install pipx
ENV PATH="/home/runner/.local/bin/:$PATH"
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
USER root
RUN \
    apt-get clean \
    rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories'

USER runner
