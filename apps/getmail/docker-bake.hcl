target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=github-releases depName=getmail6/getmail6 versioning=loose
  default = "6.19.08"
}

variable "SOURCE" {
  default = "https://github.com/getmail6/getmail6"
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
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
