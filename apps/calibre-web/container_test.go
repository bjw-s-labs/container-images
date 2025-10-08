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
		})
	})

	testhelpers.TestFilesExist(t, ctx, image, []string{
		"/opt/kepubify/kepubifyz",
		"/opt/calibre/ebook-convert",
	})
}
