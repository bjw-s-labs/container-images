target "docker-metadata-action" {}

variable "APP" {
  default = "kepubify"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=pgaskin/kepubify
  default = "4.0.4"
}

variable "SOURCE" {
  default = "https://github.com/pgaskin/kepubify"
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
