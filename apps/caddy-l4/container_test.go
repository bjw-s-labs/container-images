package main

import (
	"context"
	"testing"

	"github.com/bjw-s-labs/container-images/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/bjw-s-labs/caddy-l4:rolling")

	t.Run("Check /usr/bin/caddy exists", func(t *testing.T) {
		testhelpers.TestFileExists(t, ctx, image, "/usr/bin/caddy", nil)
	})
}
