target "docker-metadata-action" {}

variable "APP" {
  default = "radicale"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=Kozea/Radicale
  default = "3.5.7"
}

variable "SOURCE" {
  default = "https://github.com/Kozea/Radicale"
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
