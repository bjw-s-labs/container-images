<!---
NOTE: AUTO-GENERATED FILE
to edit this file, instead edit its template at: ./ci/templates/README.md.j2
-->
<div align="center">


## Containers

_A Collection of Container Images Optimized for Kubernetes_

</div>

<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/bjw-s/container-images?style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/bjw-s/container-images?style=for-the-badge)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/bjw-s/container-images/scheduled-release.yaml?style=for-the-badge&label=Scheduled%20Release)

</div>

---

## About

This repo contains a collection of containers which are optimized for use in kubernetes, and updated automatically to keep up with upstream versions. Using an image effectively in Kubernetes requires a few ingredients:

- The filesystem must be able to be immutable
- The container must not run as root
- The container shouldn't require any manual interaction
- The container should ideally be configurable via environmental variables

---

## Available Tags

Each Image will be built with the standard `latest` rolling tag, along with tags specific to it's version. For Semantically Versioned containers (e.g. `v1.2.3`), `major`, `major.minor`, and `major.minor.patch` tags will be generated, for example, ![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.2](https://img.shields.io/badge/1.2-blue?style=flat-square) and ![1.2.3](https://img.shields.io/badge/1.2.3-blue?style=flat-square). Available Images Below.

### Application Images
Application Images are all built from the customer base images below, and will leverage a `/data` and a `/config` volume where these are necessary, and follow the guidelines above for use in Kubernetes.

Container | Channel | Image | Latest Tags
--- | --- | --- | ---
[calibre-web](https://github.com/bjw-s/container-images/pkgs/container/calibre-web) | stable | ghcr.io/bjw-s/calibre-web |![0.6.20](https://img.shields.io/badge/0.6.20-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[gatus](https://github.com/bjw-s/container-images/pkgs/container/gatus) | stable | ghcr.io/bjw-s/gatus |![5](https://img.shields.io/badge/5-blue?style=flat-square) ![5.5](https://img.shields.io/badge/5.5-blue?style=flat-square) ![5.5.1](https://img.shields.io/badge/5.5.1-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[getmail](https://github.com/bjw-s/container-images/pkgs/container/getmail) | stable | ghcr.io/bjw-s/getmail |![6.18.13](https://img.shields.io/badge/6.18.13-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[kepubify](https://github.com/bjw-s/container-images/pkgs/container/kepubify) | stable | ghcr.io/bjw-s/kepubify |![4.0.4](https://img.shields.io/badge/4.0.4-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[mdbook](https://github.com/bjw-s/container-images/pkgs/container/mdbook) | stable | ghcr.io/bjw-s/mdbook |![0.4.34](https://img.shields.io/badge/0.4.34-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[paperless-ngx](https://github.com/bjw-s/container-images/pkgs/container/paperless-ngx) | stable | ghcr.io/bjw-s/paperless-ngx |![1.17.2](https://img.shields.io/badge/1.17.2-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[radicale](https://github.com/bjw-s/container-images/pkgs/container/radicale) | stable | ghcr.io/bjw-s/radicale |![3.1.8](https://img.shields.io/badge/3.1.8-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)


### Base Images
All Base Images are configured with a non-root user (`bjw-s:bjw-s`), and exposed `/data` and `/config` volumes, and use `tini` as an entrypoint to ensure proper signal handling.

Container | Channel | Image | Latest Tags
--- | --- | --- | ---
