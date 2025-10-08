package main

import (
	"context"
	"testing"

	"github.com/bjw-s-labs/container-images/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/bjw-s-labs/kepubify:rolling")

	t.Run("Check /app/kepubify can run", func(t *testing.T) {
		testhelpers.TestCommandSucceeds(t, ctx, image, "/app/kepubify", "--version")
	})
}
