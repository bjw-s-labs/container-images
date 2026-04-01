package main

import (
	"context"
	"testing"

	"github.com/bjw-s-labs/container-images/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/bjw-s-labs/forgejo-rolling:rolling")

	t.Run("Check flux exists", func(t *testing.T) {
		testhelpers.TestFileExists(t, ctx, image, "/usr/local/bin/flux", nil)
	})

	t.Run("Check flux-local exists", func(t *testing.T) {
		testhelpers.TestFileExists(t, ctx, image, "/root/.local/bin/flux-local", nil)
	})

	t.Run("Check helm exists", func(t *testing.T) {
		testhelpers.TestFileExists(t, ctx, image, "/usr/local/bin/helm", nil)
	})

	t.Run("Check kustomize exists", func(t *testing.T) {
		testhelpers.TestFileExists(t, ctx, image, "/usr/local/bin/kustomize", nil)
	})

	t.Run("Check rsync exists", func(t *testing.T) {
		testhelpers.TestFileExists(t, ctx, image, "/usr/bin/rsync", nil)
	})
}
