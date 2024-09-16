<div align="center">

## Container Images

_A Collection of Container Images Optimized for use in Kubernetes_

</div>

<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/bjw-s/container-images?style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/bjw-s/container-images?style=for-the-badge)

</div>

---

## About

This repo contains a collection of container images which are optimized for use in Kubernetes, and updated automatically to keep up with upstream versions. The images try to adhere to the following principles:

- Images are built upon a [Alpine](https://hub.docker.com/_/alpine) or [Ubuntu](https://hub.docker.com/_/ubuntu) base image.
- The container can be run rootless.
- No use of [s6-overlay](https://github.com/just-containers/s6-overlay).
- Semantic versioning is available to specify exact versions to run.
- The container filesystem must be able to be immutable.

## Available Images

Images can be [browsed on the GitHub Packages page for this repo's packages](https://github.com/bjw-s?tab=packages&repo_name=container-images).

## Persistent data

For applications that need to have persistent data the container will leverage a `/data` and/or a `/config` volume where these are necessary. These locations are hardcoded and not able to be changed in most cases.

## Deprecations

Containers here can be **deprecated** at any point, this could be for any reason described below.

1. The upstream application is no longer actively developed.
2. The upstream application has an official upstream container that fits within the goals of this project.
3. The upstream application has been replaced with a better alternative.
4. The maintenance burden of keeping the container here is too bothersome.

> [!NOTE]
> Deprecated containers will remained published to this repo for 6 months after which they will be pruned.
