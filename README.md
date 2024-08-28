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
- Semantic versioning is available to specify exact versions to run
- The container can be run rootless
- The container shouldn't require any manual interaction
- The container should ideally be configurable via environmental variables

## Configuration volume

For applications that need to have persistent configuration data the container will leverage a `/data` and a `/config` volume where these are necessary. This is not able to be changed in most cases.

---

## Available Tags

For Semantically Versioned containers (e.g. `v1.2.3`), `major`, `major.minor`, and `major.minor.patch` tags will be generated, for example, ![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.2](https://img.shields.io/badge/1.2-blue?style=flat-square) and ![1.2.3](https://img.shields.io/badge/1.2.3-blue?style=flat-square). Available Images Below.

### Application Images

Each Image will be built with a `rolling` tag, along with tags specific to it's version. Available Images Below

Container | Channel | Image
--- | --- | ---
[calibre-web](https://github.com/bjw-s/container-images/pkgs/container/calibre-web) | stable | ghcr.io/bjw-s/calibre-web
[gatus](https://github.com/bjw-s/container-images/pkgs/container/gatus) | stable | ghcr.io/bjw-s/gatus
[getmail](https://github.com/bjw-s/container-images/pkgs/container/getmail) | stable | ghcr.io/bjw-s/getmail
[gh-safe-settings](https://github.com/bjw-s/container-images/pkgs/container/gh-safe-settings) | stable | ghcr.io/bjw-s/gh-safe-settings
[gluetun-qb-port-sync](https://github.com/bjw-s/container-images/pkgs/container/gluetun-qb-port-sync) | stable | ghcr.io/bjw-s/gluetun-qb-port-sync
[kepubify](https://github.com/bjw-s/container-images/pkgs/container/kepubify) | stable | ghcr.io/bjw-s/kepubify
[manyfold](https://github.com/bjw-s/container-images/pkgs/container/manyfold) | stable | ghcr.io/bjw-s/manyfold
[mdbook](https://github.com/bjw-s/container-images/pkgs/container/mdbook) | stable | ghcr.io/bjw-s/mdbook
[radicale](https://github.com/bjw-s/container-images/pkgs/container/radicale) | stable | ghcr.io/bjw-s/radicale
