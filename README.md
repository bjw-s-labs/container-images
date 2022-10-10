# container-images

Welcome to my container images repo. If looking for a container start by [browsing the container packages](https://github.com/bjw-s?tab=packages&repo_name=containers).

## Credits

Thanks a lot to https://github.com/onedr0p/containers for a lot of the groundwork!

Also, a lot of inspiration and ideas are thanks to the hard work of [hotio.dev](https://hotio.dev/) and [linuxserver.io](https://www.linuxserver.io/) contributors.

## Mission statement

The goal of this project is to support [semantically versioned](https://semver.org/), [rootless](https://rootlesscontaine.rs/), and [multiple architecture](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/) containers for various applications.

I also try to adhere to a [KISS principle](https://en.wikipedia.org/wiki/KISS_principle), logging to stdout, [one process per container](https://testdriven.io/tips/59de3279-4a2d-4556-9cd0-b444249ed31e/), no [s6-overlay](https://github.com/just-containers/s6-overlay) and all images are built on top of [Alpine](https://hub.docker.com/_/alpine) or [Ubuntu](https://hub.docker.com/_/ubuntu).

In most cases if the application developers supports a container image and adheres to the above I will often not build a custom image and use their image instead.

## Tag immutability

The containers built here do not use immutable tags, as least not in the more common way you have seen from [linuxserver.io](https://fleet.linuxserver.io/) or [Bitnami](https://bitnami.com/stacks/containers).

I do take a similar approach but instead of appending a `-ls69` or `-r420` prefix to the tag I instead insist on pinning to the sha256 digest of the image. While this is not as pretty it is just as functional in making the images immutable.

| Container                                       | Immutable |
|-------------------------------------------------|-----------|
| `ghcr.io/bjw-s/getmail:rolling`                 | ❌        |
| `ghcr.io/bjw-s/getmail:6.18.10`                 | ❌        |
| `ghcr.io/bjw-s/getmail:rolling@sha256:8053...`  | ✅        |
| `ghcr.io/bjw-s/getmail:6.18.10@sha256:8053...`  | ✅        |

_If pinning an image to the sha256 digest, tools like [Renovate](https://github.com/renovatebot/renovate) support updating the container on a digest or application version change._
