target "docker-metadata-action" {}

variable "APP" {
  default = "manyfold"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=manyfold3d/manyfold
  default = "0.114.0"
}

variable "SOURCE" {
  default = "https://github.com/manyfold3d/manyfold"
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
