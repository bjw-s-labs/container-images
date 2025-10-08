package main

import (
	"context"
	"testing"

	"github.com/bjw-s-labs/container-images/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/bjw-s-labs/calibre-web:rolling")

	t.Run("HTTP endpoint test", func(t *testing.T) {
		testhelpers.TestHTTPEndpoint(t, ctx, image, testhelpers.HTTPTestConfig{
			Port: "8083",
		}, nil)
	})

	t.Run("Check /opt/kepubify/kepubify exists", func(t *testing.T) {
		testhelpers.TestFileExists(t, ctx, image, "/opt/kepubify/kepubify", nil)
	})

	t.Run("Check /opt/calibre/ebook-convert exists", func(t *testing.T) {
		testhelpers.TestFileExists(t, ctx, image, "/opt/calibre/ebook-convert", nil)
	})
}
