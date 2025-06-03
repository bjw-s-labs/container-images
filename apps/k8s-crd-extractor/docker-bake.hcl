target "docker-metadata-action" {}

variable "APP" {
  default = "k8s-crd-extractor"
}

variable "VERSION" {
  default = "f3cdc86d7e26c959f2c366f19a29c5e5872bf9d6"
}

variable "SOURCE" {
  default = "https://github.com/datreeio/CRDs-catalog"
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
