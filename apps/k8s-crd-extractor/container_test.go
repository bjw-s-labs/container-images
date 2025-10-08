package main

import (
	"context"
	"testing"

	"github.com/bjw-s-labs/container-images/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/bjw-s-labs/k8s-crd-extractor:rolling")

	t.Run("Check /app/crd-extractor.sh exists", func(t *testing.T) {
		testhelpers.TestFileExists(t, ctx, image, "/app/crd-extractor.sh")
	})

	t.Run("Check /app/openapi2jsonschema.py exists", func(t *testing.T) {
		testhelpers.TestFileExists(t, ctx, image, "/app/openapi2jsonschema.py")
	})
}
