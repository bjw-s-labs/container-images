DATE = formatdate( "YYYY.MM.DD", timestamp() )
APP = "calibre-web"
SOURCE = "https://github.com/janeczku/calibre-web"
variable "GIT_SHA" {}

variable "VERSION" {
  // renovate: datasource=github-releases depName=janeczku/calibre-web
  default = "0.6.26"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
  }
  labels = {
    "org.opencontainers.image.vendor" = "bjw-s"
    "org.opencontainers.image.source" = "https://github.com/bjw-s-labs/container-images"
    "org.opencontainers.image.created" = "${DATE}"
    "org.opencontainers.image.revision" = "${GIT_SHA}"
    "org.opencontainers.image.title" = "${APP}"
    "org.opencontainers.image.url" = "${SOURCE}"
    "org.opencontainers.image.version" = "${VERSION}"
  }
  no-cache = true
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
  tags = [
    "ghcr.io/bjw-s-labs/${APP}:rolling",
    "ghcr.io/bjw-s-labs/${APP}:sha-${GIT_SHA}",
    can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+", VERSION)) ? "" : "ghcr.io/bjw-s-labs/${APP}:${DATE}",
    "ghcr.io/bjw-s-labs/${APP}:${VERSION}",
    can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+", VERSION)) ? "ghcr.io/bjw-s-labs/${APP}:${regex("^([0-9]+\\.[0-9]+)", VERSION)[0]}" : "",
    can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+", VERSION)) ? "ghcr.io/bjw-s-labs/${APP}:${regex("^([0-9]+)", VERSION)[0]}" : ""
  ]
}

target "docker-metadata-action" {}
