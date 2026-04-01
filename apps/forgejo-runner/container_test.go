package main

import (
	"context"
	"testing"

	"github.com/bjw-s-labs/container-images/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/bjw-s-labs/forgejo-rolling:rolling")

	t.Run("Check flux-local exists", func(t *testing.T) {
		testhelpers.TestFileExists(t, ctx, image, "/home/runner/.local/bin/flux-local", nil)
	})
}
