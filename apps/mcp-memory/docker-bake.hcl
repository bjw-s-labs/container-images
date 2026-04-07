DATE = formatdate( "YYYY.MM.DD", timestamp() )
APP = "mcp-memory"
SOURCE = "https://github.com/modelcontextprotocol/servers/tree/main/src/memory"
variable "GIT_SHA" {}

variable "VERSION" {
  // renovate: datasource=github-releases depName=modelcontextprotocol/servers
  default = "2026.1.26"
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
    "ghcr.io/bjw-s-labs/${APP}:${VERSION}"
  ]

}

target "docker-metadata-action" {}
