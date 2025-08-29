target "docker-metadata-action" {}

variable "APP" {
  default = "calibre-web"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=janeczku/calibre-web
  default = "0.6.25"
}

variable "SOURCE" {
  default = "https://github.com/janeczku/calibre-web"
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
    "org.opencontainers.image.source" = "${SOURCE}"
  }
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
}
